## Armamentização (Weaponization)

<img src="https://tryhackme-images.s3.amazonaws.com/user-uploads/5c549500924ec576f953d9fc/room-content/51b64c85665c43b1ef139b93bc5e047c.png"
     alt="Reconhecimento"
     width="200px" />

Após uma fase de reconhecimento bem-sucedida, "Megatron" trabalharia na criação de uma "arma de destruição". Ele preferiria não interagir diretamente com a vítima e, em vez disso, criará um "armamentizador" (weaponizer) que, segundo a Lockheed Martin, combina malware e exploit em um payload entregável. A maioria dos invasores geralmente usa ferramentas automatizadas para gerar o malware ou recorre à DarkWeb para comprar o malware. Atores mais sofisticados ou APTs (Grupos de Ameaça Persistente Avançada) patrocinados por nações escreveriam seu próprio malware personalizado para tornar a amostra de malware única e evitar a detecção no alvo.

Vamos primeiro definir alguma terminologia antes de analisarmos a fase de Armamentização.

*   **Malware** é um programa ou software projetado para danificar, interromper ou obter acesso não autorizado a um computador.
*   Um **exploit** é um programa ou código que se aproveita de uma vulnerabilidade ou falha em uma aplicação ou sistema.
*   Um **payload** é um código malicioso que o invasor executa no sistema.

Continuando com nosso adversário, "Megatron" escolhe...

"Megatron" escolhe comprar um payload já escrito de outra pessoa na DarkWeb, para que ele possa gastar mais tempo nas outras fases.

Na fase de Armamentização, o invasor iria:

*   Criar um documento do Microsoft Office infectado contendo uma macro maliciosa ou scripts VBA (Visual Basic for Applications). Se você quiser aprender sobre macro e VBA, consulte o artigo "[Intro to Macros and VBA For Script Kiddies](https://www.trustedsec.com/blog/intro-to-macros-and-vba-for-script-kiddies/)" da TrustedSec.
*   Um invasor pode criar um payload malicioso ou um worm muito sofisticado, implantá-lo em unidades USB e, em seguida, distribuí-los em público. Um exemplo do vírus.
*   Um invasor escolheria técnicas de Comando e Controle (C2) para executar os comandos na máquina da vítima ou entregar mais payloads. Você pode ler mais sobre as técnicas de C2 no [MITRE ATT&CK](https://attack.mitre.org/techniques/T1071/).
*   Um invasor selecionaria um implante de backdoor (a maneira de acessar o sistema do computador, que inclui contornar os mecanismos de segurança).

---
**Responda às perguntas abaixo:**

Este termo é referido como um grupo de comandos que realizam uma tarefa específica. Você pode pensar neles como sub-rotinas ou funções que contêm o código que a maioria dos usuários usa para automatizar tarefas rotineiras. Mas atores maliciosos tendem a usá-los para fins maliciosos e incluí-los em documentos do Microsoft Office. Você pode fornecer o termo para isso?
R: Macro