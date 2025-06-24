## Instalação (Installation)

<img src="https://tryhackme-images.s3.amazonaws.com/user-uploads/5c549500924ec576f953d9fc/room-content/c7711ee8f96ae1647adc1b07265f04c6.png"
     alt="Reconhecimento"
     width="200px" />

Como você aprendeu na fase de Armamentização, o backdoor permite que um invasor contorne as medidas de segurança e oculte o acesso. Um backdoor também é conhecido como um ponto de acesso.

Uma vez que o invasor obtém acesso ao sistema, ele gostaria de reacessar o sistema se perder a conexão com ele, se for detectado e tiver o acesso inicial removido, ou se o sistema for corrigido posteriormente. Ele não terá mais acesso a ele. É quando o invasor precisa instalar um backdoor persistente. Um backdoor persistente permitirá que o invasor acesse o sistema que ele comprometeu no passado. Você pode conferir a sala [Windows Persistence](caminho/para/windows-persistence.md) no TryHackMe para aprender como um invasor pode alcançar a persistência no Windows.

A persistência pode ser alcançada através de:

*   **Instalação de um web shell no servidor web.** Um web shell é um script malicioso escrito em linguagens de programação de desenvolvimento web como ASP, PHP ou JSP, usado por um invasor para manter o acesso ao sistema comprometido. Devido à simplicidade do web shell e à formatação de arquivo (.php, .asp, .aspx, .jsp, etc.), pode ser difícil de detectar e pode ser classificado como benigno. Você pode conferir este ótimo artigo divulgado pela [Microsoft sobre vários ataques de web shell](https://www.microsoft.com/en-us/security/blog/2021/02/11/web-shell-attacks-continue-to-rise/).
*   **Instalação de um backdoor na máquina da vítima.** Por exemplo, o invasor pode usar o Meterpreter para instalar um backdoor na máquina da vítima. Meterpreter é um payload do Metasploit Framework que fornece um shell interativo a partir do qual um invasor pode interagir com a máquina da vítima remotamente e executar o código malicioso.
*   **Criação ou modificação de serviços do Windows.** Esta técnica é conhecida como [T1543.003 no MITRE ATT&CK](https://attack.mitre.org/techniques/T1543/003/) (MITRE ATT&CK® é uma base de conhecimento de táticas e técnicas de adversários baseadas em cenários do mundo real). Um invasor pode criar ou modificar os serviços do Windows para executar os scripts ou payloads maliciosos regularmente como parte da persistência. Um invasor pode usar ferramentas como `sc.exe` (`sc.exe` permite Criar, Iniciar, Parar, Consultar ou Excluir qualquer Serviço do Windows) e `Reg` para modificar as configurações do serviço. O invasor também pode mascarar o payload malicioso usando um nome de serviço que é conhecido por estar relacionado ao Sistema Operacional ou software legítimo.
*   **Adição da entrada às "chaves de execução" (run keys) para o payload malicioso no Registro ou na Pasta de Inicialização (Startup Folder).** Ao fazer isso, o payload será executado cada vez que o usuário fizer login no computador. De acordo com o MITRE ATT&CK, existe um local da pasta de inicialização para contas de usuário individuais e uma pasta de inicialização em todo o sistema que será verificada, não importa qual conta de usuário faça login.
    Você pode ler mais sobre a persistência através de Chaves de Execução do Registro / Pasta de Inicialização em uma das [técnicas do MITRE ATT&CK](https://attack.mitre.org/techniques/T1547/001/).

Nesta fase, o invasor também pode usar a técnica de **Timestomping** para evitar a detecção pelo investigador forense e também para fazer o malware parecer parte de um programa legítimo. A técnica de Timestomping permite que um invasor modifique os carimbos de data/hora do arquivo, incluindo os horários de modificação, acesso, criação e alteração.

---
**Responda às perguntas abaixo:**

Você pode fornecer a técnica usada para modificar os atributos de tempo do arquivo para ocultar arquivos novos ou alterações em arquivos existentes?
R: Timestomping

Você pode nomear o script malicioso plantado por um invasor no servidor web para manter o acesso ao sistema comprometido e que permite que o servidor web seja acessado remotamente?
R: Web shell