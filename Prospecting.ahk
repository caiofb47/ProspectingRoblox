#Requires AutoHotkey v2.0
CoordMode "Mouse", "Window"
SetKeyDelay 50, 50 ; IMPORTANTE: Faz todas as teclas terem um atraso natural (50ms pressionando)

; Author: Caiofb47.
; Description: Script otimizado para Prospecting (Venda Blindada).

; =====================================================================
; --- CONFIGURAÇÕES PRINCIPAIS ---
; =====================================================================
totalRepeticoes := 100
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
pausaAbrirMenu := 800       ; Aumentei para garantir que a animação termine
pausaAntesVender := 500
pausaAposVender := 1000

; =====================================================================
; --- PERFIS ---
; =====================================================================
cliquesParaEncher_F1 := 2
tempoLavarBateia_F1 := 4000
cliquesParaEncher_F2 := 1
tempoLavarBateia_F2 := 3000

; =====================================================================
; --- HOTKEYS ---
; =====================================================================
F1::ExecutarCiclo(cliquesParaEncher_F1, tempoCliqueAreiaPerfeito, tempoLavarBateia_F1)
F2::ExecutarCiclo(cliquesParaEncher_F2, tempoCliqueAreiaPerfeito, tempoLavarBateia_F2)
F4::Reload()

; Testes
F5::ColetarAreia(cliquesParaEncher_F1, tempoCliqueAreiaPerfeito)
F8::LavarBateia(tempoLavarBateia_F1)
F9::VenderItens() ; Teste a nova lógica de venda aqui

; =====================================================================
; --- FUNÇÕES DE AÇÃO ---
; =====================================================================

; Função auxiliar para garantir que a tecla seja lida pelo jogo
ApertarComForca(tecla) {
    SendEvent "{" tecla " down}" ; Segura a tecla
    Sleep(150)                   ; Mantém segurada por 150ms (Isso é muito tempo pro PC, mas ideal pro jogo)
    SendEvent "{" tecla " up}"   ; Solta a tecla
    Sleep(100)                   ; Pausa extra pós-tecla
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
    
    ; 1. DESEQUIPAR (Com força)
    ApertarComForca(teclaFerramenta)
    Sleep(500)
    
    ; 2. ABRIR MENU (Com força)
    ApertarComForca(teclaMenuVendas)
    Sleep(pausaAbrirMenu) ; Espera animação
    
    ; 3. MOVER E "TREMER" O MOUSE
    MouseMove(posX_Vender, posY_Vender)
    Sleep(100)
    ; Move 1 pixel pro lado e volta para forçar o jogo a ver o mouse
    MouseMove(posX_Vender + 2, posY_Vender) 
    Sleep(50)
    MouseMove(posX_Vender, posY_Vender)
    Sleep(300) ; Espera botão "acender"
    
    ; 4. CLIQUE DE VENDA (Lento e Seguro)
    SendEvent "{LButton down}"
    Sleep(150) ; Segura o clique
    SendEvent "{LButton up}"
    Sleep(200)
    
    ; 5. VOLTAR MIRA
    MouseMove(posX_Centro, posY_Centro)
    Sleep(300)
    
    ; 6. FECHAR MENU (Com força)
    ApertarComForca(teclaMenuVendas)
    Sleep(800) ; Espera fechar visualmente
    
    ; 7. EQUIPAR (Com força)
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