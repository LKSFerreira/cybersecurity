## Arquivos

No Python, você pode ler e escrever em arquivos. Vimos que em cibersegurança, é comum escrever um script e importar ou exportar de um arquivo; seja como uma forma de armazenar a saída do seu script ou para importar uma lista de centenas de sites de um arquivo para enumerar. Vamos direto a um exemplo:

```python
f = open("file_name", "r")
print(f.read())
```

Para abrir o arquivo, usamos a função embutida `open()`, e o parâmetro `"r"` significa "read" (ler) e é usado porque estamos lendo o conteúdo do arquivo. A variável tem um método `read()` para ler o conteúdo do arquivo. Você também pode usar o método `readlines()` e iterar sobre cada linha no arquivo; útil se você tiver uma lista onde cada item está em uma nova linha. No exemplo acima, o arquivo está na mesma pasta que o script Python; se estivesse em outro lugar, você precisaria especificar o caminho completo do arquivo.

Você também pode criar e escrever em arquivos. Se você está escrevendo em um arquivo existente, você abre o arquivo primeiro e usa o `"a"` na função `open()` após a chamada do nome do arquivo (que significa *append* - anexar). Se você está escrevendo em um novo arquivo, você usa `"w"` (*write* - escrever) em vez de `"a"`. Veja os exemplos abaixo para clareza:

```python
f = open("demofile1.txt", "a") # Anexar a um arquivo existente
f.write("The file will include more text..")
f.close()

f = open("demofile2.txt", "w") # Criando e escrevendo em um novo arquivo
f.write("demofile2 file created, with this content in!")
f.close()
```

Note que usamos o método `close()` após escrever em um arquivo; isso fecha o arquivo para que nenhuma escrita adicional no arquivo (dentro do programa) possa ocorrer.

---
**Responda às perguntas abaixo:**

No editor de código, escreva um código Python para ler o arquivo `flag.txt`. Qual é a flag neste arquivo?
<details>
  <summary>Clique para ver a resposta</summary>
  THM{FILES_PYTHON}
</details>