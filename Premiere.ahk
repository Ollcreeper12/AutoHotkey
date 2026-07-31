#Requires AutoHotkey v2.0
#SingleInstance Force

ST := 50

SetTimer(NoWarningPremiere, 500/2)

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

#HotIf WinActive("ahk_exe Adobe Premiere Pro.exe")

~LAlt::Send("{Blind}{vkE8}")

; WheelDown::Send("{WheelDown 7}")
; WheelUp::Send("{WheelUp 7}")

; +WheelDown::Send("{Shift}{WheelDown 7}")
; +WheelUp::Send("{Shift}{WheelUp 7}")

timeline1 := 0x414141 ;timeline color inside the in/out points ON a targeted track
timeline2 := 0x313131 ;timeline color of the separating LINES between targeted AND non targeted tracks inside the in/out points
timeline3 := 0x1b1b1b ;the timeline color inside in/out points on a NON targeted track
timeline4 := 0x202020 ;the color of the bare timeline NOT inside the in out points
timeline5 := 0xDFDFDF ;the color of a SELECTED blank space on the timeline, NOT in the in/out points
timeline6 := 0xE4E4E4 ;the color of a SELECTED blank space on the timeline, IN the in/out points, on a TARGETED track
timeline7 := 0xBEBEBE ;the color of a SELECTED blank space on the timeline, IN the in/out points, on an UNTARGETED track
timeline8 := 0x212121

NoWarningPremiere() {
    if WinActive("Warning ahk_exe Adobe Premiere Pro.exe"){
        SendInput("{Enter}")
    }
}

PremierePanelFocus(Panel) {
    ;If in FS It Selects The Panel
    SendInput("^!+7")
    Sleep(ST / 5)
    SendInput("^!+7")
    Sleep(ST / 5)
    
    if (Panel = "project")
        SendInput("^!+1")
    else if (Panel = "src")
        SendInput("^!+2")
    else if (Panel = "timeline")
        SendInput("^!+3")
    else if (Panel = "program" OR Panel = "prog")
        SendInput("^!+4")
    else if (Panel = "effect controls" OR Panel = "ec")
        SendInput("^!+5")
    else if (Panel = "audio")
        SendInput("^!+6")
    else if (Panel = "effects")
        goto('end')
    
    end:
    ToolTip()
}

ApplyEffect(Effect){
    CoordMode("Mouse", "Client")
    MouseGetPos(&Xpos, &Ypos)
    CaretGetPos(&A_CaretX, &A_CaretY)

    ;Disable The Shift Key
    KeyWait("Shift")
    Send("{Shift up}")
    
    ToolTip("Stop PlayBack")
    Send("^!+k")
    Sleep(ST/5)
    Send("^!+k")
    Sleep(ST/5)

    ;Sel TM
    ToolTip("If Just Nested Select TM With MMB")
    MouseClick("Middle")

    ;Highlight The Effects Window
    ToolTip("Open FX Panel")
    PremierePanelFocus("effects")
    Sleep(ST)
    
    ;Clear Secrch If Not Empty
    ToolTip("Clear Search")
    SendInput("^b")
    Sleep(ST/2)
    
    if (A_CaretX = "")
    {
        waiting2 := 0
        Loop
        {
            waiting2++
            Sleep(33)
            
            hasCaret := CaretGetPos(&A_CaretX, &A_CaretY)
            ToolTip("counter = " (waiting2 * 33) "`nCaret = " (hasCaret ? A_CaretX : "None"))
            
            if (hasCaret)
            {
                ToolTip("CARET WAS FOUND")
                break
            }
            
            if (waiting2 > 40)
            {
                ToolTip("FAIL - no caret found. `nIf your cursor will not move, hit the button to call the preset() function again.`nTo remove this tooltip, refresh the script using its icon in the taskbar.`n`nIt's possible Premiere tried to AUTOSAVE at just the wrong moment!")
                Sleep(20)
                goto theEnding
            }
        }
        Sleep(1)
        ToolTip()
    }

    ;Search For Effect
    ToolTip("Search For The " . Effect . " Effect")
    Send(Effect)
    Sleep(ST)
    
    ;Hover Over Effect
    ToolTip("Goto Effect")
    MouseMove(A_CaretX, A_CaretY + 50)
    Sleep(ST+50)
    
    ;Move To Clip
    ToolTip("Move To Clip")
    MouseClickDrag("Left", A_CaretX, A_CaretY + 50, Xpos, Ypos)
    Sleep(ST)
    
    ;Clear Serch Agen
    ToolTip("Clear Search")
    PremierePanelFocus("effects")
    SendInput("^b")
    Send("{Backspace}")
    Sleep(ST)
    
    ;Open Effect Controlls Window
    ToolTip("Open Effect Controls")
    PremierePanelFocus("ec")
    Sleep(ST+50)
    
    theEnding:
    ToolTip()
    return
} ;Change some values with window spy under mouse pos client

;Default Effects ;Will need to make presets with this names
!+w::ApplyEffect("ClipDefault") ;1080p Footage
!+e::ApplyEffect("ResetMotion") ;1080p Footage
!+q::ApplyEffect("CropLeft50")

;XButton1 Is One Of My Mouse Side Buttons [CAN RE BIND]
;Cut All When Playing
XButton1::{
    ToolTip("Cutting All When Relese")
    
    ;Select The Razer Tool & Hold Shift To To Cut All Tracks
    Send("b")
    Send("{Shift down}")
    KeyWait("XButton1")
    ToolTip() ;Get Rid Of TooltTip
    
    ;Click Mouse And Relese Keys
    Send("{LButton}")
    Send("{Shift Up}")
    Sleep(ST / 2 / 2 - 0.5) ;Math
    Send("v")

    return
}

^XButton1::{
    ToolTip("Cutting Clip When Relese")
    
    ;Select The Razer Tool & Hold Shift To To Cut All Tracks
    Send("b")
    KeyWait("XButton1")
    ToolTip() ;Get Rid Of TooltTip
    
    ;Click Mouse And Relese Keys
    Send("{LButton}")
    Sleep(ST / 2 / 2 - 0.5) ;Math
    Send("v")

    return
}

;XButton1 Is One Of My Mouse Side Buttons [CAN RE BIND]
;Delete Hoverd When Playing
XButton2::{
    ToolTip("Deleting Clip When Relese")
    KeyWait("XButton2")
    
    ToolTip("Focus Timeline")
    MouseClick("Middle")

    ToolTip("Deselect All")
    Send("^+a")
    
    ToolTip("Selection Tool")
    Send("v")
    
    ToolTip("Select Clip")
    Send("{LAlt down}")
    MouseClick()
    Send("{LAlt up}")
    
    ToolTip("Delete Clip")
    Send("c")
    ToolTip()
    return
}

+XButton2::{
    Send("^+a")
    Send("v")
    Click()
    Send("c")
    return
}

^XButton2::{
    Send("^+a")
    Send("v")
    
    Click()
    Send("^!+{Delete}")

    return
}

;Ripple Under Mouse And Play ; Need to rebind ripple delete to Shift + F or Change The Line Send("+f")
^f::{
    KeyWait("Control")
    MouseClick()
    Send("+f")
    Sleep(ST/5)
    Send("{Space}")
}

;FullScreen Program Monitor
+!s::{
    ToolTip("Select Program Monitor")
    SendInput("^!+4")
    
    ToolTip("FullScreen/Exit FullScreen")
    SendInput('^!+[')
    
    ToolTip()
    return
}

^+r:: {
    ToolTip("Open Sequ Menu")
    Send("{LAlt down}")
    Send("s")
    Send("{LAlt up}")

    ToolTip("Select Render In To Out")
    Send("{Down 2}")

    ToolTip("Conferm It")
    Send("{Enter}")
    
    ToolTip()
    return
}

;Playhead to cursor
RButton::{
    MouseGetPos(&x, &y)
    colorr := PixelGetColor(x, y)

    if (colorr = timeline5 || colorr = timeline6 || colorr = timeline7) {
        Send("{Escape}")
    }

    if (
        colorr = timeline1 ||
        colorr = timeline2 ||
        colorr = timeline3 ||
        colorr = timeline4 ||
        colorr = timeline5 ||
        colorr = timeline6 ||
        colorr = timeline7 ||
        colorr = timeline8
    ) {
        MouseClick("Middle")

        if (GetKeyState("RButton", "P")) {
            while(GetKeyState("RButton", "P")) {
                Send("\")
                ToolTip("Right click playhead mod!")
                Sleep(16)
            }

            Send("{Escape}")
        }

    } else {
        SendInput("{RButton}")
    }
    
    ToolTip()
    return
}

^+p::{
    ToolTip("Open Sequ Menu")
    Send("{LAlt down}")
    Send("s")
    Send("{LAlt up}")
    
    Send("q")
    
    ToolTip()
    return
}

;Make a Default Text Faster
^t:: {
    CoordMode("Mouse", "Client")
    MouseGetPos(&x, &y)
    MouseGetPos(&xCol, &yCol)
    
    cColor := PixelGetColor(xCol, yCol)
    reqColor1 := 0xdddddd
    waiting := 0
    

    Tippy("text", "Make Text Clip")
    Send("\")
    Send("^!+t")
    Sleep(ST)
    MouseMove(x + 20, y)

    Loop {
        waiting++
        MouseGetPos(&xCol, &yCol)
        cColor := PixelGetColor(xCol, yCol)
        
        if (cColor = reqColor1) {
            MouseGetPos(&xNew, &yNew)
            MouseMove(xNew +1, yNew -1)
        }  else {
            goto ContinueScript
        }

        if (waiting > 40) {
            goto theEnding
        }
    }

    ContinueScript:
    ApplyEffect("TextDefault")

    MouseMove(15, 160)

    ; MsgBox("Should be at bottem of arrow", "Debug")
    Click()

    MouseGetPos(&xEC, &yEC)

    MouseMove(xEC, yEC+20)

    MouseGetPos(&xEC, &yEC)
    MouseMove(xEC+40, yEC)

    Click()
    SendInput("c")

    MouseMove(15, 160)
    Click()

    MouseMove(x, y)
    PremierePanelFocus("ec")
    Click("M")
    
    theEnding:

    ToolTip()
    return

}

^+5::{
    Send("^r")
    Sleep(ST+100)

    Send("50")
    Send("{Tab 6}")
    Send("{Enter}")

    return
}

; ^RButton::{
;     MouseGetPos(&x, &y)
;     colorr := PixelGetColor(x, y)

;     if (colorr = timeline5 || colorr = timeline6 || colorr = timeline7) {
;         Send("{Escape}")
;     }

;     if (
;         colorr = timeline1 ||
;         colorr = timeline2 ||
;         colorr = timeline3 ||
;         colorr = timeline4 ||
;         colorr = timeline5 ||
;         colorr = timeline6 ||
;         colorr = timeline7 ||
;         colorr = timeline8
;     ) {
;         MouseClick("Middle")

;         if (GetKeyState("RButton", "P")) {
;             while(GetKeyState("RButton", "P")) {
;                 Send("\")
;                 ToolTip("Right click playhead mod!")
;                 Sleep(16)
;             }

;             Send("{Escape}")
;         }

;     } else {
;         SendInput("{RButton}")
;     }
    
;     KeyWait("^")
;     SendInput("{Space}")

;     ToolTip()
;     return
; }


;Reload With Ctrl+R
#HotIf WinActive("ahk_exe Code.exe")
^r::Reload

#HotIf 

