## Análise de Código (Code Analysis)

Agora que desofuscamos o código, podemos começar a analisá-lo:

Código: `javascript`
```javascript
'use strict';
function generateSerial() {
  /* ...RECORTADO... */
  var xhr = new XMLHttpRequest;
  var url = "/serial.php";
  xhr.open("POST", url, true);
  xhr.send(null);
};
```

Vemos que o arquivo `secret.js` contém apenas uma função, `generateSerial`.

### Requisições HTTP

Vamos analisar cada linha da função `generateSerial`.

#### Variáveis do Código

A função começa definindo uma variável `xhr`, que cria um objeto de `XMLHttpRequest`. Como podemos não saber exatamente o que `XMLHttpRequest` faz em JavaScript, vamos pesquisar no Google por `XMLHttpRequest` para ver para que é usado.
Depois de lermos sobre isso, vemos que é uma função JavaScript que lida com requisições web.

A segunda variável definida é a variável `url`, que contém uma URL para `/serial.php`, que deve estar no mesmo domínio, já que nenhum domínio foi especificado.

#### Funções do Código

Em seguida, vemos que `xhr.open` é usado com `"POST"` e `url`. Podemos pesquisar esta função no Google mais uma vez, e vemos que ela abre a requisição HTTP definida ('GET ou POST') para a URL, e então a próxima linha `xhr.send` enviaria a requisição.

Então, tudo o que `generateSerial` está fazendo é simplesmente enviar uma requisição POST para `/serial.php`, sem incluir nenhum dado POST ou recuperar nada em troca.

Os desenvolvedores podem ter implementado esta função sempre que precisassem gerar um serial, como ao clicar em um determinado botão "Gerar Serial", por exemplo. No entanto, como não vimos nenhum elemento HTML semelhante que gere seriais, os desenvolvedores não devem ter usado esta função ainda e a mantiveram para uso futuro.

Com o uso da desofuscação de código e análise de código, fomos capazes de descobrir esta função. Agora podemos tentar replicar sua funcionalidade para ver se ela é tratada no lado do servidor (server-side) ao enviar uma requisição POST. Se a função estiver habilitada e tratada no lado do servidor, podemos descobrir uma funcionalidade não lançada, que geralmente tende a ter bugs e vulnerabilidades.