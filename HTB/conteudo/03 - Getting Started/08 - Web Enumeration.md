## Enumeração Web

Ao realizar a varredura de serviços, frequentemente encontraremos servidores web rodando nas portas 80 e 443. Os servidores web hospedam aplicações web (às vezes mais de uma), que muitas vezes fornecem uma superfície de ataque considerável e um alvo de altíssimo valor durante um teste de invasão. A enumeração web adequada é crítica, especialmente quando uma organização não expõe muitos serviços ou esses serviços estão devidamente corrigidos (*patched*).

### Gobuster

Após descobrir uma aplicação web, sempre vale a pena verificar se podemos descobrir quaisquer arquivos ou diretórios ocultos no servidor web que não se destinam ao acesso público. Podemos usar uma ferramenta como `ffuf` ou `GoBuster` para realizar essa enumeração de diretórios. Às vezes, encontraremos funcionalidades ocultas ou páginas/diretórios expondo dados sensíveis que podem ser aproveitados para acessar a aplicação web ou até mesmo para execução remota de código no próprio servidor web.

#### Enumeração de Diretório/Arquivo

O GoBuster é uma ferramenta versátil que permite realizar *brute-forcing* de DNS, vhost e diretórios. A ferramenta possui funcionalidades adicionais, como a enumeração de buckets S3 públicos da AWS. Para os propósitos deste módulo, estamos interessados nos modos de *brute-forcing* de diretório (e arquivo), especificados com o switch `dir`. Vamos executar uma varredura simples usando a wordlist `common.txt` do dirb.

  Enumeração Web
```bash
lksferreira@htb[/htb]$ gobuster dir -u http://10.10.10.121/ -w /usr/share/seclists/Discovery/Web-Content/common.txt

===============================================================
Gobuster v3.0.1
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@_FireFart_)
===============================================================
[+] Url:            http://10.10.10.121/
[+] Threads:        10
[+] Wordlist:       /usr/share/seclists/Discovery/Web-Content/common.txt
[+] Status codes:   200,204,301,302,307,401,403
[+] User Agent:     gobuster/3.0.1
[+] Timeout:        10s
===============================================================
2020/12/11 21:47:25 Starting gobuster
===============================================================
/.hta (Status: 403)
/.htpasswd (Status: 403)
/.htaccess (Status: 403)
/index.php (Status: 200)
/server-status (Status: 403)
/wordpress (Status: 301)
===============================================================
2020/12/11 21:47:46 Finished
===============================================================
```
Um código de status HTTP `200` revela que a requisição do recurso foi bem-sucedida, enquanto um código de status HTTP `403` indica que estamos proibidos de acessar o recurso. Um código de status `301` indica que estamos sendo redirecionados, o que não é um caso de falha. Vale a pena se familiarizar com os vários códigos de status HTTP, que podem ser encontrados [aqui](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status). O Módulo da Academy sobre [Requisições Web](./caminho/para/web-requests.md) também cobre os códigos de status HTTP mais a fundo.

A varredura foi concluída com sucesso e identifica uma instalação do WordPress em `/wordpress`. O WordPress é o CMS (Content Management System - Sistema de Gerenciamento de Conteúdo) mais comumente usado e tem uma enorme superfície de ataque potencial. Neste caso, visitar `http://10.10.10.121/wordpress` em um navegador revela que o WordPress ainda está em modo de configuração, o que nos permitirá obter execução remota de código (RCE) no servidor.

![imagem](https://academy.hackthebox.com/storage/modules/77/wordpress.png)
> *Tela de seleção de idioma do WordPress com uma lista de idiomas e um botão 'Continuar'.*

#### Enumeração de Subdomínio DNS

Também pode haver recursos essenciais hospedados em subdomínios, como painéis de administração ou aplicações com funcionalidades adicionais que poderiam ser exploradas. Podemos usar o GoBuster para enumerar subdomínios disponíveis de um determinado domínio usando a flag `dns` para especificar o modo DNS. Primeiro, vamos clonar o repositório do GitHub do SecLists, que contém muitas listas úteis para *fuzzing* e exploração:

**Instalar SecLists**
  Enumeração Web
```bash
lksferreira@htb[/htb]$ git clone https://github.com/danielmiessler/SecLists
```
  Enumeração Web
```bash
lksferreira@htb[/htb]$ sudo apt install seclists -y
```
Em seguida, adicione um Servidor DNS como `1.1.1.1` ao arquivo `/etc/resolv.conf`. Vamos visar o domínio `inlanefreight.com`, o site de uma empresa fictícia de frete e logística.

  Enumeração Web
```bash
lksferreira@htb[/htb]$ gobuster dns -d inlanefreight.com -w /usr/share/SecLists/Discovery/DNS/namelist.txt

===============================================================
Gobuster v3.0.1
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@_FireFart_)
===============================================================
[+] Domain:     inlanefreight.com
[+] Threads:    10
[+] Timeout:    1s
[+] Wordlist:   /usr/share/SecLists/Discovery/DNS/namelist.txt
===============================================================
2020/12/17 23:08:55 Starting gobuster
===============================================================
Found: blog.inlanefreight.com
Found: customer.inlanefreight.com
Found: my.inlanefreight.com
Found: ns1.inlanefreight.com
Found: ns2.inlanefreight.com
Found: ns3.inlanefreight.com
===============================================================
2020/12/17 23:10:34 Finished
===============================================================
```
Esta varredura revela vários subdomínios interessantes que poderíamos examinar mais a fundo. O módulo [Atacando Aplicações Web com Ffuf](./caminho/para/attacking-web-apps-ffuf.md) entra em mais detalhes sobre enumeração web e *fuzzing*.

### Dicas de Enumeração Web

Vamos percorrer algumas dicas adicionais de enumeração web que ajudarão a completar máquinas no HTB e no mundo real.

#### Banner Grabbing / Cabeçalhos do Servidor Web

Na última seção, discutimos *banner grabbing* para fins gerais. Os cabeçalhos do servidor web fornecem uma boa imagem do que está hospedado em um servidor web. Eles podem revelar o framework da aplicação específico em uso, as opções de autenticação e se o servidor está sem opções de segurança essenciais ou foi mal configurado. Podemos usar o `cURL` para obter informações do cabeçalho do servidor a partir da linha de comando. O `cURL` é outra adição essencial ao nosso kit de ferramentas de teste de invasão, e a familiaridade com suas muitas opções é encorajada.

  Enumeração Web
```bash
lksferreira@htb[/htb]$ curl -IL https://www.inlanefreight.com

HTTP/1.1 200 OK
Date: Fri, 18 Dec 2020 22:24:05 GMT
Server: Apache/2.4.29 (Ubuntu)
Link: <https://www.inlanefreight.com/index.php/wp-json/>; rel="https://api.w.org/"
Link: <https://www.inlanefreight.com/>; rel=shortlink
Content-Type: text/html; charset=UTF-8
```
Outra ferramenta útil é o `EyeWitness`, que pode ser usado para tirar capturas de tela de aplicações web alvo, fazer seu *fingerprint* e identificar possíveis credenciais padrão.

#### Whatweb

Podemos extrair a versão dos servidores web, frameworks de suporte e aplicações usando a ferramenta de linha de comando `whatweb`. Esta informação pode nos ajudar a identificar as tecnologias em uso e começar a procurar por vulnerabilidades potenciais.

  Enumeração Web
```bash
lksferreira@htb[/htb]$ whatweb 10.10.10.121

http://10.10.10.121 [200 OK] Apache[2.4.41], Country[RESERVED][ZZ], Email[license@php.net], HTTPServer[Ubuntu Linux][Apache/2.4.41 (Ubuntu)], IP[10.10.10.121], Title[PHP 7.4.3 - phpinfo()]
```
O `Whatweb` é uma ferramenta útil e contém muita funcionalidade para automatizar a enumeração de aplicações web em uma rede.

  Enumeração Web
```bash
lksferreira@htb[/htb]$ whatweb --no-errors 10.10.10.0/24

http://10.10.10.11 [200 OK] Country[RESERVED][ZZ], HTTPServer[nginx/1.14.1], IP[10.10.10.11], PoweredBy[Red,nginx], Title[Test Page for the Nginx HTTP Server on Red Hat Enterprise Linux], nginx[1.14.1]
http://10.10.10.100 [200 OK] Apache[2.4.41], Country[RESERVED][ZZ], HTTPServer[Ubuntu Linux][Apache/2.4.41 (Ubuntu)], IP[10.10.10.100], Title[File Sharing Service]
http://10.10.10.121 [200 OK] Apache[2.4.41], Country[RESERVED][ZZ], Email[license@php.net], HTTPServer[Ubuntu Linux][Apache/2.4.41 (Ubuntu)], IP[10.10.10.121], Title[PHP 7.4.3 - phpinfo()]
http://10.10.10.247 [200 OK] Bootstrap, Country[RESERVED][ZZ], Email[contact@cross-fit.htb], Frame, HTML5, HTTPServer[OpenBSD httpd], IP[10.10.10.247], JQuery[3.3.1], PHP[7.4.12], Script, Title[Fine Wines], X-Powered-By[PHP/7.4.12], X-UA-Compatible[ie=edge]
```

#### Certificados

Os certificados SSL/TLS são outra fonte de informação potencialmente valiosa se o HTTPS estiver em uso. Navegar para `https://10.10.10.121/` e visualizar o certificado revela os detalhes abaixo, incluindo o endereço de e-mail e o nome da empresa. Estes poderiam ser potencialmente usados para conduzir um ataque de phishing se isso estiver dentro do escopo de uma avaliação.

![imagem](https://academy.hackthebox.com/storage/modules/77/cert.png)
> *Detalhes do certificado para Megabank Limited, incluindo informações do sujeito e do emissor com país, estado, localidade, organização e endereço de e-mail.*

#### Robots.txt

É comum que os sites contenham um arquivo `robots.txt`, cujo propósito é instruir os rastreadores da web de mecanismos de busca, como o Googlebot, sobre quais recursos podem e não podem ser acessados para indexação. O arquivo `robots.txt` pode fornecer informações valiosas, como a localização de arquivos privados e páginas de administração. Neste caso, vemos que o arquivo `robots.txt` contém duas entradas não permitidas (*disallowed*).

![imagem](https://academy.hackthebox.com/storage/modules/77/robots.png)
> *Arquivo Robots.txt não permitindo o acesso a /private e /uploaded_files para todos os user-agents.*

Navegar para `http://10.10.10.121/private` em um navegador revela uma página de login de administrador do HTB.

![imagem](https://academy.hackthebox.com/storage/modules/77/academy.png)
> *Formulário de login com campos para nome de usuário e senha, e um botão de login.*

#### Código Fonte

Também vale a pena verificar o código fonte de quaisquer páginas da web que encontrarmos. Podemos pressionar **[CTRL + U]** para abrir a janela de código fonte em um navegador. Este exemplo revela um comentário de desenvolvedor contendo credenciais para uma conta de teste, que poderiam ser usadas para fazer login no site.

![imagem](https://academy.hackthebox.com/storage/modules/77/source.png)
> *Trecho de HTML com credenciais de conta de teste, meta tags e título de login de administrador.*