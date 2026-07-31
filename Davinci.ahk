#Requires AutoHotkey v2.0
#SingleInstance Force

#HotIf WinActive("ahk_exe Resolve.exe")

ResolvePanelFocus(Panel) {
    
    SendInput("^!+1")
    SendInput("^!+1")

    if (Panel = "effects")
        goto End
    else if (Panel = "inspector")
        SendInput("^!+2")
    else if (Panel = "src viwer")
        SendInput("^!+3")
    else if (Panel = "timeline")
        SendInput("^!+4")
    End:
}

AppyEffect(Effect) {
    
}

XButton1::{
    CoordMode("Mouse", "Client")
    MouseGetPos(&x, &y)

    reqColor1  := 0x212126
    reqColor2  := 0x2d2f33
    reqColor2b := 0x5a5f66

    Send("b")
    ToolTip("Cutting Visable clips when relese")
    KeyWait("XButton1")
    
    Loop {
        MouseGetPos(&xCol, &yCol)
        tColour := PixelGetColor(xCol, yCol)

        if (tColour = reqColor1) {
            goto ContinueScript
        } else {
            MouseGetPos(&xNewUp, &yNewUp)
            MouseMove(xNewUp, yNewUp - 1)
        }
    }
    
    ContinueScript:
    Loop {
        MouseGetPos(&xCol, &yCol)
        tColour := PixelGetColor(xCol, yCol)

        if (
            tColour  = reqColor2 ||
            tColour = reqColor2b
        ) {
            goto End
        } else {
            MouseGetPos(&xNewDown, &yNewDown)
            MouseMove(xNewDown, yNewDown + 10)
            Click()
        }
    }

    End:
    MouseMove(x, y)
    Send("p")
    ToolTip()
    return
}

XButton2::{
    Send("{LAlt down}")
    ToolTip("Clip Will Be Deleted When Released")
    KeyWait("XButton2")
    MouseClick()
    Send("{LAlt up}")
    Send("f")
    ToolTip()
}

#HotIf

;Reload With Ctrl+R
#HotIf WinActive("ahk_exe Code.exe")
^r::Reload

#HotIf 