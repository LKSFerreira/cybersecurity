## Interagindo com o Sistema de Arquivos!

Até agora, cobrimos apenas os comandos `echo` e `whoami`. Não são tão úteis quando consideramos as coisas que precisamos fazer - incluindo navegar pelo sistema de arquivos, ler e escrever nele também.

Nesta tarefa, aprenderemos os comandos para que possamos fazer exatamente isso. Assim como na tarefa anterior, exibirei os comandos na tabela no próximo tópico e mostrarei exemplos desses comandos sendo usados.

### Interagindo com o Sistema de Arquivos

Como afirmei anteriormente, ser capaz de navegar na máquina em que você está logado sem depender de um ambiente de desktop é muito importante. Afinal, qual é o sentido de fazer login se não podemos ir a lugar nenhum?

| Comando | Nome Completo |
| :------ | :------------ |
| `ls`      | listing (listagem) |
| `cd`      | change directory (mudar diretório) |
| `cat`     | concatenate (concatenar) |
| `pwd`     | print working directory (imprimir diretório de trabalho) |

#### Listando Arquivos em Nosso Diretório Atual (`ls`)

Antes que possamos fazer qualquer coisa, como descobrir o conteúdo de quaisquer arquivos ou pastas, precisamos saber o que existe em primeiro lugar. Isso pode ser feito usando o comando `ls` (abreviação de *listing*).

> *Usando "ls" para listar o conteúdo do diretório atual*
```bash
tryhackme@linux1:~$ ls
'Important Files' 'My Documents' Notes Pictures
```

Na captura de tela acima, podemos ver que existem os seguintes diretórios/pastas:

*   Important Files
*   My Documents
*   Notes
*   Pictures

Ótimo! Você provavelmente pode adivinhar o que esperar que uma pasta contenha, dado seu nome.

> **Dica Pro:** Você pode listar o conteúdo de um diretório sem ter que navegar até ele usando `ls` e o nome do diretório. Ex: `ls Pictures`

#### Mudando Nosso Diretório Atual (`cd`)

Agora que sabemos quais pastas existem, precisamos usar o comando `cd` (abreviação de *change directory*) para mudar para esse diretório. Digamos que eu queira abrir o diretório "Pictures" - eu faria `cd Pictures`. Onde, novamente, queremos descobrir o conteúdo deste diretório "Pictures" e, para fazer isso, usaríamos `ls` novamente:

> *Listando nosso novo diretório depois de usarmos "cd"*
```bash
tryhackme@linux1:~/Pictures$ ls
dog_picture1.jpg dog_picture2.jpg dog_picture3.jpg dog_picture4.jpg
```
Neste caso, parece que há 4 fotos de cachorros!

#### Exibindo o Conteúdo de um Arquivo (`cat`)

Embora saber sobre a existência de arquivos seja ótimo — não é tão útil a menos que possamos ver o conteúdo deles.

Discutiremos algumas das ferramentas disponíveis que nos permitem transferir arquivos de uma máquina para outra em uma sala posterior. Mas, por enquanto, vamos falar sobre simplesmente ver o conteúdo de arquivos de texto usando um comando chamado `cat`.

`cat` é a abreviação de *concatenating* (concatenar) e é uma maneira fantástica de exibirmos o conteúdo de arquivos (não apenas arquivos de texto!).

Na captura de tela abaixo, você pode ver como eu combinei o uso de `ls` para listar os arquivos dentro de um diretório chamado "Documents":

> *Usando "ls" para listar o conteúdo do diretório atual*
```bash
tryhackme@linux1:~/Documents$ ls
todo.txt
tryhackme@linux1:~/Documents$ cat todo.txt
Here's something important for me to do later!
```

Aplicamos algum conhecimento de antes nesta tarefa para fazer o seguinte:

1.  Usamos `ls` para nos informar quais arquivos estão disponíveis na pasta "Documents" desta máquina. Neste caso, é chamado "todo.txt".
2.  Em seguida, usamos `cat todo.txt` para concatenar/exibir o conteúdo deste arquivo "todo.txt", onde o conteúdo é "Here's something important for me to do later!"

> **Dica Pro:** Você pode usar `cat` para exibir o conteúdo de um arquivo dentro de diretórios sem ter que navegar até ele, usando `cat` e o nome do diretório. Ex: `cat /home/ubuntu/Documents/todo.txt`

Às vezes, coisas como nomes de usuário, senhas (sim - sério...), flags ou configurações são armazenadas em arquivos onde `cat` pode ser usado para recuperá-las.

#### Descobrindo o Caminho Completo para Nosso Diretório de Trabalho Atual (`pwd`)

Você notará, à medida que avança na navegação de sua máquina Linux, que o nome do diretório em que você está trabalhando atualmente será listado em seu terminal.

É fácil perder o controle de onde estamos exatamente no sistema de arquivos, e é por isso que quero apresentar o `pwd`. Isso significa *print working directory* (imprimir diretório de trabalho).

Usando a máquina de exemplo de antes, estamos atualmente na pasta "Documents" — mas onde isso está exatamente no sistema de arquivos da máquina Linux? Podemos descobrir isso usando este comando `pwd`, como na captura de tela abaixo:

> *Usando "pwd" para listar o caminho completo do diretório atual*
```bash
tryhackme@linux1:~/Documents$ pwd
/home/ubuntu/Documents
tryhackme@linux1:~/Documents$
```
Vamos analisar isso:

1.  Já sabemos que estamos em "Documents" graças ao nosso terminal, mas neste momento, não temos ideia de onde "Documents" está armazenado para que possamos voltar a ele facilmente no futuro.
2.  Eu usei o comando `pwd` (print working directory) para encontrar o caminho completo do arquivo desta pasta "Documents".
3.  O Linux nos informa que este diretório "Documents" está armazenado em `/home/ubuntu/Documents` na máquina — ótimo saber!

Agora, no futuro, se nos encontrarmos em um local diferente, podemos simplesmente usar `cd /home/ubuntu/Documents` para mudar nosso diretório de trabalho para este diretório "Documents".

---
**Responda às perguntas abaixo:**

Na máquina Linux que você implantou, quantas pastas existem?
<details>
  <summary>Clique para ver a resposta</summary>
  4
</details>

Qual diretório contém um arquivo?
<details>
  <summary>Clique para ver a resposta</summary>
  folder4
</details>

Qual é o conteúdo deste arquivo?
<details>
  <summary>Clique para ver a resposta</summary>
  Hello World
</details>

Use o comando `cd` para navegar até este arquivo e descubra o novo diretório de trabalho atual. Qual é o caminho?
<details>
  <summary>Clique para ver a resposta</summary>
  /home/tryhackme/folder4
</details>