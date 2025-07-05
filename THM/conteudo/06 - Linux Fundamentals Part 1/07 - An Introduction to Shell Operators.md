## Uma Introdução aos Operadores de Shell

Os operadores do Linux são uma maneira fantástica de aprimorar seu conhecimento de trabalho com o Linux. Existem alguns operadores importantes que valem a pena notar. Cobriremos o básico e os detalharemos em pedaços pequenos.

Em uma visão geral, vou apresentar os seguintes operadores:

| Símbolo / Operador | Descrição                                                                                                                                              |
| :----------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `&`                | Este operador permite que você execute comandos em segundo plano no seu terminal.                                                                        |
| `&&`               | Este operador permite que você combine múltiplos comandos em uma única linha do seu terminal.                                                              |
| `>`                | Este operador é um redirecionador - o que significa que podemos pegar a saída de um comando (como usar `cat` para exibir um arquivo) e direcioná-la para outro lugar. |
| `>>`               | Este operador faz a mesma função do operador `>`, mas anexa a saída em vez de substituir (o que significa que nada é sobrescrito).                         |

Vamos cobrir estes em um pouco mais de detalhe.

### Operador `&`

Este operador nos permite executar comandos em segundo plano. Por exemplo, digamos que queremos copiar um arquivo grande. Isso obviamente levará um tempo considerável e nos deixará incapazes de fazer qualquer outra coisa até que o arquivo seja copiado com sucesso.

O operador de shell `&` nos permite executar um comando e fazê-lo rodar em segundo plano (como esta cópia de arquivo), permitindo-nos fazer outras coisas!

### Operador `&&`

Este operador de shell é um pouco enganoso no sentido de quão familiar é para seu parceiro `&`. Ao contrário do operador `&`, podemos usar `&&` para fazer uma lista de comandos para executar, por exemplo, `comando1 && comando2`. No entanto, vale a pena notar que `comando2` só será executado se `comando1` for bem-sucedido.

### Operador `>`

Este operador é o que é conhecido como um redirecionador de saída. O que isso essencialmente significa é que pegamos a saída de um comando que executamos e enviamos essa saída para outro lugar.

Um ótimo exemplo disso é redirecionar a saída do comando `echo` que aprendemos na Tarefa 4. Claro, executar algo como `echo howdy` retornará "howdy" para o nosso terminal — isso não é super útil. O que podemos fazer em vez disso, é redirecionar "howdy" para algo como um novo arquivo!

Digamos que quiséssemos criar um arquivo chamado "welcome" com a mensagem "hey". Podemos executar `echo hey > welcome`, onde queremos que o arquivo seja criado com o conteúdo "hey", assim:

> *Usando o Operador >*
```bash
tryhackme@linux1:~$ echo hey > welcome
```
> *Usando cat para exibir o arquivo "welcome"*
```bash
tryhackme@linux1:~$ cat welcome
hey
```
**Nota:** Se o arquivo, ou seja, "welcome", já existir, o conteúdo será sobrescrito!

### Operador `>>`

Este operador também é um redirecionador de saída, como no operador `>` que discutimos anteriormente. No entanto, o que torna este operador diferente é que, em vez de sobrescrever qualquer conteúdo dentro de um arquivo, por exemplo, ele apenas coloca a saída no final.

Continuando com nosso exemplo anterior, onde temos o arquivo "welcome" que tem o conteúdo "hey". Se usássemos `echo` para adicionar "hello" ao arquivo usando o operador `>`, o arquivo agora teria apenas "hello" e não "hey".

O operador `>>` permite anexar a saída ao final do arquivo — em vez de substituir o conteúdo, assim:

> *Usando o Operador >>*
```bash
tryhackme@linux1:~$ echo hello >> welcome
```
> *Usando cat para exibir o arquivo "welcome"*
```bash
tryhackme@linux1:~$ cat welcome
hey
hello
```

---
**Responda às perguntas abaixo:**

Se quiséssemos executar um comando em segundo plano, qual operador usaríamos?
<details>
  <summary>Clique para ver a resposta</summary>
  &
</details>

Se eu quisesse substituir o conteúdo de um arquivo chamado "passwords" pela palavra "password123", qual seria meu comando?
<details>
  <summary>Clique para ver a resposta</summary>
  echo password123 > passwords
</details>

Agora, se eu quisesse adicionar "tryhackme" a este arquivo chamado "passwords", mas também manter "passwords123", qual seria meu comando?
<details>
  <summary>Clique para ver a resposta</summary>
  echo tryhackme >> passwords
</details>