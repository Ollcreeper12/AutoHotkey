#Requires AutoHotkey v2.0
#SingleInstance Force

ST := 50

Tippy(TypeOfTip, Text := "", Duration := 10000) {
    if (TypeOfTip = "text") {
        ToolTip(Text)
    }
    else if (TypeOfTip = "coords" && Text == "") {
        CoordMode("Mouse", "Client")
        MouseGetPos(&x, &y)
        ToolTip("Position: X: " x ", Y: " y)
    }
    else if (TypeOfTip = "coords" && Text != "") {
        CoordMode("Mouse", "Client")
        MouseGetPos(&x, &y)
        ToolTip("Position: X: " x ", Y: " y " Extra Info: " Text)
    }

    SetTimer(() => ToolTip(), -Duration)
}

#HotIf WinActive("ahk_class FMTMainForm")

^r:: {
    CoordMode("Mouse", "Client")

    Tippy("coords", "", 2000)

    ; Click Menu
    MouseMove(19, 12)
    Tippy("coords", "", 2000)
    Click("L")
    Sleep(100)

    calcToExport := (25 * 6) - 10

    ; Navigate menu to Export
    MouseMove(19, 12 + calcToExport)
    Sleep(ST * 10)
    MouseMove(19 + 300, 12 + calcToExport)

    Send("{Down 3}")
    Sleep(ST)
    Send("{Enter}")

    ; Give the Save/Export window time to appear
    Sleep(400)

    ; Active Caret Loop
    waiting2 := 0
    caretFound := false

    Loop {
        waiting2++
        Sleep(33)
        
        ; Query caret position live inside the loop
        hasCaret := CaretGetPos(&caretX, &caretY)
        ToolTip("Counter = " (waiting2 * 33) "ms`nCaret Status: " (hasCaret ? "Found!" : "Searching..."))
        
        if (hasCaret) {
            ToolTip("CARET WAS FOUND")
            caretFound := true
            break
        }
        
        ; Timeout safety net (~1.3s)
        if (waiting2 > 40) {
            ToolTip("Caret detection bypassed/timed out — attempting to type filename anyway.")
            Sleep(1000)
            break ; Continue to typing rather than completely exiting script
        }
    }

    ToolTip() ; Clear searching tooltip
    Sleep(150)

    ; Type export filename and confirm
    SendText("Animation Export.mp4")
    Sleep(100)
    Send("{Enter}")

    theEnding:
    ToolTip()
    return
}

#HotIf



; Quick Reload in VS Code
#HotIf WinActive("ahk_exe Code.exe")
^r::Reload
#HotIf