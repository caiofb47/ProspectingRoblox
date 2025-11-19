#Requires AutoHotkey v2.0
CoordMode "Mouse", "Window" ; Garante que as coordenadas usem a janela do jogo

; Author: Caiofb47.
; Description: Script para automatizar o processo de prospecting no jogo Prospecting.

; =====================================================================
; --- Configurações Principais (Movimento e Coleta) ---
; =====================================================================
totalRepeticoes := 100      ; Quantas vezes o ciclo todo vai repetir
tempoAndarRio := 500        ; (ms) Tempo andando (A) para o RIO
tempoAndarTerra := 500      ; (ms) Tempo andando (D) para a TERRA
pausaEntreCliques := 1000   ; (ms) Pausa entre cada clique da PARTE 1
pausaAposEncher := 1000     ; (ms) Pausa após encher a bateia (antes de andar)
pausaAntesLavar := 500      ; (ms) Pausa entre o clique e segurar o clique (PARTE 3)
pausaAposLavar := 1000      ; (ms) Pausa após terminar de lavar (antes de vender/andar)
pausaAntesRepetir := 500    ; (ms) Pausa final antes de recomeçar o ciclo

tempoCliqueAreiaPerfeito := 450 ; (ms) Tempo para coleta de areia perfeita.

; =====================================================================
; --- CONFIGURAÇÃO: SISTEMA DE VENDA E MIRA ---
; =====================================================================
ciclosParaVender := 10       ; A cada QUANTOS ciclos ele vai clicar em vender?

; Onde está o botão "Vender"?
posX_Vender := 842          
posY_Vender := 635          

; Para onde o mouse volta depois? (Centro/Mira)
posX_Centro := 964          
posY_Centro := 484          

; Configuração do Menu de Vendas
teclaMenuVendas := "'"      ; Tecla que abre/fecha o menu (Aspas simples)
pausaAbrirMenu := 1000       ; Tempo esperando o menu abrir antes de mover o mouse
pausaAntesVender := 1000     ; Pausa extra antes de começar o movimento
pausaAposVender := 1000     ; Tempo parado APÓS fechar o menu e voltar a mira
; ===================================================================== 


; ===================================================================== 
; --- Configuração Perfil 1 (F1) ---
cliquesParaEncher_F1 := 2
tempoLavarBateia_F1 := 4000

; --- Configuração Perfil 2 (F2) ---
cliquesParaEncher_F2 := 1
tempoLavarBateia_F2 := 3000
; =====================================================================


; =====================================================================
; --- TECLAS DE ATALHO (Hotkeys) ---
; =====================================================================

F1:: {
    ExecutarCiclo(cliquesParaEncher_F1, tempoCliqueAreiaPerfeito, tempoLavarBateia_F1)
}

F2:: {
    ExecutarCiclo(cliquesParaEncher_F2, tempoCliqueAreiaPerfeito, tempoLavarBateia_F2)
}

F4::Reload() ; Para o script

; --- TESTES INDIVIDUAIS ---
F5::ColetarAreia(cliquesParaEncher_F1, tempoCliqueAreiaPerfeito)
F6::ColetarAreia(cliquesParaEncher_F2, tempoCliqueAreiaPerfeito)
F8::LavarBateia(tempoLavarBateia_F1)
F9::VenderItens() ; Testa a rotina completa de venda (Abrir > Vender > Fechar)


; =====================================================================
; --- BLOCOS DE AÇÃO (Funções) ---
; =====================================================================

ColetarAreia(numCliques, tempoClique) {
    Loop numCliques {
        Send "{LButton down}"
        Sleep(tempoClique)
        Send "{LButton up}"
        Sleep(pausaEntreCliques)
    }
}

LavarBateia(tempoLavagem) {
    Click() 
    Sleep(pausaAntesLavar)
    Send "{LButton down}" 
    Sleep(tempoLavagem)
    Send "{LButton up}"
}

; --- FUNÇÃO DE VENDER (COM ABERTURA DE MENU) ---
VenderItens() {
    Sleep(pausaAntesVender)
    
    ; 1. ABRE O MENU
    Send teclaMenuVendas
    Sleep(pausaAbrirMenu) ; Espera a animação do menu
    
    ; 2. Move para o botão de venda
    MouseMove(posX_Vender, posY_Vender)
    Sleep(300) ; Pequena pausa para o botão "acender"
    
    ; 3. CLIQUE
    Click()
    Sleep(100) 
    
    ; 4. VOLTA PARA O CENTRO IMEDIATAMENTE
    MouseMove(posX_Centro, posY_Centro)
    Sleep(200) ; Garante que a mira voltou
    
    ; 5. FECHA O MENU
    Send teclaMenuVendas
    
    ; 6. Espera final de segurança
    Sleep(pausaAposVender) 
}


; =====================================================================
; --- FUNÇÃO PRINCIPAL ---
; =====================================================================

ExecutarCiclo(numCliques, tempoClique, tempoLavagem) {
    
    Loop totalRepeticoes {
        
        ToolTip "Ciclo: " A_Index " | Próxima venda no ciclo: " (Ceil(A_Index/ciclosParaVender)*ciclosParaVender)
        
        ; --- PARTE 1: Enchendo ---
        ColetarAreia(numCliques, tempoClique)
        Sleep(pausaAposEncher)

        ; --- PARTE 2: Indo ao Rio ---
        Send "{a down}"
        Sleep(tempoAndarRio)
        Send "{a up}"

        ; --- PARTE 3: Lavando ---
        LavarBateia(tempoLavagem)
        Sleep(pausaAposLavar)

        ; --- LÓGICA DE VENDA (NA ÁGUA) ---
        if (Mod(A_Index, ciclosParaVender) == 0) {
            ToolTip "VENDENDO (Abrindo Menu)..."
            VenderItens() 
        }
        
        ; --- PARTE 4: Voltando a Terra ---
        Send "{d down}"
        Sleep(tempoAndarTerra)
        Send "{d up}"
        
        Sleep(pausaAntesRepetir)
        ToolTip 
        
    } 
    
    return
}