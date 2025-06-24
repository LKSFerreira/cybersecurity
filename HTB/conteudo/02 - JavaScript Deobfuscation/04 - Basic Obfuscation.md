## Ofuscação Básica

A ofuscação de código geralmente não é feita manualmente, pois existem muitas ferramentas para várias linguagens que fazem a ofuscação de código automatizada. Muitas ferramentas online podem ser encontradas para isso, embora muitos atores maliciosos e desenvolvedores profissionais desenvolvam suas próprias ferramentas de ofuscação para torná-la mais difícil de desofuscar.

### Executando código JavaScript

Vamos pegar a seguinte linha de código como exemplo e tentar ofuscá-la:

Código: `javascript`
```javascript
console.log('HTB JavaScript Deobfuscation Module');
```

Primeiro, vamos testar a execução deste código em texto puro (cleartext), para vê-lo funcionando na prática. Podemos ir ao [JSConsole](https://jsconsole.com/), colar o código e pressionar enter, e ver sua saída:

![Imagem da página](https://academy.hackthebox.com/storage/modules/41/js_deobf_jsconsole_1_1.jpg)
`https://jsconsole.com`
*Saída do console mostrando a mensagem de log 'HTB JavaScript Deobfuscation Module' e a versão 2.1.2.*

Vemos que esta linha de código imprime `HTB JavaScript Deobfuscation Module`, o que é feito usando a função `console.log()`.

### Minificando código JavaScript

Uma forma comum de reduzir a legibilidade de um trecho de código JavaScript, mantendo-o totalmente funcional, é a **minificação de JavaScript (JavaScript minification)**. A minificação de código significa ter todo o código em uma única linha (geralmente muito longa). A minificação de código é mais útil para códigos mais longos, pois se nosso código consistisse apenas em uma única linha, não pareceria muito diferente quando minificado.

Muitas ferramentas podem nos ajudar a minificar código JavaScript, como o [javascript-minifier](https://javascript-minifier.com/). Simplesmente copiamos nosso código, clicamos em "Minify", e obtemos a saída minificada à direita:

![Ferramenta de minificação de JavaScript mostrando o código de entrada e a saída minificada.](https://academy.hackthebox.com/storage/modules/41/js_minify_1.jpg)
`https://javascript-minifier.com/`
*Ferramenta de minificação de JavaScript mostrando o código de entrada e a saída minificada.*

Mais uma vez, podemos copiar o código minificado para o [JSConsole](https://jsconsole.com/) e executá-lo, e vemos que ele funciona como esperado. Geralmente, o código JavaScript minificado é salvo com a extensão `.min.js`.

**Nota:** A minificação de código não é exclusiva do JavaScript e pode ser aplicada a muitas outras linguagens, como pode ser visto no [javascript-minifier](https://javascript-minifier.com/).

### Empacotando código JavaScript (Packing)

Agora, vamos ofuscar nossa linha de código para torná-la mais obscura e difícil de ler. Primeiro, tentaremos o [BeautifyTools](http://beautifytools.com/javascript-obfuscator.php) para ofuscar nosso código:

![Ferramenta de desofuscação de JavaScript com opções para decodificação](https://academy.hackthebox.com/storage/modules/41/js_deobf_obfuscator.jpg)
`http://beautifytools.com/javascript-obfuscator.php`
*Ferramenta de desofuscação de JavaScript com opções para decodificação rápida e caracteres especiais, mostrando código ofuscado.*

Código: `javascript`
```javascript
eval(function(p,a,c,k,e,d){e=function(c){return c};if(!''.replace(/^/,String)){while(c--){d[c]=k[c]||c}k=[function(e){return d[e]}];e=function(){return'\\w+'};c=1};while(c--){if(k[c]){p=p.replace(new RegExp('\\b'+e(c)+'\\b','g'),k[c])}}return p}('5.4(\'3 2 1 0\');',6,6,'Module|Deobfuscation|JavaScript|HTB|log|console'.split('|'),0,{}))
```

Vemos que nosso código ficou muito mais ofuscado e difícil de ler. Podemos copiar este código para o [https://jsconsole.com](https://jsconsole.com/), para verificar se ele ainda executa sua função principal:
![Saída do console mostrando código JavaScript ofuscado e a versão 2.1.2.](https://academy.hackthebox.com/storage/modules/41/js_deobf_jsconsole_3_1.jpg)
`https://jsconsole.com`
*Saída do console mostrando código JavaScript ofuscado e a versão 2.1.2.*

Vemos que obtemos a mesma saída.

**Nota:** O tipo de ofuscação acima é conhecido como **"empacotamento" (packing)**, que geralmente é reconhecível pelos seis argumentos de função usados na função inicial `"function(p,a,c,k,e,d)"`.

Uma ferramenta de ofuscação do tipo "packer" geralmente tenta converter todas as palavras e símbolos do código em uma lista ou dicionário e, em seguida, referenciá-los usando a função `(p,a,c,k,e,d)` para reconstruir o código original durante a execução. Os argumentos `(p,a,c,k,e,d)` podem ser diferentes de um "packer" para outro. No entanto, geralmente contêm uma certa ordem na qual as palavras e símbolos do código original foram empacotados para saber como ordená-los durante a execução.

Embora um "packer" faça um ótimo trabalho reduzindo a legibilidade do código, ainda podemos ver suas strings principais escritas em texto puro, o que pode revelar alguma de sua funcionalidade. É por isso que podemos querer procurar maneiras melhores de ofuscar nosso código.