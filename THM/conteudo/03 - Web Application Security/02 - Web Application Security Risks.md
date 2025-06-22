## Riscos de Segurança em Aplicações Web

Digamos que você queira comprar um item em uma loja online. Existem certas funções que você esperaria poder realizar nesta aplicação web. De forma mais direta, o pedido online pode ocorrer da seguinte forma:

1.  Fazer login no site.
2.  Procurar o produto.
3.  Adicionar o produto ao carrinho de compras.
4.  Especificar o endereço de entrega.
5.  Fornecer os detalhes de pagamento.

Existem algumas categorias principais de ataques comuns contra aplicações web. Considere os seguintes passos e ataques relacionados.

*   **Fazer login no site:** O invasor pode tentar descobrir a senha tentando muitas palavras. O invasor usaria uma longa lista de senhas com uma ferramenta automatizada para testá-las contra a página de login.
*   **Procurar o produto:** O invasor pode tentar violar o sistema adicionando caracteres e códigos específicos ao termo de busca. O objetivo do invasor é que o sistema alvo retorne dados que não deveria ou execute um programa que não deveria.
*   **Fornecer detalhes de pagamento:** O invasor verificaria se os detalhes de pagamento são enviados em texto puro (cleartext) ou usando criptografia fraca. Criptografia refere-se a tornar os dados ilegíveis sem conhecer a chave secreta ou senha.

Não podemos cobrir tudo, mas apresentaremos algumas categorias formais do OWASP Top Ten. Não se preocupe se essas técnicas parecerem estranhas para você; o TryHackMe o guiará por cada vulnerabilidade.

### Falha de Identificação e Autenticação (Identification and Authentication Failure)

**Identificação** refere-se à capacidade de identificar um usuário de forma única. Em contraste, **autenticação** refere-se à capacidade de provar que o usuário é quem ele afirma ser. A loja online deve confirmar a identidade do usuário e autenticá-lo antes que ele possa usar o sistema. No entanto, esta etapa está propensa a diferentes tipos de fraquezas. Exemplos de fraquezas incluem:

*   Permitir que o invasor use força bruta (brute force), ou seja, tente muitas senhas, geralmente usando ferramentas automatizadas, para encontrar credenciais de login válیدas.
*   Permitir que o usuário escolha uma senha fraca. Uma senha fraca geralmente é fácil de adivinhar.
*   Armazenar as senhas dos usuários em texto puro. Se o invasor conseguir ler o arquivo contendo as senhas, não queremos que ele consiga descobrir a senha armazenada.

*Tabela de banco de dados com nomes de usuário e senhas em texto puro.*

### Controle de Acesso Quebrado (Broken Access Control)

O controle de acesso garante que cada usuário só possa acessar arquivos (documentos, imagens, etc.) relacionados à sua função ou trabalho. Por exemplo, você não quer que alguém do departamento de marketing acesse (leia) os documentos do departamento financeiro. Exemplos de vulnerabilidades relacionadas ao controle de acesso incluem:

*   Falhar em aplicar o princípio do menor privilégio e dar aos usuários mais permissões de acesso do que eles precisam. Por exemplo, um cliente online deve ser capaz de visualizar os preços dos itens, mas não deve ser capaz de alterá-los.
*   Ser capaz de visualizar ou modificar a conta de outra pessoa usando seu identificador único. Por exemplo, você não quer que um cliente de banco consiga visualizar as transações de outro cliente.
*   Ser capaz de navegar em páginas que exigem autenticação (login) como um usuário não autenticado. Por exemplo, não podemos permitir que ninguém visualize o webmail antes de fazer login.

### Injeção (Injection)

Um ataque de injeção refere-se a uma vulnerabilidade na aplicação web onde o usuário pode inserir código malicioso como parte de sua entrada. Uma causa dessa vulnerabilidade é a falta de validação e sanitização adequadas da entrada do usuário.

### Falhas Criptográficas (Cryptographic Failures)

Esta categoria refere-se às falhas relacionadas à criptografia. A criptografia foca nos processos de criptografia e descriptografia de dados. A **criptografia** embaralha o texto puro (cleartext) em texto cifrado (ciphertext), que deve ser um amontoado de caracteres sem sentido para qualquer um que não tenha a chave secreta para descriptografá-lo. Em outras palavras, a criptografia garante que ninguém possa ler os dados sem conhecer a chave secreta. A **descriptografia** converte o texto cifrado de volta para o texto puro original usando a chave secreta. Exemplos de falhas criptográficas incluem:

*   Enviar dados sensíveis em texto puro, por exemplo, usando HTTP em vez de HTTPS. HTTP é o protocolo usado para acessar a web, enquanto HTTPS é a versão segura do HTTP. Outros podem ler tudo o que você envia por HTTP, mas não por HTTPS.
*   Confiar em um algoritmo criptográfico fraco. Um algoritmo criptográfico antigo é deslocar cada letra em uma posição. Por exemplo, “TRY HACK ME” se torna “USZ IBDL NF”. Este algoritmo criptográfico é trivial de quebrar.
*   Usar chaves padrão ou fracas para funções criptográficas. Não será desafiador quebrar a criptografia que usou `1234` como chave secreta.

*Esta figura mostra um cliente usando seu cartão de crédito online e o número do cartão de crédito sendo enviado em texto puro.*

Não se preocupe se essas técnicas parecerem desafiadoras ou sofisticadas no início. O TryHackMe possui salas (módulos) dedicadas e aprofundadas para ajudá-lo a entender e experimentar os vários ataques contra aplicações web.

---
**Responda às perguntas abaixo:**

Você descobriu que a página de login permite um número ilimitado de tentativas de login sem tentar desacelerar o usuário ou bloquear a conta. Qual é a categoria deste risco de segurança?
R: Falha de Identificação e Autenticação (Identification and Authentication Failure)

Você notou que o nome de usuário e a senha são enviados em texto puro sem criptografia. Qual é a categoria deste risco de segurança?
R: Falhas Criptográficas (Cryptographic Failures)