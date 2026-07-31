#Requires AutoHotkey v2.0
#SingleInstance Force

#HotIf WinActive("ahk_exe blender.exe")

;Apply All Transforms
^a:: {
    BlockInput("Mouse")
    BlockInput("On")
    
    Send("+^!a")
    Send("a")
    Send("{Enter}")

    BlockInput("Off")
    return
}

;Location
^!a:: {
    BlockInput("Mouse")
    BlockInput("On")
    
    Send("+^!a")
    Send("l")
    Send("{Enter}")

    BlockInput("Off")
    return
}

;Rotation
^+a:: {
    BlockInput("Mouse")
    BlockInput("On")
    
    Send("+^!a")
    Send("r")
    Send("{Enter}")

    BlockInput("Off")
    return
}

;Scale
!+a:: {
    BlockInput("Mouse")
    BlockInput("On")
    
    Send("+^!a")
    Send("s")
    Send("{Enter}")

    BlockInput("Off")
    return
}



#HotIf WinActive("ahk_exe Code.exe")
^r::Reload
#HotIf 