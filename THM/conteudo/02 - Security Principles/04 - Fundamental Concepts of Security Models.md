## Conceitos Fundamentais de Modelos de Segurança

Aprendemos que a tríade de segurança é representada por Confidencialidade, Integridade e Disponibilidade (CIA). Alguém pode perguntar: como podemos criar um sistema que garanta uma ou mais funções de segurança? A resposta estaria no uso de modelos de segurança. Nesta tarefa, apresentaremos três modelos de segurança fundamentais:

*   Modelo Bell-LaPadula
*   Modelo de Integridade Biba
*   Modelo Clark-Wilson

### Modelo Bell-LaPadula

O Modelo Bell-LaPadula visa alcançar a confidencialidade especificando três regras:

1.  **Propriedade de Segurança Simples (Simple Security Property):** Esta propriedade é referida como “não ler para cima” (no read up); ela afirma que um sujeito (subject) em um nível de segurança inferior não pode ler um objeto (object) em um nível de segurança superior. Esta regra impede o acesso a informações sensíveis acima do nível autorizado.
2.  **Propriedade de Segurança Estrela (Star Security Property):** Esta propriedade é referida como “não escrever para baixo” (no write down); ela afirma que um sujeito em um nível de segurança superior não pode escrever em um objeto em um nível de segurança inferior. Esta regra impede a divulgação de informações sensíveis a um sujeito de nível de segurança inferior.
3.  **Propriedade de Segurança Discricionária (Discretionary-Security Property):** Esta propriedade usa uma matriz de acesso para permitir operações de leitura e escrita. Um exemplo de matriz de acesso é mostrado na tabela abaixo e usado em conjunto com as duas primeiras propriedades.

    | Sujeitos    | Objeto A    | Objeto B  |
    | :---------- | :---------- | :-------- |
    | Sujeito 1   | Escrever    | Sem acesso |
    | Sujeito 2   | Ler/Escrever | Ler       |

As duas primeiras propriedades podem ser resumidas como “escrever para cima, ler para baixo” (write up, read down). Você pode compartilhar informações confidenciais com pessoas de maior nível de segurança (escrever para cima), e você pode receber informações confidenciais de pessoas com menor nível de segurança (ler para baixo).

Existem certas limitações no modelo Bell-LaPadula. Por exemplo, ele não foi projetado para lidar com o compartilhamento de arquivos.

### Modelo Biba

O Modelo Biba visa alcançar a integridade especificando duas regras principais:

1.  **Propriedade de Integridade Simples (Simple Integrity Property):** Esta propriedade é referida como “não ler para baixo” (no read down); um sujeito de integridade superior não deve ler de um objeto de integridade inferior.
2.  **Propriedade de Integridade Estrela (Star Integrity Property):** Esta propriedade é referida como “não escrever para cima” (no write up); um sujeito de integridade inferior não deve escrever em um objeto de integridade superior.

Essas duas propriedades podem ser resumidas como “ler para cima, escrever para baixo” (read up, write down). Esta regra contrasta com o Modelo Bell-LaPadula, e isso não deve ser surpreendente, pois um se preocupa com a confidencialidade enquanto o outro se preocupa com a integridade.

O Modelo Biba sofre de várias limitações. Um exemplo é que ele não lida com ameaças internas (insider threat).

### Modelo Clark-Wilson

O Modelo Clark-Wilson também visa alcançar a integridade usando os seguintes conceitos:

*   **Item de Dados Restrito (Constrained Data Item - CDI):** Refere-se ao tipo de dados cuja integridade queremos preservar.
*   **Item de Dados Não Restrito (Unconstrained Data Item - UDI):** Refere-se a todos os tipos de dados além do CDI, como entrada do usuário e do sistema.
*   **Procedimentos de Transformação (Transformation Procedures - TPs):** Esses procedimentos são operações programadas, como ler e escrever, e devem manter a integridade dos CDIs.
*   **Procedimentos de Verificação de Integridade (Integrity Verification Procedures - IVPs):** Esses procedimentos verificam e garantem a validade dos CDIs.

Cobrimos apenas três modelos de segurança. O leitor pode explorar muitos modelos de segurança adicionais. Exemplos incluem:

*   Modelo Brewer e Nash
*   Modelo Goguen-Meseguer
*   Modelo Sutherland
*   Modelo Graham-Denning
*   Modelo Harrison-Ruzzo-Ullman