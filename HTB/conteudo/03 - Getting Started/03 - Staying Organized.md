## Mantendo a Organização (Staying Organized)

Seja realizando avaliações para clientes, jogando CTFs, fazendo um curso na Academy ou em outro lugar, ou resolvendo boxes/labs do HTB, a organização é sempre crucial. É essencial priorizar uma documentação clara e precisa desde o início. Essa habilidade nos beneficiará não importa o caminho que sigamos em segurança da informação ou mesmo em outras carreiras.

### Estrutura de Pastas

Ao atacar uma única box, lab ou ambiente de cliente, devemos ter uma estrutura de pastas clara em nossa máquina de ataque para salvar dados como: informações de escopo (scoping), dados de enumeração, evidências de tentativas de exploração, dados sensíveis como credenciais, e outros dados obtidos durante o reconhecimento (recon), exploração e pós-exploração. Uma estrutura de pastas de exemplo pode se parecer com o seguinte:

  Mantendo a Organização
```bash
lksferreira@htb[/htb]$ tree Projects/

Projects/
└── Acme Company
    ├── EPT
    │   ├── evidence
    │   │   ├── credentials
    │   │   ├── data
    │   │   └── screenshots
    │   ├── logs
    │   ├── scans
    │   ├── scope
    │   └── tools
    └── IPT
        ├── evidence
        │   ├── credentials
        │   ├── data
        │   └── screenshots
        ├── logs
        ├── scans
        ├── scope
        └── tools
```

Aqui temos uma pasta para o cliente Acme Company com duas avaliações, Teste de Invasão Interno (IPT - Internal Penetration Test) e Teste de Invasão Externo (EPT - External Penetration Test). Sob cada pasta, temos subpastas para salvar dados de varredura (scans), quaisquer ferramentas relevantes, saídas de log, informações de escopo (ou seja, listas de IPs/redes para alimentar nossas ferramentas de varredura) e uma pasta de evidências que pode conter quaisquer credenciais recuperadas durante a avaliação, quaisquer dados relevantes recuperados, bem como capturas de tela (screenshots).

É uma preferência pessoal, mas algumas pessoas criam uma pasta para cada host alvo e salvam as capturas de tela dentro dela. Outras organizam suas anotações por host ou rede e salvam as capturas de tela diretamente na ferramenta de anotações. Experimente com estruturas de pastas e veja o que funciona melhor para você se manter organizado e trabalhar com mais eficiência.

### Ferramentas de Anotação

Produtividade e organização são muito importantes. Um pentester muito técnico, mas desorganizado, terá dificuldade em ter sucesso nesta indústria. Várias ferramentas podem ser usadas para organização e anotações. A seleção de uma ferramenta de anotação é muito individual. Alguns de nós podem não precisar de um recurso que outra pessoa requer com base em seu fluxo de trabalho. Algumas ótimas opções para explorar incluem:

|                |                      |            |
| :------------- | :------------------- | :--------- |
| Cherrytree     | Visual Studio Code   | Evernote   |
| Notion         | GitBook              | Sublime Text |
| Notepad++      |                      |            |

Algumas delas são mais focadas em anotações, enquanto outras, como Notion e GitBook, têm recursos mais ricos que podem ser usados para criar páginas do tipo Wiki, folhas de consulta (cheat sheets) e muito mais. É importante garantir que quaisquer dados de clientes sejam armazenados apenas localmente e não sincronizados com a nuvem se estiver usando uma dessas ferramentas em avaliações do mundo real.

> **Dica:** Aprender a linguagem Markdown é fácil e muito útil para fazer anotações, pois pode ser facilmente representada de uma forma visualmente atraente e organizada.

### Outras Ferramentas e Dicas

Todo profissional de infosec deve manter uma base de conhecimento. Isso pode ser no formato de sua escolha (embora as ferramentas acima sejam recomendadas). Esta base de conhecimento deve conter guias de referência rápida para tarefas de configuração que realizamos na maioria das avaliações e folhas de consulta (cheat sheets) para comandos comuns que usamos para cada fase de uma avaliação.

À medida que completamos boxes, labs, avaliações, cursos de treinamento, etc., devemos agregar cada payload, comando, dica, pois nunca sabemos quando um deles pode ser útil. Tê-los acessíveis aumentará nossa eficiência e produtividade geral. Cada Módulo da HTB Academy possui uma folha de consulta de comandos relevantes apresentados nas seções do Módulo, que você pode baixar e guardar para referência futura.

Também devemos manter checklists, modelos de relatório para vários tipos de avaliação e construir um banco de dados de achados/vulnerabilidades. Este banco de dados pode assumir a forma de uma planilha ou algo mais complexo e incluir um título do achado, descrição, impacto, conselhos de remediação e referências. Ter esses achados já escritos nos economizará um tempo considerável e retrabalho durante a fase de relatório, pois a maior parte dos achados já estará escrita e provavelmente exigirá apenas alguma personalização para o ambiente alvo.

### Seguindo em Frente

Experimente várias ferramentas de anotação e desenvolva a estrutura de pastas que funciona para você e corresponde à sua metodologia. Comece cedo, para que isso se torne um hábito! O walkthrough da máquina Nibbles mais adiante neste Módulo é uma excelente oportunidade para praticar nossa documentação. Além disso, este Módulo contém muitos comandos que são úteis para adicionar à nossa folha de consulta de comandos comuns.
