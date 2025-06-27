## Executando Seus Primeiros Comandos

Como discutimos anteriormente, um grande atrativo de usar SOs como o Ubuntu é o quão leves eles podem ser. Isso, é claro, não vem sem suas desvantagens, onde, por exemplo, muitas vezes não há uma GUI (Interface Gráfica do Usuário) ou o que também é conhecido como um ambiente de desktop que podemos usar para interagir com a máquina (a menos que tenha sido instalado). Uma grande parte da interação com esses sistemas é usando o "Terminal".

O "Terminal" é puramente baseado em texto e é intimidador no início. No entanto, se analisarmos alguns dos comandos, depois de algum tempo, você rapidamente se familiariza com o uso do terminal!

> *É assim que um terminal se parece*
> `tryhackme@linux1:~$ digite os comandos aqui`

Precisamos ser capazes de realizar funções básicas como navegar até arquivos, exibir seus conteúdos e criar arquivos! Os comandos para fazer isso são autoexplicativos (uma vez que você sabe quais são, é claro...).

Vamos começar com dois dos primeiros comandos, que eu detalhei na tabela abaixo:

| Comando | Descrição                                               |
| :------ | :-------------------------------------------------------- |
| `echo`    | Exibe qualquer texto que fornecemos.                      |
| `whoami`  | Descobre com qual usuário estamos logados no momento!     |

Veja os trechos abaixo para um exemplo de cada comando sendo usado.

### Usando o `echo`

```bash
tryhackme@linux1:~$ echo Hello
Hello
tryhackme@linux1:~$ echo "Hello Friend!"
Hello Friend!
```

Como mostrado no terminal acima, se quisermos exibir uma única palavra com `echo`, não precisamos usar aspas duplas, por exemplo, `echo Hello`. No entanto, a string deve ser colocada entre aspas duplas se houver um ou mais espaços, por exemplo, `echo "Hello Friend!"`.

`whoami` pode ser usado para encontrar o nome de usuário com o qual estamos logados.

### Usando o `whoami` para descobrir o nome de usuário

```bash
tryhackme@linux1:~$ whoami
tryhackme
```
Tente isso em sua máquina Linux agora!

---
**Responda às perguntas abaixo:**

Se quiséssemos exibir o texto "TryHackMe", qual seria nosso comando?
R: echo TryHackMe

Qual é o nome de usuário com o qual você está logado em sua máquina Linux implantada?
R: tryhackme
