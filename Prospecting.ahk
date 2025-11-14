#Requires AutoHotkey v2.0
; Por Caiofb47 xD
; =====================================================================
; --- CONFIGURAÇÕES (Ajuste os valores aqui) ---
; =====================================================================

; --- Ajuste pessoal ---
tempoCliqueAreia := 600     ; (ms) Quanto tempo SEGURA o clique ao pegar areia
cliquesParaEncher := 5    ; Vezes para clicar e encher a bateia x2 (PARTE 1) 
tempoLavarBateia := 10000
; --- Fim Ajuste pessoal ---


; --- Pausas (Ajuste fino) ---
totalRepeticoes := 100      ; Quantas vezes o ciclo todo vai repetir
tempoAndarRio := 1000       ; (ms) Tempo andando (D) para o rio
tempoAndarTerra := 1000     ; (ms) Tempo andando (A) para a área de mineração
pausaEntreCliques := 1000    ; (ms) Pausa entre cada clique da PARTE 1
pausaAposEncher := 1000     ; (ms) Pausa após encher a bateia (antes de andar)
pausaAntesLavar := 500      ; (ms) Pausa entre o clique e segurar o clique (PARTE 3)
pausaAposLavar := 1000      ; (ms) Pausa após terminar de lavar (antes de andar)
pausaAntesRepetir := 500    ; (ms) Pausa final antes de recomeçar o ciclo


; =====================================================================
; --- INÍCIO DO SCRIPT (Não precisa mexer aqui) ---
; =====================================================================

F1:: {
    ; --- LOOP PRINCIPAL: Repete o ciclo X vezes ---
    Loop totalRepeticoes {
        
        ; --- PARTE 1: Enchendo a bateia com areia ---
        Loop cliquesParaEncher {
            Send "{LButton down}"
            Sleep(tempoCliqueAreia)
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
        Sleep(tempoLavarBateia) ; <-- USA O VALOR CALCULADO AQUI
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

; --- TECLA DE FIM (F2) ---
F2:: {
    Reload() ; Para e recarrega o script
}