#Requires AutoHotkey v2.0

; Author: Caiofb47 xD
; Description: Script para automatizar o processo de prospecting no jogo Prospecting.

; Tutorial: Ative a trava de shift (Shift Lock) no jogo para facilitar o movimento.
; Se pozicionar o personagem corretamente, com o rio a sua esquerda e a área de mineração a sua direita.
; Pressione F1 para iniciar o script.
; Pressione F4 para parar o script a qualquer momento.


; =====================================================================
; --- Configurações principais ---
; Quantidade de repetições até o script parar
totalRepeticoes := 100      ; Quantas vezes o ciclo todo vai repetir

; Variáveis de configuração de tempo (em milissegundos)
tempoAndarRio := 1000       ; (ms) Tempo andando (D) para o rio
tempoAndarTerra := 1000     ; (ms) Tempo andando (A) para a área de mineração
pausaEntreCliques := 1000    ; (ms) Pausa entre cada clique da PARTE 1
pausaAposEncher := 1000     ; (ms) Pausa após encher a bateia (antes de andar)
pausaAntesLavar := 500      ; (ms) Pausa entre o clique e segurar o clique (PARTE 3)
pausaAposLavar := 1000      ; (ms) Pausa após terminar de lavar (antes de andar)
pausaAntesRepetir := 500    ; (ms) Pausa final antes de recomeçar o ciclo
; =====================================================================


; ===================================================================== 
; --- Configuração F1 ---
tempoCliqueAreia := 600     ; Tempo em (ms) para coleta de areia perfeita.
cliquesParaEncher := 5    ; Vezes para clicar e encher a bateia
tempoLavarBateia := 10000  ; Tempo em (ms) para lavar a bateia completamente (coloque um pouco a mais para garantir e evitar erros).
; =====================================================================

; ===================================================================== 
; --- Configuração F2 ---
tempoCliqueAreia2x := 600     ; Tempo em (ms) para coleta de areia perfeita.
cliquesParaEncher2x := 5    ; Vezes para clicar e encher a bateia
tempoLavarBateia2x := 10000  ; Tempo em (ms) para lavar a bateia completamente (coloque um pouco a mais para garantir e evitar erros).
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

F2:: {
    ; --- LOOP PRINCIPAL: Repete o ciclo X vezes ---
    Loop totalRepeticoes {
        
        ; --- PARTE 1: Enchendo a bateia com areia ---
        Loop cliquesParaEncher2x {
            Send "{LButton down}"
            Sleep(tempoCliqueAreia2x)
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
        Sleep(tempoLavarBateia2x) ; <-- USA O VALOR CALCULADO AQUI
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
F4:: {
    Reload() ; Para e recarrega o script
}