## Ferramentas Básicas

Ferramentas como SSH, Netcat, Tmux e Vim são essenciais e usadas diariamente pela maioria dos profissionais de segurança da informação. Embora essas ferramentas não se destinem a ser ferramentas de teste de invasão, elas são críticas para o processo de teste de invasão, portanto, devemos dominá-las.

### Usando SSH

**Secure Shell (SSH)** é um protocolo de rede que roda na porta 22 por padrão e fornece aos usuários, como administradores de sistema, uma maneira segura de acessar um computador remotamente. O SSH pode ser configurado com autenticação por senha ou sem senha, usando autenticação de chave pública com um par de chaves pública/privada SSH. O SSH pode ser usado para acessar remotamente sistemas na mesma rede, pela internet, facilitar conexões a recursos em outras redes usando encaminhamento de porta/proxy (*port forwarding/proxying*), e para fazer upload/download de arquivos de e para sistemas remotos.

O SSH usa um modelo cliente-servidor, conectando um usuário que executa uma aplicação cliente SSH, como o OpenSSH, a um servidor SSH. Ao atacar uma *box* ou durante uma avaliação do mundo real, muitas vezes obtemos credenciais em texto puro ou uma chave privada SSH que pode ser aproveitada para conectar-se diretamente a um sistema via SSH. Uma conexão SSH é tipicamente muito mais estável do que uma conexão de *reverse shell* e pode ser usada como um "*jump host*" para enumerar e atacar outros hosts na rede, transferir ferramentas, configurar persistência, etc. Se obtivermos um conjunto de credenciais, podemos usar o SSH para fazer login remotamente no servidor usando o `nome_de_usuário@ip_do_servidor_remoto`, da seguinte forma:

  Ferramentas Básicas
```bash
lksferreira@htb[/htb]$ ssh Bob@10.10.10.10

Bob@remotehost's password: *********

Bob@remotehost#
```

Também é possível ler chaves privadas locais em um sistema comprometido ou adicionar nossa chave pública para obter acesso SSH a um usuário específico, como discutiremos em uma seção posterior. Como podemos ver, o SSH é uma excelente ferramenta para se conectar de forma segura a uma máquina remota. Ele também fornece uma maneira de mapear portas locais na máquina remota para nosso localhost, o que pode ser útil às vezes.

### Usando Netcat

**Netcat**, `ncat` ou `nc`, é um excelente utilitário de rede para interagir com portas TCP/UDP. Ele pode ser usado para muitas coisas durante um pentest. Seu uso principal é para conectar-se a shells, o que discutiremos mais adiante neste módulo. Além disso, o netcat pode ser usado para se conectar a qualquer porta em escuta (*listening*) e interagir com o serviço que está rodando naquela porta. Por exemplo, o SSH é programado para lidar com conexões na porta 22 para enviar todos os dados e chaves. Podemos nos conectar à porta TCP 22 com o netcat:

  Ferramentas Básicas
```bash
lksferreira@htb[/htb]$ netcat 10.10.10.10 22

SSH-2.0-OpenSSH_8.4p1 Debian-3
```

Como podemos ver, a porta 22 nos enviou seu banner, afirmando que o SSH está rodando nela. Essa técnica é chamada de **Banner Grabbing** e pode ajudar a identificar qual serviço está rodando em uma porta específica. O Netcat vem pré-instalado na maioria das distribuições Linux. Também podemos baixar uma cópia para máquinas Windows [neste link](https://nmap.org/ncat/). Existe outra alternativa para o netcat no Windows, codificada em PowerShell, chamada [PowerCat](https://github.com/besimorhino/powercat). O Netcat também pode ser usado para transferir arquivos entre máquinas, como discutiremos mais adiante.

Outro utilitário de rede semelhante é o **socat**, que possui alguns recursos que o netcat não suporta, como encaminhar portas e conectar-se a dispositivos seriais. O Socat também pode ser usado para atualizar um shell para um TTY totalmente interativo. Veremos alguns exemplos disso em uma seção posterior. O Socat é um utilitário muito útil que deve fazer parte do kit de ferramentas de todo pentester. Um binário autônomo do Socat pode ser transferido para um sistema após obter execução remota de código para obter uma conexão de *reverse shell* mais estável.

### Usando Tmux

Multiplexadores de terminal, como **tmux** ou **Screen**, são ótimos utilitários para expandir os recursos de um terminal Linux padrão, como ter várias janelas dentro de um terminal e alternar entre elas. Vamos ver alguns exemplos de uso do tmux, que é o mais comum dos dois. Se o tmux não estiver presente em nosso sistema Linux, podemos instalá-lo com o seguinte comando:

  Ferramentas Básicas
```bash
lksferreira@htb[/htb]$ sudo apt install tmux -y
```

Uma vez que temos o tmux, podemos iniciá-lo digitando `tmux` como nosso comando:
![Imagem](https://academy.hackthebox.com/storage/modules/77/getting_started_tmux_1.jpg)
> *Terminal Parrot com prompt do usuário mostrando o comando 'tmux'.*

A tecla padrão para inserir o prefixo dos comandos do tmux é **[CTRL + B]**. Para abrir uma nova janela no tmux, podemos pressionar o prefixo (ou seja, [CTRL + B]) e, em seguida, pressionar **C**:
![imagem](https://academy.hackthebox.com/storage/modules/77/getting_started_tmux_2.jpg)
> *Terminal Parrot com prompt do usuário pronto para entrada.*

Vemos as janelas numeradas na parte inferior. Podemos alternar para cada janela pressionando o prefixo e, em seguida, inserindo o número da janela, como `0` ou `1`. Também podemos dividir uma janela verticalmente em painéis (*panes*) pressionando o prefixo e, em seguida, **[SHIFT + %]**:
![imagem](https://academy.hackthebox.com/storage/modules/77/getting_started_tmux_3.jpg)
> *Terminal Parrot com dois painéis, cada um mostrando prompts do usuário prontos para entrada.*

Também podemos dividir em painéis horizontais pressionando o prefixo e, em seguida, **[SHIFT + "]**:
![imagem](https://academy.hackthebox.com/storage/modules/77/getting_started_tmux_4.jpg)
> *Terminal Parrot com dois painéis, cada um mostrando prompts do usuário prontos para entrada.*

Podemos alternar entre os painéis pressionando o prefixo e, em seguida, as setas para a esquerda ou direita para alternância horizontal ou as setas para cima ou para baixo para alternância vertical. Os comandos acima cobrem algum uso básico do tmux. É uma ferramenta poderosa e pode ser usada para muitas coisas, incluindo logging, que é muito importante durante qualquer engajamento técnico. Este [*cheatsheet*](https://tmuxcheatsheet.com/) é uma referência muito útil. Além disso, este vídeo [Introduction to tmux](https://www.youtube.com/watch?v=LqLgKx9vY24) do ippsec vale o seu tempo.

### Usando Vim

**Vim** é um ótimo editor de texto que pode ser usado para escrever código ou editar arquivos de texto em sistemas Linux. Um dos grandes benefícios de usar o Vim é que ele depende inteiramente do teclado, então você não precisa usar o mouse, o que (uma vez que pegamos o jeito) aumentará significativamente sua produtividade e eficiência na escrita/edição de código. Geralmente encontramos o Vim ou o Vi instalados em sistemas Linux comprometidos, então aprender a usá-lo nos permite editar arquivos mesmo em sistemas remotos. O Vim também possui muitos outros recursos, como extensões e plugins, que podem estender significativamente seu uso e torná-lo um ótimo editor de código. Vamos ver alguns dos conceitos básicos do Vim. Para abrir um arquivo com o Vim, podemos adicionar o nome do arquivo após ele:

  Ferramentas Básicas
```bash
lksferreira@htb[/htb]$ vim /etc/hosts
```
![imagem](https://academy.hackthebox.com/storage/modules/77/getting_started_vim_1.jpg)
> *Terminal Parrot exibindo um arquivo de configuração com configurações de rede e comentários.*

Se quisermos criar um novo arquivo, inserimos o novo nome do arquivo, e o Vim abrirá uma nova janela com esse arquivo. Uma vez que abrimos um arquivo, estamos no **modo normal** de apenas leitura, que nos permite navegar e ler o arquivo. Para editar o arquivo, pressionamos **`i`** para entrar no **modo de inserção**, indicado por `-- INSERT --` na parte inferior do Vim. Depois, podemos mover o cursor de texto e editar o arquivo:

![imagem](https://academy.hackthebox.com/storage/modules/77/getting_started_vim_2.jpg)
> *Terminal Parrot exibindo um arquivo de configuração com configurações de rede e comentários.*

Quando terminamos de editar um arquivo, podemos pressionar a tecla escape **`esc`** para sair do modo de inserção, voltando ao modo normal. Quando estamos no modo normal, podemos usar as seguintes teclas para executar alguns atalhos úteis:

| Comando | Descrição             |
| :------ | :-------------------- |
| `x`     | Cortar caractere      |
| `dw`    | Cortar palavra        |
| `dd`    | Cortar linha inteira  |
| `yw`    | Copiar palavra        |
| `yy`    | Copiar linha inteira  |
| `p`     | Colar                 |

> **Dica:** Podemos multiplicar qualquer comando para executá-lo várias vezes adicionando um número antes dele. Por exemplo, '4yw' copiaria 4 palavras em vez de uma, e assim por diante.

Se quisermos salvar um arquivo ou sair do Vim, temos que pressionar **`:`** para entrar no **modo de comando**. Uma vez que fazemos isso, veremos quaisquer comandos que digitarmos na parte inferior da janela do vim:
![imagem](https://academy.hackthebox.com/storage/modules/77/getting_started_vim_3.jpg)
> *Terminal Parrot exibindo um arquivo de configuração com configurações de rede e comentários.*

Existem muitos comandos disponíveis para nós. A seguir estão alguns deles:

| Comando | Descrição                    |
| :------ | :--------------------------- |
| `:1`    | Ir para a linha número 1.    |
| `:w`    | Escrever o arquivo, salvar   |
| `:q`    | Sair                         |
| `:q!`   | Sair sem salvar              |
| `:wq`   | Escrever e sair (salvar e sair) |

O Vim é uma ferramenta muito poderosa e tem muitos outros comandos e recursos. Este [*cheatsheet*](https://vim.rtorr.com/) é um excelente recurso para desbloquear ainda mais o poder do Vim.