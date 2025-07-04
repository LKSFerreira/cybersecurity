## Laços (Loops)

Na programação, os laços (loops) permitem que os programas iterem e executem ações um determinado número de vezes. Existem dois tipos de laços: laços `for` e `while`.

### Laços `while`

Vamos começar observando como estruturamos um laço `while`. Podemos fazer o laço rodar indefinidamente ou (semelhante a uma declaração `if`) determinar quantas vezes o laço deve rodar com base em uma condição.

```python
i = 1
while i <= 10:
     print(i)
     i = i + 1
```

Este laço `while` rodará 10 vezes, exibindo o valor da variável `i` a cada iteração (laço). Vamos analisar isso:

*   A variável `i` é definida como 1.
*   A declaração `while` especifica onde o início do laço deve começar.
*   Toda vez que ele itera, ele começará no topo (exibindo o valor de `i`).
*   Em seguida, ele vai para a próxima linha no laço, que aumenta o valor de `i` em 1.
*   Então (como não há mais código para o programa executar), ele volta ao topo do laço, começando o processo novamente.
*   O programa continuará em laço até que o valor da variável `i` seja maior que 10.

### Laços `for`

Um laço `for` é usado para iterar sobre uma sequência, como uma lista. As listas são usadas para armazenar múltiplos itens em uma única variável e são criadas usando colchetes (veja abaixo). Vamos aprender através do seguinte exemplo:

```python
websites = ["facebook.com", "google.com", "amazon.com"]
for site in websites:
     print(site)
```

Este laço `for` mostrado no bloco de código acima rodará 3 vezes, exibindo cada site da lista. Vamos analisar isso:

*   A variável de lista chamada `websites` está armazenando 3 elementos.
*   O laço itera através de cada elemento, imprimindo o elemento.
*   O programa para de iterar quando passa por cada elemento no laço.

Para dar um cenário do mundo real, você poderia criar um programa que verifica se um site está online ou se um item está em estoque. Você percorreria a lista de sites, adicionaria funcionalidade dentro do laço para verificar o site e exibiria os resultados. A sala "[Python para Pentesters](./caminho/para/python-for-pentesters.md)" mostra como usar o Python para enumerar um alvo, construir um keylogger, escanear uma rede e muito mais.

No Python, também podemos iterar através de um intervalo de números usando a função `range`. Abaixo está um exemplo de código Python que imprimirá os números de 0 a 4. Na programação, 0 é frequentemente o número inicial, então contar até 5 é de 0 a 4 (mas tem 5 números: 0, 1, 2, 3 e 4).

```python
for i in range(5):
     print(i)
```

---
**Responda às perguntas abaixo:**

No editor de código, clique de volta na aba "script.py" e codifique um laço que exiba todos os números de 0 a 50.
<details>
  <summary>Clique para ver a resposta</summary>
  THM{PYTHON_LOOPS}
</details>