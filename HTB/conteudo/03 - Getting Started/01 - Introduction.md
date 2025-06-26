# Visão Geral de Segurança da Informação (Infosec)

Segurança da Informação (infosec) é um campo vasto. O campo cresceu e evoluiu muito nos últimos anos. Ele oferece muitas especializações, incluindo, mas não se limitando a:

*   Segurança de redes e infraestrutura
*   Segurança de aplicações
*   Testes de segurança
*   Auditoria de sistemas
*   Planejamento de continuidade de negócios
*   Forense digital
*   Detecção e resposta a incidentes

Em resumo, infosec é a prática de proteger dados contra acesso não autorizado, alterações, uso ilegal, interrupção, etc. Profissionais de infosec também tomam medidas para reduzir o impacto geral de qualquer incidente desse tipo.

Os dados podem ser eletrônicos ou físicos e tangíveis (ex: projetos de design) ou intangíveis (conhecimento). Uma frase comum que surgirá muitas vezes em nossa carreira de infosec é proteger a "confidencialidade, integridade e disponibilidade dos dados", ou a **tríade CIA**.

## Processo de Gerenciamento de Riscos

A proteção de dados deve focar na implementação eficiente, porém eficaz, de políticas, sem afetar negativamente as operações de negócios e a produtividade de uma organização. Para alcançar isso, as organizações devem seguir um processo chamado **processo de gerenciamento de riscos**. Este processo envolve as seguintes cinco etapas:

| Passo                 | Explicação                                                                                                                                                             |
| :-------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Identificando o Risco | Identificar os riscos aos quais o negócio está exposto, como riscos legais, ambientais, de mercado, regulatórios e outros tipos de riscos.                             |
| Analisar o Risco      | Analisar os riscos para determinar seu impacto e probabilidade. Os riscos devem ser mapeados para as várias políticas, procedimentos e processos de negócios da organização. |
| Avaliar o Risco       | Avaliar, classificar e priorizar os riscos. Então, a organização deve decidir aceitar (inevitável), evitar (mudar planos), controlar (mitigar) ou transferir o risco (seguro/contratar seguro). |
| Lidando com o Risco   | Eliminar ou conter os riscos da melhor forma possível. Isso é tratado interagindo diretamente com as partes interessadas (stakeholders) do sistema ou processo ao qual o risco está associado. |
| Monitorando o Risco   | Todos os riscos devem ser constantemente monitorados. Os riscos devem ser constantemente monitorados para quaisquer mudanças situacionais que possam alterar sua pontuação de impacto, ou seja, de baixo para médio ou alto impacto. |

Como mencionado anteriormente, o princípio central da infosec é a garantia da informação, ou manter a CIA dos dados e garantir que eles não sejam comprometidos de forma alguma quando ocorrer um incidente. Um incidente pode ser um desastre natural, mau funcionamento do sistema ou incidente de segurança.

## Red Team vs. Blue Team

Em infosec, geralmente ouvimos os termos **red team** e **blue team**. Nos termos mais simples, o red team desempenha o papel dos atacantes, enquanto o blue team desempenha o papel dos defensores.

Os red teamers geralmente desempenham um papel de adversário, tentando invadir a organização para identificar quaisquer fraquezas potenciais que atacantes reais possam utilizar para quebrar as defesas da organização. A tarefa mais comum do lado do red teaming é o teste de invasão (penetration testing), engenharia social e outras técnicas ofensivas semelhantes.

Por outro lado, o blue team compõe a maioria dos trabalhos em infosec. É responsável por fortalecer as defesas da organização, analisando os riscos, elaborando políticas, respondendo a ameaças e incidentes, e usando efetivamente ferramentas de segurança e outras tarefas semelhantes.

## Papel dos Pentesters (Testadores de Invasão)

Um avaliador de segurança (testador de invasão de rede, testador de invasão de aplicações web, red teamer, etc.) ajuda uma organização a identificar riscos em suas redes externas e internas. Esses riscos podem incluir vulnerabilidades de rede ou de aplicações web, exposição de dados sensíveis, configurações incorretas ou problemas que podem levar a danos à reputação. Um bom testador pode trabalhar com um cliente para identificar riscos para sua organização, fornecer informações sobre como reproduzir esses riscos e orientação sobre como mitigar ou remediar os problemas identificados durante o teste.

As avaliações podem assumir muitas formas, desde um teste de invasão white-box contra todos os sistemas e aplicações no escopo para identificar o maior número possível de vulnerabilidades, até uma avaliação de phishing para avaliar o risco ou a conscientização de segurança dos funcionários, até uma avaliação de red team direcionada, construída em torno de um cenário para emular um ator de ameaça (threat actor) do mundo real.

Devemos entender o panorama geral dos riscos que uma organização enfrenta e seu ambiente para avaliar e classificar com precisão as vulnerabilidades descobertas durante os testes. Um profundo entendimento do processo de gerenciamento de riscos é crítico para qualquer pessoa que esteja começando em segurança da informação.

Este módulo focará em como começar em infosec e testes de invasão (penetration testing) de uma perspectiva prática, especificamente selecionando e navegando em uma distro de pentest, aprendendo sobre tecnologias comuns e ferramentas essenciais, aprendendo os níveis e o básico de testes de invasão, "quebrando" nossa primeira máquina (box) no HTB, como encontrar e pedir ajuda da forma mais eficaz, problemas potenciais comuns e como navegar na plataforma Hack The Box.

Embora este módulo use a plataforma Hack The Box e máquinas propositalmente vulneráveis como exemplos, as habilidades fundamentais apresentadas se aplicam a qualquer ambiente.