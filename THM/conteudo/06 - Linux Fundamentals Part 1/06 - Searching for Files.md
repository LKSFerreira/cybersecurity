## Buscando por Arquivos

Embora não pareça até agora, uma das características redentoras do Linux é o quão eficiente você pode ser com ele. Dito isso, você só pode ser tão eficiente quanto está familiarizado com ele, é claro. À medida que você interage com SOs como o Ubuntu ao longo do tempo, comandos essenciais como os que já cobrimos começarão a se tornar memória muscular.

Uma maneira fantástica de mostrar o quão eficiente você pode ser com sistemas como este é usando um conjunto de comandos para procurar rapidamente por arquivos em todo o sistema aos quais nosso usuário tem acesso. Não há necessidade de usar `cd` e `ls` constantemente para descobrir o que está onde. Em vez disso, podemos usar comandos como `find` para automatizar coisas assim para nós!

É aqui que o Linux começa a se tornar um pouco mais intimidador de abordar -- mas vamos detalhar isso e facilitar para você.

### Usando o `find`

O comando `find` é fantástico no sentido de que pode ser usado tanto de forma muito simples quanto bastante complexa, dependendo do que você quer fazer exatamente. No entanto, vamos nos ater aos fundamentos primeiro.

Veja o trecho abaixo; podemos ver uma lista de diretórios disponíveis para nós:

> *Usando "ls" para listar o conteúdo do diretório atual*
```bash
tryhackme@linux1:~$ ls
Desktop Documents Pictures folder1
tryhackme@linux1:~$
```

*   Desktop
*   Documents
*   Pictures
*   folder1

Agora, é claro, diretórios podem conter ainda mais diretórios dentro deles. Torna-se uma dor de cabeça quando temos que olhar através de cada um deles apenas para tentar procurar por arquivos específicos. Podemos usar o `find` para fazer exatamente isso por nós!

Vamos começar de forma simples e supor que já sabemos o nome do arquivo que estamos procurando — mas não conseguimos lembrar onde ele está exatamente! Neste caso, estamos procurando por "passwords.txt".

Se lembrarmos do nome do arquivo, podemos simplesmente usar `find -name passwords.txt`, onde o comando procurará por esse arquivo específico em cada pasta do nosso diretório atual, assim:

> *Usando "find" para encontrar um arquivo com o nome de "passwords.txt"*
```bash
tryhackme@linux1:~$ find -name passwords.txt
./folder1/passwords.txt
tryhackme@linux1:~$
```

O `find` conseguiu encontrar o arquivo — acontece que ele está localizado em `folder1/passwords.txt` — ótimo. Mas digamos que não sabemos o nome do arquivo, ou queremos procurar por todos os arquivos que têm uma extensão como ".txt". O `find` também nos permite fazer isso!

Podemos simplesmente usar o que é conhecido como um curinga (`*`) para procurar por qualquer coisa que tenha `.txt` no final. Em nosso caso, queremos encontrar todos os arquivos `.txt` que estão em nosso diretório atual. Construiremos um comando como `find -name *.txt`. Onde o `find` conseguiu encontrar todos os arquivos `.txt` e nos deu a localização de cada um:

> *Usando "find" para encontrar qualquer arquivo com a extensão ".txt"*
```bash
tryhackme@linux1:~$ find -name *.txt
./folder1/passwords.txt
./Documents/todo.txt
tryhackme@linux1:~$
```

O `find` conseguiu encontrar:

*   "passwords.txt" localizado em "folder1"
*   "todo.txt" localizado em "Documents"

Não foi tão difícil, hein!

### Usando o `grep`

Outro ótimo utilitário que é excelente de se aprender é o uso do `grep`. O comando `grep` nos permite pesquisar o conteúdo de arquivos por valores específicos que estamos procurando.

Pegue, por exemplo, o log de acesso de um servidor web. Neste caso, o `access.log` de um servidor web tem 244 entradas.

> *Usando "wc" para contar o número de entradas em "access.log"*
```bash
tryhackme@linux1:~$ wc -l access.log
244 access.log
tryhackme@linux1:~$
```

Usar um comando como `cat` não vai ser muito eficaz aqui. Digamos, por exemplo, que quiséssemos pesquisar este arquivo de log para ver as coisas que um certo usuário/endereço IP visitou? Olhar através de 244 entradas não é tão eficiente, considerando que queremos encontrar um valor específico.

Podemos usar o `grep` para pesquisar todo o conteúdo deste arquivo por quaisquer entradas do valor que estamos procurando. Seguindo o exemplo do log de acesso de um servidor web, queremos ver tudo o que o endereço IP "81.143.211.90" visitou (note que isso é fictício).

> *Usando "grep" para encontrar quaisquer entradas com o endereço IP de "81.143.211.90" em "access.log"*
```bash
tryhackme@linux1:~$ grep "81.143.211.90" access.log
81.143.211.90 - - [25/Mar/2021:11:17 + 0000] "GET / HTTP/1.1" 200 417 "-" "Mozilla/5.0 (Linux; Android 7.0; Moto G(4))"
tryhackme@linux1:~$
```

O `grep` pesquisou através deste arquivo e nos mostrou quaisquer entradas do que fornecemos e que estão contidas neste arquivo de log para o IP.

---
**Responda às perguntas abaixo:**

Use `grep` em "access.log" para encontrar a flag que tem um prefixo de "THM". Qual é a flag? Nota: O arquivo "access.log" está localizado no diretório "/home/tryhackme/".
<details>
  <summary>Clique para ver a resposta</summary>
  THM{ACCESS}
</details>

E eu ainda não encontrei o que estou procurando!
<details>
  <summary>Clique para ver a resposta</summary>
  Nenhuma resposta necessária
</details>