#Requires AutoHotkey v2.0
#SingleInstance Force

ST := 50

Tippy(TypeOfTip, Text, Duration := 10000) {
    if (TypeOfTip = "text") {
        ToolTip(Text)
    }
    if (TypeOfTip = "coords") {
        CoordMode("Mouse", "Client")
        MouseGetPos(&x, &y)
        ToolTip("Position: X: " x ", Y: " y)
    }

    if (TypeOfTip = "coords" && Text != "") {
        CoordMode("Mouse", "Client")
        MouseGetPos(&x, &y)
        ToolTip("Position: X: " x ", Y: " y " Extra Info: " Text)
    }


    SetTimer(() => ToolTip(), -Duration)
}


#HotIf WinActive("ahk_exe kdenlive.exe")

^!Enter::{
    Send("^!+T")
}


#HotIf 


#HotIf WinActive("ahk_exe Code.exe")
^r::Reload
#HotIf 