### **POST**

Na seção anterior, vimos como as requisições GET podem ser usadas por aplicações web para funcionalidades como busca e acesso a páginas. No entanto, sempre que aplicações web precisam transferir arquivos ou mover os parâmetros do usuário para fora da URL, elas utilizam requisições POST.

Ao contrário do HTTP GET, que coloca os parâmetros do usuário dentro da URL, o HTTP POST coloca os parâmetros do usuário dentro do corpo da Requisição HTTP (HTTP Request body). Isso tem três benefícios principais:

*   **Ausência de Logging (Registro):** Como as requisições POST podem transferir arquivos grandes (ex: upload de arquivo), não seria eficiente para o servidor registrar (logar) todos os arquivos enviados como parte da URL solicitada, como seria o caso com um arquivo enviado através de uma requisição GET.
*   **Menos Requisitos de Codificação (Encoding):** URLs são projetadas para serem compartilhadas, o que significa que precisam estar em conformidade com caracteres que podem ser convertidos em letras. A requisição POST coloca os dados no corpo (body), que pode aceitar dados binários. Os únicos caracteres que precisam ser codificados são aqueles usados para separar parâmetros.
*   **Mais dados podem ser enviados:** O Comprimento Máximo da URL (Maximum URL Length) varia entre navegadores (Chrome/Firefox/IE), servidores web (IIS, Apache, nginx), Redes de Distribuição de Conteúdo (Content Delivery Networks - CDNs como Fastly, Cloudfront, Cloudflare) e até mesmo Encurtadores de URL (bit.ly, amzn.to). De modo geral, o comprimento de uma URL deve ser mantido abaixo de 2.000 caracteres e, portanto, elas não podem lidar com muitos dados.

Então, vamos ver alguns exemplos de como as requisições POST funcionam e como podemos utilizar ferramentas como cURL ou as ferramentas de desenvolvedor (devtools) do navegador para ler e enviar requisições POST.

### **Formulários de Login**
O exercício no final desta seção é similar ao exemplo que vimos na seção GET. No entanto, assim que visitamos a aplicação web, vemos que ela utiliza um formulário de login PHP em vez de autenticação básica HTTP (HTTP basic auth):

`http://<IP_DO_SERVIDOR>:<PORTA>/`
![Imagem de uma tela de login em PHP](https://academy.hackthebox.com/storage/modules/35/web_requests_post_login.jpg)
*Tela de login com campos para 'Username' (Usuário) e 'Password' (Senha) e um botão 'Login'.*

Se tentarmos fazer login com `admin:admin`, conseguimos entrar e vemos uma função de busca similar à que vimos anteriormente na seção GET:

`http://<IP_DO_SERVIDOR>:<PORTA>/`
![Imagem de tela de login acessada com sucesso](https://academy.hackthebox.com/storage/modules/35/web_requests_login_search.jpg)
*Ícone de busca com a instrução: 'Digite o nome de uma cidade e pressione Enter'.*

Se limparmos a aba Network (Rede) nas devtools do nosso navegador e tentarmos fazer login novamente, veremos muitas requisições sendo enviadas. Podemos filtrar as requisições pelo IP do nosso servidor, para que mostre apenas as requisições destinadas ao servidor web da aplicação (ou seja, filtrar requisições externas), e notaremos a seguinte requisição POST sendo enviada:
![Imagem de uma requisição posto no navegador sendo exibida pela DevTools](https://academy.hackthebox.com/storage/modules/35/web_requests_login_request.jpg)
*Interface de busca com um ícone de busca e texto 'Digite o nome de uma cidade e pressione Enter'. A aba Network mostra três requisições bem-sucedidas para 'ip_do_servidor', incluindo uma requisição POST com nome de usuário e senha 'admin'.*

Podemos clicar na requisição, clicar na aba Request (Requisição) (que mostra o corpo da requisição), e então clicar no botão Raw (Bruto) para mostrar os dados brutos da requisição. Vemos que os seguintes dados estão sendo enviados como dados da requisição POST:

Código: `bash`
```bash
username=admin&password=admin
```

Com os dados da requisição em mãos, podemos tentar enviar uma requisição similar com o cURL, para ver se isso também nos permitiria fazer login. Além disso, como fizemos na seção anterior, podemos simplesmente clicar com o botão direito na requisição e selecionar Copiar > Copiar como cURL. No entanto, é importante ser capaz de criar requisições POST manualmente, então vamos tentar fazer isso.

Usaremos a flag `-X POST` para enviar uma requisição POST. Então, para adicionar nossos dados POST, podemos usar a flag `-d` e adicionar os dados acima após ela, da seguinte forma:

POST
```bash
lksferreira@htb[/htb]$ curl -X POST -d 'username=admin&password=admin' http://<IP_DO_SERVIDOR>:<PORTA>/

...RECORTADO...
        <em>Digite o nome de uma cidade e pressione <strong>Enter</strong></em>
...RECORTADO...
```

Se examinarmos o código HTML, não veremos o código do formulário de login, mas veremos o código da função de busca, o que indica que de fato fomos autenticados.

**Dica:** Muitos formulários de login nos redirecionariam para uma página diferente após a autenticação (ex: `/dashboard.php`). Se quisermos seguir o redirecionamento com o cURL, podemos usar a flag `-L`.

**Cookies Autenticados**
Se fomos autenticados com sucesso, deveríamos ter recebido um cookie para que nossos navegadores possam persistir nossa autenticação, e não precisemos fazer login toda vez que visitarmos a página. Podemos usar as flags `-v` ou `-i` para visualizar a resposta, que deve conter o cabeçalho `Set-Cookie` com nosso cookie autenticado:

POST
```bash
lksferreira@htb[/htb]$ curl -X POST -d 'username=admin&password=admin' http://<IP_DO_SERVIDOR>:<PORTA>/ -i

HTTP/1.1 200 OK
Date: <Data>
Server: Apache/2.4.41 (Ubuntu)
Set-Cookie: PHPSESSID=c1nsa6op7vtk7kdis7bcnbadf1; path=/

...RECORTADO...
        <em>Digite o nome de uma cidade e pressione <strong>Enter</strong></em>
...RECORTADO...
```

Com nosso cookie autenticado, agora devemos ser capazes de interagir com a aplicação web sem precisar fornecer nossas credenciais toda vez. Para testar isso, podemos definir o cookie acima com a flag `-b` no cURL, da seguinte forma:

POST
```bash
lksferreira@htb[/htb]$ curl -b 'PHPSESSID=c1nsa6op7vtk7kdis7bcnbadf1' http://<IP_DO_SERVIDOR>:<PORTA>/

...RECORTADO...
        <em>Digite o nome de uma cidade e pressione <strong>Enter</strong></em>
...RECORTADO...
```

Como podemos ver, fomos de fato autenticados e chegamos à função de busca. Também é possível especificar o cookie como um cabeçalho (header), da seguinte forma:

Código: `bash`
```bash
curl -H 'Cookie: PHPSESSID=c1nsa6op7vtk7kdis7bcnbadf1' http://<IP_DO_SERVIDOR>:<PORTA>/
```

Também podemos tentar a mesma coisa com nossos navegadores. Primeiro, vamos fazer logout, e então devemos voltar para a página de login. Em seguida, podemos ir para a aba Storage (Armazenamento) nas devtools com [SHIFT+F9]. Na aba Storage, podemos clicar em Cookies no painel esquerdo e selecionar nosso site para visualizar nossos cookies atuais. Podemos ou não ter cookies existentes, mas se estivéssemos deslogados, nosso cookie PHP não deveria estar autenticado, e é por isso que vemos o formulário de login e não a função de busca:
"[Imagem do DevTools mostrando o storage do navegador](https://academy.hackthebox.com/storage/modules/35/web_requests_cookies.jpg)
*Tela de login com campos para 'Username' (Usuário) e 'Password' (Senha), um botão 'Login', e informações de cookie mostrando PHPSESSID para 'ip_do_servidor'.*

Agora, vamos tentar usar nosso cookie autenticado anteriormente e ver se conseguimos entrar sem precisar fornecer nossas credenciais. Para fazer isso, podemos simplesmente substituir o valor do cookie pelo nosso. Caso contrário, podemos clicar com o botão direito no cookie e selecionar Excluir Todos (Delete All), e então clicar no ícone `+` para adicionar um novo cookie. Depois disso, precisamos inserir o nome do cookie, que é a parte antes do `=` (PHPSESSID), e então o valor do cookie, que é a parte depois do `=` (c1nsa6op7vtk7kdis7bcnbadf1). Então, uma vez que nosso cookie esteja definido, podemos atualizar a página, e veremos que de fato somos autenticados sem precisar fazer login, simplesmente usando um cookie autenticado:
![Imagem do DevTools mostrando o login com sucesso após configurar manualmente uma sessão de cookie](https://academy.hackthebox.com/storage/modules/35/web_requests_cookies.jpg)
*Interface de busca com um ícone de busca e texto 'Digite o nome de uma cidade e pressione Enter'. A aba Storage mostra o cookie PHPSESSID para 'ip_do_servidor'.*

Como podemos ver, ter um cookie válido pode ser suficiente para ser autenticado em muitas aplicações web. Isso pode ser uma parte essencial de alguns ataques web, como Cross-Site Scripting.

### **Dados JSON**
Finalmente, vamos ver quais requisições são enviadas quando interagimos com a função de Busca de Cidade. Para fazer isso, iremos para a aba Network nas devtools do navegador, e então clicaremos no ícone da lixeira para limpar todas as requisições. Então, podemos fazer qualquer consulta de busca para ver quais requisições são enviadas:
![Requisição post sendo vizualizada na aba Network](https://academy.hackthebox.com/storage/modules/35/web_requests_search_request.jpg)
*Interface de busca mostrando resultado para 'London (UK)'. A aba Network exibe uma requisição POST bem-sucedida para 'ip_do_servidor' para search.php com o payload `{'search':'London'}`.*

Como podemos ver, o formulário de busca envia uma requisição POST para `search.php`, com os seguintes dados:

Código: `json`
```json
{"search":"london"}
```

Os dados POST parecem estar em formato JSON, então nossa requisição deve ter especificado o cabeçalho `Content-Type` como `application/json`. Podemos confirmar isso clicando com o botão direito na requisição e selecionando Copiar > Copiar Cabeçalhos da Requisição (Copy Request Headers):

Código: `bash`
```bash
POST /search.php HTTP/1.1
Host: ip_do_servidor
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:97.0) Gecko/20100101 Firefox/97.0
Accept: */*
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Referer: http://ip_do_servidor/index.php
Content-Type: application/json
Origin: http://ip_do_servidor
Content-Length: 19
DNT: 1
Connection: keep-alive
Cookie: PHPSESSID=c1nsa6op7vtk7kdis7bcnbadf1
```

De fato, temos `Content-Type: application/json`. Vamos tentar replicar esta requisição como fizemos anteriormente, mas incluir tanto o cookie quanto o cabeçalho `Content-Type`, e enviar nossa requisição para `search.php`:

POST
```bash
lksferreira@htb[/htb]$ curl -X POST -d '{"search":"london"}' -b 'PHPSESSID=c1nsa6op7vtk7kdis7bcnbadf1' -H 'Content-Type: application/json' http://<IP_DO_SERVIDOR>:<PORTA>/search.php
["London (UK)"]
```

Como podemos ver, fomos capazes de interagir com a função de busca diretamente sem precisar fazer login ou interagir com o front-end da aplicação web. Esta pode ser uma habilidade essencial ao realizar avaliações de aplicações web ou exercícios de bug bounty, pois é muito mais rápido testar aplicações web desta forma.

**Exercício:** Tente repetir a requisição acima sem adicionar o cookie ou o cabeçalho `Content-Type`, e veja como a aplicação web agiria de forma diferente.

Finalmente, vamos tentar repetir a mesma requisição acima usando Fetch, como fizemos na seção anterior. Podemos clicar com o botão direito na requisição e selecionar Copiar > Copiar como Fetch, e então ir para a aba Console e executar nosso código lá:
![Imagem do DevTools exbindo um Fetch de Requisição posto no console do navegador](https://academy.hackthebox.com/storage/modules/35/web_requests_fetch_post.jpg)
*Console mostrando uma requisição fetch para 'http://ip_do_servidor/search.php' com credenciais incluídas. Cabeçalhos especificam user-agent e accept-language. A resposta JSON contém 'London (UK)'.*

Nossa requisição retorna com sucesso os mesmos dados que obtivemos com o cURL. Tente pesquisar por cidades diferentes interagindo diretamente com o `search.php` através do Fetch ou cURL.