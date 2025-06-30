## Conectando-se Usando VPN

Uma rede privada virtual (VPN) nos permite conectar a uma rede privada (interna) e acessar hosts e recursos como se estivéssemos diretamente conectados à rede privada alvo. É um canal de comunicações seguro sobre redes públicas compartilhadas para se conectar a uma rede privada (ou seja, um funcionário conectando-se remotamente à rede corporativa de sua empresa de sua casa). As VPNs fornecem um grau de privacidade e segurança ao criptografar as comunicações sobre o canal para evitar interceptação (eavesdropping) e acesso aos dados que trafegam pelo canal.
![Diagrama de rede](https://academy.hackthebox.com/storage/modules/77/GettingStarted.png)
> *Diagrama de rede mostrando Internet, Firewall, Servidor VPN, LAN Corporativa, Servidores Corporativos, Desktops e Uso Remoto.*

Em alto nível, uma VPN funciona roteando a conexão de internet do nosso dispositivo através do servidor privado da VPN alvo, em vez de nosso provedor de serviços de internet (ISP). Quando conectado a uma VPN, os dados se originam do servidor VPN em vez de nosso computador e parecerão se originar de um endereço IP público diferente do nosso.

Existem dois tipos principais de VPNs de acesso remoto: **VPN baseada em cliente** e **VPN SSL**. A VPN SSL usa o navegador web como o cliente VPN. A conexão é estabelecida entre o navegador e um gateway de VPN SSL e pode ser configurada para permitir acesso apenas a aplicações baseadas na web, como e-mail e sites de intranet, ou até mesmo à rede interna, mas sem a necessidade de o usuário final instalar ou usar qualquer software especializado. A VPN baseada em cliente requer o uso de um software cliente para estabelecer a conexão VPN. Uma vez conectado, o host do usuário funcionará principalmente como se estivesse conectado diretamente à rede da empresa e será capaz de acessar quaisquer recursos (aplicações, hosts, sub-redes, etc.) permitidos pela configuração do servidor. Algumas VPNs corporativas fornecerão aos funcionários acesso total à rede corporativa interna, enquanto outras colocarão os usuários em um segmento específico reservado para trabalhadores remotos.

### Por que Usar uma VPN?

Podemos usar um serviço de VPN como NordVPN ou Private Internet Access e nos conectar a um servidor VPN em outra parte do nosso país ou em outra região do mundo para ocultar nosso tráfego de navegação ou disfarçar nosso endereço IP público. Isso pode nos fornecer algum nível de segurança e privacidade. Ainda assim, como estamos nos conectando ao servidor de uma empresa, sempre há a chance de que os dados estejam sendo registrados ou que o serviço de VPN não esteja seguindo as melhores práticas de segurança ou os recursos de segurança que eles anunciam. O uso de um serviço de VPN vem com o risco de que o provedor não esteja fazendo o que diz e esteja registrando todos os dados. O uso de um serviço de VPN não garante anonimato ou privacidade, mas é útil para contornar certas restrições de rede/firewall ou quando conectado a uma rede possivelmente hostil (ou seja, uma rede sem fio de aeroporto público). Um serviço de VPN nunca deve ser usado com o pensamento de que nos protegerá das consequências de realizar atividades nefastas.

### Conectando-se à VPN do HTB

O HTB e outros serviços que oferecem VMs/redes propositalmente vulneráveis exigem que os jogadores se conectem à rede alvo via VPN para acessar a rede privada do laboratório. Os hosts dentro das redes do HTB não podem se conectar diretamente à internet. Ao se conectar à VPN do HTB (ou a qualquer laboratório focado em testes de invasão/hacking), devemos sempre considerar a rede como "hostil". Devemos nos conectar apenas a partir de uma máquina virtual, desabilitar a autenticação por senha se o SSH estiver ativado em nossa VM de ataque, proteger quaisquer servidores web e não deixar informações sensíveis em nossa VM de ataque (ou seja, não jogue no HTB ou em outras redes vulneráveis com a mesma VM que usamos para realizar avaliações de clientes). Ao nos conectarmos a uma VPN (seja na HTB Academy ou na plataforma principal do HTB), usamos o seguinte comando:

  Conectando-se Usando VPN
```bash
lksferreira@htb[/htb]$ sudo openvpn user.ovpn

Thu Dec 10 18:42:41 2020 OpenVPN 2.4.9 x86_64-pc-linux-gnu [SSL (OpenSSL)] [LZO] [LZ4] [EPOLL] [PKCS11] [MH/PKTINFO] [AEAD] built on Apr 21 2020
Thu Dec 10 18:42:41 2020 library versions: OpenSSL 1.1.1g  21 Apr 2020, LZO 2.10
Thu Dec 10 18:42:41 2020 Outgoing Control Channel Authentication: Using 256 bit message hash 'SHA256' for HMAC authentication
Thu Dec 10 18:42:41 2020 Incoming Control Channel Authentication: Using 256 bit message hash 'SHA256' for HMAC authentication
Thu Dec 10 18:42:41 2020 TCP/UDP: Preserving recently used remote address: [AF_INET]
Thu Dec 10 18:42:41 2020 Socket Buffers: R=[212992->212992] S=[212992->212992]
Thu Dec 10 18:42:41 2020 UDP link local: (not bound)
...RECORTADO...
Thu Dec 10 18:42:41 2020 Initialization Sequence Completed
```

A última linha `Initialization Sequence Completed` nos diz que nos conectamos com sucesso à VPN.

Onde `sudo` diz ao nosso host para executar o comando como o usuário `root` elevado, `openvpn` é o cliente VPN, e o arquivo `user.ovpn` é a chave VPN que baixamos da seção do módulo da Academy ou da plataforma principal do HTB. Se digitarmos `ifconfig` em outra janela do terminal, veremos um adaptador `tun` se nos conectamos com sucesso à VPN.

  Conectando-se Usando VPN
```bash
lksferreira@htb[/htb]$ ifconfig

...RECORTADO...

tun0: flags=4305<UP,POINTOPOINT,RUNNING,NOARP,MULTICAST>  mtu 1500
        inet 10.10.x.2  netmask 255.255.254.0  destination 10.10.x.2
        inet6 dead:beef:1::2000  prefixlen 64  scopeid 0x0<global>
        inet6 fe80::d82f:301a:a94a:8723  prefixlen 64  scopeid 0x20<link>
        unspec 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00  txqueuelen
```

Digitar `netstat -rn` nos mostrará as redes acessíveis via VPN.

  Conectando-se Usando VPN
```bash
lksferreira@htb[/htb]$ netstat -rn

Kernel IP routing table
Destination     Gateway         Genmask         Flags   MSS Window  irtt Iface
0.0.0.0         192.168.1.2     0.0.0.0         UG        0 0          0 eth0
10.10.14.0      0.0.0.0         255.255.254.0   U         0 0          0 tun0
10.129.0.0      10.10.14.1      255.255.0.0     UG        0 0          0 tun0
192.168.1.0     0.0.0.0         255.255.255.0   U         0 0          0 eth0
```

Aqui podemos ver que a rede `10.129.0.0/16` usada para as máquinas da HTB Academy está acessível através do adaptador `tun0` via rede `10.10.14.0/23`.

### Ajuda com a VPN

Se esta é sua primeira vez usando uma VPN, os seguintes recursos no portal de suporte do Hack The Box serão úteis:

*   [**Introdução ao Acesso ao Laboratório**](https://help.hackthebox.com/en/articles/5185687-gs-introduction-to-lab-access)
*   [**Solução de Problemas de Conexão**](https://help.hackthebox.com/en/articles/5185536-t-connection-troubleshooting)