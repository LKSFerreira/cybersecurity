## Engenharia Social

### O que é Engenharia Social?

**Engenharia Social** é o termo usado para descrever qualquer ciberataque onde um humano (em vez de um computador) é o alvo; por essa razão, às vezes é referida como "*People Hacking*" (Hacking de Pessoas). Por exemplo, se um invasor deseja obter a senha de uma vítima, ele poderia tentar adivinhar ou fazer *brute-force* da senha — ou poderia simplesmente perguntar a você.

<img src="https://tryhackme-images.s3.amazonaws.com/user-uploads/5d9e176315f8850e719252ed/room-content/4044940b5b0b6596cba1851545b759d0.png" width="200px" />

> *Imagem decorativa de um hacker com um telefone e um computador*

Embora o exemplo acima seja relativamente direto, os ataques de engenharia social podem se tornar muito complexos e muitas vezes resultam em um invasor ganhando controle significativo sobre a vida de um alvo — tanto online quanto offline. Os ataques de engenharia social são frequentemente multicamadas e escalam devido ao efeito bola de neve. Por exemplo, um invasor pode começar obtendo uma pequena quantidade de informações publicamente disponíveis da presença de uma vítima nas redes sociais, que ele poderia então usar para obter mais informações, digamos, do seu provedor de telefone ou banda larga. A informação obtida na segunda etapa poderia então ser usada para obter informações mais úteis, e então escalar passo a passo para algo como a conta bancária da vítima.

A melhor maneira de entender a engenharia social é vê-la em ação! Estes vídeos da Defcon23 (uma das maiores conferências de hacking do mundo) e da CNN demonstram parte do imenso poder da engenharia social. Ambos valem muito a pena assistir!

### Outras Formas de Engenharia Social

Hackers carismáticos ligando para sua companhia telefônica e tomando posse de sua conta é uma forma de engenharia social; no entanto, existem muitos outros tipos. A engenharia social é um tópico vasto, abrangendo qualquer ataque que se baseia em enganar humanos para dar acesso ao invasor, em vez de atacar a tecnologia diretamente. Embora a interação direta com os alvos seja o estilo mais comum de engenharia social, outros exemplos incluem deixar dispositivos de armazenamento USB em locais públicos (por exemplo, em estacionamentos de empresas) na esperança de que alguém (muitas vezes um funcionário da empresa) pegue um e o conecte a um computador sensível. De forma semelhante, os invasores podem deixar um "cabo de carregamento" conectado a uma tomada em um local público. Na realidade, o cabo contém software malicioso, como *keyloggers* ou ferramentas para assumir o controle do dispositivo da vítima.

<details>
  <summary><b>Estudo de Caso: Stuxnet (Clique para Ler)</b></summary>
  
  Stuxnet foi o nome dado a um vírus de computador particularmente desagradável (supostamente desenvolvido pelos governos dos Estados Unidos e de Israel) que foi originalmente usado para atingir o programa nuclear do Irã em 2009. Devido à sua capacidade como um "worm" de se autorreplicar (ou seja, clonar-se através de redes — incluindo a internet), o vírus escapou e se tornou muito mais difundido do que o pretendido. Múltiplas variantes agora também existem, tornando o Stuxnet uma arma particularmente impactante e notória. Você pode ler mais sobre o histórico do Stuxnet [aqui](https://www.wired.com/2014/11/countdown-to-zero-day-stuxnet/).
  
  O que torna o Stuxnet particularmente interessante para esta seção é o método original de infecção. O vírus pode se clonar através de redes, mas isso não ajuda muito quando a rede alvo é uma instalação de desenvolvimento de armas nucleares sem acesso à internet mais ampla. A questão se tornou: como você pode colocar um vírus em uma rede que não permite que nada entre ou saia? A resposta foi simples: deixar dispositivos USB maliciosos em locais onde trabalhadores de empresas que lidavam com a instalação os encontrariam e esperar que um deles conectasse o dispositivo a um computador de trabalho. Neste caso, a aposta funcionou, com o Stuxnet causando danos severos ao programa nuclear do Irã e destruindo efetivamente muitas das centrífugas nucleares.
</details>

Em suma, os limites da engenharia social estão nos limites da imaginação de um invasor. Um bom engenheiro social pode (e irá) usar uma infinidade de truques psicológicos sob qualquer contexto plausível para "hackear" seus alvos.

### Mantendo-se Seguro contra Ataques de Engenharia Social

De muitas maneiras, é muito complicado se manter seguro contra a engenharia social, pois nem sempre será com você que o invasor estará falando, mas sim com alguém que pode dar a ele o que ele precisa sem o seu consentimento (por exemplo, ligar para o seu banco fingindo ser você, para acessar sua conta bancária). Dito isso, ainda existem medidas que você pode tomar para se proteger de ataques de Engenharia Social:

*   Sempre certifique-se de configurar múltiplas formas de autenticação e garanta que os provedores as respeitem. Por exemplo, defina respostas difíceis de adivinhar — ou incorretas — para perguntas de segurança (certificando-se de guardar as respostas em um lugar seguro!), e certifique-se de que essas perguntas sejam feitas quando você tentar acessar contas por telefone.
*   Nunca conecte mídias externas (por exemplo, USBs/CDs/etc) em um computador com o qual você se importa ou que esteja conectado a quaisquer outros dispositivos. Idealmente, não conecte a mídia de forma alguma e, em vez disso, entregue-a à sua polícia local para custódia.
*   Sempre insista em uma prova de identidade quando um estranho ligar ou enviar uma mensagem para você, alegando trabalhar para uma empresa cujos serviços você usa. Onde possível, confirme com um número de telefone ou endereço de e-mail conhecido que a chamada ou mensagem que você recebeu era legítima (ou seja, use um método confiável para entrar em contato com a empresa para confirmar). Lembre-se de que nenhum funcionário legítimo jamais pedirá sua senha ou outras informações que protegem sua conta.

---
**Responda às perguntas abaixo:**

Leia as informações da tarefa e assista aos vídeos anexados.
<details>
  <summary>Clique para ver a resposta</summary>
  Nenhuma resposta necessária
</details>

Qual era o alvo original do Stuxnet?
<details>
  <summary>Clique para ver a resposta</summary>
  Iran nuclear programme
</details>