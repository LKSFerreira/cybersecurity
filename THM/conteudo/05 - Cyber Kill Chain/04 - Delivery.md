## Entrega (Delivery)

<img src="https://tryhackme-images.s3.amazonaws.com/user-uploads/5c549500924ec576f953d9fc/room-content/a984f5db347f07a8f754014d71479eaf.png"
     alt="Reconhecimento"
     width="200px" />

A fase de Entrega é quando "Megatron" decide escolher o método para transmitir o payload ou o malware. Ele tem muitas opções para escolher:

*   **E-mail de phishing:** após conduzir o reconhecimento e determinar os alvos para o ataque, o ator malicioso criaria um e-mail malicioso que visaria uma pessoa específica (ataque de spearphishing) ou várias pessoas na empresa. O e-mail conteria um payload ou malware. Por exemplo, "Megatron" descobriria que Nancy, do departamento de Vendas da empresa A, curte constantemente as postagens no LinkedIn de Scott, um Gerente de Entrega de Serviços da empresa B. Ele suspeitaria que ambos se comunicam por e-mails de trabalho. "Megatron" criaria um e-mail usando o Nome e Sobrenome de Scott, fazendo o domínio parecer semelhante ao da empresa onde Scott trabalha. Um invasor então enviaria um e-mail falso de "Fatura" para Nancy, que contém o payload.
*   **Distribuir unidades USB infectadas** em locais públicos como cafeterias, estacionamentos ou na rua. Um invasor pode decidir conduzir um sofisticado Ataque de Queda de USB (USB Drop Attack) imprimindo o logotipo da empresa nas unidades USB e enviando-as para a empresa, fingindo ser um cliente enviando os dispositivos USB como um presente. Você pode ler sobre um desses ataques semelhantes no [CSO Online "Grupo cibercriminoso envia dongles USB maliciosos para empresas-alvo."](https://www.csoonline.com/article/567083/cybercriminal-group-mails-malicious-usb-dongles-to-targeted-companies.html)
*   **Ataque de Watering Hole.** Um ataque de watering hole é um ataque direcionado projetado para atingir um grupo específico de pessoas, comprometendo o site que elas costumam visitar e, em seguida, redirecionando-as para o site malicioso de escolha do invasor. O invasor procuraria uma vulnerabilidade conhecida no site e tentaria explorá-la. O invasor incentivaria as vítimas a visitar o site enviando e-mails "inofensivos" apontando para a URL maliciosa para tornar o ataque mais eficiente. Após visitar o site, a vítima baixaria involuntariamente malware ou uma aplicação maliciosa para seu computador. Esse tipo de ataque é chamado de **drive-by download**. Um exemplo pode ser um pop-up malicioso pedindo para baixar uma extensão de navegador falsa.

---
**Responda às perguntas abaixo:**

Qual é o nome do ataque quando ele é realizado contra um grupo específico de pessoas, e o invasor busca infectar o site que o mencionado grupo de pessoas visita constantemente?
R: Watering hole attack