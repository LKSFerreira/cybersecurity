## CIA (Confidencialidade, Integridade, Disponibilidade)

*Tríangulo CIA*

Antes que possamos descrever algo como seguro, precisamos considerar melhor o que compõe a segurança. Quando você quer julgar a segurança de um sistema, precisa pensar em termos da tríade de segurança: confidencialidade, integridade e disponibilidade (CIA - Confidentiality, Integrity, Availability).

*   **Confidencialidade (Confidentiality)** garante que apenas as pessoas ou destinatários pretendidos possam acessar os dados.
*   **Integridade (Integrity)** visa garantir que os dados não possam ser alterados; além disso, podemos detectar qualquer alteração se ela ocorrer.
*   **Disponibilidade (Availability)** visa garantir que o sistema ou serviço esteja disponível quando necessário.

*Um vendedor com um recibo, adicionando um zero ao preço de um item depois que um comprador o escolhe, multiplicando assim o preço por dez.*

Vamos considerar a tríade de segurança CIA no caso de fazer um pedido em compras online:

*   **Confidencialidade:** Durante as compras online, você espera que o número do seu cartão de crédito seja divulgado apenas à entidade que processa o pagamento. Se você duvidar que as informações do seu cartão de crédito serão divulgadas a uma parte não confiável, provavelmente se absterá de continuar com a transação. Além disso, se uma violação de dados resultar na divulgação de informações de identificação pessoal, incluindo cartões de crédito, a empresa incorrerá em enormes perdas em vários níveis.
*   **Integridade:** Após preencher seu pedido, se um invasor puder alterar o endereço de entrega que você enviou, o pacote será enviado para outra pessoa. Sem a integridade dos dados, você pode ficar muito relutante em fazer seu pedido com este vendedor.
*   **Disponibilidade:** Para fazer seu pedido online, você navegará no site da loja ou usará seu aplicativo oficial. Se o serviço estiver indisponível, você não conseguirá navegar pelos produtos ou fazer um pedido. Se continuar enfrentando esses problemas técnicos, você pode eventualmente desistir e começar a procurar outra loja online.

Vamos considerar a CIA em relação aos registros de pacientes e sistemas relacionados:

*   **Confidencialidade:** De acordo com várias leis em países modernos, os prestadores de cuidados de saúde devem garantir e manter a confidencialidade dos registros médicos. Consequentemente, os prestadores de cuidados de saúde podem ser responsabilizados legalmente se divulgarem ilegalmente os registros médicos de seus pacientes.
*   **Integridade:** Se um registro de paciente for alterado acidental ou maliciosamente, isso pode levar à administração do tratamento errado, o que, por sua vez, pode levar a uma situação de risco de vida. Portanto, o sistema seria inútil e potencialmente prejudicial sem garantir a integridade dos registros médicos.
*   **Disponibilidade:** Quando um paciente visita uma clínica para acompanhar sua condição médica, o sistema deve estar disponível. Um sistema indisponível significaria que o profissional médico não pode acessar os registros do paciente e, consequentemente, não saberá se algum sintoma atual está relacionado ao histórico médico do paciente. Essa situação pode tornar o diagnóstico médico mais desafiador e propenso a erros.

A ênfase não precisa ser a mesma em todas as três funções de segurança. Um exemplo seria um anúncio universitário; embora geralmente não seja confidencial, a integridade do documento é crítica.

### Além da CIA

*Um entregador com um número absurdamente grande de caixas de pizza e um homem na porta dizendo: "Eu não pedi isso."*

Indo um passo além da tríade de segurança CIA, podemos pensar em:

*   **Autenticidade (Authenticity):** Autêntico significa não fraudulento ou falsificado. Autenticidade é sobre garantir que o documento/arquivo/dado seja da fonte alegada.
*   **Não Repúdio (Non-repudiation):** Repudiar significa recusar-se a reconhecer a validade de algo. O não repúdio garante que a fonte original não possa negar que é a fonte de um determinado documento/arquivo/dado. Essa característica é indispensável para vários domínios, como compras, diagnóstico de pacientes e transações bancárias.

Esses dois requisitos estão intimamente relacionados. A necessidade de distinguir arquivos ou pedidos autênticos de falsos é indispensável. Além disso, garantir que a outra parte não possa negar ser a fonte é vital para que muitos sistemas sejam utilizáveis.

Em compras online, dependendo do seu negócio, você pode tolerar a tentativa de entregar uma camiseta com pagamento na entrega e descobrir mais tarde que o destinatário nunca fez tal pedido. No entanto, nenhuma empresa pode tolerar o envio de 1000 carros para descobrir que o pedido é falso. No exemplo de um pedido de compra, você quer confirmar que o referido cliente realmente fez este pedido; isso é autenticidade. Além disso, você quer garantir que eles não possam negar ter feito este pedido; isso é não repúdio.

Como empresa, se você receber um pedido de remessa de 1000 carros, precisa garantir a autenticidade deste pedido; além disso, a fonte não deve ser capaz de negar ter feito tal pedido. Sem autenticidade e não repúdio, o negócio não pode ser conduzido.

### Hexágono Parkeriano (Parkerian Hexad)

Em 1998, Donn Parker propôs o Hexágono Parkeriano, um conjunto de seis elementos de segurança. Eles são:

*   Disponibilidade (Availability)
*   Utilidade (Utility)
*   Integridade (Integrity)
*   Autenticidade (Authenticity)
*   Confidencialidade (Confidentiality)
*   Posse (Possession)

Já cobrimos quatro dos seis elementos acima. Vamos discutir os dois elementos restantes:

*   **Utilidade (Utility):** A utilidade foca na utilidade da informação. Por exemplo, um usuário pode ter perdido a chave de descriptografia para acessar um laptop com armazenamento criptografado. Embora o usuário ainda tenha o laptop com seus discos intactos, ele não pode acessá-los. Em outras palavras, embora ainda disponível, a informação está em uma forma que não é útil, ou seja, sem utilidade.
*   **Posse (Possession):** Este elemento de segurança exige que protejamos a informação contra tomada, cópia ou controle não autorizados. Por exemplo, um adversário pode pegar uma unidade de backup, o que significa que perdemos a posse da informação enquanto ele tiver a unidade. Alternativamente, o adversário pode conseguir criptografar nossos dados usando ransomware; isso também leva à perda da posse dos dados.