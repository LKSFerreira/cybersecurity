## Desofuscação (Deobfuscation)

Agora que entendemos como funciona a ofuscação de código, vamos começar nosso aprendizado em direção à desofuscação. Assim como existem ferramentas para ofuscar código automaticamente, existem ferramentas para embelezar (beautify) e desofuscar o código automaticamente.

### Embelezar (Beautify)

Vemos que o código atual que temos está todo escrito em uma única linha. Isso é conhecido como código JavaScript Minificado (Minified JavaScript code). Para formatar corretamente o código, precisamos Embelezar (Beautify) nosso código. O método mais básico para fazer isso é através das Ferramentas de Desenvolvedor do Navegador (Browser Dev Tools).

Por exemplo, se estivéssemos usando o Firefox, podemos abrir o depurador do navegador com [CTRL+SHIFT+Z] e, em seguida, clicar em nosso script `secret.js`. Isso mostrará o script em sua formatação original, mas podemos clicar no botão '{ }' na parte inferior, que fará o "Pretty Print" (Embelezar Impressão) do script em sua formatação JavaScript adequada:

![Editor de código mostrando o arquivo JavaScript](https://academy.hackthebox.com/storage/modules/41/js_deobf_pretty_print.jpg)

*Editor de código mostrando o arquivo JavaScript 'secret.js' com código de substituição regex.*

Além disso, podemos utilizar muitas ferramentas online ou plugins de editor de código, como [Prettier](https://prettier.io/) ou [Beautifier.io](https://beautifier.io/). Vamos copiar o script `secret.js`:

Código: `javascript`
```javascript
eval(function (p, a, c, k, e, d) { e = function (c) { return c.toString(36) }; if (!''.replace(/^/, String)) { while (c--) { d[c.toString(a)] = k[c] || c.toString(a) } k = [function (e) { return d[e] }]; e = function () { return '\\w+' }; c = 1 }; while (c--) { if (k[c]) { p = p.replace(new RegExp('\\b' + e(c) + '\\b', 'g'), k[c]) } } return p }('g 4(){0 5="6{7!}";0 1=8 a();0 2="/9.c";1.d("e",2,f);1.b(3)}', 17, 17, 'var|xhr|url|null|generateSerial|flag|HTB|flag|new|serial|XMLHttpRequest|send|php|open|POST|true|function'.split('|'), 0, {}))
```

Podemos ver que ambos os sites fazem um bom trabalho na formatação do código:

![Editor de código exibindo função JavaScript ofuscada usando eval.](https://academy.hackthebox.com/storage/modules/41/js_deobf_prettier_1.jpg)

`https://prettier.io/playground/` *Editor de código exibindo função JavaScript ofuscada usando eval.*

![Código JavaScript ofuscado usando eval e substituição regex](https://academy.hackthebox.com/storage/modules/41/js_deobf_beautifier_1.jpg)

`https://beautifier.io/` *Código JavaScript ofuscado usando eval e substituição regex.*

No entanto, o código ainda não é muito fácil de ler. Isso ocorre porque o código com o qual estamos lidando não foi apenas minificado, mas também ofuscado. Portanto, simplesmente formatar ou embelezar o código não será suficiente. Para isso, precisaremos de ferramentas para desofuscar o código.

### Desofuscar (Deobfuscate)

Podemos encontrar muitas boas ferramentas online para desofuscar código JavaScript e transformá-lo em algo que possamos entender. Uma boa ferramenta é o [UnPacker](https://matthewfl.com/unPacker.html). Vamos tentar copiar nosso código ofuscado acima e executá-lo no UnPacker clicando no botão "UnPack".

**Dica:** Certifique-se de não deixar nenhuma linha vazia antes do script, pois isso pode afetar o processo de desofuscação e fornecer resultados imprecisos.

![Código JavaScript ofuscado com funções para gerar e enviar seriais.](https://academy.hackthebox.com/storage/modules/41/js_deobf_unpacker_1.jpg)

`https://matthewfl.com/unPacker.html` *Código JavaScript ofuscado com funções para gerar e enviar seriais.*

Podemos ver que esta ferramenta faz um trabalho muito melhor na desofuscação do código JavaScript e nos deu uma saída que podemos entender:

Código: `javascript`
```javascript
function generateSerial() {
  /* ...RECORTADO... */
  var xhr = new XMLHttpRequest;
  var url = "/serial.php";
  xhr.open("POST", url, true);
  xhr.send(null);
};
```

Como mencionado anteriormente, o método de ofuscação usado acima é o "empacotamento" (packing). Outra forma de desempacotar tal código é encontrar o valor de retorno no final e usar `console.log` para imprimi-lo em vez de executá-lo.

### Engenharia Reversa (Reverse Engineering)

Embora essas ferramentas estejam fazendo um bom trabalho até agora em limpar o código para algo que possamos entender, uma vez que o código se torne mais ofuscado e codificado (encoded), se tornará muito mais difícil para as ferramentas automatizadas limpá-lo. Isso é especialmente verdadeiro se o código foi ofuscado usando uma ferramenta de ofuscação personalizada.

Para tais casos, precisaríamos fazer engenharia reversa manual do código para entender como ele foi ofuscado e sua funcionalidade. Se você estiver interessado em saber mais sobre Desofuscação Avançada de JavaScript e Engenharia Reversa, pode conferir o módulo [Secure Coding 101](link-para-o-modulo-se-existir), que deve cobrir este tópico detalhadamente.