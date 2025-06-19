# Checklist de Reconhecimento Inicial (Fase de 10 Minutos)

Este checklist descreve o processo de reconhecimento passivo e semi-passivo para uma aplicação web. O objetivo é coletar o máximo de informações sobre a tecnologia, estrutura e potenciais pontos fracos do alvo no menor tempo possível, sem lançar ataques ativos ou gerar ruído excessivo.

---

### 1. Análise da URL e Tecnologia Visível

*   **O que é?** A primeira observação da estrutura da URL da página principal.
*   **Por que é importante?** Revela imediatamente a tecnologia de backend principal, guiando nossas futuras hipóteses de vulnerabilidades.
*   **Como fazer?** Olhe para a barra de endereço do navegador.
    *   **Exemplo Real:** A URL termina em `index.php`.
    *   **Conclusão:** A aplicação é construída em PHP. Nossos testes devem incluir vulnerabilidades comuns em PHP (ex: Inclusão de Arquivos, desserialização, etc.).

### 2. Verificação do `robots.txt`

*   **O que é?** Um arquivo de texto que instrui robôs de busca sobre quais diretórios não devem ser indexados.
*   **Por que é importante?** Funciona como um mapa involuntário, muitas vezes listando caminhos para painéis administrativos, seções de API ou outros diretórios que não estão linkados na página principal.
*   **Como fazer?** Navegue diretamente para `https://{url_do_alvo}/robots.txt`. Se o arquivo existir, anote todos os caminhos listados em `Disallow:`.

### 3. Inspeção do Código-Fonte (HTML)

*   **O que é?** A análise do código HTML que o servidor envia para o seu navegador.
*   **Por que é importante?** Desenvolvedores frequentemente deixam informações valiosas "escondidas" à vista de todos.
*   **Como fazer?** Pressione `Ctrl+U` (ou clique com o botão direito -> "Exibir código-fonte da página"). Procure por:
    *   **Comentários (`<!-- ... -->`):** Podem conter notas, nomes de desenvolvedores, endpoints antigos ou lógica de negócios.
    *   **Links para arquivos JavaScript (`<script src="..."></script>`):** Anote os nomes dos arquivos `.js`. Eles contêm a lógica do lado do cliente e podem revelar endpoints de API que a interface não mostra.
    *   **Campos de formulário ocultos (`<input type="hidden">`):** Podem conter dados que a aplicação usa e que talvez possamos manipular.

### 4. Análise dos Cabeçalhos HTTP

*   **O que é?** A verificação dos metadados que acompanham a comunicação entre o navegador e o servidor.
*   **Por que é importante?** Fornece informações detalhadas sobre a infraestrutura do servidor, como o sistema operacional e versões de software, que podem ser usadas para encontrar vulnerabilidades conhecidas (CVEs).
*   **Como fazer?**
    1.  Pressione `F12` para abrir as Ferramentas de Desenvolvedor.
    2.  Vá para a aba **Network (Rede)**.
    3.  Recarregue a página (F5).
    4.  Clique na primeira requisição (ex: `index.php`).
    5.  Na janela de detalhes, procure pela seção **Response Headers (Cabeçalhos de Resposta)**.
    *   **Exemplo Real:** O cabeçalho `Server: Apache/2.4.7 (Ubuntu)` foi encontrado.
    *   **Conclusão:** Sabemos a versão exata do servidor web e o sistema operacional.

### 5. Análise de Cookies

*   **O que é?** A inspeção dos pequenos arquivos de dados que o site armazena no seu navegador para gerenciar a sessão.
*   **Por que é importante?** Cookies podem conter informações além de um simples ID de sessão. Às vezes, dados como nomes de usuário ou permissões (`role=user`) são armazenados no cookie, talvez codificados (ex: Base64). Manipular esses dados pode levar a escalação de privilégios.
*   **Como fazer?**
    1.  Pressione `F12`.
    2.  Vá para a aba **Application (Aplicação)** no Chrome/Edge ou **Storage (Armazenamento)** no Firefox.
    3.  No menu à esquerda, expanda a seção "Cookies" e selecione o domínio do site.

### 6. Tentativa de Acesso a Arquivos Comuns

*   **O que é?** Um teste rápido para ver se arquivos ou diretórios administrativos comuns e sensíveis estão acessíveis, mesmo que não estejam linkados.
*   **Por que é importante?** Uma configuração incorreta do servidor pode deixar páginas de administração, logs ou backups expostos publicamente.
*   **Como fazer?** Tente navegar diretamente para URLs comuns.
    *   **Exemplo Real:** Tentar acessar `https://{url_do_alvo}/admin.php`.
    *   **Conclusão:** O resultado foi `404 Not Found`, o que é bom para a segurança do site, mas o teste em si é uma etapa essencial do processo. Outros exemplos para testar incluem `/admin/`, `/login.php`, `/config.php`.

### 7. Mapeamento dos Pontos de Entrada

*   **O que é?** A identificação de todas as funcionalidades da aplicação que aceitam entrada do usuário.
*   **Por que é importante?** Este é o resultado final da nossa análise inicial. Ele define a nossa "superfície de ataque" e nos diz onde vamos focar nossos próximos esforços.
*   **Como fazer?** Com base em tudo que vimos, liste as funcionalidades interativas.
    *   **Exemplo Real:** A página possui os botões "Sign in" e "Sign up".
    *   **Conclusão:** Nossos próximos alvos são os formulários de criação de conta e de login. Eles são os principais pontos de entrada para a aplicação.

---

### Resumo e Próximos Passos

Após esta análise de 10 minutos, temos um perfil claro do nosso alvo: uma aplicação **PHP** rodando em um servidor **Apache/2.4.7 (Ubuntu)**, com os principais pontos de entrada sendo os formulários de **registro e login**. O próximo passo lógico é interagir com esses formulários, criando uma conta e observando detalhadamente o processo para encontrar a primeira de sete flags.