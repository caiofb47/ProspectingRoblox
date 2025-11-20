#Requires AutoHotkey v2.0
CoordMode "Mouse", "Window"
SetKeyDelay 50, 50

; Author: Caiofb47.
; Description: Script PRO v15 - Com tempo de areia personalizado por perfil.

; =====================================================================
; 🛠️ ÁREA DE CONFIGURAÇÃO DOS PERFIS
; =====================================================================
; Adicione "TempoAreia" no perfil se quiser que ele seja diferente do padrão.
; Se não colocar, ele usa o padrão de 450ms.

ConfigPerfis := Map()

; F1: Usa o tempo de areia PADRÃO (450ms)
ConfigPerfis["F1"] := {Nome: "Sem Totem (Padrão)",    Cliques: 2, TempoLavar: 8000}

; F2: Usa o tempo de areia PADRÃO (450ms)
ConfigPerfis["F2"] := {Nome: "Totem Força (x2)",      Cliques: 1, TempoLavar: 5000}

; F3: Tem tempo de areia PERSONALIZADO (Ex: 300ms)
ConfigPerfis["F3"] := {Nome: "Totem Força + Ilum.",   Cliques: 2, TempoLavar: 5000, TempoAreia: 300}


; =====================================================================
; ⚙️ CONFIGURAÇÕES GERAIS DO JOGO
; =====================================================================
GlobalConfig := {
    Repeticoes: 500,            
    CiclosVenda: 10,            
    TempoCliqueAreia: 450,      ; <--- ESSE É O PADRÃO SE O PERFIL NÃO TIVER UM ESPECÍFICO
    
    ; Tempos de Movimento
    AndarRio: 500,
    AndarTerra: 500,
    
    ; Pausas
    EntreCliques: 1000,
    AposEncher: 1000,
    AntesLavar: 500,
    AposLavar: 1000,
    AntesRepetir: 500,
    
    ; Venda
    PosVender: {X: 842, Y: 635},
    PosCentro: {X: 964, Y: 484},
    Teclas: {Menu: "'", Ferramenta: "1"},
    DelaysVenda: {AbrirMenu: 800, AntesMove: 500, AposVenda: 1000}
}

; =====================================================================
; 🎮 HOTKEYS
; =====================================================================
F1::IniciarPerfil("F1")
F2::IniciarPerfil("F2")
F3::IniciarPerfil("F3")

F4:: {
    SendEvent "{LButton up}"
    SendEvent "{a up}"
    SendEvent "{d up}"
    SendEvent "{" GlobalConfig.Teclas.Ferramenta " up}"
    SendEvent "{" GlobalConfig.Teclas.Menu " up}"
    ToolTip "🛑 SCRIPT PARADO!"
    Sleep(1000)
    ToolTip
    Reload()
}

; Testes
F5::ColetarAreia(ConfigPerfis["F1"].Cliques, GlobalConfig.TempoCliqueAreia)
F9::VenderItens()


; =====================================================================
; 🧠 LÓGICA PRINCIPAL
; =====================================================================

IniciarPerfil(tecla) {
    if !ConfigPerfis.Has(tecla)
        return
    
    perfil := ConfigPerfis[tecla]
    
    ; Lógica inteligente para decidir o tempo da areia
    tempoAreiaUsado := perfil.HasOwnProp("TempoAreia") ? perfil.TempoAreia : GlobalConfig.TempoCliqueAreia
    
    MsgBox("Iniciando: " perfil.Nome "`n`nCliques: " perfil.Cliques "`nTempo Lavar: " perfil.TempoLavar "`nTempo Areia: " tempoAreiaUsado, "Info", "T1")
    
    ExecutarCiclo(perfil, tempoAreiaUsado)
}

ExecutarCiclo(perfil, tempoAreiaParaEsteCiclo) {
    Loop GlobalConfig.Repeticoes {
        
        proximaVenda := (Ceil(A_Index/GlobalConfig.CiclosVenda)*GlobalConfig.CiclosVenda)
        textoInfo := "► PERFIL: " perfil.Nome "`n"
                   . "🔄 Ciclo: " A_Index " / " GlobalConfig.Repeticoes "`n"
                   . "⏳ Areia: " tempoAreiaParaEsteCiclo "ms | Lavar: " perfil.TempoLavar "ms`n"
                   . "💰 Venda no ciclo: " proximaVenda
        ToolTip textoInfo
        
        ; 1. Encher (Usa o tempo decidido na inicialização)
        ColetarAreia(perfil.Cliques, tempoAreiaParaEsteCiclo)
        Sleep(GlobalConfig.AposEncher)

        ; 2. Ir pro Rio
        SendEvent "{a down}"
        Sleep(GlobalConfig.AndarRio)
        SendEvent "{a up}"

        ; 3. Lavar
        LavarBateia(perfil.TempoLavar)
        Sleep(GlobalConfig.AposLavar)

        ; Venda
        if (Mod(A_Index, GlobalConfig.CiclosVenda) == 0) {
            ToolTip "💰 VENDENDO..."
            VenderItens()
        }
        
        ; 4. Voltar pra Terra
        SendEvent "{d down}"
        Sleep(GlobalConfig.AndarTerra)
        SendEvent "{d up}"
        
        Sleep(GlobalConfig.AntesRepetir)
    }
    ToolTip "✅ FIM!"
    SetTimer () => ToolTip(), -3000
}

; =====================================================================
; 🔧 FUNÇÕES DE AÇÃO
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
        Sleep(GlobalConfig.EntreCliques)
    }
}

LavarBateia(tempoLavagem) {
    Click()
    Sleep(GlobalConfig.AntesLavar)
    SendEvent "{LButton down}"
    Sleep(tempoLavagem)
    SendEvent "{LButton up}"
}

VenderItens() {
    Sleep(GlobalConfig.DelaysVenda.AntesMove)
    
    ; 1. DESEQUIPAR
    ApertarComForca(GlobalConfig.Teclas.Ferramenta)
    Sleep(500)
    
    ; 2. ABRIR MENU
    ApertarComForca(GlobalConfig.Teclas.Menu)
    Sleep(GlobalConfig.DelaysVenda.AbrirMenu)
    
    ; 3. MOVER E "TREMER"
    posX := GlobalConfig.PosVender.X
    posY := GlobalConfig.PosVender.Y
    
    MouseMove(posX, posY)
    Sleep(100)
    MouseMove(posX + 2, posY) 
    Sleep(50)
    MouseMove(posX, posY)
    Sleep(300)
    
    ; 4. CLIQUE DE VENDA
    SendEvent "{LButton down}"
    Sleep(150)
    SendEvent "{LButton up}"
    Sleep(200)
    
    ; 5. VOLTAR MIRA
    MouseMove(GlobalConfig.PosCentro.X, GlobalConfig.PosCentro.Y)
    Sleep(300)
    
    ; 6. FECHAR MENU
    ApertarComForca(GlobalConfig.Teclas.Menu)
    Sleep(800)
    
    ; 7. EQUIPAR
    ApertarComForca(GlobalConfig.Teclas.Ferramenta)
    Sleep(800)
    
    Sleep(GlobalConfig.DelaysVenda.AposVenda)
}