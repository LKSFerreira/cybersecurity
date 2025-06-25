## Requisições HTTP (HTTP Requests)

Na seção anterior, descobrimos que a função principal de `secret.js` está enviando uma requisição POST vazia para `/serial.php`. Nesta seção, tentaremos fazer o mesmo usando o cURL para enviar uma requisição POST para `/serial.php`. Para aprender mais sobre cURL e requisições web, você pode conferir o módulo [Requisições Web (Web Requests)](./caminho/para/web-requests.md).

### cURL

cURL é uma poderosa ferramenta de linha de comando usada em distribuições Linux, macOS e até mesmo nas versões mais recentes do Windows PowerShell. Podemos requisitar qualquer site simplesmente fornecendo sua URL, e o obteríamos em formato de texto, da seguinte forma:

Requisições HTTP
```bash
lksferreira@htb[/htb]$ curl http://IP_DO_SERVIDOR:PORTA/

</html>
<!DOCTYPE html>

<head>
    <title>Secret Serial Generator</title>
    <style>
        *,
        html {
            margin: 0;
            padding: 0;
            border: 0;
/* ...RECORTADO... */
        <h1>Secret Serial Generator</h1>
        <p>This page generates secret serials!</p>
    </div>
</body>

</html>
```
Este é o mesmo HTML que analisamos quando verificamos o código fonte na primeira seção.

### Requisição POST

Para enviar uma requisição POST, devemos adicionar a flag `-X POST` ao nosso comando, e ele deve enviar uma requisição POST:

Requisições HTTP
```bash
lksferreira@htb[/htb]$ curl -s http://IP_DO_SERVIDOR:PORTA/ -X POST
```

**Dica:** Adicionamos a flag `"-s"` para reduzir a poluição da resposta com dados desnecessários.

No entanto, a requisição POST geralmente contém dados POST. Para enviar dados, podemos usar a flag `"-d "param1=sample""` e incluir nossos dados para cada parâmetro, da seguinte forma:

Requisições HTTP
```bash
lksferreira@htb[/htb]$ curl -s http://IP_DO_SERVIDOR:PORTA/ -X POST -d "param1=sample"
```

Agora que sabemos como usar o cURL para enviar requisições POST básicas, na próxima seção, utilizaremos isso para replicar o que `secret.js` (o nome do arquivo parece ter mudado de `server.js` para `secret.js` ao longo do texto original, mantive `secret.js` conforme o contexto mais recente) está fazendo para entender melhor seu propósito.