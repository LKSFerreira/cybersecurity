## Comando e Controle (Command & Control)

<img src="https://tryhackme-images.s3.amazonaws.com/user-uploads/5c549500924ec576f953d9fc/room-content/57d9956006c4a483fe336f82efb021fe.png"
     alt="Reconhecimento"
     width="200px" />

Após obter persistência e executar o malware na máquina da vítima, "Megatron" abre o canal C2 (Comando e Controle) através do malware para controlar e manipular remotamente a vítima. Este termo também é conhecido como C&C ou **C2 Beaconing** como um tipo de comunicação maliciosa entre um servidor C2 e o malware no host infectado. O host infectado se comunicará consistentemente com o servidor C2; é daí que também veio o termo *beaconing* (sinalização).

O endpoint comprometido se comunicaria com um servidor externo configurado por um invasor para estabelecer um canal de comando e controle. Após estabelecer a conexão, o invasor tem controle total da máquina da vítima. Até recentemente, o IRC (Internet Relay Chat) era o canal C2 tradicional usado por invasores. Este não é mais o caso, pois as soluções de segurança modernas podem detectar facilmente o tráfego IRC malicioso.

Os canais C2 mais comuns usados por adversários atualmente:

*   Os protocolos **HTTP na porta 80 e HTTPS na porta 443** - este tipo de *beaconing* mistura o tráfego malicioso com o tráfego legítimo e pode ajudar o invasor a evadir firewalls.
*   **DNS (Domain Name Server - Servidor de Nomes de Domínio).** A máquina infectada faz constantes requisições DNS ao servidor DNS que pertence a um invasor; este tipo de comunicação C2 também é conhecido como **DNS Tunneling (Tunelamento DNS)**.

É importante notar que um adversário ou outro host comprometido pode ser o proprietário da infraestrutura C2.

---
**Responda às perguntas abaixo:**

Qual é a comunicação C2 onde a vítima faz requisições DNS regulares a um servidor DNS e domínio que pertencem a um invasor?
R: DNS Tunneling