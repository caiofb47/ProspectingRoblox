#Requires AutoHotkey v2.0

; Author: Caiofb47.
; Description: Script para automatizar o processo de prospecting no jogo Prospecting.

; Tutorial:
; Se pozicionar o personagem corretamente, com o rio a sua esquerda e a área de mineração a sua direita.
; Pressione F1 para iniciar o ciclo completo (Modo Normal).
; Pressione F2 para iniciar o ciclo completo (Modo Rápido/2x).
; Pressione F4 para parar o script a qualquer momento.

; Pressione F5 para apenas COLETAR (usa config F1).
; Pressione F6 para apenas COLETAR (usa config F2).
; Pressione F8 para apenas LAVAR (usa config F1).

; =====================================================================
; --- Configurações Principais (Compartilhadas) ---
; =====================================================================
totalRepeticoes := 100      ; Quantas vezes o ciclo todo vai repetir
tempoAndarRio := 500       ; (ms) Tempo andando (A) para o RIO
tempoAndarTerra := 500     ; (ms) Tempo andando (D) para a TERRA
pausaEntreCliques := 1000   ; (ms) Pausa entre cada clique da PARTE 1
pausaAposEncher := 1000     ; (ms) Pausa após encher a bateia (antes de andar)
pausaAntesLavar := 500      ; (ms) Pausa entre o clique e segurar o clique (PARTE 3)
pausaAposLavar := 1000      ; (ms) Pausa após terminar de lavar (antes de andar)
pausaAntesRepetir := 500    ; (ms) Pausa final antes de recomeçar o ciclo
; =====================================================================


tempoCliqueAreiaPerfeito := 250 ; (ms) Tempo em para coleta de areia perfeita.

; ===================================================================== 
; --- Configuração Perfil 1 (F1) ---
cliquesParaEncher_F1 := 2
tempoLavarBateia_F1 := 5000

; --- Configuração Perfil 2 (F2) ---
cliquesParaEncher_F2 := 1
tempoLavarBateia_F2 := 3000
; =====================================================================


; =====================================================================
; --- TECLAS DE ATALHO (Hotkeys) ---
; =====================================================================

F1:: {
    ; Chama a função de ciclo com as configurações do PERFIL 1
    ExecutarCiclo(cliquesParaEncher_F1, tempoCliqueAreiaPerfeito, tempoLavarBateia_F1)
}

F2:: {
    ; Chama a MESMA função de ciclo, mas com as configurações do PERFIL 2
    ExecutarCiclo(cliquesParaEncher_F2, tempoCliqueAreiaPerfeito, tempoLavarBateia_F2)
}

; --- TECLA DE FIM (F4) ---
F4:: {
    Reload() ; Para e recarrega o script
}

; --- AÇÃO ÚNICA: Coletar (F5) ---
F5:: {
    ; Coleta areia UMA VEZ usando o perfil F1
    ColetarAreia(cliquesParaEncher_F1, tempoCliqueAreiaPerfeito)
    return
}

; --- AÇÃO ÚNICA: Coletar (F6) ---
F6:: {
    ; Coleta areia UMA VEZ usando o perfil F2
    ColetarAreia(cliquesParaEncher_F2, tempoCliqueAreiaPerfeito)
    return
}

; --- AÇÃO ÚNICA: Lavar (F8) ---
F8:: {
    ; Lava a bateia UMA VEZ usando o perfil F1
    LavarBateia(tempoLavarBateia_F1)
    return
}


; =====================================================================
; --- BLOCOS DE AÇÃO (Novas Funções) ---
; =====================================================================

; --- PARTE 1: Função de Coletar Areia ---
ColetarAreia(numCliques, tempoClique) {
    Loop numCliques {
        Send "{LButton down}"
        Sleep(tempoClique)
        Send "{LButton up}"
        Sleep(pausaEntreCliques)
    }
}

; --- PARTE 3: Função de Lavar a Bateia ---
LavarBateia(tempoLavagem) {
    Click() ; 1 clique inicial para ativar
    Sleep(pausaAntesLavar)
    Send "{LButton down}" ; Segura o clique para lavar
    Sleep(tempoLavagem)
    Send "{LButton up}"
}


; =====================================================================
; --- FUNÇÃO PRINCIPAL (A lógica do script fica aqui) ---
; =====================================================================

ExecutarCiclo(numCliques, tempoClique, tempoLavagem) {
    
    ; --- LOOP PRINCIPAL: Repete o ciclo X vezes ---
    Loop totalRepeticoes {
        
        ; --- PARTE 1: Enchendo a bateia com areia ---
        ColetarAreia(numCliques, tempoClique) ; <-- CHAMA A FUNÇÃO
        
        Sleep(pausaAposEncher) ; Pausa extra após encher

        ; --- PARTE 2: Andar para a esquerda (A) - Indo para o rio ---
        Send "{a down}"
        Sleep(tempoAndarRio)
        Send "{a up}"

        ; --- PARTE 3: Limpando a bateia no rio ---
        LavarBateia(tempoLavagem) ; <-- CHAMA A FUNÇÃO

        Sleep(pausaAposLavar) ; Pausa após lavar
        
        ; --- PARTE 4: Andar para a direita (D) - Voltando a terra ---
        Send "{d down}"
        Sleep(tempoAndarTerra)
        Send "{d up}"
        
        Sleep(pausaAntesRepetir) ; Pausa antes de recomeçar o loop
        
    } ; Fim do loop principal
    
    return
}