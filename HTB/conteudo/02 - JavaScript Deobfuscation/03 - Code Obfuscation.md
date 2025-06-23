## Ofuscação de Código (Code Obfuscation)

Antes de começarmos a aprender sobre desofuscação, devemos primeiro aprender sobre ofuscação de código. Sem entender como o código é ofuscado, podemos não ser capazes de desofuscar o código com sucesso, especialmente se ele foi ofuscado usando um ofuscador personalizado.

### O que é ofuscação

**Ofuscação** é uma técnica usada para tornar um script mais difícil de ser lido por humanos, mas que permite que ele funcione da mesma forma do ponto de vista técnico, embora o desempenho possa ser mais lento. Isso geralmente é alcançado automaticamente usando uma ferramenta de ofuscação, que recebe o código como entrada e tenta reescrever o código de uma forma muito mais difícil de ler, dependendo de seu design.

Por exemplo, os ofuscadores de código frequentemente transformam o código em um dicionário de todas as palavras e símbolos usados dentro do código e, em seguida, tentam reconstruir o código original durante a execução, referindo-se a cada palavra e símbolo do dicionário. O seguinte é um exemplo de um código JavaScript simples sendo ofuscado:

`http://beautifytools.com/javascript-obfuscator.php`

<img src="https://academy.hackthebox.com/storage/modules/41/obfuscation_example.jpg"
     alt="Representação"
     width="400px" />

*Módulo de desofuscação de JavaScript com opções para decodificação rápida e caracteres especiais, mostrando código ofuscado.*

Códigos escritos em muitas linguagens são publicados e executados sem serem compilados em linguagens interpretadas, como Python, PHP e JavaScript. Enquanto Python e PHP geralmente residem no lado do servidor (server-side) e, portanto, ficam ocultos dos usuários finais, o JavaScript é geralmente usado em navegadores no lado do cliente (client-side), e o código é enviado ao usuário e executado em texto puro (cleartext). É por isso que a ofuscação é muito frequentemente usada com JavaScript.

### Casos de Uso

Existem muitas razões pelas quais os desenvolvedores podem considerar ofuscar seu código. Uma razão comum é ocultar o código original e suas funções para evitar que seja reutilizado ou copiado sem a permissão do desenvolvedor, tornando mais difícil a engenharia reversa da funcionalidade original do código. Outra razão é fornecer uma camada de segurança ao lidar com autenticação ou criptografia para prevenir ataques a vulnerabilidades que podem ser encontradas no código.

**Deve-se notar que fazer autenticação ou criptografia no lado do cliente não é recomendado, pois o código fica mais propenso a ataques dessa forma.**

O uso mais comum da ofuscação, no entanto, é para ações maliciosas. É comum que invasores e atores maliciosos ofusquem seus scripts maliciosos para impedir que os sistemas de Detecção e Prevenção de Intrusão (Intrusion Detection and Prevention systems) detectem seus scripts. Na próxima seção, aprenderemos como ofuscar um código JavaScript simples e tentaremos executá-lo antes e depois da ofuscação para notar quaisquer diferenças.