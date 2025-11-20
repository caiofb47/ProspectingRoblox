#Requires AutoHotkey v2.0
CoordMode "Mouse", "Window"
SetKeyDelay 50, 50 ; Atraso natural para o jogo

; Author: Caiofb47.
; Description: Script PRO para Prospecting - Organizado e Visual.

; =====================================================================
; 🛠️ ÁREA DE CONFIGURAÇÃO DOS PERFIS (EDITE AQUI)
; =====================================================================
; Adicione ou altere os perfis aqui.
; Formato: "Tecla": {Nome: "Descrição", Cliques: X, Lavar: Y}

ConfigPerfis := Map()
ConfigPerfis["F1"] := {Nome: "Sem Totem (Padrão)",    Cliques: 2, TempoLavar: 8000}
ConfigPerfis["F2"] := {Nome: "Totem Força (x2)",      Cliques: 1, TempoLavar: 5000}
ConfigPerfis["F3"] := {Nome: "Totem Força + Ilum.",   Cliques: 1, TempoLavar: 5000}

; =====================================================================
; ⚙️ CONFIGURAÇÕES GERAIS DO JOGO
; =====================================================================
GlobalConfig := {
    Repeticoes: 500,            ; Total de ciclos
    CiclosVenda: 10,            ; Vender a cada X ciclos
    TempoCliqueAreia: 450,      ; Tempo do clique perfeito
    
    ; Tempos de Movimento
    AndarRio: 500,
    AndarTerra: 500,
    
    ; Pausas (Delays)
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
; 🎮 HOTKEYS (CONTROLES)
; =====================================================================

; --- Inicia os Perfis Automaticamente baseado na configuração acima ---
F1::IniciarPerfil("F1")
F2::IniciarPerfil("F2")
F3::IniciarPerfil("F3")

; --- Parada de Emergência ---
F4:: {
    ; Solta tudo que possa estar segurado
    SendEvent "{LButton up}"
    SendEvent "{a up}"
    SendEvent "{d up}"
    SendEvent "{" GlobalConfig.Teclas.Ferramenta " up}"
    SendEvent "{" GlobalConfig.Teclas.Menu " up}"
    
    ToolTip "🛑 SCRIPT PARADO PELO USUÁRIO"
    Sleep(1000)
    ToolTip
    Reload()
}

; --- Testes Rápidos ---
F5::ColetarAreia(ConfigPerfis["F1"].Cliques, GlobalConfig.TempoCliqueAreia)
F8::LavarBateia(ConfigPerfis["F1"].TempoLavar)
F9::VenderItens()


; =====================================================================
; 🧠 LÓGICA PRINCIPAL (NÃO PRECISA MEXER MUITO AQUI)
; =====================================================================

; Função Wrapper para iniciar o ciclo com os dados corretos
IniciarPerfil(tecla) {
    if !ConfigPerfis.Has(tecla)
        return
    
    perfil := ConfigPerfis[tecla]
    
    MsgBox("Iniciando: " perfil.Nome "`n`nCliques: " perfil.Cliques "`nTempo Lavar: " perfil.TempoLavar, "Preparar...", "T1")
    
    ExecutarCiclo(perfil)
}

ExecutarCiclo(perfil) {
    Loop GlobalConfig.Repeticoes {
        
        ; --- FEEDBACK VISUAL MELHORADO ---
        proximaVenda := (Ceil(A_Index/GlobalConfig.CiclosVenda)*GlobalConfig.CiclosVenda)
        textoInfo := "► PERFIL ATIVO: " perfil.Nome "`n"
                   . "🔄 Ciclo: " A_Index " / " GlobalConfig.Repeticoes "`n"
                   . "💰 Próxima Venda: Ciclo " proximaVenda
        ToolTip textoInfo
        
        ; 1. Encher
        ColetarAreia(perfil.Cliques, GlobalConfig.TempoCliqueAreia)
        Sleep(GlobalConfig.AposEncher)

        ; 2. Ir pro Rio
        SendEvent "{a down}"
        Sleep(GlobalConfig.AndarRio)
        SendEvent "{a up}"

        ; 3. Lavar
        LavarBateia(perfil.TempoLavar)
        Sleep(GlobalConfig.AposLavar)

        ; LÓGICA DE VENDA (NA ÁGUA)
        if (Mod(A_Index, GlobalConfig.CiclosVenda) == 0) {
            ToolTip "💰 HORA DE VENDER...`n(Executando rotina de venda)"
            VenderItens()
        }
        
        ; 4. Voltar pra Terra
        SendEvent "{d down}"
        Sleep(GlobalConfig.AndarTerra)
        SendEvent "{d up}"
        
        Sleep(GlobalConfig.AntesRepetir)
    }
    ToolTip "✅ FIM DO CICLO!"
    SetTimer () => ToolTip(), -3000 ; Limpa tooltip após 3s
}

; =====================================================================
; 🔧 FUNÇÕES DE AÇÃO (AGORA USANDO O OBJETO DE CONFIGURAÇÃO)
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