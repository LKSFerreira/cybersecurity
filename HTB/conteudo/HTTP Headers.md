**HTTP Headers**
Vimos exemplos de *HTTP requests* e *response headers* na seção anterior. Esses *HTTP headers* transmitem informações entre o cliente e o servidor. Alguns cabeçalhos são usados apenas em *requests* ou em *responses*, enquanto outros cabeçalhos gerais são comuns a ambos.

Os cabeçalhos podem ter um ou vários valores, adicionados após o nome do cabeçalho e separados por dois-pontos. Podemos dividir os cabeçalhos nas seguintes categorias:

* **General Headers**
* **Entity Headers**
* **Request Headers**
* **Response Headers**
* **Security Headers**

Vamos discutir cada uma dessas categorias.

---

### General Headers

*General headers* são usados em *HTTP requests* e *responses*. Eles são contextuais e servem para descrever a mensagem em si, e não seu conteúdo.

| Header     | Exemplo                               | Descrição                                                                                                                                                                                                                                                  |
| ---------- | ------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Date       | `Date: Wed, 16 Feb 2022 10:38:44 GMT` | Contém a data e hora em que a mensagem se originou. É preferível converter o horário para o fuso UTC.                                                                                                                                                      |
| Connection | `Connection: close`                   | Indica se a conexão de rede atual deve permanecer ativa após o término da requisição. Valores comuns: `close` e `keep-alive`. `close` (cliente ou servidor) indica encerramento da conexão; `keep-alive` mantém a conexão aberta para receber novos dados. |

---

### Entity Headers

Semelhantes aos *general headers*, *Entity Headers* podem ser comuns a *requests* e *responses*. Esses cabeçalhos descrevem a *entity* (conteúdo) transferida pela mensagem. Geralmente aparecem em *responses* e em *POST* ou *PUT requests*.

| Header           | Exemplo                       | Descrição                                                                                                                                                                                                                 |
| ---------------- | ----------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Content-Type     | `Content-Type: text/html`     | Descreve o tipo de recurso sendo transferido. O valor é adicionado automaticamente pelos navegadores no cliente e retornado na resposta do servidor. O campo `charset` indica o padrão de codificação, por exemplo UTF-8. |
| Media-Type       | `Media-Type: application/pdf` | Similar a `Content-Type`, descreve o tipo de mídia dos dados transferidos. Pode influenciar como o servidor interpreta a entrada. Também pode incluir `charset`.                                                          |
| Boundary         | `boundary="b4e4fbd93540"`     | Atua como marcador para separar conteúdos quando há mais de um na mesma mensagem. Por exemplo, em *form data* usa-se `--b4e4fbd93540` para dividir diferentes partes do formulário.                                       |
| Content-Length   | `Content-Length: 385`         | Contém o tamanho da *entity* sendo enviada. Necessário para que o servidor leia o corpo da mensagem; é gerado automaticamente pelo navegador e por ferramentas como cURL.                                                 |
| Content-Encoding | `Content-Encoding: gzip`      | Os dados podem passar por transformações (por exemplo compressão) antes de serem enviados. O tipo de codificação usada deve ser especificado neste cabeçalho.                                                             |

---

### Request Headers

O cliente envia os *Request Headers* em uma transação HTTP. Esses cabeçalhos são usados na *HTTP request* e não se relacionam ao conteúdo da mensagem. Os mais comuns são:

| Header        | Exemplo                                  | Descrição                                                                                                                                                                                                                        |
| ------------- | ---------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Host          | `Host: www.inlanefreight.com`            | Especifica o host consultado pelo recurso. Pode ser um nome de domínio ou um endereço IP. Servidores HTTP podem hospedar vários sites, identificados pelo hostname, tornando o `Host` alvo importante de enumeração.             |
| User-Agent    | `User-Agent: curl/7.77.0`                | Descreve o cliente que solicita recursos. Pode revelar o navegador, sua versão e o sistema operacional.                                                                                                                          |
| Referer       | `Referer: http://www.inlanefreight.com/` | Indica de onde vem a requisição atual. Por exemplo, clicar em um link no Google faria `https://google.com` o `Referer`. Confiar nesse cabeçalho pode ser perigoso, pois é facilmente manipulado.                                 |
| Accept        | `Accept: */*`                            | Descreve quais tipos de mídia o cliente aceita. Pode conter vários tipos separados por vírgulas. O valor `*/*` significa que todos os tipos de mídia são aceitos.                                                                |
| Cookie        | `Cookie: PHPSESSID=b4e4fbd93540`         | Contém pares `nome=valor`. Cookies são dados armazenados no cliente e no servidor como identificadores. São enviados a cada requisição para manter a sessão ou preferências do usuário. Múltiplos cookies são separados por `;`. |
| Authorization | `Authorization: BASIC cGFzc3dvcmQK`      | Outra forma de identificar clientes. Após autenticação, o servidor retorna um token único. Diferente de cookies, tokens ficam apenas no cliente e são enviados a cada requisição. Vários esquemas de autenticação existem.       |

> Uma lista completa de *request headers* e seus usos pode ser encontrada [aqui](https://developer.mozilla.org/docs/Web/HTTP/Headers).

---

### Response Headers

*Response Headers* aparecem em *HTTP responses* e não se relacionam ao conteúdo. Alguns dão contexto adicional, como `Age`, `Location` e `Server`. Os mais comuns são:

| Header           | Exemplo                                     | Descrição                                                                                                 |
| ---------------- | ------------------------------------------- | --------------------------------------------------------------------------------------------------------- |
| Server           | `Server: Apache/2.2.14 (Win32)`             | Informações sobre o servidor HTTP que processou a requisição. Pode revelar versão e facilitar enumeração. |
| Set-Cookie       | `Set-Cookie: PHPSESSID=b4e4fbd93540`        | Contém cookies para identificação do cliente. O navegador armazena e envia em futuras requisições.        |
| WWW-Authenticate | `WWW-Authenticate: BASIC realm="localhost"` | Informa qual tipo de autenticação é necessário para acessar o recurso solicitado.                         |

---

### Security Headers

Com o aumento de ataques web, tornou-se necessário definir cabeçalhos de resposta que reforcem a segurança. *HTTP Security headers* especificam regras e políticas que o navegador deve seguir.

| Header                    | Exemplo                                       | Descrição                                                                                                                           |
| ------------------------- | --------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| Content-Security-Policy   | `Content-Security-Policy: script-src 'self'`  | Define a política de carregamento de recursos externos (por exemplo JavaScript). Aceita apenas domínios confiáveis, prevenindo XSS. |
| Strict-Transport-Security | `Strict-Transport-Security: max-age=31536000` | Impede o acesso ao site via HTTP e força HTTPS, evitando o sniffing de tráfego e exposição de dados sensíveis.                      |
| Referrer-Policy           | `Referrer-Policy: origin`                     | Controla se o navegador deve incluir o cabeçalho `Referer` em requisições subsequentes, protegendo URLs sensíveis.                  |

> Observação: Esta seção menciona apenas um subconjunto de *HTTP headers* comuns. Existem muitos outros cabeçalhos contextuais e é possível definir *custom headers* conforme necessidade. Uma lista completa pode ser encontrada [aqui](https://developer.mozilla.org/docs/Web/HTTP/Headers).

---

## cURL

Na seção anterior vimos como usar a flag `-v` com cURL para exibir todos os detalhes da *HTTP request* e *response*. Se quisermos ver apenas os *response headers*, usamos `-I` (HEAD request). Para mostrar cabeçalhos e corpo (por exemplo HTML), usamos `-i`. A diferença é: `-I` envia um HEAD request; `-i` envia o método especificado e mostra cabeçalhos.

O comando abaixo mostra um exemplo usando `-I`:

```bash
lksferreira@htb[/htb]$ curl -I https://www.inlanefreight.com

Host: www.inlanefreight.com
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/605.1.15 (KHTML, like Gecko)
Cookie: cookie1=298zf09hf012fh2; cookie2=u32t4o3tb3gg4
Accept: text/plain
Referer: https://www.inlanefreight.com/
Authorization: BASIC cGFzc3dvcmQK

Date: Sun, 06 Aug 2020 08:49:37 GMT
Connection: keep-alive
Content-Length: 26012
Content-Type: text/html; charset=ISO-8859-4
Content-Encoding: gzip
Server: Apache/2.2.14 (Win32)
Set-Cookie: name1=value1,name2=value2; Expires=Wed, 09 Jun 2021 10:18:14 GMT
WWW-Authenticate: BASIC realm="localhost"
Content-Security-Policy: script-src 'self'
Strict-Transport-Security: max-age=31536000
Referrer-Policy: origin
```

> **Exercício**: Analise cada cabeçalho acima e tente lembrar seu uso.

Além de visualizar, cURL também permite definir *request headers* com `-H`. Alguns, como `User-Agent` ou `Cookie`, têm flags próprias (`-A` para User-Agent). Exemplo:

```bash
lksferreira@htb[/htb]$ curl https://www.inlanefreight.com -A 'Mozilla/5.0'

<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html><head>
...SNIP...
```

> **Exercício**: Use `-I` ou `-v` no exemplo acima para verificar se alteramos o User-Agent com `-A`.

---

## Browser DevTools


Para pré-visualizar cabeçalhos no navegador, abra o DevTools e vá na aba **Network**. Clique em qualquer requisição para ver detalhes.
![Imagem de DevTools](https://academy.hackthebox.com/storage/modules/35/devtools_network_requests_details.jpg)

Na primeira aba (**Headers**) aparecem *HTTP request* e *response headers*. Você pode clicar em **Raw** para ver o formato cru. Na aba **Cookies** visualiza os cookies usados, como discutido.
