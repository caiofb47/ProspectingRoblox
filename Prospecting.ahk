#Requires AutoHotkey v2.0
CoordMode "Mouse", "Window"
SetKeyDelay 50, 50 ; Atraso natural para o Roblox registrar as teclas

; Author: Caiofb47.
; Description: Script otimizado para Prospecting (Venda Blindada + Parada Segura).

; =====================================================================
; --- CONFIGURAÇÕES PRINCIPAIS ---
; =====================================================================
totalRepeticoes := 500
tempoAndarRio := 500
tempoAndarTerra := 500
pausaEntreCliques := 1000
pausaAposEncher := 1000
pausaAntesLavar := 500
pausaAposLavar := 1000
pausaAntesRepetir := 500
tempoCliqueAreiaPerfeito := 450

; --- CONFIGURAÇÃO DE VENDA ---
ciclosParaVender := 10

; Coordenadas (Vender e Mira)
posX_Vender := 842
posY_Vender := 635
posX_Centro := 964
posY_Centro := 484

; Teclas e Tempos de Menu
teclaMenuVendas := "'"
teclaFerramenta := "1"
pausaAbrirMenu := 800
pausaAntesVender := 500
pausaAposVender := 1000

; =====================================================================
; --- PERFIS ---
; =====================================================================
cliquesParaEncher_F1 := 2
tempoLavarBateia_F1 := 8000

cliquesParaEncher_F2 := 1
tempoLavarBateia_F2 := 5000

cliquesParaEncher_F3 := 1
tempoLavarBateia_F3 := 5000

; =====================================================================
; --- Opções ---
; =====================================================================

; Sem Totem
F1::ExecutarCiclo(cliquesParaEncher_F1, tempoCliqueAreiaPerfeito, tempoLavarBateia_F1)

; Totem força
F2::ExecutarCiclo(cliquesParaEncher_F2, tempoCliqueAreiaPerfeito, tempoLavarBateia_F2)

; Totem força + totem iluminante
F3::ExecutarCiclo(cliquesParaEncher_F3, tempoCliqueAreiaPerfeito, tempoLavarBateia_F3)

; F4 AGORA COM SEGURANÇA
F4:: {
    SendEvent "{LButton up}"
    SendEvent "{a up}"
    SendEvent "{d up}"
    SendEvent "{1 up}"
    SendEvent "{' up}"
    ToolTip "🛑 PARANDO..."
    Sleep(500)
    ToolTip
    Reload()
}

; Testes
F5::ColetarAreia(cliquesParaEncher_F1, tempoCliqueAreiaPerfeito)
F8::LavarBateia(tempoLavarBateia_F1)
F9::VenderItens()

; =====================================================================
; --- FUNÇÕES DE AÇÃO ---
; =====================================================================

ApertarComForca(tecla) {
    SendEvent "{" tecla " down}"
    Sleep(150)
    SendEvent "{" tecla " up}"
    Sleep(100)
}

ColetarAreia(numCliques, tempoClique) {
    Loop numCliques {
        SendEvent "{LButton down}"
        Sleep(tempoClique)
        SendEvent "{LButton up}"
        Sleep(pausaEntreCliques)
    }
}

LavarBateia(tempoLavagem) {
    Click()
    Sleep(pausaAntesLavar)
    SendEvent "{LButton down}"
    Sleep(tempoLavagem)
    SendEvent "{LButton up}"
}

; --- LÓGICA DE VENDA BLINDADA ---
VenderItens() {
    Sleep(pausaAntesVender)
    
    ; 1. DESEQUIPAR
    ApertarComForca(teclaFerramenta)
    Sleep(500)
    
    ; 2. ABRIR MENU
    ApertarComForca(teclaMenuVendas)
    Sleep(pausaAbrirMenu)
    
    ; 3. MOVER E "TREMER" O MOUSE
    MouseMove(posX_Vender, posY_Vender)
    Sleep(100)
    MouseMove(posX_Vender + 2, posY_Vender) 
    Sleep(50)
    MouseMove(posX_Vender, posY_Vender)
    Sleep(300)
    
    ; 4. CLIQUE DE VENDA
    SendEvent "{LButton down}"
    Sleep(150)
    SendEvent "{LButton up}"
    Sleep(200)
    
    ; 5. VOLTAR MIRA
    MouseMove(posX_Centro, posY_Centro)
    Sleep(300)
    
    ; 6. FECHAR MENU
    ApertarComForca(teclaMenuVendas)
    Sleep(800)
    
    ; 7. EQUIPAR
    ApertarComForca(teclaFerramenta)
    Sleep(800)
    
    Sleep(pausaAposVender)
}

; =====================================================================
; --- LOOP PRINCIPAL ---
; =====================================================================
ExecutarCiclo(numCliques, tempoClique, tempoLavagem) {
    Loop totalRepeticoes {
        ToolTip "Ciclo: " A_Index " | Próxima venda no ciclo: " (Ceil(A_Index/ciclosParaVender)*ciclosParaVender)
        
        ; PARTE 1: Encher
        ColetarAreia(numCliques, tempoClique)
        Sleep(pausaAposEncher)

        ; PARTE 2: Ir pro Rio
        SendEvent "{a down}"
        Sleep(tempoAndarRio)
        SendEvent "{a up}"

        ; PARTE 3: Lavar
        LavarBateia(tempoLavagem)
        Sleep(pausaAposLavar)

        ; VENDA (Na água)
        if (Mod(A_Index, ciclosParaVender) == 0) {
            ToolTip "VENDENDO..."
            VenderItens()
        }
        
        ; PARTE 4: Voltar pra Terra
        SendEvent "{d down}"
        Sleep(tempoAndarTerra)
        SendEvent "{d up}"
        
        Sleep(pausaAntesRepetir)
        ToolTip
    }
    return
}