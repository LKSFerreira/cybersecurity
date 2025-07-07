## Escalação de Privilégios

Nosso acesso inicial a um servidor remoto geralmente ocorre no contexto de um usuário com poucos privilégios, o que não nos daria acesso completo sobre a *box*. Para obter acesso total, precisaremos encontrar uma vulnerabilidade interna/local que escale nossos privilégios para o usuário `root` no Linux ou para o usuário `administrator`/`SYSTEM` no Windows. Vamos percorrer alguns métodos comuns de escalação de nossos privilégios.

### Checklists de Escalação de Privilégios (PrivEsc)

Uma vez que obtemos acesso inicial a uma *box*, queremos enumerar minuciosamente a *box* para encontrar quaisquer vulnerabilidades potenciais que possamos explorar para alcançar um nível de privilégio mais alto. Podemos encontrar muitos checklists e *cheat sheets* online que têm uma coleção de verificações que podemos executar e os comandos para executar essas verificações. Um excelente recurso é o [HackTricks](https://book.hacktricks.xyz/), que tem um excelente checklist para escalação de privilégios local tanto em Linux quanto em Windows. Outro excelente repositório é o [PayloadsAllTheThings](https://github.com/swisskyrepo/PayloadsAllTheThings), que também tem checklists para Linux e Windows. Devemos começar a experimentar vários comandos e técnicas e nos familiarizar com eles para entender múltiplas fraquezas que podem levar à escalação de nossos privilégios.

### Scripts de Enumeração

Muitos dos comandos acima podem ser executados automaticamente com um script para percorrer o relatório e procurar por quaisquer fraquezas. Podemos executar muitos scripts para enumerar automaticamente o servidor, executando comandos comuns que retornam quaisquer achados interessantes. Alguns dos scripts de enumeração Linux comuns incluem [LinEnum](https://github.com/rebootuser/LinEnum) e [linuxprivchecker](https://github.com/linted/linuxprivchecker), e para Windows incluem [Seatbelt](https://github.com/GhostPack/Seatbelt) e [JAWS](https://github.com/411Hall/JAWS).

Outra ferramenta útil que podemos usar para a enumeração de servidores é a [Privilege Escalation Awesome Scripts SUITE (PEASS)](https://github.com/carlospolop/PEASS-ng), pois é bem mantida para permanecer atualizada e inclui scripts para enumerar tanto Linux quanto Windows.

> **Nota:** Esses scripts executarão muitos comandos conhecidos por identificar vulnerabilidades e criarão muito "ruído" que pode acionar software antivírus ou software de monitoramento de segurança que procura por esses tipos de eventos. Isso pode impedir que os scripts sejam executados ou até mesmo acionar um alarme de que o sistema foi comprometido. Em algumas instâncias, podemos querer fazer uma enumeração manual em vez de executar scripts.

Vamos pegar um exemplo de execução do script Linux do PEASS chamado LinPEAS:

  Escalação de Privilégios
```bash
lksferreira@htb[/htb]$ ./linpeas.sh
...RECORTADO...

Linux Privesc Checklist: https://book.hacktricks.xyz/linux-unix/linux-privilege-escalation-checklist
 LEYEND:
  RED/YELLOW: 99% a PE vector
  RED: You must take a look at it
  LightCyan: Users with console
  Blue: Users without console & mounted devs
  Green: Common things (users, groups, SUID/SGID, mounts, .sh scripts, cronjobs)
  LightMangenta: Your username


====================================( Basic information )=====================================
OS: Linux version 3.9.0-73-generic
User & Groups: uid=33(www-data) gid=33(www-data) groups=33(www-data)
...RECORTADO...
```
Como podemos ver, uma vez que o script é executado, ele começa a coletar informações e a exibi-las em um excelente relatório. Vamos discutir algumas das vulnerabilidades que devemos procurar na saída desses scripts.

### Exploits de Kernel

Sempre que encontrarmos um servidor executando um sistema operacional antigo, devemos começar procurando por vulnerabilidades potenciais de kernel que possam existir. Se o servidor não estiver sendo mantido com as últimas atualizações e patches, é provável que seja vulnerável a exploits de kernel específicos encontrados em versões não corrigidas do Linux e do Windows.

Por exemplo, o script acima nos mostrou que a versão do Linux é `3.9.0-73-generic`. Se pesquisarmos no Google por exploits para esta versão ou usarmos o `searchsploit`, encontraríamos um CVE-2016-5195, também conhecido como **DirtyCow**. Podemos procurar e baixar o exploit DirtyCow e executá-lo no servidor para obter acesso root.

O mesmo conceito também se aplica ao Windows, pois existem muitas vulnerabilidades em versões mais antigas/não corrigidas do Windows, com várias vulnerabilidades que podem ser usadas para escalação de privilégios. Devemos ter em mente que os exploits de kernel podem causar instabilidade no sistema, e devemos ter muito cuidado antes de executá-los em sistemas de produção. É melhor testá-los em um ambiente de laboratório e executá-los em sistemas de produção apenas com aprovação explícita e coordenação com nosso cliente.

### Software Vulnerável

Outra coisa que devemos procurar é o software instalado. Por exemplo, podemos usar o comando `dpkg -l` no Linux ou olhar em `C:\Program Files` no Windows para ver qual software está instalado no sistema. Devemos procurar por exploits públicos para qualquer software instalado, especialmente se alguma versão mais antiga estiver em uso, contendo vulnerabilidades não corrigidas.

### Privilégios de Usuário

Outro aspecto crítico a ser procurado após obter acesso a um servidor são os privilégios disponíveis para o usuário ao qual temos acesso. Se tivermos permissão para executar comandos específicos como `root` (ou como outro usuário), podemos ser capazes de escalar nossos privilégios para usuários `root`/`system` ou obter acesso como um usuário diferente. Abaixo estão algumas maneiras comuns de explorar certos privilégios de usuário:

*   `sudo`
*   `SUID`
*   Privilégios de Token do Windows

O comando `sudo` no Linux permite que um usuário execute comandos como um usuário diferente. Geralmente é usado para permitir que usuários com menos privilégios executem comandos como `root` sem lhes dar acesso ao usuário `root`. Isso geralmente é feito porque comandos específicos só podem ser executados como `root` (como `tcpdump`) ou para permitir que o usuário acesse certos diretórios exclusivos do `root`. Podemos verificar quais privilégios `sudo` temos com o comando `sudo -l`:

  Escalação de Privilégios
```bash
lksferreira@htb[/htb]$ sudo -l

[sudo] password for user1:
...RECORTADO...

User user1 may run the following commands on ExampleServer:
    (ALL : ALL) ALL
```
A saída acima diz que podemos executar todos os comandos com `sudo`, o que nos dá acesso completo, e podemos usar o comando `su` com `sudo` para mudar para o usuário `root`:

  Escalação de Privilégios
```bash
lksferreira@htb[/htb]$ sudo su -

[sudo] password for user1:
whoami
root
```
O comando acima requer uma senha para executar qualquer comando com `sudo`. Há certas ocasiões em que podemos ter permissão para executar certas aplicações, ou todas as aplicações, sem ter que fornecer uma senha:

  Escalação de Privilégios
```bash
lksferreira@htb[/htb]$ sudo -l

    (user : user) NOPASSWD: /bin/echo
```
A entrada `NOPASSWD` mostra que o comando `/bin/echo` pode ser executado sem senha. Isso seria útil se obtivéssemos acesso ao servidor através de uma vulnerabilidade e não tivéssemos a senha do usuário. Como diz `user`, podemos executar `sudo` como esse usuário e não como `root`. Para fazer isso, podemos especificar o usuário com `-u user`:

  Escalação de Privilégios
```bash
lksferreira@htb[/htb]$ sudo -u user /bin/echo Hello World!

    Hello World!
```
Uma vez que encontramos uma aplicação específica que podemos executar com `sudo`, podemos procurar maneiras de explorá-la para obter um shell como o usuário `root`. O [GTFOBins](https://gtfobins.github.io/) contém uma lista de comandos e como eles podem ser explorados através do `sudo`. Podemos procurar pela aplicação sobre a qual temos privilégio `sudo`, e se ela existir, pode nos dizer o comando exato que devemos executar para obter acesso root usando o privilégio `sudo` que temos.

O [LOLBAS](https://lolbas-project.github.io/) também contém uma lista de aplicações do Windows que podemos aproveitar para executar certas funções, como baixar arquivos ou executar comandos no contexto de um usuário privilegiado.

### Tarefas Agendadas

Tanto no Linux quanto no Windows, existem métodos para que scripts sejam executados em intervalos específicos para realizar uma tarefa. Alguns exemplos são ter uma varredura de antivírus rodando a cada hora ou um script de backup que roda a cada 30 minutos. Geralmente, existem duas maneiras de tirar proveito de tarefas agendadas (Windows) ou *cron jobs* (Linux) para escalar nossos privilégios:

1.  Adicionar novas tarefas agendadas/*cron jobs*
2.  Enganá-los para executar um software malicioso

A maneira mais fácil é verificar se temos permissão para adicionar novas tarefas agendadas. No Linux, uma forma comum de manter tarefas agendadas é através de *Cron Jobs*. Existem diretórios específicos que podemos utilizar para adicionar novos *cron jobs* se tivermos permissões de escrita sobre eles. Estes incluem:

*   `/etc/crontab`
*   `/etc/cron.d`
*   `/var/spool/cron/crontabs/root`

Se pudermos escrever em um diretório chamado por um *cron job*, podemos escrever um script bash com um comando de reverse shell, que deve nos enviar um reverse shell quando executado.

### Credenciais Expostas

Em seguida, podemos procurar por arquivos que podemos ler e ver se eles contêm alguma credencial exposta. Isso é muito comum em arquivos de configuração, arquivos de log e arquivos de histórico do usuário (`bash_history` no Linux e `PSReadLine` no Windows). Os scripts de enumeração que discutimos no início geralmente procuram por senhas potenciais em arquivos e as fornecem para nós, como abaixo:

  Escalação de Privilégios
```bash
...RECORTADO...
[+] Searching passwords in config PHP files
[+] Finding passwords inside logs (limit 70)
...RECORTADO...
/var/www/html/config.php: $conn = new mysqli(localhost, 'db_user', 'password123');
```
Como podemos ver, a senha do banco de dados `password123` está exposta, o que nos permitiria fazer login nos bancos de dados mysql locais e procurar por informações interessantes. Também podemos verificar a **Reutilização de Senha**, pois o usuário do sistema pode ter usado sua senha para os bancos de dados, o que pode nos permitir usar a mesma senha para mudar para esse usuário, da seguinte forma:

  Escalação de Privilégios
```bash
lksferreira@htb[/htb]$ su -

Password: password123
whoami

root
```
Também podemos usar as credenciais do usuário para fazer `ssh` no servidor como esse usuário.

### Chaves SSH

Finalmente, vamos discutir as chaves SSH. Se tivermos acesso de leitura sobre o diretório `.ssh` de um usuário específico, podemos ler suas chaves ssh privadas encontradas em `/home/user/.ssh/id_rsa` ou `/root/.ssh/id_rsa`, e usá-la para fazer login no servidor. Se pudermos ler o diretório `/root/.ssh/` e pudermos ler o arquivo `id_rsa`, podemos copiá-lo para nossa máquina e usar a flag `-i` para fazer login com ele:

  Escalação de Privilégios
```bash
lksferreira@htb[/htb]$ vim id_rsa
lksferreira@htb[/htb]$ chmod 600 id_rsa
lksferreira@htb[/htb]$ ssh root@10.10.10.10 -i id_rsa

root@10.10.10.10#
```
Note que usamos o comando `chmod 600 id_rsa` na chave depois que a criamos em nossa máquina para tornar as permissões do arquivo mais restritivas. Se as chaves ssh tiverem permissões frouxas, ou seja, talvez possam ser lidas por outras pessoas, o servidor ssh impediria que elas funcionassem.

Se nos encontrarmos com acesso de escrita a um diretório `.ssh/` de um usuário, podemos colocar nossa chave pública no diretório ssh do usuário em `/home/user/.ssh/authorized_keys`. Esta técnica é geralmente usada para obter acesso ssh após obter um shell como esse usuário. A configuração SSH atual não aceitará chaves escritas por outros usuários, então só funcionará se já tivermos obtido controle sobre esse usuário. Primeiro, devemos criar uma nova chave com `ssh-keygen` e a flag `-f` para especificar o arquivo de saída:

  Escalação de Privilégios
```bash
lksferreira@htb[/htb]$ ssh-keygen -f key

Generating public/private rsa key pair.
Enter passphrase (empty for no passphrase): *******
Enter same passphrase again: *******

Your identification has been saved in key
Your public key has been saved in key.pub
The key fingerprint is:
SHA256:...RECORTADO... user@parrot
The key's randomart image is:
+---[RSA 3072]----+
|   ..o.++.+      |
...RECORTADO...
|     . ..oo+.    |
+----[SHA256]-----+
```
Isso nos dará dois arquivos: `key` (que usaremos com `ssh -i`) e `key.pub`, que copiaremos para a máquina remota. Vamos copiar `key.pub`, então na máquina remota, vamos adicioná-lo em `/root/.ssh/authorized_keys`:

  Escalação de Privilégios
```bash
user@remotehost$ echo "ssh-rsa AAAAB...RECORTADO...M= user@parrot" >> /root/.ssh/authorized_keys
```
Agora, o servidor remoto deve nos permitir fazer login como esse usuário usando nossa chave privada:

  Escalação de Privilégios
```bash
lksferreira@htb[/htb]$ ssh root@10.10.10.10 -i key

root@remotehost# 
```
Como podemos ver, agora podemos fazer ssh como o usuário `root`. Os módulos [Escalação de Privilégios Linux](./caminho/para/linux-privesc.md) e [Escalação de Privilégios Windows](./caminho/para/windows-privesc.md) entram em mais detalhes sobre como usar cada um desses métodos para Escalação de Privilégios, e muitos outros também.