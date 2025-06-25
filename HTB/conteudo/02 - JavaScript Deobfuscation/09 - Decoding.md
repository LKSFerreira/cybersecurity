## Decodificação (Decoding)

Após fazer o exercício na seção anterior, obtivemos um bloco de texto estranho que parece estar codificado (encoded):

Decodificação
```bash
lksferreira@htb[/htb]$ curl http://IP_DO_SERVIDOR:PORTA/serial.php -X POST -d "param1=sample"

ZG8gdGhlIGV4ZXJjaXNlLCBkb24ndCBjb3B5IGFuZCBwYXN0ZSA7KQo=
```

Este é outro aspecto importante da ofuscação ao qual nos referimos em "Mais Ofuscação" na seção "Ofuscação Avançada". Muitas técnicas podem ofuscar ainda mais o código e torná-lo menos legível por humanos e menos detectável por sistemas. Por essa razão, você encontrará com muita frequência código ofuscado contendo blocos de texto codificados que são decodificados durante a execução. Cobriremos 3 dos métodos de codificação de texto mais comumente usados:

*   base64
*   hex
*   rot13

### Base64

A codificação **base64** é geralmente usada para reduzir o uso de caracteres especiais, pois quaisquer caracteres codificados em base64 seriam representados em caracteres alfanuméricos, além de `+` e `/` apenas. Independentemente da entrada, mesmo que esteja em formato binário, a string codificada em base64 resultante usaria apenas eles.

#### Identificando Base64

Strings codificadas em base64 são facilmente identificadas, pois contêm apenas caracteres alfanuméricos. No entanto, a característica mais distintiva do base64 é seu preenchimento (padding) usando caracteres `=`. O comprimento das strings codificadas em base64 deve ser um múltiplo de 4. Se a saída resultante tiver apenas 3 caracteres de comprimento, por exemplo, um `=` extra é adicionado como preenchimento, e assim por diante.

#### Codificar em Base64

Para codificar qualquer texto em base64 no Linux, podemos usar `echo` e redirecionar (pipe) com `|` para `base64`:

Decodificação
```bash
lksferreira@htb[/htb]$ echo https://www.hackthebox.eu/ | base64

aHR0cHM6Ly93d3cuaGFja3RoZWJveC5ldS8K
```

#### Decodificar Base64

Se quisermos decodificar qualquer string codificada em base64, podemos usar `base64 -d`, da seguinte forma:

Decodificação
```bash
lksferreira@htb[/htb]$ echo aHR0cHM6Ly93d3cuaGFja3RoZWJveC5ldS8K | base64 -d

https://www.hackthebox.eu/
```

### Hex (Hexadecimal)

Outro método de codificação comum é a **codificação hexadecimal (hex encoding)**, que codifica cada caractere em sua ordem hexadecimal na tabela ASCII. Por exemplo, `a` é `61` em hexadecimal, `b` é `62`, `c` é `63`, e assim por diante. Você pode encontrar a tabela ASCII completa no Linux usando o comando `man ascii`.

#### Identificando Hex

Qualquer string codificada em hexadecimal seria composta apenas por caracteres hexadecimais, que são apenas 16 caracteres: `0-9` e `a-f`. Isso torna a identificação de strings codificadas em hexadecimal tão fácil quanto identificar strings codificadas em base64.

#### Codificar em Hex

Para codificar qualquer string em hexadecimal no Linux, podemos usar o comando `xxd -p`:

Decodificação
```bash
lksferreira@htb[/htb]$ echo https://www.hackthebox.eu/ | xxd -p

68747470733a2f2f7777772e6861636b746865626f782e65752f0a
```

#### Decodificar Hex

Para decodificar uma string codificada em hexadecimal, podemos usar o comando `xxd -p -r`:

Decodificação
```bash
lksferreira@htb[/htb]$ echo 68747470733a2f2f7777772e6861636b746865626f782e65752f0a | xxd -p -r

https://www.hackthebox.eu/
```

### Caesar/Rot13

Outra técnica de codificação comum - e muito antiga - é a **cifra de César (Caesar cipher)**, que desloca cada letra por um número fixo. Por exemplo, deslocar por 1 caractere faz `a` se tornar `b`, e `b` se torna `c`, e assim por diante. Muitas variações da cifra de César usam um número diferente de deslocamentos, sendo a mais comum o **rot13**, que desloca cada caractere 13 vezes para frente.

#### Identificando Caesar/Rot13

Embora este método de codificação faça qualquer texto parecer aleatório, ainda é possível identificá-lo porque cada caractere é mapeado para um caractere específico. Por exemplo, em rot13, `http://www` se torna `uggc://jjj`, o que ainda mantém algumas semelhanças e pode ser reconhecido como tal.

#### Codificar em Rot13

Não existe um comando específico no Linux para fazer a codificação rot13. No entanto, é bastante fácil criar nosso próprio comando para fazer o deslocamento de caracteres:

Decodificação
```bash
lksferreira@htb[/htb]$ echo https://www.hackthebox.eu/ | tr 'A-Za-z' 'N-ZA-Mn-za-m'

uggcf://jjj.unpxgurobk.rh/
```

#### Decodificar Rot13

Podemos usar o mesmo comando anterior para decodificar rot13 também:

Decodificação
```bash
lksferreira@htb[/htb]$ echo uggcf://jjj.unpxgurobk.rh/ | tr 'A-Za-z' 'N-ZA-Mn-za-m'

https://www.hackthebox.eu/
```

Outra opção para codificar/decodificar rot13 seria usar uma ferramenta online, como [rot13.com](https://rot13.com/).

### Outros Tipos de Codificação

Existem centenas de outros métodos de codificação que podemos encontrar online. Embora estes sejam os mais comuns, às vezes nos depararemos com outros métodos de codificação, que podem exigir alguma experiência para identificar e decodificar.

Se você enfrentar tipos semelhantes de codificação, primeiro tente determinar o tipo de codificação e, em seguida, procure ferramentas online para decodificá-la.

Algumas ferramentas podem nos ajudar a determinar automaticamente o tipo de codificação, como o [Cipher Identifier](https://www.boxentriq.com/code-breaking/cipher-identifier). Tente as strings codificadas acima com o Cipher Identifier, para ver se ele consegue identificar corretamente o método de codificação.

Além da codificação, muitas ferramentas de ofuscação utilizam **criptografia**, que é codificar uma string usando uma chave, o que pode tornar o código ofuscado muito difícil de fazer engenharia reversa e desofuscar, especialmente se a chave de descriptografia não estiver armazenada dentro do próprio script.