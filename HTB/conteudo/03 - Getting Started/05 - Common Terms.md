## Termos Comuns

Testes de invasão (penetration testing)/hacking é um campo enorme. Encontraremos inúmeras tecnologias ao longo de nossas carreiras. Aqui estão alguns dos termos e tecnologias mais comuns que encontraremos repetidamente e dos quais devemos ter um firme entendimento. Esta não é uma lista exaustiva, mas é suficiente para começar com Módulos fundamentais e boxes fáceis do HTB.

### O que é um Shell?

**Shell** é um termo muito comum que ouviremos repetidamente durante nossa jornada. Ele tem alguns significados. Em um sistema Linux, o shell é um programa que recebe entradas do usuário via teclado e passa esses comandos para o sistema operacional para executar uma função específica. Nos primórdios da computação, o shell era a única interface disponível para interagir com os sistemas. Desde então, muitos outros tipos e versões de sistemas operacionais surgiram, juntamente com a interface gráfica do usuário (GUI), para complementar as interfaces de linha de comando (shell), como o terminal Linux, a linha de comando do Windows (`cmd.exe`) e o Windows PowerShell.

A maioria dos sistemas Linux usa um programa chamado **Bash** (Bourne Again Shell) como programa de shell para interagir com o sistema operacional. O Bash é uma versão aprimorada do `sh`, o programa de shell original dos sistemas Unix. Além do bash, existem também outros shells, incluindo, mas não se limitando a, Zsh, Tcsh, Ksh, Fish shell, etc.

Frequentemente leremos ou ouviremos outros falando sobre "obter um shell" em uma box (sistema). Isso significa que o host alvo foi explorado, e obtivemos acesso em nível de shell (tipicamente bash ou sh) e podemos executar comandos interativamente como se estivéssemos logados no host. Um shell pode ser obtido explorando uma aplicação web ou uma vulnerabilidade de rede/serviço, ou obtendo credenciais e fazendo login remotamente no host alvo. Existem três tipos principais de conexões de shell:

| Tipo de Shell     | Descrição                                                                                                                                                            |
| :---------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Reverse shell** | Inicia uma conexão de volta para um "ouvinte" (listener) em nossa máquina de ataque.                                                                                     |
| **Bind shell**    | "Vincula-se" (binds) a uma porta específica no host alvo e espera por uma conexão de nossa máquina de ataque.                                                              |
| **Web shell**     | Executa comandos do sistema operacional através do navegador web, tipicamente não interativo ou semi-interativo. Também pode ser usado para executar comandos únicos (ou seja, aproveitando uma vulnerabilidade de upload de arquivo e enviando um script PHP para executar um único comando). |

Cada tipo de shell tem seu caso de uso, e da mesma forma que existem muitas maneiras de obter um shell, o programa auxiliar que usamos para obter um shell pode ser escrito em muitas linguagens (Python, Perl, Go, Bash, Java, awk, PHP, etc.). Estes podem ser pequenos scripts ou programas maiores e mais complexos para facilitar uma conexão do host alvo de volta ao nosso sistema de ataque e obter acesso de "shell". O acesso de shell será discutido em profundidade em uma seção posterior.

### O que é uma Porta?

Uma **porta** pode ser pensada como uma janela ou porta em uma casa (sendo a casa um sistema remoto); se uma janela ou porta for deixada aberta ou não for trancada corretamente, muitas vezes podemos obter acesso não autorizado a uma casa. Isso é semelhante na computação. As portas são pontos virtuais onde as conexões de rede começam e terminam. Elas são baseadas em software e gerenciadas pelo sistema operacional do host. As portas estão associadas a um processo ou serviço específico e permitem que os computadores diferenciem entre diferentes tipos de tráfego (o tráfego SSH flui para uma porta diferente das requisições web para acessar um site, embora as requisições de acesso sejam enviadas pela mesma conexão de rede).

Cada porta recebe um número, e muitas são padronizadas em todos os dispositivos conectados à rede (embora um serviço possa ser configurado para rodar em uma porta não padrão). Por exemplo, mensagens HTTP (tráfego de site) normalmente vão para a porta 80, enquanto mensagens HTTPS vão para a porta 443, a menos que configurado de outra forma. Encontraremos aplicações web rodando em portas não padrão, mas tipicamente as encontraremos nas portas 80 e 443. Os números de porta nos permitem acessar serviços ou aplicações específicas rodando nos dispositivos alvo. Em um nível muito alto, as portas ajudam os computadores a entender como lidar com os vários tipos de dados que recebem.

Existem duas categorias de portas, **Protocolo de Controle de Transmissão (TCP)** e **Protocolo de Datagrama do Usuário (UDP)**.
*   **TCP** é orientado à conexão, o que significa que uma conexão entre um cliente e um servidor deve ser estabelecida antes que os dados possam ser enviados. O servidor deve estar em um estado de escuta (listening) aguardando solicitações de conexão dos clientes.
*   **UDP** utiliza um modelo de comunicação sem conexão. Não há "handshake" e, portanto, introduz uma certa quantidade de falta de confiabilidade, pois não há garantia de entrega de dados. O UDP é útil quando a correção/verificação de erros não é necessária ou é tratada pela própria aplicação. O UDP é adequado para aplicações que executam tarefas sensíveis ao tempo, pois descartar pacotes é mais rápido do que esperar por pacotes atrasados devido à retransmissão, como é o caso do TCP, e pode afetar significativamente um sistema em tempo real.

Existem 65.535 portas TCP e 65.535 portas UDP diferentes, cada uma denotada por um número. Algumas das portas TCP e UDP mais conhecidas estão listadas abaixo:

| Porta(s)      | Protocolo          |
| :------------ | :----------------- |
| 20/21 (TCP)   | FTP                |
| 22 (TCP)      | SSH                |
| 23 (TCP)      | Telnet             |
| 25 (TCP)      | SMTP               |
| 80 (TCP)      | HTTP               |
| 161 (TCP/UDP) | SNMP               |
| 389 (TCP/UDP) | LDAP               |
| 443 (TCP)     | SSL/TLS (HTTPS)    |
| 445 (TCP)     | SMB                |
| 3389 (TCP)    | RDP                |

Como profissionais de segurança da informação, devemos ser capazes de recordar rapidamente grandes quantidades de informações sobre uma ampla variedade de tópicos. É essencial para nós, especialmente como pentesters, ter um firme entendimento de muitas portas TCP e UDP e ser capaz de reconhecê-las rapidamente apenas pelo seu número (ou seja, saber que a porta 21 é FTP, a porta 80 é HTTP, a porta 88 é Kerberos) sem ter que procurar. Isso virá com a prática e a repetição e, eventualmente, se tornará uma segunda natureza à medida que atacamos mais boxes, labs e redes do mundo real, e nos ajudará a trabalhar com mais eficiência e a priorizar melhor nossos esforços de enumeração e ataques.

Guias como [este](https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xhtml) e [este](https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers) são ótimos recursos para aprender portas TCP e UDP padrão e menos comuns. Desafie-se a memorizar o máximo possível delas e pesquise sobre cada um dos protocolos listados na tabela acima. Esta é uma ótima referência sobre as [1.000 principais portas TCP e UDP do nmap](https://nmap.org/book/nmap-services.html), juntamente com os 100 principais serviços escaneados pelo nmap.

### O que é um Servidor Web

Um **servidor web** é uma aplicação que roda no servidor de back-end, que lida com todo o tráfego HTTP do navegador do lado do cliente, o roteia para as páginas de destino das requisições e, finalmente, responde ao navegador do lado do cliente. Os servidores web geralmente rodam nas portas TCP 80 ou 443 e são responsáveis por conectar os usuários finais a várias partes da aplicação web, além de lidar com suas várias respostas:
![Dashboard](https://academy.hackthebox.com/storage/modules/77/htb_main_2.jpg)
> *Dashboard mostrando 914 jogadores online, 1020 "machine owns", 618 "challenge owns" e atividade recente com os alvos Active, Lame e Beep.*

Como as aplicações web tendem a estar abertas para interação pública e voltadas para a internet, elas podem levar ao comprometimento do servidor de back-end se sofrerem de alguma vulnerabilidade. As aplicações web podem fornecer uma vasta superfície de ataque, tornando-as um alvo de alto valor para atacantes e pentesters.

Existem muitos tipos de vulnerabilidades que podem afetar as aplicações web. Frequentemente ouviremos/veremos referências ao **OWASP Top 10**. Esta é uma lista padronizada das 10 principais vulnerabilidades de aplicações web mantida pelo Open Web Application Security Project (OWASP). Esta lista é considerada as 10 vulnerabilidades mais perigosas e não é uma lista exaustiva de todas as possíveis vulnerabilidades de aplicações web. As metodologias de avaliação de segurança de aplicações web são frequentemente baseadas no OWASP Top 10 como ponto de partida para as principais categorias de falhas que um avaliador deve verificar. A lista atual do OWASP Top 10 é:

| Número | Categoria                                  | Descrição                                                                                                                                                                                                                                                                                        |
| :----- | :----------------------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1.     | Controle de Acesso Quebrado                | Restrições não são implementadas adequadamente para impedir que usuários acessem contas de outros usuários, visualizem dados sensíveis, acessem funcionalidades não autorizadas, modifiquem dados, etc.                                                                                              |
| 2.     | Falhas Criptográficas                      | Falhas relacionadas à criptografia que muitas vezes levam à exposição de dados sensíveis ou ao comprometimento do sistema.                                                                                                                                                                       |
| 3.     | Injeção                                    | Dados fornecidos pelo usuário não são validados, filtrados ou sanitizados pela aplicação. Alguns exemplos de injeção são injeção de SQL, injeção de comando, injeção de LDAP, etc.                                                                                                                   |
| 4.     | Design Inseguro                            | Esses problemas acontecem quando a aplicação não é projetada com a segurança em mente.                                                                                                                                                                                                             |
| 5.     | Configuração Incorreta de Segurança        | Falta de endurecimento (hardening) de segurança apropriado em qualquer parte da pilha de aplicações, configurações padrão inseguras, armazenamento em nuvem aberto, mensagens de erro verbosas que divulgam muitas informações.                                                                       |
| 6.     | Componentes Vulneráveis e Desatualizados   | Usar componentes (tanto do lado do cliente quanto do lado do servidor) que são vulneráveis, não suportados ou desatualizados.                                                                                                                                                                     |
| 7.     | Falhas de Identificação e Autenticação     | Ataques relacionados à autenticação que visam a identidade do usuário, autenticação e gerenciamento de sessão.                                                                                                                                                                                    |
| 8.     | Falhas de Integridade de Software e Dados  | Falhas de integridade de software e dados se relacionam a código e infraestrutura que não protegem contra violações de integridade. Um exemplo disso é quando uma aplicação depende de plugins, bibliotecas ou módulos de fontes, repositórios e redes de distribuição de conteúdo (CDNs) não confiáveis. |
| 9.     | Falhas de Logging e Monitoramento de Segurança | Esta categoria visa ajudar a detectar, escalar e responder a violações ativas. Sem logging e monitoramento, as violações não podem ser detectadas.                                                                                                                                                |
| 10.    | Server-Side Request Forgery (SSRF)         | Falhas de SSRF ocorrem sempre que uma aplicação web está buscando um recurso remoto sem validar a URL fornecida pelo usuário. Permite que um atacante coaja a aplicação a enviar uma requisição criada para um destino inesperado, mesmo quando protegido por um firewall, VPN ou outro tipo de lista de controle de acesso (ACL) de rede. |

É essencial familiarizar-se com cada uma dessas categorias e as várias vulnerabilidades que se encaixam em cada uma. As vulnerabilidades de aplicações web serão abordadas em profundidade em módulos posteriores. Para saber mais sobre aplicações web, confira o módulo [Introdução a Aplicações Web](https://academy.hackthebox.com/module/details/75).