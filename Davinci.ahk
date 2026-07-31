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
    Send("b")
    ToolTip("Cuts Clip When Relesed")
    KeyWait("XButton1")
    MouseClick()
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