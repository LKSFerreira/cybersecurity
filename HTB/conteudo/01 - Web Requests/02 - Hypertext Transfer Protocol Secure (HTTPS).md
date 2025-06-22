**Protocolo de Transferência de Hipertexto Seguro (HTTPS)**

Na seção anterior, discutimos como as requisições HTTP são enviadas e processadas. No entanto, uma das desvantagens significativas do HTTP é que todos os dados são transferidos em texto puro (clear-text). Isso significa que qualquer pessoa entre a origem e o destino pode realizar um ataque Man-in-the-middle (MiTM) para visualizar os dados transferidos.

Para combater esse problema, o protocolo HTTPS (HTTP Seguro) foi criado, no qual todas as comunicações são transferidas em um formato criptografado, assim, mesmo que um terceiro intercepte a requisição, eles não conseguiriam extrair os dados dela. Por essa razão, HTTPS tornou-se o esquema predominante (mainstream) para websites na internet, e o HTTP está sendo gradualmente descontinuado (phased out), e em breve a maioria dos navegadores web não permitirá visitar websites HTTP.

**Visão Geral do HTTPS**

Se examinarmos uma requisição HTTP, podemos ver o efeito de não impor comunicações seguras entre um navegador web e uma aplicação web. Por exemplo, o seguinte é o conteúdo de uma requisição de login HTTP:
![Captura do Wireshark mostrando uma requisição HTTP POST](https://academy.hackthebox.com/storage/modules/35/https_clear.png)
*Captura do Wireshark mostrando uma requisição HTTP POST para /login.php com nome de usuário 'admin' e senha 'password' em texto puro.*

Podemos ver que as credenciais de login podem ser visualizadas em texto puro (clear-text). Isso tornaria fácil para alguém na mesma rede (como uma rede sem fio pública) capturar a requisição e reutilizar as credenciais para fins maliciosos.

Em contraste, quando alguém intercepta e analisa o tráfego de uma requisição HTTPS, eles veriam algo como o seguinte:
![Captura do Wireshark mostrando dados de aplicação criptografados](https://academy.hackthebox.com/storage/modules/35/https_google_enc.png)
*Captura do Wireshark mostrando dados de aplicação criptografados TLSv1.2 da origem 216.58.197.36 para o destino 192.168.0.108, usando a porta 443.*

Como podemos ver, os dados são transferidos como um único fluxo (stream) criptografado, o que torna muito difícil para qualquer pessoa capturar informações como credenciais ou quaisquer outros dados sensíveis.

Websites que impõem HTTPS podem ser identificados através de `https://` em sua URL (ex: `https://www.google.com`), bem como pelo ícone de cadeado na barra de endereços do navegador web, à esquerda da URL:
![Navegador mostrando informações do site para www.google.com](https://academy.hackthebox.com/storage/modules/35/https_google.png)
*Navegador mostrando informações do site para www.google.com: conexão segura, nenhuma permissão especial concedida, opção para limpar cookies e dados do site.*

Então, se visitarmos um website que utiliza HTTPS, como o Google, todo o tráfego será criptografado.

**Nota:** Embora os dados transferidos através do protocolo HTTPS possam ser criptografados, a requisição ainda pode revelar a URL visitada se contatou um servidor DNS em texto puro (clear-text). Por esta razão, é recomendado utilizar servidores DNS criptografados (ex: 8.8.8.8 ou 1.1.1.1), ou utilizar um serviço de VPN para garantir que todo o tráfego seja devidamente criptografado.

**Fluxo HTTPS**

Vejamos como o HTTPS opera em alto nível:
![Diagrama da comunicação HTTP para HTTPS](https://academy.hackthebox.com/storage/modules/35/HTTPS_Flow.png)
*Diagrama da comunicação HTTP para HTTPS: Usuário solicita inlanefreight.com, recebe redirecionamento HTTP 301 para HTTPS, seguido por handshake TLS e comunicação criptografada.*

Se digitarmos `http://` em vez de `https://` para visitar um website que impõe HTTPS, o navegador tenta resolver o domínio e redireciona o usuário para o servidor web que hospeda o website alvo. Uma requisição é enviada primeiro para a porta 80, que é o protocolo HTTP não criptografado. O servidor detecta isso e redireciona o cliente para a porta HTTPS segura 443. Isso é feito através do código de resposta 301 Movido Permanentemente (301 Moved Permanently), que discutiremos em uma próxima seção.

Em seguida, o cliente (navegador web) envia um pacote "client hello", fornecendo informações sobre si mesmo. Depois disso, o servidor responde com "server hello", seguido por uma troca de chaves (key exchange) para trocar certificados SSL. O cliente verifica a chave/certificado e envia um dos seus. Depois disso, um handshake criptografado é iniciado para confirmar se a criptografia e a transferência estão funcionando corretamente.

Uma vez que o handshake é concluído com sucesso, a comunicação HTTP normal é continuada, sendo criptografada a partir daí. Esta é uma visão geral de muito alto nível da troca de chaves (key exchange), que está além do escopo deste módulo.

**Nota:** Dependendo das circunstâncias, um atacante pode ser capaz de realizar um ataque de downgrade HTTP (HTTP downgrade attack), que rebaixa a comunicação HTTPS para HTTP, tornando os dados transferidos em texto puro (clear-text). Isso é feito configurando um proxy Man-In-The-Middle (MITM) para transferir todo o tráfego através do host do atacante sem o conhecimento do usuário. No entanto, a maioria dos navegadores, servidores e aplicações web modernos protegem contra esse ataque.

**cURL para HTTPS**

O cURL deve lidar automaticamente com todos os padrões de comunicação HTTPS e realizar um handshake seguro e, em seguida, criptografar e descriptografar dados automaticamente. No entanto, se alguma vez contatarmos um website com um certificado SSL inválido ou desatualizado, então o cURL, por padrão, não prosseguiria com a comunicação para proteger contra os ataques MiTM mencionados anteriormente:

  Protocolo de Transferência de Hipertexto Seguro (HTTPS)
```bash
lksferreira@htb[/htb]$ curl https://inlanefreight.com

curl: (60) Problema com o certificado SSL: Cadeia de certificados inválida
Mais detalhes aqui: https://curl.haxx.se/docs/sslcerts.html
...RECORTADO...
```

Navegadores web modernos fariam o mesmo, alertando o usuário contra visitar um website com um certificado SSL inválido.

Podemos enfrentar tal problema ao testar uma aplicação web local ou com uma aplicação web hospedada para fins de prática, já que tais aplicações web podem ainda não ter implementado um certificado SSL válido. Para pular a verificação de certificado com o cURL, podemos usar a flag `-k`:

  Protocolo de Transferência de Hipertexto Seguro (HTTPS)
```bash
lksferreira@htb[/htb]$ curl -k https://inlanefreight.com

<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html><head>
...RECORTADO...
```

Como podemos ver, a requisição foi processada desta vez, e recebemos os dados da resposta.