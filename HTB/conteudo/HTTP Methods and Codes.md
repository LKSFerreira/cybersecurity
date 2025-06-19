**HTTP Methods and Codes**
O protocolo HTTP suporta múltiplos *methods* para acessar um recurso. Vários *request methods* permitem que o navegador envie informações, formulários ou arquivos para o servidor. Esses métodos servem, entre outras coisas, para dizer ao servidor como processar a requisição que enviamos e como responder.

Observamos diferentes métodos HTTP nas requisições testadas nas seções anteriores. No cURL, ao usar `-v`, a primeira linha mostra o método HTTP (ex.: `GET / HTTP/1.1`); nos DevTools do navegador, o método aparece na coluna **Method**. Além disso, os *response headers* também contêm o **HTTP response code**, que indica o status do processamento da nossa requisição.

---

### Request Methods

Os métodos mais comuns incluem:

| Method  | Descrição                                                                                                                                                                              |
| ------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| GET     | Requisita um recurso específico. Dados adicionais podem ser passados via *query string* na URL (ex.: `?param=value`).                                                                  |
| POST    | Envia dados ao servidor. Pode incluir texto, PDFs e outros dados binários no *request body*. Usado para envio de formulários, logins ou upload de arquivos (imagens, documentos etc.). |
| HEAD    | Requisita apenas os *headers* que seriam retornados em um GET, sem o corpo. Útil para verificar o tamanho da resposta antes de baixar o recurso.                                       |
| PUT     | Cria ou substitui recursos no servidor. Se não for controlado, pode permitir upload de conteúdo malicioso.                                                                             |
| DELETE  | Remove um recurso existente no servidor. Sem segurança adequada, pode causar DoS (remoção de arquivos críticos).                                                                       |
| OPTIONS | Retorna informações sobre o servidor, como métodos aceitos.                                                                                                                            |
| PATCH   | Aplica modificações parciais ao recurso no local especificado.                                                                                                                         |

> Observação: A disponibilidade de cada método depende da configuração do servidor e da aplicação. Para uma lista completa de *HTTP methods*, visite este [link](https://developer.mozilla.org/docs/Web/HTTP/Methods).

**Nota**: A maioria das aplicações web modernas usa principalmente GET e POST. Aplicações que expõem REST APIs também empregam PUT e DELETE para atualizar e excluir dados.

---

### Response Codes

Os **HTTP status codes** informam ao cliente o resultado da requisição. Existem cinco categorias:

| Tipo | Descrição                                                        |
| ---- | ---------------------------------------------------------------- |
| 1xx  | Informativo; não afeta o processamento.                          |
| 2xx  | Sucesso; requisição processada corretamente.                     |
| 3xx  | Redirecionamento; cliente deve fazer nova requisição.            |
| 4xx  | Erros do cliente; requisição inválida ou recurso não encontrado. |
| 5xx  | Erros do servidor; falha no processamento lado servidor.         |

Exemplos comuns:

| Código                    | Descrição                                                                    |
| ------------------------- | ---------------------------------------------------------------------------- |
| 200 OK                    | Requisição bem-sucedida; o corpo contém o recurso solicitado.                |
| 302 Found                 | Redireciona o cliente para outra URL (por exemplo, dashboard após login).    |
| 400 Bad Request           | Requisição malformada (faltam terminadores de linha, JSON inválido etc.).    |
| 403 Forbidden             | Acesso negado; o cliente não tem permissão ou input malicioso foi detectado. |
| 404 Not Found             | Recurso não existe no servidor.                                              |
| 500 Internal Server Error | Erro interno do servidor; não foi possível processar a requisição.           |

> Para uma lista completa de **HTTP response codes**, consulte este [link](https://developer.mozilla.org/docs/Web/HTTP/Status).

Além dos códigos padrão, provedores como Cloudflare e AWS podem implementar códigos personalizados.
