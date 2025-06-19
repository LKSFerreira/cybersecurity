## Requisições e Respostas HTTP

As comunicações HTTP consistem principalmente em uma requisição HTTP e uma resposta HTTP. Uma requisição HTTP é feita pelo cliente (por exemplo, cURL/navegador) e processada pelo servidor (por exemplo, servidor web). As requisições contêm todos os detalhes que solicitamos ao servidor, incluindo o recurso (por exemplo, URL, caminho, parâmetros), quaisquer dados da requisição, *headers* ou opções que especificamos, além de muitas outras opções que discutiremos ao longo deste módulo.

Assim que o servidor recebe a requisição HTTP, ele a processa e responde enviando a resposta HTTP, que contém o código de resposta (discutido em uma seção posterior) e pode conter os dados do recurso, caso o solicitante tenha acesso a ele.

---

### Requisição HTTP

Vamos começar analisando o seguinte exemplo de requisição HTTP:

![Exemplo de Requisição HTTP](https://academy.hackthebox.com/storage/modules/35/raw_request.png)

**Detalhes da requisição HTTP**: Método `GET`, caminho `/users/login.html`, versão `HTTP/1.1`. Os *headers* incluem `Host: inlanefreight.com`, `User-Agent: Mozilla/5.0` e `Cookie: PHPSESSID=c4ggt4jull9obt7aupa55o8vbf`.

A imagem acima mostra uma requisição HTTP GET para a URL:

```
http://inlanefreight.com/users/login.html
```

A primeira linha de qualquer requisição HTTP contém três campos principais, **separados por espaços**:

| Campo   | Exemplo             | Descrição                                                                                                                 |
| ------- | ------------------- | ------------------------------------------------------------------------------------------------------------------------- |
| Method  | `GET`               | O método ou verbo HTTP, que especifica o tipo de ação a ser realizada.                                                    |
| Path    | `/users/login.html` | O caminho até o recurso que está sendo acessado. Esse campo também pode conter uma *query string* (ex: `?username=user`). |
| Version | `HTTP/1.1`          | O terceiro e último campo indica a versão do protocolo HTTP.                                                              |

As próximas linhas contêm os pares chave-valor dos *headers* HTTP, como `Host`, `User-Agent`, `Cookie`, entre muitos outros possíveis. Esses *headers* são usados para especificar vários atributos da requisição. Os *headers* são finalizados com uma nova linha, o que é necessário para o servidor validar a requisição. Finalmente, uma requisição pode terminar com o corpo da requisição (*request body*) e seus dados.

**Nota**: A versão HTTP 1.X envia as requisições em *clear-text* (texto plano), usando o caractere de nova linha para separar diferentes campos e diferentes requisições. Já a versão HTTP 2.X envia as requisições como dados binários, no formato de dicionário.

---

### Resposta HTTP

Assim que o servidor processa nossa requisição, ele envia sua resposta. Abaixo temos um exemplo de resposta HTTP:
![Exemplo de Resposta HTTP](https://academy.hackthebox.com/storage/modules/35/raw_response.png)

**Detalhes da resposta HTTP**: Versão `HTTP/1.1`, status `200 OK`. *Headers* incluem `Date`, `Server: Apache/2.4.41`, `Set-Cookie: PHPSESSID=m4u64rqlpfthrvvb12ai9voqgf`, e `Content-Type: text/html; charset=UTF-8`.

A primeira linha de uma resposta HTTP contém dois campos separados por espaços: o primeiro é a versão HTTP (por exemplo, `HTTP/1.1`) e o segundo indica o código de resposta HTTP (por exemplo, `200 OK`).

Os códigos de resposta são usados para determinar o status da requisição, como discutiremos em uma seção posterior. Após a primeira linha, a resposta lista seus *headers*, de forma semelhante à requisição HTTP. Ambos os *headers* de requisição e resposta são discutidos na próxima seção.

Finalmente, a resposta pode terminar com um **corpo de resposta** (*response body*), que é separado por uma nova linha após os *headers*. O corpo da resposta geralmente é definido como código HTML. No entanto, ele também pode conter outros tipos de código, como JSON, recursos de sites como imagens, folhas de estilo (*style sheets*) ou scripts, ou até mesmo documentos, como um PDF hospedado no servidor web.

---

## cURL

Nos exemplos anteriores com o `cURL`, apenas especificamos a URL e obtivemos o corpo da resposta em retorno. No entanto, o `cURL` também permite visualizar a requisição HTTP completa e a resposta HTTP completa, o que pode ser extremamente útil durante testes de penetração web ou ao escrever exploits. Para visualizar a requisição e resposta completas, podemos simplesmente adicionar a opção `-v` (*verbose*) aos comandos anteriores, e isso exibirá tanto a requisição quanto a resposta:

```bash
lksferreira@htb[/htb]$ curl inlanefreight.com -v

*   Trying SERVER_IP:80...
* TCP_NODELAY set
* Connected to inlanefreight.com (SERVER_IP) port 80 (#0)
> GET / HTTP/1.1
> Host: inlanefreight.com
> User-Agent: curl/7.65.3
> Accept: */*
> Connection: close
> 
* Mark bundle as not supporting multiuse
< HTTP/1.1 401 Unauthorized
< Date: Tue, 21 Jul 2020 05:20:15 GMT
< Server: Apache/X.Y.ZZ (Ubuntu)
< WWW-Authenticate: Basic realm="Restricted Content"
< Content-Length: 464
< Content-Type: text/html; charset=iso-8859-1
< 
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html><head>
```

...SNIP...

Como podemos ver, desta vez recebemos a requisição e a resposta HTTP completas. A requisição simplesmente enviou `GET / HTTP/1.1`, junto com os *headers* `Host`, `User-Agent` e `Accept`. Em retorno, a resposta HTTP continha `HTTP/1.1 401 Unauthorized`, o que indica que não temos acesso ao recurso solicitado, como veremos em uma seção posterior. Assim como a requisição, a resposta também continha diversos *headers* enviados pelo servidor, como `Date`, `Content-Length` e `Content-Type`. Por fim, a resposta continha o corpo da resposta em HTML, que é o mesmo que recebemos anteriormente ao usar o `cURL` sem a flag `-v`.

> **Exercício**: A flag `-vvv` exibe uma saída ainda mais detalhada. Tente usar essa flag para ver quais informações extras da requisição e resposta são exibidas.

---

## DevTools do Navegador

A maioria dos navegadores modernos possui ferramentas de desenvolvedor integradas (*DevTools*), que são voltadas principalmente para desenvolvedores testarem suas aplicações web. No entanto, como analistas de segurança em testes de penetração web, essas ferramentas podem ser um recurso vital em qualquer avaliação que realizarmos, pois o navegador (e seus *DevTools*) são alguns dos recursos mais acessíveis e utilizados em avaliações web.

Sempre que visitamos um site ou acessamos uma aplicação web, nosso navegador envia múltiplas requisições web e lida com múltiplas respostas HTTP para renderizar a visualização final que vemos na janela do navegador. Para abrir os *DevTools* no Chrome ou Firefox, podemos pressionar **\[CTRL+SHIFT+I]** ou simplesmente clicar **\[F12]**. Os *DevTools* contêm várias abas, cada uma com sua finalidade. Neste módulo, vamos focar principalmente na aba **Network**, pois é ela que trata das requisições web.

Se clicarmos na aba *Network* e atualizarmos a página, poderemos ver a lista de requisições feitas pela página:
![Exemplo de DevTools do Navegador](https://academy.hackthebox.com/storage/modules/35/devtools_network_requests.jpg)
aba Network mostrando duas requisições GET para `188.166.146.97:31122`. Status `304` para `'/'` e `404` para `'favicon.ico'`.

Como podemos ver, os *DevTools* nos mostram de forma clara o status da resposta (ou seja, o código de resposta), o método da requisição usado (GET), o recurso solicitado (URL/domínio), juntamente com o caminho requisitado. Além disso, podemos usar o **Filter URLs** para buscar uma requisição específica, caso o site carregue muitas requisições para examinarmos uma a uma.

> **Exercício**: Tente clicar em qualquer uma das requisições para visualizar seus detalhes. Você pode então clicar na aba **Response** para ver o corpo da resposta, e depois clicar no botão **Raw** para visualizar o código-fonte bruto (não renderizado) do corpo da resposta.