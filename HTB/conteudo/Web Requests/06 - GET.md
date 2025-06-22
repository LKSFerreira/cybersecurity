### **GET**

Sempre que visitamos qualquer URL, nossos navegadores fazem por padrão uma requisição **GET** para obter os recursos remotos hospedados naquela URL. Assim que o navegador recebe a página inicial solicitada, ele pode enviar outras requisições utilizando diversos métodos HTTP. Isso pode ser observado na aba **Network** (Rede) nas ferramentas de desenvolvedor do navegador, como visto na seção anterior.

**Exercício:** Escolha qualquer site de sua preferência e monitore a aba *Network* nas ferramentas de desenvolvedor do navegador enquanto o visita, para entender o que a página está fazendo. Essa técnica pode ser usada para entender detalhadamente como uma aplicação web interage com seu *backend*, o que pode ser um exercício essencial em uma análise de aplicação web ou em atividades de *bug bounty*.

---

### **HTTP Basic Auth**

Ao acessarmos o exercício ao final desta seção, somos solicitados a digitar um nome de usuário e senha. Diferente dos formulários de login usuais, que utilizam parâmetros HTTP (ex.: requisição POST) para validar as credenciais do usuário, este tipo de autenticação utiliza a **autenticação HTTP básica**, que é tratada diretamente pelo *webserver* para proteger uma página ou diretório específico, sem interagir diretamente com a aplicação web.

Para acessar a página, devemos inserir um par de credenciais válidas, que neste caso são: `admin:admin`.

```
http://<SERVER_IP>:<PORT>/
Formulário de login com campos para o usuário 'admin' e senha, aviso: 'Sua senha será enviada sem criptografia'.
```
![Imagem de login](https://academy.hackthebox.com/storage/modules/35/http_auth_login.jpg)

Após inserirmos as credenciais, teremos acesso à página:

```
http://<SERVER_IP>:<PORT>/
Ícone de busca com o texto 'Digite o nome de uma cidade e pressione Enter'.
```
![Imagem de login realizado com sucesso](https://academy.hackthebox.com/storage/modules/35/http_auth_index.jpg)

Vamos tentar acessar a página com **cURL**, adicionando a opção `-i` para visualizar os *headers* da resposta:

```bash
$ curl -i http://<SERVER_IP>:<PORT>/
HTTP/1.1 401 Authorization Required
Date: Mon, 21 Feb 2022 13:11:46 GMT
Server: Apache/2.4.41 (Ubuntu)
Cache-Control: no-cache, must-revalidate, max-age=0
WWW-Authenticate: Basic realm="Access denied"
Content-Length: 13
Content-Type: text/html; charset=UTF-8

Access denied
```

Como podemos ver, recebemos `Access denied` no corpo da resposta, e também `Basic realm="Access denied"` no *header* `WWW-Authenticate`, o que confirma que esta página realmente utiliza autenticação HTTP básica, como discutido na seção sobre *headers*. Para fornecer as credenciais via cURL, usamos a flag `-u`, da seguinte forma:

```bash
$ curl -u admin:admin http://<SERVER_IP>:<PORT>/

<!DOCTYPE html>
<html lang="en">
<head>
...SNIP...
```

Desta vez, conseguimos obter a página na resposta. Há também outro método para fornecer as credenciais HTTP básicas, diretamente pela URL no formato `username:password@URL`, como discutido na primeira seção. Se fizermos isso com cURL ou pelo navegador, também teremos acesso à página:

```bash
$ curl http://admin:admin@<SERVER_IP>:<PORT>/

<!DOCTYPE html>
<html lang="en">
<head>
...SNIP...
```

Também podemos tentar visitar essa mesma URL no navegador, e devemos ser autenticados da mesma forma.

**Exercício:** Tente visualizar os *headers* da resposta adicionando `-i` à requisição acima e veja como a resposta autenticada difere da não autenticada.

---

### **HTTP Authorization Header**

Se adicionarmos a flag `-v` a qualquer um dos comandos anteriores com cURL:

```bash
$ curl -v http://admin:admin@<SERVER_IP>:<PORT>/
```

A saída será:

```
*   Trying <SERVER_IP>:<PORT>...
* Connected to <SERVER_IP> (<SERVER_IP>) port PORT (#0)
* Server auth using Basic with user 'admin'
> GET / HTTP/1.1
> Host: <SERVER_IP>
> Authorization: Basic YWRtaW46YWRtaW4=
> User-Agent: curl/7.77.0
> Accept: */*
> 
< HTTP/1.1 200 OK
< Date: Mon, 21 Feb 2022 13:19:57 GMT
< Server: Apache/2.4.41 (Ubuntu)
< Cache-Control: no-store, no-cache, must-revalidate
< Expires: Thu, 19 Nov 1981 08:52:00 GMT
< Pragma: no-cache
< Vary: Accept-Encoding
< Content-Length: 1453
< Content-Type: text/html; charset=UTF-8
```

Como estamos usando autenticação HTTP básica, vemos que nossa requisição HTTP define o *header* `Authorization` como `Basic YWRtaW46YWRtaW4=`, que é o valor em **base64** de `admin:admin`. Se estivéssemos usando um método de autenticação moderno (como JWT), o *Authorization* seria do tipo `Bearer` e conteria um *token* criptografado mais longo.

Vamos tentar definir manualmente o *Authorization header* sem fornecer as credenciais diretamente, para ver se conseguimos acesso à página. Podemos usar a flag `-H` para definir *headers*, e usaremos o mesmo valor do exemplo acima. Podemos usar `-H` várias vezes para definir múltiplos *headers*:

```bash
$ curl -H 'Authorization: Basic YWRtaW46YWRtaW4=' http://<SERVER_IP>:<PORT>/

<!DOCTYPE html>
<html lang="en">
<head>
...SNIP...
```

Como vemos, isso também nos deu acesso à página. Esses são alguns métodos que podemos usar para autenticar o acesso à página. A maioria das aplicações web modernas usa formulários de login construídos com linguagens de *backend* (ex.: PHP), que utilizam requisições HTTP **POST** para autenticar os usuários e retornar um **cookie** para manter a sessão.

---

### **GET Parameters**

Depois de autenticados, temos acesso a uma função de busca de cidades, onde podemos digitar um termo e obter uma lista de cidades correspondentes:

```
http://<SERVER_IP>:<PORT>/
Ícone de busca com a instrução: 'Digite o nome de uma cidade e pressione Enter'.
```
![Imagem de Get com parametros](https://academy.hackthebox.com/storage/modules/35/http_auth_index.jpg)

À medida que a página retorna os resultados, ela pode estar contactando um recurso remoto para obter as informações e então exibi-las na página. Para verificar isso, podemos abrir as *devtools* do navegador e ir até a aba *Network* (atalho: **CTRL+SHIFT+E**). Antes de digitar o termo de busca e visualizar as requisições, pode ser necessário clicar no ícone de lixeira no canto superior esquerdo para limpar requisições anteriores e monitorar apenas as novas:

![Imagem da aba network do modo desenvolvedor](https://academy.hackthebox.com/storage/modules/35/network_clear_requests.jpg)

> Aba Network com instrução: 'Realize uma requisição ou recarregue a página para ver informações detalhadas sobre a atividade de rede. Clique no cronômetro para iniciar a análise de desempenho.'

Depois disso, podemos digitar qualquer termo de busca e pressionar Enter, e imediatamente veremos uma nova requisição sendo enviada ao *backend*:
![Busca e janela do modo desenvolvedor exibindo as requisições](https://academy.hackthebox.com/storage/modules/35/web_requests_get_search.jpg)

> Resultados da busca por "le" exibindo Leeds (UK) e Leicester (UK). Aba Network mostra uma requisição GET bem-sucedida para 127.0.0.1 em `search.php`.

Ao clicarmos na requisição, vemos que foi enviada para `search.php` com o parâmetro GET `search=le` usado na URL. Isso nos ajuda a entender que a função de busca consulta outra página para retornar os resultados.

Agora podemos enviar a mesma requisição diretamente para `search.php` para obter os resultados completos, embora provavelmente sejam retornados em um formato específico (por exemplo, JSON), sem o layout HTML mostrado anteriormente.

Para enviar uma requisição GET com cURL, podemos usar exatamente a mesma URL vista nas capturas de tela, já que requisições GET colocam seus parâmetros diretamente na URL. No entanto, as *devtools* do navegador fornecem uma forma mais conveniente de obter o comando cURL: clique com o botão direito na requisição e selecione **Copy > Copy as cURL**. Depois, cole o comando no terminal e execute-o para obter a mesma resposta:

```bash
$ curl 'http://<SERVER_IP>:<PORT>/search.php?search=le' -H 'Authorization: Basic YWRtaW46YWRtaW4='

Leeds (UK)
Leicester (UK)
```

**Nota:** O comando copiado conterá todos os *headers* usados na requisição HTTP. No entanto, podemos remover a maioria deles e manter apenas os essenciais, como o *Authorization*.

Também podemos repetir a mesma requisição diretamente nas *devtools* do navegador, selecionando **Copy > Copy as Fetch**. Isso copia a requisição HTTP usando a biblioteca `fetch` do JavaScript. Em seguida, vá até o console JavaScript (**CTRL+SHIFT+K**), cole o comando `fetch` e pressione Enter para enviar a requisição:

![Imagem da requisição via fetch do DevTools](https://academy.hackthebox.com/storage/modules/35/web_requests_fetch_search.jpg)

> Console exibindo um comando fetch para `http://127.0.0.1/search.php?search=lel` com headers incluindo `user-agent` e `authorization`. Aba Network exibe uma requisição GET bem-sucedida com status 200.

Como vemos, o navegador enviou a requisição, e podemos ver a resposta retornada em seguida. Podemos clicar sobre ela para ver os detalhes, expandir os dados e analisá-los.