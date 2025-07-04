## Importações (Imports)

No Python, podemos importar **bibliotecas (libraries)**, que são uma coleção de arquivos que contêm funções. Pense em importar uma biblioteca como importar funções que você pode usar e que já foram escritas para você. Por exemplo, existe uma biblioteca `"datetime"` que lhe dá acesso a centenas de diferentes funções para qualquer coisa relacionada a data e hora.

```python
import datetime
current_time = datetime.datetime.now()
print(current_time)
```

Nós importamos outras bibliotecas usando a palavra-chave `import`. Então, no Python, usamos o nome da biblioteca importada para referenciar suas funções. No exemplo acima, importamos `datetime`, depois acessamos o método `.now()` chamando `nome_da_biblioteca.nome_do_metodo()`. Copie e cole o exemplo acima no editor de código.

Aqui estão algumas bibliotecas populares que você pode achar úteis em scripts como um pentester:

*   **Request** - biblioteca HTTP simples.
*   **Scapy** - envia, fareja (*sniff*), disseca e forja pacotes de rede.
*   **Pwntools** - uma biblioteca para desenvolvimento de CTF e exploits.

Muitas dessas bibliotecas já estão embutidas na linguagem de programação; no entanto, bibliotecas escritas por outros programadores que ainda não estão instaladas em sua máquina podem ser instaladas usando uma aplicação chamada **pip**, que é o gerenciador de pacotes do Python. Digamos que você queira instalar a biblioteca `"scapy"` (que permite que você crie seus próprios pacotes em código e os envie para outras máquinas); você a instala primeiro executando o comando `pip install scapy`, após o qual, em seu programa, você pode agora importar a biblioteca `scapy`.

---
**Responda às perguntas abaixo:**

Leia a tarefa e execute o código de exemplo Python acima no editor de código à direita.
<details>
  <summary>Clique para ver a resposta</summary>
  Nenhuma resposta necessária
</details>