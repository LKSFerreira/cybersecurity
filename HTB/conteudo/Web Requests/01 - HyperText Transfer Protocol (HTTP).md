**Protocolo de Transferência de Hipertexto (HTTP)**

Atualmente, a maioria das aplicações que usamos interagem constantemente com a internet, tanto aplicações web quanto mobile. A maioria das comunicações na internet são realizadas através de requisições web por meio do protocolo HTTP. HTTP é um protocolo de nível de aplicação usado para acessar os recursos da World Wide Web. O termo hipertexto refere-se a texto contendo links para outros recursos e texto que os leitores podem interpretar facilmente.

A comunicação HTTP consiste em um cliente e um servidor, onde o cliente solicita um recurso ao servidor. O servidor processa as requisições e retorna o recurso solicitado. A porta padrão para comunicação HTTP é a porta 80, embora isso possa ser alterado para qualquer outra porta, dependendo da configuração do servidor web. As mesmas requisições são utilizadas quando usamos a internet para visitar diferentes websites. Nós inserimos um Nome de Domínio Totalmente Qualificado (FQDN) como um Localizador Uniforme de Recursos (URL) para alcançar o website desejado, como www.hackthebox.com.

**URL**

Recursos sobre HTTP são acessados via uma URL, que oferece muito mais especificações do que simplesmente especificar um website que queremos visitar. Vejamos a estrutura de uma URL:
![Imagem da estrutura de uma URL](https://academy.hackthebox.com/storage/modules/35/url_structure.png)
*Diagrama da estrutura de uma URL: esquema 'http', usuário 'admin:password', host 'inlanefreight.com', porta '80', caminho '/dashboard.php', query string 'login=true', fragmento 'status'.*

Aqui está o que cada componente significa:

| Componente            | Exemplo           | Descrição                                                                                                                                                              |
| :-------------------- | :---------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Esquema (Scheme)      | `http://` `https://` | Usado para identificar o protocolo sendo acessado pelo cliente, e termina com dois pontos e uma barra dupla (`://`)                                                       |
| Informações do Usuário (User Info) | `admin:password@` | Este é um componente opcional que contém as credenciais (separadas por dois pontos `:`) usadas para autenticar no host, e é separado do host por um sinal de arroba (`@`) |
| Host                  | `inlanefreight.com` | O host significa a localização do recurso. Pode ser um hostname ou um endereço IP.                                                                                       |
| Porta (Port)          | `:80`             | A Porta é separada do Host por dois pontos (`:`). Se nenhuma porta for especificada, esquemas `http` usam por padrão a porta 80 e `https` usa por padrão a porta 443.       |
| Caminho (Path)        | `/dashboard.php`  | Isso aponta para o recurso sendo acessado, que pode ser um arquivo ou uma pasta. Se não houver caminho especificado, o servidor retorna o índice padrão (ex: `index.html`). |
| Query String          | `?login=true`     | A query string começa com um ponto de interrogação (`?`), e consiste em um parâmetro (ex: `login`) e um valor (ex: `true`). Múltiplos parâmetros podem ser separados por um e comercial (`&`). |
| Fragmentos (Fragments)| `#status`         | Fragmentos são processados pelos navegadores no lado do cliente (client-side) para localizar seções dentro do recurso primário (ex: um cabeçalho ou seção na página).         |

Nem todos os componentes são necessários para acessar um recurso. Os principais campos obrigatórios são o esquema e o host, sem os quais a requisição não teria recurso para solicitar.

**Fluxo HTTP**
![Diagrama mostrando um usuário acessando inlanefreight.com](https://academy.hackthebox.com/storage/modules/35/HTTP_Flow.png)
*Diagrama mostrando um usuário acessando inlanefreight.com. O navegador envia uma consulta DNS para encontrar o endereço IP, recebe 152.153.81.14, e faz uma requisição HTTP para o servidor web, que responde com 'HTTP/1.1 200 OK'.*

O diagrama acima apresenta a anatomia de uma requisição HTTP em um nível muito alto. A primeira vez que um usuário insere a URL (`inlanefreight.com`) no navegador, ele envia uma requisição para um servidor DNS (Domain Name System - Sistema de Nomes de Domínio) para resolver o domínio e obter seu IP. O servidor DNS procura o endereço IP para `inlanefreight.com` e o retorna. Todos os nomes de domínio precisam ser resolvidos desta forma, pois um servidor não pode se comunicar sem um endereço IP.

**Nota:** Nossos navegadores geralmente primeiro procuram registros no arquivo local `/etc/hosts`, e se o domínio solicitado não existir nele, então eles contatariam outros servidores DNS. Podemos usar o `/etc/hosts` para adicionar manualmente registros para resolução DNS, adicionando o IP seguido pelo nome do domínio.

Uma vez que o navegador obtém o endereço IP vinculado ao domínio solicitado, ele envia uma requisição GET para a porta HTTP padrão (ex: 80), solicitando o caminho raiz `/`. Então, o servidor web recebe a requisição e a processa. Por padrão, os servidores são configurados para retornar um arquivo de índice (index file) quando uma requisição para `/` é recebida.

Neste caso, o conteúdo de `index.html` é lido e retornado pelo servidor web como uma resposta HTTP. A resposta também contém o código de status (status code) (ex: `200 OK`), que indica que a requisição foi processada com sucesso. O navegador web então renderiza o conteúdo de `index.html` e o apresenta ao usuário.

**Nota:** Este módulo foca principalmente em requisições web HTTP. Para mais informações sobre HTML e aplicações web, você pode consultar o módulo Introdução a Aplicações Web.

**cURL**

Neste módulo, enviaremos requisições web através de duas das ferramentas mais importantes para qualquer testador de penetração web (web penetration tester): um Navegador Web (Web Browser), como Chrome ou Firefox, e a ferramenta de linha de comando cURL.

cURL (client URL) é uma ferramenta de linha de comando e biblioteca que suporta primariamente HTTP juntamente com muitos outros protocolos. Isso o torna um bom candidato para scripts, bem como para automação, tornando-o essencial para enviar vários tipos de requisições web a partir da linha de comando, o que é necessário para muitos tipos de testes de penetração web.

Podemos enviar uma requisição HTTP básica para qualquer URL usando-a como um argumento para o cURL, da seguinte forma:

  Protocolo de Transferência de Hipertexto (HTTP)
```bash
lksferreira@htb[/htb]$ curl inlanefreight.com

<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html><head>
...RECORTADO...
```

Vemos que o cURL não renderiza o código HTML/JavaScript/CSS, ao contrário de um navegador web, mas o imprime em seu formato bruto (raw format). No entanto, como penetration testers, estamos principalmente interessados no contexto da requisição e da resposta, o que geralmente se torna muito mais rápido e conveniente do que com um navegador web.

Também podemos usar o cURL para baixar uma página ou um arquivo e direcionar o conteúdo para um arquivo usando a flag `-O`. Se quisermos especificar o nome do arquivo de saída, podemos usar a flag `-o` e especificar o nome. Caso contrário, podemos usar `-O` e o cURL usará o nome do arquivo remoto, da seguinte forma:

  Protocolo de Transferência de Hipertexto (HTTP)
```bash
lksferreira@htb[/htb]$ curl -O inlanefreight.com/index.html
lksferreira@htb[/htb]$ ls
index.html
```

Como podemos ver, a saída não foi impressa desta vez, mas sim salva em `index.html`. Notamos que o cURL ainda imprimiu algum status durante o processamento da requisição. Podemos silenciar o status com a flag `-s`, da seguinte forma:

  Protocolo de Transferência de Hipertexto (HTTP)
```bash
lksferreira@htb[/htb]$ curl -s -O inlanefreight.com/index.html
```

Desta vez, o cURL não imprimiu nada, pois a saída foi salva no arquivo `index.html`. Finalmente, podemos usar a flag `-h` para ver quais outras opções podemos usar com o cURL:

  Protocolo de Transferência de Hipertexto (HTTP)
```bash
lksferreira@htb[/htb]$ curl -h
Usage: curl [options...] <url>
 -d, --data <data>   Dados HTTP POST
 -h, --help <categoria> Obter ajuda para comandos
 -i, --include       Incluir cabeçalhos de resposta do protocolo na saída
 -o, --output <arquivo> Escrever em arquivo em vez de stdout
 -O, --remote-name   Escrever saída em um arquivo nomeado como o arquivo remoto
 -s, --silent        Modo silencioso
 -u, --user <usuário:senha> Usuário e senha do servidor
 -A, --user-agent <nome> Enviar User-Agent <nome> para o servidor
 -v, --verbose       Tornar a operação mais detalhada (verbosa)

Esta não é a ajuda completa, este menu está dividido em categorias.
Use "--help categoria" para obter uma visão geral de todas as categorias.
Use o manual do usuário `man curl` ou a flag "--help all" para todas as opções.
```

Como a mensagem acima menciona, podemos usar `--help all` para imprimir um menu de ajuda mais detalhado, ou `--help categoria` (ex: `-h http`) para imprimir a ajuda detalhada de uma flag específica. Se precisarmos ler uma documentação mais detalhada, podemos usar `man curl` para visualizar a página de manual completa do cURL.

Nas próximas seções, cobriremos a maioria das flags acima e veremos onde devemos usar cada uma delas.