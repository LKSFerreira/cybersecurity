## Variáveis e Tipos de Dados

As variáveis permitem que você armazene e atualize dados em um programa de computador. Você tem um nome de variável e armazena dados nesse nome.

```python
food = "ice cream"
money = 2000
```

No exemplo acima, temos 2 variáveis. A variável chamada "food" armazena a string (palavras) `ice cream`, enquanto outra variável chamada "money" armazena um número (`2000`).

As variáveis são poderosas, pois você pode alterá-las ao longo do seu programa. O exemplo a seguir define a variável `age` como 30, depois aumentamos essa variável `age` em 1, tornando o dado final da variável 31. Sinta-se à vontade para copiar e colar isso no editor, executar o código e ver sua saída.

```python
age = 30
age = age + 1
print(age)
```

Observe, na linha 2, a maneira como atualizamos uma variável: à esquerda, temos o nome da variável já criada "age", seguido pelo operador `=`. À direita, temos o que estamos definindo para a variável; no nosso caso, a variável `age` (que atualmente está definida como 30) está sendo aumentada em 1.

Vamos falar sobre **Tipos de Dados**, que é o tipo de dado sendo armazenado em uma variável. Você pode armazenar texto, ou números, e muitos outros tipos. Os tipos de dados a conhecer são:

*   **String** - Usado para combinações de caracteres, como letras ou símbolos.
*   **Integer** - Números inteiros.
*   **Float** - Números que contêm pontos decimais ou para frações.
*   **Boolean** - Usado para dados que são restritos às opções Verdadeiro (True) ou Falso (False).
*   **List** - Séries de diferentes tipos de dados armazenados em uma coleção.

<img src="https://tryhackme-images.s3.amazonaws.com/user-uploads/5bec5dfd73790a7d06282266/room-content/1d06d9ac2b8f1e9f75f61f60169e7b2e.png">

---
**Responda às perguntas abaixo:**

No editor de código, crie uma variável chamada `height` e defina seu valor inicial como 200.
<details>
  <summary>Clique para ver a resposta</summary>
  Nenhuma resposta necessária
</details>

Em uma nova linha, adicione 50 à variável `height`.
<details>
  <summary>Clique para ver a resposta</summary>
  Nenhuma resposta necessária
</details>

Em outra nova linha, imprima o valor de `height`. Qual é a flag que aparece?
<details>
  <summary>Clique para ver a resposta</summary>
  THM{VARIABLES}
</details>