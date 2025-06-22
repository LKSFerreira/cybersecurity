**API CRUD**

Vimos exemplos de uma aplicação web de Busca de Cidades que usa parâmetros PHP para pesquisar o nome de uma cidade nas seções anteriores. Esta seção analisará como tal aplicação web pode utilizar APIs para realizar a mesma coisa, e interagiremos diretamente com o endpoint da API.

**APIs**

Existem vários tipos de APIs. Muitas APIs são usadas para interagir com um banco de dados, de modo que seríamos capazes de especificar a tabela solicitada e a linha (ou registro) solicitada em nossa consulta à API, e então usar um método HTTP para realizar a operação necessária. Por exemplo, para o endpoint `api.php` em nosso exemplo, se quiséssemos atualizar a tabela `city` no banco de dados, e a linha que estaremos atualizando tem o nome de cidade `london`, então a URL se pareceria com algo assim:

Código: `bash`
```bash
curl -X PUT http://<IP_DO_SERVIDOR>:<PORTA>/api.php/city/london ...RECORTADO...
```

**CRUD**

Como podemos ver, podemos especificar facilmente a tabela e a linha sobre a qual queremos realizar uma operação através de tais APIs. Então, podemos utilizar diferentes métodos HTTP para realizar diferentes operações naquela linha. Em geral, as APIs realizam 4 operações principais na entidade do banco de dados solicitada:

| Operação  | Método HTTP | Descrição                                             |
| :-------- | :---------- | :---------------------------------------------------- |
| Criar     | POST        | Adiciona os dados especificados à tabela do banco de dados |
| Ler       | GET         | Lê a entidade especificada da tabela do banco de dados  |
| Atualizar | PUT         | Atualiza os dados da tabela do banco de dados especificada |
| Excluir   | DELETE      | Remove a linha especificada da tabela do banco de dados |

Essas quatro operações estão principalmente ligadas às comumente conhecidas APIs CRUD, mas o mesmo princípio também é usado em APIs REST e vários outros tipos de APIs. Claro, nem todas as APIs funcionam da mesma maneira, e o controle de acesso do usuário limitará quais ações podemos realizar e quais resultados podemos ver. O módulo Introdução a Aplicações Web explica melhor esses conceitos, então você pode consultá-lo para mais detalhes sobre APIs e seu uso.

**Ler (Read)**

A primeira coisa que faremos ao interagir com uma API é ler dados. Como mencionado anteriormente, podemos simplesmente especificar o nome da tabela após a API (ex: `/city`) e então especificar nosso termo de busca (ex: `/london`), da seguinte forma:

API CRUD
```bash
lksferreira@htb[/htb]$ curl http://<IP_DO_SERVIDOR>:<PORTA>/api.php/city/london

[{"city_name":"London","country_name":"(UK)"}]
```

Vemos que o resultado é enviado como uma string JSON. Para tê-lo devidamente formatado em formato JSON, podemos redirecionar (pipe) a saída para o utilitário `jq`, que o formatará corretamente. Também silenciaremos qualquer saída desnecessária do cURL com `-s`, da seguinte forma:

API CRUD
```bash
lksferreira@htb[/htb]$ curl -s http://<IP_DO_SERVIDOR>:<PORTA>/api.php/city/london | jq

[
  {
    "city_name": "London",
    "country_name": "(UK)"
  }
]
```

Como podemos ver, obtivemos a saída em um formato bem apresentado. Também podemos fornecer um termo de busca e obter todos os resultados correspondentes:

API CRUD
```bash
lksferreira@htb[/htb]$ curl -s http://<IP_DO_SERVIDOR>:<PORTA>/api.php/city/le | jq

[
  {
    "city_name": "Leeds",
    "country_name": "(UK)"
  },
  {
    "city_name": "Dudley",
    "country_name": "(UK)"
  },
  {
    "city_name": "Leicester",
    "country_name": "(UK)"
  },
  ...RECORTADO...
]
```

Finalmente, podemos passar uma string vazia para recuperar todas as entradas na tabela:

API CRUD
```bash
lksferreira@htb[/htb]$ curl -s http://<IP_DO_SERVIDOR>:<PORTA>/api.php/city/ | jq

[
  {
    "city_name": "London",
    "country_name": "(UK)"
  },
  {
    "city_name": "Birmingham",
    "country_name": "(UK)"
  },
  {
    "city_name": "Leeds",
    "country_name": "(UK)"
  },
  ...RECORTADO...
]
```

Tente visitar qualquer um dos links acima usando seu navegador, para ver como o resultado é renderizado.

**Criar (Create)**

Para adicionar uma nova entrada, podemos usar uma requisição HTTP POST, que é bastante similar ao que realizamos na seção anterior. Podemos simplesmente fazer um POST dos nossos dados JSON, e eles serão adicionados à tabela. Como esta API está usando dados JSON, também definiremos o cabeçalho `Content-Type` para JSON, da seguinte forma:

API CRUD
```bash
lksferreira@htb[/htb]$ curl -X POST http://<IP_DO_SERVIDOR>:<PORTA>/api.php/city/ -d '{"city_name":"HTB_City", "country_name":"HTB"}' -H 'Content-Type: application/json'
```

Agora, podemos ler o conteúdo da cidade que adicionamos (HTB_City), para ver se foi adicionada com sucesso:

API CRUD
```bash
lksferreira@htb[/htb]$ curl -s http://<IP_DO_SERVIDOR>:<PORTA>/api.php/city/HTB_City | jq

[
  {
    "city_name": "HTB_City",
    "country_name": "HTB"
  }
]
```

Como podemos ver, uma nova cidade foi criada, a qual não existia antes.

**Exercício:** Tente adicionar uma nova cidade através das devtools do navegador, usando uma das requisições POST com Fetch que você usou na seção anterior.

**Atualizar (Update)**

Agora que sabemos como ler e escrever entradas através de APIs, vamos começar a discutir dois outros métodos HTTP que não usamos até agora: PUT e DELETE. Como mencionado no início da seção, PUT é usado para atualizar entradas da API e modificar seus detalhes, enquanto DELETE é usado para remover uma entidade específica.

**Nota:** O método HTTP PATCH também pode ser usado para atualizar entradas da API em vez de PUT. Para ser preciso, PATCH é usado para atualizar parcialmente uma entrada (modificar apenas alguns de seus dados, "ex: apenas `city_name`"), enquanto PUT é usado para atualizar a entrada inteira. Também podemos usar o método HTTP OPTIONS para ver qual dos dois é aceito pelo servidor, e então usar o método apropriado de acordo. Nesta seção, focaremos no método PUT, embora seu uso seja bastante similar.

Usar PUT é bastante similar a POST neste caso, com a única diferença sendo que temos que especificar o nome da entidade que queremos editar na URL, caso contrário a API não saberá qual entidade editar. Então, tudo o que temos que fazer é especificar o nome da cidade na URL, mudar o método da requisição para PUT, e fornecer os dados JSON como fizemos com POST, da seguinte forma:

API CRUD
```bash
lksferreira@htb[/htb]$ curl -X PUT http://<IP_DO_SERVIDOR>:<PORTA>/api.php/city/london -d '{"city_name":"New_HTB_City", "country_name":"HTB"}' -H 'Content-Type: application/json'
```

Vemos no exemplo acima que primeiro especificamos `/city/london` como nossa cidade, e passamos uma string JSON que continha `"city_name":"New_HTB_City"` nos dados da requisição. Então, a cidade `london` não deve mais existir, e uma nova cidade com o nome `New_HTB_City` deve existir. Vamos tentar ler ambas para confirmar:

API CRUD
```bash
lksferreira@htb[/htb]$ curl -s http://<IP_DO_SERVIDOR>:<PORTA>/api.php/city/london | jq
```
API CRUD
```bash
lksferreira@htb[/htb]$ curl -s http://<IP_DO_SERVIDOR>:<PORTA>/api.php/city/New_HTB_City | jq

[
  {
    "city_name": "New_HTB_City",
    "country_name": "HTB"
  }
]
```

De fato, substituímos com sucesso o nome da cidade antiga pela nova cidade.

**Nota:** Em algumas APIs, a operação de Atualização (Update) pode ser usada para criar novas entradas também. Basicamente, enviaríamos nossos dados, e se não existissem, seriam criados. Por exemplo, no exemplo acima, mesmo que uma entrada com a cidade `london` não existisse, criaria uma nova entrada com os detalhes que passamos. Em nosso exemplo, no entanto, este não é o caso. Tente atualizar uma cidade inexistente e veja o que você obteria.

**Excluir (DELETE)**

Finalmente, vamos tentar excluir uma cidade, o que é tão fácil quanto ler uma cidade. Simplesmente especificamos o nome da cidade para a API e usamos o método HTTP DELETE, e ele excluiria a entrada, da seguinte forma:

API CRUD
```bash
lksferreira@htb[/htb]$ curl -X DELETE http://<IP_DO_SERVIDOR>:<PORTA>/api.php/city/New_HTB_City
```
API CRUD
```bash
lksferreira@htb[/htb]$ curl -s http://<IP_DO_SERVIDOR>:<PORTA>/api.php/city/New_HTB_City | jq
[]
```

Como podemos ver, depois que excluímos `New_HTB_City`, obtemos um array vazio quando tentamos lê-la, o que significa que ela não existe mais.

**Exercício:** Tente excluir qualquer uma das cidades que você adicionou anteriormente através de requisições POST, e então leia todas as entradas para confirmar que foram excluídas com sucesso.

Com isso, somos capazes de realizar todas as 4 operações CRUD através do cURL. Em uma aplicação web real, tais ações podem não ser permitidas para todos os usuários, ou seria considerada uma vulnerabilidade se qualquer um pudesse modificar ou excluir qualquer entrada. Cada usuário teria certos privilégios sobre o que pode ler ou escrever, onde escrever se refere a adicionar, modificar ou excluir dados. Para autenticar nosso usuário para usar a API, precisaríamos passar um cookie ou um cabeçalho de autorização (ex: JWT), como fizemos em uma seção anterior. Fora isso, as operações são similares ao que praticamos nesta seção.