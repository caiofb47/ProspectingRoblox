#Requires AutoHotkey v2.0

; Author: Caiofb47.
; Description: Script para automatizar o processo de prospecting no jogo Prospecting.

; Tutorial: Ative a trava de shift (Shift Lock) no jogo para facilitar o movimento.
; Se pozicionar o personagem corretamente, com o rio a sua esquerda e a área de mineração a sua direita.
; Pressione F1 para iniciar o script (Modo Normal).
; Pressione F2 para iniciar o script (Modo Rápido/2x).
; Pressione F4 para parar o script a qualquer momento.

; =====================================================================
; --- Configurações Principais (Compartilhadas) ---
; =====================================================================
totalRepeticoes := 100      ; Quantas vezes o ciclo todo vai repetir
tempoAndarRio := 1000       ; (ms) Tempo andando (A) para o RIO
tempoAndarTerra := 1000     ; (ms) Tempo andando (D) para a TERRA
pausaEntreCliques := 1000   ; (ms) Pausa entre cada clique da PARTE 1
pausaAposEncher := 1000     ; (ms) Pausa após encher a bateia (antes de andar)
pausaAntesLavar := 500      ; (ms) Pausa entre o clique e segurar o clique (PARTE 3)
pausaAposLavar := 1000      ; (ms) Pausa após terminar de lavar (antes de andar)
pausaAntesRepetir := 500    ; (ms) Pausa final antes de recomeçar o ciclo
; =====================================================================


; ===================================================================== 
; --- Configuração Perfil 1 (F1) ---
cliquesParaEncher_F1 := 5
tempoCliqueAreia_F1 := 600
tempoLavarBateia_F1 := 10000
; =====================================================================

; ===================================================================== 
; --- Configuração Perfil 2 (F2) ---
cliquesParaEncher_F2 := 5
tempoCliqueAreia_F2 := 600
tempoLavarBateia_F2 := 10000
; =====================================================================


; =====================================================================
; --- TECLAS DE ATALHO (Hotkeys) ---
; =====================================================================

F1:: {
    ; Chama a função principal com as configurações do PERFIL 1
    ExecutarCiclo(cliquesParaEncher_F1, tempoCliqueAreia_F1, tempoLavarBateia_F1)
}

F2:: {
    ; Chama a MESMA função principal, mas com as configurações do PERFIL 2
    ExecutarCiclo(cliquesParaEncher_F2, tempoCliqueAreia_F2, tempoLavarBateia_F2)
}

; --- TECLA DE FIM (F4) ---
F4:: {
    Reload() ; Para e recarrega o script
}


; =====================================================================
; --- FUNÇÃO PRINCIPAL (A lógica do script fica aqui) ---
; =====================================================================

ExecutarCiclo(numCliques, tempoClique, tempoLavagem) {
    
    ; --- LOOP PRINCIPAL: Repete o ciclo X vezes ---
    Loop totalRepeticoes {
        
        ; --- PARTE 1: Enchendo a bateia com areia ---
        Loop numCliques { ; <-- Usa a variável da função
            Send "{LButton down}"
            Sleep(tempoClique) ; <-- Usa a variável da função
            Send "{LButton up}"
            Sleep(pausaEntreCliques)
        }
        
        Sleep(pausaAposEncher) ; Pausa extra após encher

        ; --- PARTE 2: Andar para a esquerda (A) - Indo para o rio ---
        Send "{a down}"
        Sleep(tempoAndarRio)
        Send "{a up}"

        ; --- PARTE 3: Limpando a bateia no rio ---
        Click() ; 1 clique inicial para ativar
        Sleep(pausaAntesLavar)
        Send "{LButton down}" ; Segura o clique para lavar
        Sleep(tempoLavagem) ; <-- Usa a variável da função
        Send "{LButton up}"

        Sleep(pausaAposLavar) ; Pausa após lavar
        
        ; --- PARTE 4: Andar para a direita (D) - Voltando a terra ---
        Send "{d down}"
        Sleep(tempoAndarTerra)
        Send "{d up}"
        
        Sleep(pausaAntesRepetir) ; Pausa antes de recomeçar o loop
        
    } ; Fim do loop principal
    
    return
}