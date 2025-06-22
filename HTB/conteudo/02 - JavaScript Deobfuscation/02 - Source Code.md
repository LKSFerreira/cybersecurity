## Código Fonte (Source Code)

A maioria dos sites hoje em dia utiliza JavaScript para realizar suas funções. Enquanto o HTML é usado para determinar os campos e parâmetros principais do site, e o CSS é usado para determinar seu design, o JavaScript é usado para realizar quaisquer funções necessárias para executar o site. Isso acontece em segundo plano, e nós apenas vemos a bela interface (front-end) do site e interagimos com ela.

Embora todo esse código fonte esteja disponível no lado do cliente (client-side), ele é renderizado por nossos navegadores, então muitas vezes não prestamos atenção ao código fonte HTML. No entanto, se quiséssemos entender as funcionalidades do lado do cliente de uma determinada página, geralmente começamos dando uma olhada no código fonte da página. Esta seção mostrará como podemos descobrir o código fonte que contém tudo isso e entender seu uso geral.

### HTML

Começaremos iniciando o exercício abaixo, abrindo o Firefox em nossa PwnBox e visitando a URL mostrada na questão:

`http://IP_DO_SERVIDOR:PORTA`
![Screenshot](https://academy.hackthebox.com/storage/modules/41/js_deobf_mainsite.jpg)
*Secret Serial Generator: Esta página gera seriais secretos.*

Como podemos ver, o site diz "Secret Serial Generator" (Gerador de Seriais Secretos), sem ter nenhum campo de entrada ou mostrar qualquer funcionalidade clara. Então, nosso próximo passo é dar uma espiada em seu código fonte. Podemos fazer isso pressionando [CTRL + U], o que deve abrir a visualização do código fonte do site:

`view-source:http://IP_DO_SERVIDOR:PORTA`
![Screenshot](https://academy.hackthebox.com/storage/modules/41/js_deobf_mainsite_source_1.jpg)
*Trecho de código HTML para uma página web intitulada 'Secret Serial Generator' com CSS para largura e altura de página inteira.*

Como podemos ver, podemos visualizar o código fonte HTML do site.

O código fonte HTML pode conter várias informações, como comentários, para facilitar ainda mais uma melhor compreensão do código. Os desenvolvedores podem deixar informações sensíveis, que podem ser posteriormente aproveitadas. Vale a pena ler os comentários HTML.

### CSS

O código CSS é definido internamente no mesmo arquivo HTML entre elementos `<style>`, ou definido externamente em um arquivo `.css` separado e referenciado dentro do código HTML.

Neste caso, vemos que o CSS é definido internamente, como visto no trecho de código abaixo:

Código: `html`
```html
    <style>
        *,
        html {
            margin: 0;
            padding: 0;
            border: 0;
        }
        /* ...RECORTADO... */
        h1 {
            font-size: 144px;
        }
        p {
            font-size: 64px;
        }
    </style>
```

Se o estilo CSS de uma página for definido externamente, o arquivo `.css` externo é referenciado com a tag `<link>` dentro do `head` do HTML, da seguinte forma:

Código: `html`
```html
<head>
    <link rel="stylesheet" href="style.css">
</head>
```

### JavaScript

O mesmo conceito se aplica ao JavaScript. Ele pode ser escrito internamente entre elementos `<script>` ou escrito em um arquivo `.js` separado e referenciado dentro do código HTML.

Podemos ver em nosso código fonte HTML que o arquivo `.js` é referenciado externamente:

Código: `html`
```html
<script src="secret.js"></script>
```

Podemos verificar o script clicando em `secret.js`, o que deve nos levar diretamente ao script. Quando o visitamos, vemos que o código é muito complicado e não pode ser compreendido:

Código: `javascript`
```javascript
eval(function (p, a, c, k, e, d) { e = function (c) { /* ...RECORTADO... */ '|true|function'.split('|'), 0, {}))
```

A razão por trás disso é a **ofuscação de código**. O que é isso? Como é feito? Onde é usado?