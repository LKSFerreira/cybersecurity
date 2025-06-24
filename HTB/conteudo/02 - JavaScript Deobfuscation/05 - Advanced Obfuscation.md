## Ofuscação Avançada

Até agora, conseguimos tornar nosso código ofuscado e mais difícil de ler. No entanto, o código ainda contém strings em texto puro (cleartext), o que pode revelar sua funcionalidade original. Nesta seção, tentaremos algumas ferramentas que devem ofuscar completamente o código e ocultar quaisquer resquícios de sua funcionalidade original.

### Obfuscator.io

Vamos visitar [https://obfuscator.io](https://obfuscator.io). Antes de clicarmos em "obfuscate", alteraremos "String Array Encoding" para "Base64", como visto abaixo:

![Ferramenta de ofuscação de JavaScript](https://academy.hackthebox.com/storage/modules/41/js_deobf_obfuscator_2.jpg)
`https://obfuscator.io`
*Ferramenta de ofuscação de JavaScript com opções para código compacto, manipulação de array de strings e sourcemaps.*

Agora, podemos colar nosso código e clicar em "obfuscate":

![Área de entrada de código JavaScript com o botão 'Obfuscate'](https://academy.hackthebox.com/storage/modules/41/js_deobf_obfuscator_1.jpg)
`https://obfuscator.io`
*Área de entrada de código JavaScript com o botão 'Obfuscate'.*

Obtemos o seguinte código:

Código: `javascript`
```javascript
var _0x1ec6=['Bg9N','sfrciePHDMfty3jPChqGrgvVyMz1C2nHDgLVBIbnB2r1Bgu='];(function(_0x13249d,_0x1ec6e5){var _0x14f83b=function(_0x3f720f){while(--_0x3f720f){_0x13249d['push'](_0x13249d['shift']());}};_0x14f83b(++_0x1ec6e5);}(_0x1ec6,0xb4));var _0x14f8=function(_0x13249d,_0x1ec6e5){_0x13249d=_0x13249d-0x0;var _0x14f83b=_0x1ec6[_0x13249d];if(_0x14f8['eOTqeL']===undefined){var _0x3f720f=function(_0x32fbfd){var _0x523045='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+/=',_0x4f8a49=String(_0x32fbfd)['replace'](/=+$/,'');var _0x1171d4='';for(var _0x44920a=0x0,_0x2a30c5,_0x443b2f,_0xcdf142=0x0;_0x443b2f=_0x4f8a49['charAt'](_0xcdf142++);~_0x443b2f&&(_0x2a30c5=_0x44920a%0x4?_0x2a30c5*0x40+_0x443b2f:_0x443b2f,_0x44920a++%0x4)?_0x1171d4+=String['fromCharCode'](0xff&_0x2a30c5>>(-0x2*_0x44920a&0x6)):0x0){_0x443b2f=_0x523045['indexOf'](_0x443b2f);}return _0x1171d4;};_0x14f8['oZlYBE']=function(_0x8f2071){var _0x49af5e=_0x3f720f(_0x8f2071);var _0x52e65f=[];for(var _0x1ed1cf=0x0,_0x79942e=_0x49af5e['length'];_0x1ed1cf<_0x79942e;_0x1ed1cf++){_0x52e65f+='%'+('00'+_0x49af5e['charCodeAt'](_0x1ed1cf)['toString'](0x10))['slice'](-0x2);}return decodeURIComponent(_0x52e65f);},_0x14f8['qHtbNC']={},_0x14f8['eOTqeL']=!![];}var _0x20247c=_0x14f8['qHtbNC'][_0x13249d];return _0x20247c===undefined?(_0x14f83b=_0x14f8['oZlYBE'](_0x14f83b),_0x14f8['qHtbNC'][_0x13249d]=_0x14f83b):_0x14f83b=_0x20247c,_0x14f83b;};console[_0x14f8('0x0')](_0x14f8('0x1'));
```

Este código é obviamente mais ofuscado, e não podemos ver nenhum resquício do nosso código original. Podemos agora tentar executá-lo em [https://jsconsole.com](https://jsconsole.com/) para verificar se ele ainda executa sua função original. Tente brincar com as configurações de ofuscação em [https://obfuscator.io](https://obfuscator.io/) para gerar um código ainda mais ofuscado e, em seguida, tente executá-lo novamente em [https://jsconsole.com](https://jsconsole.com/) para verificar se ele ainda executa sua função original.

### Mais Ofuscação

Agora devemos ter uma ideia clara de como funciona a ofuscação de código. Ainda existem muitas variações de ferramentas de ofuscação de código, cada uma das quais ofusca o código de forma diferente. Pegue o seguinte código JavaScript, por exemplo:

Código: `javascript`
```javascript
[][(![]+[])[+[]]+([![]]+[][[]])[+!+[]+[+[]]]+(![]+[])[!+[]+!+[]]+(!![]+[])[+[]]+(!![]+[])[!+[]+!+[]+!+[]]+(!![]+[])[+!+[]]][([][(![]+[])[+[]]+([![]]+[][[]])[+!+[]+[+[]]]+(![]+[])[!+[]+!+[]]+(!![]+[])[+[]]+(!![]+[])[!+[]+!+[]+!+[]]+(!![]+[])[+!+[]]]+[])[!+[]+!+[]+!+[]]+(!![]+[][(![]+[])[+[]]+([![]]+[][[]])[+!+[]+[+[]]]+(![]+[])[!+[]+!+[]]+(!![]+[])[+[]]+(!![]+[])[!+[]+!+[]+!+[]]+(!![]+[])[+!+[]]])[+!+[]+[+[]]]+([][[]]+[])[+!+[]]+(![]+[])[!+[]+!+[]+!+[]]+(!![]+[])[+[]]+(!![]+[])[+!+[]]+([][[]]+[])[+[]]+([][(!
/* ...RECORTADO... */
[]]+(!![]+[][(![]+[])[+[]]+([![]]+[][[]])[+!+[]+[+[]]]+(![]+[])[!+[]+!+[]]+(!![]+[])[+[]]+(!![]+[])[!+[]+!+[]+!+[]]+(!![]+[])[+!+[]]])[+!+[]+[+[]]]+([][[]]+[])[+!+[]]+(![]+[])[!+[]+!+[]+!+[]]+(!![]+[])[+[]]+(!![]+[])[+!+[]]+([][[]]+[])[+[]]+([][(![]+[])[+[]]+([![]]+[][[]])[+!+[]+[+[]]]+(![]+[])[!+[]+!+[]]+(!![]+[])[+[]]+(!![]+[])[!+[]+!+[]+!+[]]+(!![]+[])[+!+[]]]+[])[!+[]+!+[]+!+[]]+(!![]+[])[+[]]+(!![]+[][(![]+[])[+[]]+([![]]+[][[]])[+!+[]+[+[]]]+(![]+[])[!+[]+!+[]]+(!![]+[])[+[]]+(!![]+[])[!+[]+!+[]+!+[]]+(!![]+[])[+!+[]]])[+!+[]+[+[]]]+(!![]+[])[+!+[]]])[!+[]+!+[]+[+[]]]](!+[]+!+[]+[+[]])))()
```

Ainda podemos executar este código, e ele ainda executaria sua função original:

![Saída de código JavaScript ofuscado com a mensagem 'HTB JavaScript Deobfuscation Module'](https://academy.hackthebox.com/storage/modules/41/js_deobf_jsf.jpg)
`https://jsconsole.com`
*Saída de código JavaScript ofuscado com a mensagem 'HTB JavaScript Deobfuscation Module'.*

**Nota:** O código acima foi recortado, pois o código completo é muito longo, mas o código completo deve ser executado com sucesso.

Podemos tentar ofuscar o código usando a mesma ferramenta em [JSF](https://jsfuck.com/) (provavelmente uma referência a JSFuck, um estilo de ofuscação que usa apenas `()[]!+`), e depois executá-lo novamente. Notaremos que o código pode levar algum tempo para ser executado, o que mostra como a ofuscação de código pode afetar o desempenho, como mencionado anteriormente.

Existem muitos outros ofuscadores de JavaScript, como [JJ Encode](http://www.jjencode.com/) ou [AA Encode](http://www.aaencode.com/). No entanto, tais ofuscadores geralmente tornam a execução/compilação do código muito lenta, então não é recomendado usá-los a menos que por uma razão óbvia, como contornar filtros ou restrições da web.
