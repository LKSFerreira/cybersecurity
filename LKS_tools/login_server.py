#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Servidor de login simples para testes de bruteforce com logging detalhado.

import logging
from flask import Flask, request, render_template_string

app = Flask(__name__)

# Configuração do logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
    handlers=[
        logging.FileHandler("login_attempts.log", encoding="utf-8"),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

# Credenciais corretas hardcoded no servidor.
CORRECT_USERNAME = "lucas123"
CORRECT_PASSWORD = "P@ssw0rd!123"

# Mensagem de falha que o bruteforcer deve procurar.
FAILURE_MESSAGE = "Usuário ou senha inválidos."

# Template HTML para o formulário de login.
LOGIN_FORM_HTML = """
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Página de Login de Teste</title>
    <style>
        body { font-family: sans-serif; background-color: #f0f2f5; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .login-container { background-color: white; padding: 2rem; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); width: 300px; text-align: center; }
        h1 { color: #333; }
        input[type="text"], input[type="password"] { width: 100%; padding: 10px; margin: 10px 0; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        input[type="submit"] { width: 100%; background-color: #007bff; color: white; padding: 10px; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; }
        input[type="submit"]:hover { background-color: #0056b3; }
        .message { margin-top: 15px; padding: 10px; border-radius: 4px; }
        .success { color: #155724; background-color: #d4edda; border: 1px solid #c3e6cb; }
        .error { color: #721c24; background-color: #f8d7da; border: 1px solid #f5c6cb; }
    </style>
</head>
<body>
    <div class="login-container">
        <h1>Login de Teste</h1>
        {% if message %}
            <div class="message {{ 'success' if success else 'error' }}">{{ message }}</div>
        {% endif %}
        <form method="post">
            <input type="text" name="username" placeholder="Usuário" required>
            <input type="password" name="password" placeholder="Senha" required>
            <input type="submit" value="Entrar">
        </form>
    </div>
</body>
</html>
"""

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        user = request.form.get('username', '')
        pwd = request.form.get('password', '')

        # Log da tentativa com timestamp, usuário e senha
        logger.info(f"Tentativa de login — usuário: '{user}', senha: '{pwd}'")

        if user == CORRECT_USERNAME and pwd == CORRECT_PASSWORD:
            logger.info(f"✔️ Login bem-sucedido para usuário '{user}'")
            return render_template_string(LOGIN_FORM_HTML, message="Login bem-sucedido! Bem-vindo, admin!", success=True)
        else:
            logger.warning(f"❌ Falha de login para usuário '{user}'")
            return render_template_string(LOGIN_FORM_HTML, message=FAILURE_MESSAGE, success=False)

    return render_template_string(LOGIN_FORM_HTML)

if __name__ == '__main__':
    print("Servidor de teste rodando em http://127.0.0.1:80/login")
    app.run(host='0.0.0.0', port=80, debug=False)
