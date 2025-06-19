### **HyperText Transfer Protocol (HTTP)**

Hoje em dia, a maioria dos aplicativos que utilizamos interage constantemente com a internet, tanto aplicativos web quanto mobile. A maior parte das comunicações na internet é feita por meio de requisições web através do protocolo **HTTP**. HTTP é um protocolo em nível de aplicação utilizado para acessar recursos da **World Wide Web**. O termo *hypertext* significa texto que contém links para outros recursos e texto que os leitores podem interpretar facilmente.

A comunicação via HTTP consiste em um **cliente** e um **servidor**, onde o cliente solicita um recurso ao servidor. O servidor processa a solicitação e retorna o recurso requisitado. A porta padrão para comunicação HTTP é a **porta 80**, embora isso possa ser alterado para qualquer outra porta, dependendo da configuração do servidor web. As mesmas requisições são utilizadas quando acessamos diferentes sites na internet. Digitamos um **Fully Qualified Domain Name (FQDN)** como um **Uniform Resource Locator (URL)** para acessar o site desejado, como por exemplo *[www.hackthebox.com](http://www.hackthebox.com)*.

---

### **URL**

Os recursos via HTTP são acessados por meio de uma **URL**, que oferece muito mais especificações do que simplesmente indicar um site que queremos visitar. Vamos analisar a estrutura de uma URL:
![Estrutura da URL](https://academy.hackthebox.com/storage/modules/35/url_structure.png)
### **Aqui está o que cada componente representa:**

| **Componente**   | **Exemplo**           | **Descrição**                                                                                                                                                                        |
| ---------------- | --------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Scheme**       | `http://`, `https://` | Usado para identificar o **protocolo** que está sendo acessado pelo cliente. Termina com dois pontos e duas barras (`://`).                                                          |
| **User Info**    | `admin:password@`     | Componente opcional que contém as **credenciais** (separadas por dois-pontos `:`) utilizadas para autenticar-se no **host**, sendo separado deste por uma arroba (`@`).              |
| **Host**         | `inlanefreight.com`   | O host indica a **localização do recurso**. Pode ser um **nome de domínio (hostname)** ou um **endereço IP**.                                                                        |
| **Port**         | `:80`                 | A porta é separada do host por dois-pontos (`:`). Se nenhuma porta for especificada, o esquema `http` utiliza por padrão a **porta 80**, e o `https` a **porta 443**.                |
| **Path**         | `/dashboard.php`      | Aponta para o **recurso sendo acessado**, que pode ser um arquivo ou uma pasta. Se nenhum path for especificado, o servidor retorna o **índice padrão** (por exemplo, `index.html`). |
| **Query String** | `?login=true`         | A **query string** começa com uma interrogação (`?`) e consiste em um **parâmetro** (ex: `login`) e um **valor** (ex: `true`). Múltiplos parâmetros podem ser separados por `&`.     |
| **Fragments**    | `#status`             | Os **fragments** são processados pelos navegadores no **lado do cliente**, para localizar seções dentro do recurso principal (por exemplo, um cabeçalho ou seção da página).         |

> Nem todos os componentes são necessários para acessar um recurso. Os campos obrigatórios principais são o **scheme** e o **host**, sem os quais a requisição não teria um destino válido.

### **Fluxo HTTP**
![Fluxo HTTP](https://academy.hackthebox.com/storage/modules/35/HTTP_Flow.png) 

Diagrama mostra um usuário acessando `inlanefreight.com`. O navegador envia uma consulta DNS para encontrar o endereço IP, recebe `152.153.81.14` e faz uma requisição HTTP para o servidor web, que responde com `HTTP/1.1 200 OK`.

O diagrama acima apresenta a anatomia de uma requisição HTTP em um nível bem alto. Na primeira vez que um usuário digita a URL (`inlanefreight.com`) no navegador, ele envia uma solicitação para um servidor **DNS (Domain Name System)** para resolver o domínio e obter seu IP. O servidor DNS busca o endereço IP para `inlanefreight.com` e o retorna. Todos os nomes de domínio precisam ser resolvidos dessa maneira, já que um servidor não pode se comunicar sem um endereço IP.

> **Nota:** Nossos navegadores geralmente consultam primeiro os registros no arquivo local `/etc/hosts`. Se o domínio solicitado não estiver presente nesse arquivo, eles então contatam outros servidores DNS. Podemos usar o `/etc/hosts` para adicionar registros manualmente para a resolução DNS, adicionando o IP seguido do nome do domínio.

Depois que o navegador obtém o endereço IP associado ao domínio solicitado, ele envia uma **requisição GET** para a porta padrão do HTTP (ex: 80), pedindo pelo caminho raiz `/`. O servidor web então recebe a requisição e a processa. Por padrão, os servidores são configurados para retornar um **arquivo índice** quando uma requisição para `/` é recebida.

Nesse caso, o conteúdo do `index.html` é lido e retornado pelo servidor web como uma resposta HTTP. A resposta também contém um **código de status** (ex: `200 OK`), que indica que a requisição foi processada com sucesso. O navegador então **renderiza** o conteúdo do `index.html` e o exibe para o usuário.

> **Nota:** Este módulo foca principalmente em requisições web HTTP. Para mais informações sobre HTML e aplicações web, consulte o módulo **Introdução às Aplicações Web**.

---

### **cURL**

Neste módulo, enviaremos requisições web utilizando duas das ferramentas mais importantes para qualquer pentester web: um **navegador web** (como Chrome ou Firefox), e a ferramenta de linha de comando **cURL**.

**cURL (client URL)** é uma ferramenta de linha de comando e biblioteca que oferece suporte principalmente ao protocolo HTTP, além de muitos outros. Isso a torna uma ótima candidata para **scripts e automações**, sendo essencial para o envio de diferentes tipos de requisições web a partir do terminal — algo necessário em muitos testes de penetração web.

Podemos enviar uma requisição HTTP básica para qualquer URL usando-a como argumento no cURL, assim:

```bash
lksferreira@htb[/htb]$ curl inlanefreight.com
```

```html
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html><head>
...SNIP...
```

Podemos ver que o **cURL** não renderiza o código HTML/JavaScript/CSS, ao contrário de um navegador web, mas o imprime em seu **formato bruto**. No entanto, como **pentesters**, estamos principalmente interessados no **contexto da requisição e resposta**, o que normalmente torna o uso do cURL **muito mais rápido e prático** do que um navegador.

Também podemos usar o cURL para **baixar uma página ou arquivo** e salvar o conteúdo em um arquivo usando a flag `-O`. Se quisermos especificar o nome do arquivo de saída, podemos usar a flag `-o` e informar o nome. Caso contrário, com `-O`, o cURL usará o nome do arquivo remoto, como no exemplo:

```bash
lksferreira@htb[/htb]$ curl -O inlanefreight.com/index.html
lksferreira@htb[/htb]$ ls
index.html
```

Como podemos ver, a saída não foi impressa, mas sim salva no arquivo `index.html`. Repare que o cURL ainda imprimiu algum status enquanto processava a requisição. Podemos **silenciar** esse status usando a flag `-s`, como a seguir:

```bash
lksferreira@htb[/htb]$ curl -s -O inlanefreight.com/index.html
```

Dessa vez, o cURL não imprimiu nada, pois a saída foi salva no arquivo `index.html`. Finalmente, podemos usar a flag `-h` para ver outras opções disponíveis com o cURL:

```bash
lksferreira@htb[/htb]$ curl -h
Usage: curl [options...] <url>
 -d, --data <data>       HTTP POST data
 -h, --help <category>   Obter ajuda para comandos
 -i, --include           Incluir cabeçalhos da resposta do protocolo na saída
 -o, --output <file>     Escrever em arquivo ao invés da saída padrão (stdout)
 -O, --remote-name       Salvar com o nome do arquivo remoto
 -s, --silent            Modo silencioso
 -u, --user <user:senha> Usuário e senha do servidor
 -A, --user-agent <nome> Enviar User-Agent <nome> para o servidor
 -v, --verbose           Deixar a operação mais detalhada
```

Essa não é a ajuda completa — esse menu está dividido em categorias.
Use `--help category` para obter uma visão geral de todas as categorias.
Use o manual do usuário `man curl` ou a flag `--help all` para ver todas as opções disponíveis.


Aqui está a tradução completa para o português (pt-BR), com termos técnicos mantidos em inglês quando necessário:

---

### **Hypertext Transfer Protocol Secure (HTTPS)**

Na seção anterior, discutimos como as requisições HTTP são enviadas e processadas. No entanto, uma das grandes desvantagens do HTTP é que todos os dados são transferidos em **texto claro (clear-text)**. Isso significa que qualquer pessoa entre a origem e o destino pode realizar um ataque **Man-in-the-Middle (MiTM)** e visualizar os dados transmitidos.

Para resolver esse problema, foi criado o protocolo **HTTPS (HTTP Secure)**, no qual todas as comunicações são transferidas de forma **criptografada**. Assim, mesmo que uma terceira parte intercepte a requisição, ela não conseguirá extrair os dados. Por isso, o HTTPS se tornou o padrão dominante na internet, enquanto o HTTP está sendo gradualmente descontinuado. Em breve, a maioria dos navegadores nem permitirá o acesso a sites sem HTTPS.

---

### **Visão geral do HTTPS**

Se analisarmos uma requisição HTTP, podemos ver os riscos de não utilizar comunicações seguras entre um navegador e uma aplicação web. Por exemplo, veja o conteúdo de uma requisição de login feita via HTTP:

📷 *(imagem mostra dados de login visíveis em texto claro)*
🔗 ![https://academy.hackthebox.com/storage/modules/35/https\_clear.png](https://academy.hackthebox.com/storage/modules/35/https_clear.png)

Podemos ver que as credenciais de login estão visíveis em **texto claro**, facilitando que alguém na mesma rede (como uma rede Wi-Fi pública) capture a requisição e **reuse as credenciais** para fins maliciosos.

Em contraste, ao interceptar e analisar o tráfego de uma requisição via HTTPS, veríamos algo assim:

📷 *(imagem mostra dados criptografados)*
🔗 ![https://academy.hackthebox.com/storage/modules/35/https\_google\_enc.png](https://academy.hackthebox.com/storage/modules/35/https_google_enc.png)

Aqui, os dados são transferidos como um **fluxo criptografado**, dificultando muito que alguém capture informações como credenciais ou dados sensíveis.

Sites que utilizam HTTPS podem ser identificados pelo prefixo `https://` na URL (ex: `https://www.google.com`) e pelo **ícone de cadeado** na barra de endereços do navegador, à esquerda da URL:

📷 *(imagem do cadeado ao lado da URL no navegador)*
🔗 ![https://academy.hackthebox.com/storage/modules/35/https\_google.png](https://academy.hackthebox.com/storage/modules/35/https_google.png)

Portanto, ao visitar um site que utiliza HTTPS, como o Google, todo o tráfego será **criptografado**.

> **Nota:** Embora os dados transferidos via HTTPS estejam criptografados, a **URL visitada ainda pode ser exposta** caso o DNS usado seja em texto claro. Por isso, é recomendado utilizar **servidores DNS criptografados** (como 8.8.8.8 ou 1.1.1.1) ou usar um serviço de **VPN** para garantir que todo o tráfego esteja devidamente protegido.

---

### **Fluxo HTTPS**

Vamos ver como o HTTPS opera em alto nível:

📷 *(imagem do fluxo HTTPS)*
🔗 ![https://academy.hackthebox.com/storage/modules/35/HTTPS\_Flow.png](https://academy.hackthebox.com/storage/modules/35/HTTPS_Flow.png)

Se digitarmos `http://` ao invés de `https://` para acessar um site que exige HTTPS, o navegador ainda tenta resolver o domínio e se conecta ao servidor web. A requisição é enviada inicialmente à **porta 80** (protocolo HTTP não criptografado). O servidor detecta isso e redireciona o cliente para a **porta segura 443 (HTTPS)**. Isso é feito através do **código de resposta 301 Moved Permanently**, que veremos em uma seção futura.

Em seguida, o cliente (navegador) envia um **pacote “client hello”**, com informações sobre si mesmo. O servidor responde com um **“server hello”**, seguido pela **troca de chaves** (key exchange) para compartilhar os **certificados SSL**. O cliente verifica o certificado e envia um próprio. Depois, é iniciada uma **negociação criptografada (handshake)** para confirmar que a criptografia e a transferência estão funcionando corretamente.

Após a conclusão do handshake, a comunicação HTTP segue normalmente, **já criptografada**. Essa é uma visão simplificada da troca de chaves, cujo detalhamento está fora do escopo deste módulo.

> **Nota:** Dependendo das circunstâncias, um atacante pode tentar realizar um **ataque de downgrade HTTP**, forçando a comunicação HTTPS a ser convertida em HTTP, deixando os dados visíveis. Isso é feito por meio de um proxy MiTM que redireciona todo o tráfego para o host do atacante sem o conhecimento do usuário. No entanto, navegadores e servidores modernos já possuem **proteções contra esse tipo de ataque**.

---

### **cURL para HTTPS**

O **cURL** lida automaticamente com toda a comunicação HTTPS, realizando o handshake seguro e criptografando/descriptografando os dados. Porém, se tentarmos acessar um site com um **certificado SSL inválido ou expirado**, o cURL **bloqueará a comunicação** para evitar ataques MiTM:

```bash
lksferreira@htb[/htb]$ curl https://inlanefreight.com

curl: (60) SSL certificate problem: Invalid certificate chain
More details here: https://curl.haxx.se/docs/sslcerts.html
...SNIP...
```

Navegadores modernos agem da mesma forma, **alertando o usuário** ao visitar sites com certificados inválidos.

Esse tipo de erro é comum durante testes locais ou em aplicações web de prática, que muitas vezes **não têm um certificado SSL válido**. Para **ignorar a verificação de certificado** com cURL, podemos usar a flag `-k`:

```bash
lksferreira@htb[/htb]$ curl -k https://inlanefreight.com

<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html><head>
...SNIP...
```

Como vemos, a requisição foi aceita desta vez e os dados foram retornados normalmente.
