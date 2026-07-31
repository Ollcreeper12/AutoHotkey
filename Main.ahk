#Requires AutoHotkey v2.0
#SingleInstance Force

A_HotkeyInterval := 1000
A_MaxHotkeysPerInterval := 9999

ProcessSetPriority("H")
CoordMode("Mouse", "Screen")

; MacOS Home/End Key Remaps
!Right::Send("{End}")
!Left::Send("{Home}")

; ==============================================================================
; SETTINGS & INITIALIZATION
; ==============================================================================

size             := 200
color2           := "7e4fd6"
textColor        := "903cff"
showClicks       := true
toggleFakeCursor := false

LButtonDown      := 0
RButtonDown      := 0
WWheelUp         := 0
WWheelDown       := 0

ToolTips         := false
TimeOut          := 600
Boost            := 40
Limit            := 60

Distance         := 0
vMax             := 1.0

; --- Functions ---

QuickToolTip(Text, Delay) {
    ToolTip(Text)
    SetTimer(() => ToolTip(), -Delay)
}

AccelScroll(ud) {
    global Distance, vMax, TimeOut, Boost, Limit, ToolTips

    t := A_TimeSincePriorHotkey

    ; Clean A_PriorHotkey of modifiers (~, +, ^, !, *) so Shift+WheelUp counts as WheelUp!
    cleanPriorHotkey := RegExReplace(A_PriorHotkey, "[~+^!*]")

    if (cleanPriorHotkey = ud && t < TimeOut) {
        Distance++
        v := (t < 80 && t > 1) ? (250.0 / t) - 1 : 1

        if (Boost > 1 && Distance > Boost) {
            if (v > vMax) {
                vMax := v
            } else {
                v := vMax
            }
            v *= Distance / Boost
        }

        v := (v > 1) ? ((v > Limit) ? Limit : Floor(v)) : 1

        if (v > 1 && ToolTips) {
            QuickToolTip(v, TimeOut)
        }

        Click(ud " " v)
    } else {
        Distance := 0
        vMax := 1.0
        Click(ud " 1")
    }
}

WheelKiller() {
    global WWheelUp, WWheelDown

    if (WWheelUp = -1) {
        WWheelUp := 0
        myGui.Hide()
    }
    if (WWheelDown = -1) {
        WWheelDown := 0
        myGui.Hide()
    } 
}

Looper() {
    global LButtonDown, RButtonDown, WWheelUp, WWheelDown, toggleFakeCursor, showClicks

    if (!showClicks) {
        return
    }

    if (toggleFakeCursor) {
        ToolTip("^")
    }

    MouseGetPos(&RealPosX, &RealPosY)

    PosX := RealPosX - (size / 3.4)
    PosY := RealPosY - (size / 4.1)

    ; Both Buttons Pressed
    if (LButtonDown = 1 && RButtonDown = 1) {
        MyText.Value := "()"
        PosX -= 10
        myGui.Show("X" PosX " Y" PosY " NA")
        SetTimer(Looper, -20)
        return
    }

    ; Left Button Pressed
    if (LButtonDown = 1) {
        MyText.Value := "("
        PosXX := PosX - 10
        PosYY := PosY + 10
        myGui.Show("X" PosXX " Y" PosYY " NA")
    } else if (LButtonDown = -1) {
        LButtonDown := 0
        myGui.Hide()
    }
    
    ; Right Button Pressed
    if (RButtonDown = 1) {
        MyText.Value := ")"
        PosX += 25
        PosY += 10
        myGui.Show("X" PosX " Y" PosY " NA")
    } else if (RButtonDown = -1) {
        RButtonDown := 0
        myGui.Hide()
    }

    ; Wheel Up Tracking
    if (WWheelUp = 1) {
        posYu := PosY - 10
        posXu := PosX + 8
        MyText.Value := "^"
        myGui.Show("x" posXu " y" posYu " NA")
        SetTimer(WheelKiller, -200)
        WWheelUp := -1
    }

    ; Wheel Down Trigger
    if (WWheelDown = 1) {
        posYd := PosY + 40
        posXd := PosX + 10
        MyText.Value := "v"
        myGui.Show("x" posXd " y" posYd " NA")
        SetTimer(WheelKiller, -200)
        WWheelDown := -1
    }

    SetTimer(Looper, -1)
}

; --- GUI Creation ---

myGui := Gui("-Caption +ToolWindow +AlwaysOnTop +E0x20 +LastFound")
myGui.BackColor := color2

GuiHwnd := myGui.Hwnd
DetectHiddenWindows(true)

WinSetRegion("0-0 W" size " H" size, "ahk_id " GuiHwnd)
WinSetTransColor(color2 " 100", "ahk_id " GuiHwnd)

myGui.SetFont("s32 c" textColor, "Lucida Console")
MyText := myGui.Add("Text", "vMyText", "")

myGui.Show("w" size " h" size " Hide")

if (showClicks) {
    SetTimer(Looper, -2)
}

; ==============================================================================
; HOTKEYS
; ==============================================================================

; Pass-through modified wheel turns (sets visualizer flag & tracks speed)
~^WheelUp::
~+WheelUp::
~^+WheelUp::
~!WheelUp:: {
    global WWheelUp := 1
    AccelScroll("WheelUp")
    return
}

~^WheelDown::
~+WheelDown::
~^+WheelDown::
~!WheelDown:: {
    global WWheelDown := 1
    AccelScroll("WheelDown")
    return
}

; Standard wheel turns
WheelUp:: {
    global WWheelUp := 1
    myGui.Hide()
    AccelScroll("WheelUp")
    return
}

WheelDown:: {
    global WWheelDown := 1
    myGui.Hide()
    AccelScroll("WheelDown")
    return
}

#WheelDown:: {
    global showClicks
    if (showClicks) {
        ToolTip("Changing Vis")
        showClicks := false
        SetTimer(Looper, 0)
        Sleep(555)
        ToolTip()
    } else {
        showClicks := true
        SetTimer(Looper, -20)
    }
}

#MButton::Suspend(-1)

#LButton:: {
    global toggleFakeCursor
    toggleFakeCursor := !toggleFakeCursor
    if (!toggleFakeCursor) {
        ToolTip()
    }
}

; Mouse Trackers
~*$LButton::   global LButtonDown :=  1
~*$LButton up::global LButtonDown := -1
~*$RButton::   global RButtonDown :=  1
~*$RButton up::global RButtonDown := -1

; Reload shortcut in VS Code
#HotIf WinActive("ahk_exe Code.exe")
^r::Reload
#HotIf