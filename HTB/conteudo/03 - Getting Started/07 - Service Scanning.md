## Varredura de Serviços

Estamos prontos para dar um passo adiante e começar a explorar uma máquina! A primeira coisa que precisamos fazer é identificar o sistema operacional e quaisquer serviços disponíveis que possam estar em execução. Um **serviço** é uma aplicação rodando em um computador que executa alguma função útil para outros usuários ou computadores. Chamamos essas máquinas especializadas que hospedam esses serviços úteis de "**servidores**" em vez de estações de trabalho, permitindo que os usuários interajam e consumam esses vários serviços. O que nos interessa são serviços que foram mal configurados ou que têm uma vulnerabilidade. Em vez de executar as ações esperadas como parte do serviço, estamos interessados em ver se podemos coagir o serviço a executar alguma ação não intencional que apoie nossos objetivos, como executar um comando de nossa escolha.

Aos computadores é atribuído um endereço IP, o que lhes permite ser unicamente identificados e acessíveis em uma rede. Aos serviços em execução nesses computadores pode ser atribuído um número de porta para tornar o serviço acessível. Como discutido anteriormente, os números de porta variam de 1 a 65.535, com a faixa de portas bem conhecidas de 1 a 1.023 sendo reservada para serviços privilegiados. A porta 0 é uma porta reservada em redes TCP/IP e não é usada em mensagens TCP ou UDP. Se algo tentar se vincular à porta 0 (como um serviço), ele se vinculará à próxima porta disponível acima da porta 1.024, porque a porta 0 é tratada como uma porta "curinga" (*wild card*).

Para acessar um serviço remotamente, precisamos nos conectar usando o endereço IP e o número da porta corretos e usar uma linguagem que o serviço entenda. Examinar manualmente todas as 65.535 portas em busca de quaisquer serviços disponíveis seria trabalhoso, e por isso foram criadas ferramentas para automatizar esse processo e escanear a faixa de portas para nós. Uma das ferramentas de varredura mais comumente usadas é o **Nmap** (Network Mapper).

### Nmap

Vamos começar com a varredura mais básica. Suponha que queremos realizar uma varredura básica contra um alvo localizado em `10.129.42.253`. Para fazer isso, devemos digitar `nmap 10.129.42.253` e pressionar enter. Vemos que a varredura do Nmap foi concluída muito rapidamente. Isso ocorre porque, se não especificarmos nenhuma opção adicional, o Nmap escaneará apenas as 1.000 portas mais comuns por padrão. A saída da varredura revela que as portas 21, 22, 80, 139 e 445 estão disponíveis.

  Varredura de Serviços
```bash
lksferreira@htb[/htb]$ nmap 10.129.42.253

Starting Nmap 7.80 ( https://nmap.org ) at 2021-02-25 16:07 EST
Nmap scan report for 10.129.42.253
Host is up (0.11s latency).
Not shown: 995 closed ports
PORT    STATE SERVICE
21/tcp  open  ftp
22/tcp  open  ssh
80/tcp  open  http
139/tcp open  netbios-ssn
445/tcp open  microsoft-ds

Nmap done: 1 IP address (1 host up) scanned in 2.19 seconds
```
Sob o cabeçalho `PORT`, ele também nos diz que estas são portas TCP. Por padrão, o Nmap realizará uma varredura TCP, a menos que seja especificamente solicitado a realizar uma varredura UDP.
O cabeçalho `STATE` confirma que essas portas estão abertas. Às vezes, veremos outras portas listadas com um estado diferente, como `filtered`. Isso pode acontecer se um firewall estiver permitindo acesso às portas apenas de endereços específicos.
O cabeçalho `SERVICE` nos diz o nome do serviço que é tipicamente mapeado para o número de porta específico. No entanto, a varredura padrão não nos dirá o que está escutando naquela porta. Até que instruamos o Nmap a interagir com o serviço e tentar extrair informações de identificação, poderia ser outro serviço completamente diferente.

À medida que ganhamos familiaridade, notaremos que várias portas são comumente associadas ao Windows ou Linux. Por exemplo, a porta 3389 é a porta padrão para Serviços de Área de Trabalho Remota e é uma excelente indicação de que o alvo é uma máquina Windows. Em nosso cenário atual, a porta 22 (SSH) estar disponível indica que o alvo está executando Linux/Unix, mas este serviço também pode ser configurado no Windows. Vamos executar uma varredura Nmap mais avançada e coletar mais informações sobre o dispositivo alvo.

Podemos usar o parâmetro `-sC` para especificar que os scripts do Nmap devem ser usados para tentar obter informações mais detalhadas. O parâmetro `-sV` instrui o Nmap a realizar uma varredura de versão. Nesta varredura, o Nmap fará o *fingerprint* dos serviços no sistema alvo e identificará o protocolo do serviço, o nome da aplicação e a versão. A varredura de versão é sustentada por um banco de dados abrangente de mais de 1.000 assinaturas de serviço. Finalmente, `-p-` diz ao Nmap que queremos escanear todas as 65.535 portas TCP.

  Varredura de Serviços
```bash
lksferreira@htb[/htb]$ nmap -sV -sC -p- 10.129.42.253

Starting Nmap 7.80 ( https://nmap.org ) at 2021-02-25 16:18 EST
Nmap scan report for 10.129.42.253
Host is up (0.11s latency).
Not shown: 65530 closed ports
PORT    STATE SERVICE     VERSION
21/tcp  open  ftp         vsftpd 3.0.3
| ftp-anon: Anonymous FTP login allowed (FTP code 230)
|_drwxr-xr-x    2 ftp      ftp          4096 Feb 25 19:25 pub
| ftp-syst: 
|   STAT: 
| FTP server status:
|      Connected to ::ffff:10.10.14.2
|      Logged in as ftp
|      TYPE: ASCII
|      No session bandwidth limit
|      Session timeout in seconds is 300
|      Control connection is plain text
|      Data connections will be plain text
|      At session startup, client count was 2
|      vsFTPd 3.0.3 - secure, fast, stable
|_End of status
22/tcp  open  ssh         OpenSSH 8.2p1 Ubuntu 4ubuntu0.1 (Ubuntu Linux; protocol 2.0)
80/tcp  open  http        Apache httpd 2.4.41 ((Ubuntu))
|_http-server-header: Apache/2.4.41 (Ubuntu)
|_http-title: PHP 7.4.3 - phpinfo()
139/tcp open  netbios-ssn Samba smbd 4.6.2
445/tcp open  netbios-ssn Samba smbd 4.6.2
Service Info: OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

Host script results:
|_nbstat: NetBIOS name: GS-SVCSCAN, NetBIOS user: <unknown>, NetBIOS MAC: <unknown> (unknown)
| smb2-security-mode: 
|   2.02: 
|_    Message signing enabled but not required
| smb2-time: 
|   date: 2021-02-25T21:21:51
|_  start_date: N/A

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 233.68 seconds
```
Isso retorna muito mais informações. Vemos que demorou muito mais para escanear 65.535 portas do que 1.000 portas. As opções `-sC` e `-sV` também aumentam a duração de uma varredura, pois, em vez de realizar um simples *handshake* TCP, elas realizam muito mais verificações. Notamos que desta vez há um cabeçalho `VERSION`, que relata a versão do serviço e o sistema operacional, se for possível identificar.

Até agora, sabemos que o sistema operacional é Ubuntu Linux. As versões das aplicações também podem ajudar a revelar a versão do SO alvo. Pegue o OpenSSH, por exemplo. Vemos que a versão relatada é `OpenSSH 8.2p1 Ubuntu 4ubuntu0.1`. A partir da inspeção de outros *changelogs* de pacotes SSH do Ubuntu, vemos que a versão de lançamento assume o formato `1:7.3p1-1ubuntu0.1`. Atualizando nossa versão para se ajustar a este formato, obtemos `1:8.2p1-4ubuntu0.1`. Uma busca rápida por esta versão online revela que ela está incluída no Ubuntu Linux Focal Fossa 20.04.

![imagem](https://academy.hackthebox.com/storage/modules/77/google1.png)
> *Resultados da pesquisa do Google para '1:8.2p1-4ubuntu0.1 release' mostrando links para o pacote OpenSSH no Launchpad.*

Outra busca rápida revela que a data de lançamento deste SO é 23 de abril de 2020.

![imagem](https://academy.hackthebox.com/storage/modules/77/google2.png)
> *Resultados da pesquisa do Google para 'Ubuntu focal 20.04 release date' mostrando 23 de abril de 2020 como a data de lançamento.*

No entanto, vale a pena notar que essa técnica de referência cruzada não é totalmente confiável, pois é possível instalar pacotes de aplicação mais recentes em uma versão de SO mais antiga. A flag de varredura de script `-sC` faz com que o Nmap relate os cabeçalhos do servidor (`http-server-header`) e o título da página (`http-title`) para qualquer página da web hospedada no servidor web. O título da página `PHP 7.4.3 - phpinfo()` indica que este é um arquivo PHPInfo, que muitas vezes é criado manualmente para confirmar que o PHP foi instalado com sucesso. O título (e a página PHPInfo) também revela a versão do PHP, o que vale a pena notar se for vulnerável.

![imagem](https://academy.hackthebox.com/storage/modules/77/phpinfo.png)
> `http://10.129.42.253/index.php`
> *Tabela de informações da Versão PHP 7.4.3 mostrando detalhes do sistema, data de compilação, API do servidor e caminhos de configuração.*

#### Scripts do Nmap

Especificar `-sC` executará muitos scripts padrão úteis contra um alvo, mas há casos em que é necessário executar um script específico. Por exemplo, em um escopo de avaliação, podemos ser solicitados a auditar uma grande instalação Citrix. Poderíamos usar [este script do Nmap](https://nmap.org/nsedoc/scripts/citrix-netscaler-enum-apps.html) para auditar a grave vulnerabilidade do Citrix NetScaler (CVE-2019–19781), enquanto o Nmap também tem outros scripts para auditar uma instalação Citrix.

  Varredura de Serviços
```bash
lksferreira@htb[/htb]$ locate scripts/citrix

/usr/share/nmap/scripts/citrix-brute-xml.nse
/usr/share/nmap/scripts/citrix-enum-apps-xml.nse
/usr/share/nmap/scripts/citrix-enum-apps.nse
/usr/share/nmap/scripts/citrix-enum-servers-xml.nse
/usr/share/nmap/scripts/citrix-enum-servers.nse
```
A sintaxe para executar um script do Nmap é `nmap --script <nome_do_script> -p<porta> <host>`.

Os scripts do Nmap são uma ótima maneira de aprimorar a funcionalidade de nossas varreduras, e a inspeção das opções disponíveis renderá dividendos. Confira o módulo [Enumeração de Rede com Nmap](./caminho/para/enum-rede-nmap.md) para um estudo mais detalhado da ferramenta Nmap.

### Atacando Serviços de Rede

#### Banner Grabbing

Como discutido anteriormente, *banner grabbing* é uma técnica útil para fazer o *fingerprint* de um serviço rapidamente. Muitas vezes, um serviço se identificará exibindo um banner assim que uma conexão for iniciada. O Nmap tentará pegar os banners se a sintaxe `nmap -sV --script=banner <target>` for especificada. Também podemos tentar isso manualmente usando o Netcat. Vamos pegar outro exemplo, usando a versão `nc` do Netcat:

  Varredura de Serviços
```bash
lksferreira@htb[/htb]$ nc -nv 10.129.42.253 21

(UNKNOWN) [10.129.42.253] 21 (ftp) open
220 (vsFTPd 3.0.3)
```
Isso revela que a versão do vsFTPd no servidor é 3.0.3. Também podemos automatizar esse processo usando o poderoso motor de scripts do Nmap: `nmap -sV --script=banner -p21 10.10.10.0/24`.

#### FTP

Vale a pena se familiarizar com o FTP, pois é um protocolo padrão, e este serviço muitas vezes pode conter dados interessantes. Uma varredura Nmap da porta padrão para FTP (21) revela a instalação do vsftpd 3.0.3 que identificamos anteriormente. Além disso, também relata que a autenticação anônima está habilitada e que um diretório `pub` está disponível.

  Varredura de Serviços
```bash
lksferreira@htb[/htb]$ nmap -sC -sV -p21 10.129.42.253

Starting Nmap 7.80 ( https://nmap.org ) at 2020-12-20 00:54 GMT
Nmap scan report for 10.129.42.253
Host is up (0.081s latency).

PORT   STATE SERVICE VERSION
21/tcp open  ftp     vsftpd 3.0.3
| ftp-anon: Anonymous FTP login allowed (FTP code 230)
|_drwxr-xr-x    2 ftp      ftp          4096 Dec 19 23:50 pub
| ftp-syst: 
|   STAT: 
| FTP server status:
|      Connected to ::ffff:10.10.14.2
|      Logged in as ftp
|      TYPE: ASCII
|      No session bandwidth limit
|      Session timeout in seconds is 300
|      Control connection is plain text
|      Data connections will be plain text
|      At session startup, client count was 3
|      vsFTPd 3.0.3 - secure, fast, stable
|_End of status
Service Info: OS: Unix

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 1.78 seconds
```
Vamos nos conectar ao serviço usando o utilitário de linha de comando `ftp`.

  Varredura de Serviços
```bash
lksferreira@htb[/htb]$ ftp -p 10.129.42.253

Connected to 10.129.42.253.
220 (vsFTPd 3.0.3)
Name (10.129.42.253:user): anonymous
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.

ftp> ls
227 Entering Passive Mode (10,129,42,253,158,60).
150 Here comes the directory listing.
drwxr-xr-x    2 ftp      ftp          4096 Feb 25 19:25 pub
226 Directory send OK.

ftp> cd pub
250 Directory successfully changed.

ftp> ls
227 Entering Passive Mode (10,129,42,253,182,129).
150 Here comes the directory listing.
-rw-r--r--    1 ftp      ftp            18 Feb 25 19:25 login.txt
226 Directory send OK.

ftp> get login.txt
local: login.txt remote: login.txt
227 Entering Passive Mode (10,129,42,253,181,53).
150 Opening BINARY mode data connection for login.txt (18 bytes).
226 Transfer complete.
18 bytes received in 0.00 secs (165.8314 kB/s)

ftp> exit
221 Goodbye.
```
No shell acima, vemos que o FTP suporta comandos comuns como `cd` e `ls` e nos permite baixar arquivos usando o comando `get`. A inspeção do arquivo `login.txt` baixado revela credenciais que poderíamos usar para avançar nosso acesso ao sistema.

  Varredura de Serviços
```bash
lksferreira@htb[/htb]$ cat login.txt 

admin:ftp@dmin123
```

#### SMB

SMB (Server Message Block) é um protocolo prevalente em máquinas Windows que fornece muitos vetores para movimento vertical e lateral. Dados sensíveis, incluindo credenciais, podem estar em compartilhamentos de arquivos de rede, e algumas versões do SMB podem ser vulneráveis a exploits de RCE, como o EternalBlue. É crucial enumerar cuidadosamente esta grande superfície de ataque potencial. O Nmap tem muitos scripts para enumerar SMB, como o `smb-os-discovery.nse`, que interagirá com o serviço SMB para extrair a versão do sistema operacional relatada.

  Varredura de Serviços
```bash
lksferreira@htb[/htb]$ nmap --script smb-os-discovery.nse -p445 10.10.10.40

Starting Nmap 7.91 ( https://nmap.org ) at 2020-12-27 00:59 GMT
Nmap scan report for doctors.htb (10.10.10.40)
Host is up (0.022s latency).

PORT    STATE SERVICE
445/tcp open  microsoft-ds

Host script results:
| smb-os-discovery: 
|   OS: Windows 7 Professional 7601 Service Pack 1 (Windows 7 Professional 6.1)
|   OS CPE: cpe:/o:microsoft:windows_7::sp1:professional
|   Computer name: CEO-PC
|   NetBIOS computer name: CEO-PC\x00
|   Workgroup: WORKGROUP\x00
|_  System time: 2020-12-27T00:59:46+00:00

Nmap done: 1 IP address (1 host up) scanned in 2.71 seconds
```
Neste caso, o host executa um SO Windows 7 legado, e poderíamos conduzir uma enumeração adicional para confirmar se ele é vulnerável ao EternalBlue. O Metasploit Framework tem vários módulos para o EternalBlue que podem ser usados para validar a vulnerabilidade e explorá-la, como veremos em uma seção futura. Podemos executar uma varredura contra nosso alvo para esta seção do módulo para coletar informações do serviço SMB. Podemos verificar que o host executa um kernel Linux, Samba versão 4.6.2, e o nome do host é `GS-SVCSCAN`.

  Varredura de Serviços
```bash
lksferreira@htb[/htb]$ nmap -A -p445 10.129.42.253

Starting Nmap 7.80 ( https://nmap.org ) at 2021-02-25 16:29 EST
Nmap scan report for 10.129.42.253
Host is up (0.11s latency).

PORT    STATE SERVICE     VERSION
445/tcp open  netbios-ssn Samba smbd 4.6.2
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Aggressive OS guesses: Linux 2.6.32 (95%), Linux 3.1 (95%), Linux 3.2 (95%), AXIS 210A or 211 Network Camera (Linux 2.6.17) (94%), ASUS RT-N56U WAP (Linux 3.4) (93%), Linux 3.16 (93%), Adtran 424RG FTTH gateway (92%), Linux 2.6.39 - 3.2 (92%), Linux 3.1 - 3.2 (92%), Linux 3.2 - 4.9 (92%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 2 hops

Host script results:
|_nbstat: NetBIOS name: GS-SVCSCAN, NetBIOS user: <unknown>, NetBIOS MAC: <unknown> (unknown)
| smb2-security-mode: 
|   2.02: 
|_    Message signing enabled but not required
| smb2-time: 
|   date: 2021-02-25T21:30:06
|_  start_date: N/A

TRACEROUTE (using port 445/tcp)
HOP RTT       ADDRESS
1   111.62 ms 10.10.14.1
2   111.89 ms 10.129.42.253

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 12.72 seconds
```
##### Compartilhamentos (Shares)

O SMB permite que usuários e administradores compartilhem pastas e as tornem acessíveis remotamente por outros usuários. Muitas vezes, esses compartilhamentos têm arquivos que contêm informações sensíveis, como senhas. Uma ferramenta que pode enumerar e interagir com compartilhamentos SMB é o `smbclient`. A flag `-L` especifica que queremos obter uma lista de compartilhamentos disponíveis no host remoto, enquanto `-N` suprime o prompt de senha.

  Varredura de Serviços
```bash
lksferreira@htb[/htb]$ smbclient -N -L \\\\10.129.42.253

	Sharename       Type      Comment
	---------       ----      -------
	print$          Disk      Printer Drivers
	users           Disk      
	IPC$            IPC       IPC Service (gs-svcscan server (Samba, Ubuntu))
SMB1 disabled -- no workgroup available
```
Isso revela o compartilhamento não padrão `users`. Vamos tentar nos conectar como o usuário convidado (*guest*).

  Varredura de Serviços
```bash
lksferreira@htb[/htb]$ smbclient \\\\10.129.42.253\\users

Enter WORKGROUP\users's password: 
Try "help" to get a list of possible commands.

smb: \> ls
NT_STATUS_ACCESS_DENIED listing \*

smb: \> exit
```
O comando `ls` resultou em uma mensagem de acesso negado, indicando que o acesso de convidado não é permitido. Vamos tentar novamente usando as credenciais do usuário `bob` (`bob:Welcome1`).

  Varredura de Serviços
```bash
lksferreira@htb[/htb]$ smbclient -U bob \\\\10.129.42.253\\users

Enter WORKGROUP\bob's password: 
Try "help" to get a list of possible commands.

smb: \> ls
  .                                   D        0  Thu Feb 25 16:42:23 2021
  ..                                  D        0  Thu Feb 25 15:05:31 2021
  bob                                 D        0  Thu Feb 25 16:42:23 2021

		4062912 blocks of size 1024. 1332480 blocks available
		
smb: \> cd bob

smb: \bob\> ls
  .                                   D        0  Thu Feb 25 16:42:23 2021
  ..                                  D        0  Thu Feb 25 16:42:23 2021
  passwords.txt                       N      156  Thu Feb 25 16:42:23 2021

		4062912 blocks of size 1024. 1332480 blocks available
		
smb: \bob\> get passwords.txt 
getting file \bob\passwords.txt of size 156 as passwords.txt (0.3 KiloBytes/sec) (average 0.3 KiloBytes/sec)
```
Conseguimos acesso com sucesso ao compartilhamento `users` usando credenciais e obtivemos acesso ao arquivo interessante `passwords.txt`, que pode ser baixado com o comando `get`.

#### SNMP

As *community strings* do SNMP fornecem informações e estatísticas sobre um roteador ou dispositivo, ajudando-nos a obter acesso a ele. As *community strings* padrão do fabricante, `public` e `private`, muitas vezes não são alteradas. Nas versões 1 e 2c do SNMP, o acesso é controlado usando uma *community string* em texto puro, e se soubermos o nome, podemos obter acesso a ele. Criptografia e autenticação só foram adicionadas na versão 3 do SNMP. Muitas informações podem ser obtidas do SNMP. O exame dos parâmetros do processo pode revelar credenciais passadas na linha de comando, que podem ser reutilizadas para outros serviços acessíveis externamente, dada a prevalência da reutilização de senhas em ambientes empresariais. Informações de roteamento, serviços vinculados a interfaces adicionais e a versão do software instalado também podem ser reveladas.

  Varredura de Serviços
```bash
lksferreira@htb[/htb]$ snmpwalk -v 2c -c public 10.129.42.253 1.3.6.1.2.1.1.5.0

iso.3.6.1.2.1.1.5.0 = STRING: "gs-svcscan"
```
  Varredura de Serviços
```bash
lksferreira@htb[/htb]$ snmpwalk -v 2c -c private  10.129.42.253 

Timeout: No Response from 10.129.42.253
```
Uma ferramenta como o `onesixtyone` pode ser usada para forçar os nomes das *community strings* usando um arquivo de dicionário de *community strings* comuns, como o arquivo `dict.txt` incluído no repositório GitHub da ferramenta.

  Varredura de Serviços
```bash
lksferreira@htb[/htb]$ onesixtyone -c dict.txt 10.129.42.254

Scanning 1 hosts, 51 communities
10.129.42.254 [public] Linux gs-svcscan 5.4.0-66-generic #74-Ubuntu SMP Wed Jan 27 22:54:38 UTC 2021 x86_64
```

### Conclusão

A varredura e enumeração de serviços é um assunto vasto sobre o qual aprenderemos mais à medida que avançamos. Os aspectos que cobrimos aqui se aplicam a muitas redes, incluindo as máquinas do HTB.