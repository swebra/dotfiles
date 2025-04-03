#SingleInstance Force

; =======================
; Configuration Variables
; =======================
YasbTitle := "YasbBar"
YasbHide := true
KomorebiHide := true


; =========
; Functions
; =========

; Komorebi
; --------
Komorebic(cmd) {
    RunWait(format("komorebic.exe {}", cmd), , "Hide")
}

; Menu Setup
; ----------
StartKomorebi(args := "") {
    if (ProcessExist("komorebi.exe")) {
        TrayTip("Komorebi already running")
        return
    }
    Run('powershell.exe -Command "komorebic start --bar ' args '"', , KomorebiHide ? "Hide" : "")
}

StopKomorebi() {
    Komorebic("stop --bar")
}

StartYasb(*) {
    if (WinExist(YasbTitle)) {
        TrayTip("Yasb already running")
        return
    }
    Run('powershell.exe -Command "python $Env:USERPROFILE\yasb\src\main.py"', , YasbHide ? "Hide" : "")
}

InitMenu() {
    A_TrayMenu.Delete()
    A_TrayMenu.Add("Reload AHK config", (*) => Reload())
    AutoHotkeySubmenu := Menu()
    AutoHotkeySubmenu.AddStandard()
    A_TrayMenu.Add("More AHK", AutoHotkeySubmenu)

    A_TrayMenu.Add() ; Line break

    A_TrayMenu.Add("Fill timesheet", (*) => InputTimeTracking())

    A_TrayMenu.Add() ; Line break

    A_TrayMenu.Add("Restart komorebi", (*) => (
        StopKomorebi()
        StartKomorebi()
    ))
    A_TrayMenu.Add("Restart komorebi w/o state", (*) => (
        StopKomorebi()
        StartKomorebi("--clean-state")
    ))
    A_TrayMenu.Add("Start komorebi", (*) => StartKomorebi())
    A_TrayMenu.Add("Stop komorebi", (*) => StopKomorebi())
    A_TrayMenu.Add("Force quit komorebi", (*) => ProcessClose("komorebi.exe"))
    A_TrayMenu.Add("Open komorebi GUI", (*) => Komorebic("gui"))

    ; A_TrayMenu.Add() ; Line break

    ; A_TrayMenu.Add("Start Yasb", StartYasb)
    ; A_TrayMenu.Add("Stop Yasb", (*) => ProcessClose(WinGetPID(YasbTitle)))
}

; Windows Lock Remap
; ------------------
; Based upon
; https://www.autohotkey.com/boards/viewtopic.php?p=333845&sid=7b59e57070d97358baaa66d80276f806#p333845
LockWindows() {
    Run('schtasks /Run /TN "WinLockEnable"', , "Hide")
    Sleep(500)
    DllCall("LockWorkStation")
    Sleep(500)
    Run('schtasks /Run /TN "WinLockDisable"', , "Hide")
}

; KDE Window Drag + Resize
; ------------------------
; Based upon
; https://www.autohotkey.com/docs/v2/scripts/index.htm#EasyWindowDrag_(KDE)

DragWindow(mouseButton) {
    ; Setup coords and window action delay for this function thread
    CoordMode("Mouse")
    SetWinDelay(2)

    ; Get the initial mouse position and the window under it
    MouseGetPos(&mouseX1, &mouseY1, &winId)
    ; Abort if the window is maximized
    if (WinGetMinMax(winId)) {
        return
    }
    ; Get the initial window position.
    WinGetPos(&winX, &winY,,, winId)

    ; While mouse button remains pressed
    While (GetKeyState(mouseButton, "P")) {
        ; Move the window to the new position.
        MouseGetPos(&mouseX2, &mouseY2)
        WinMove(winX + mouseX2 - mouseX1, winY + mouseY2 - mouseY1,,, winId)
    }
}

ResizeWindow(mouseButton) {
    ; Setup coords and window action delay for this function thread
    CoordMode("Mouse")
    SetWinDelay(2)

    ; Get the initial mouse position and the window under it
    MouseGetPos(&mouseX1, &mouseY1, &winId)
    ; Abort if the window is maximized
    if (WinGetMinMax(winId)) {
        return
    }
    ; Determine the window quadrant the mouse is currently in.
    ; 1 if mouse in left/top half of window, -1 if in right/bottom half
    WinGetPos(&winX, &winY, &winW, &winH, winId)
    winXMouseHalf := (mouseX1 < winX + winW / 2) ? 1 : -1
    winYMouseHalf := (mouseY1 < winY + winH / 2) ? 1 : -1

    ; While mouse button remains pressed
    While (GetKeyState(mouseButton, "P")) {
        ; MouseGetPos &mouseX2, &mouseY2 ; Get the current mouse position.

        ; Get amount mouse has moved, update old values after calculation
        MouseGetPos &mouseX2, &mouseY2
        mouseXOffset := (mouseX2 - mouseX1)
        mouseYOffset := (mouseY2 - mouseY1)
        mouseX1 := mouseX2
        mouseY1 := mouseY2

        ; Resize the window according to mouse movement and quadrant
        WinGetPos(&winX, &winY, &winW, &winH, winId)

        WinMove(
            winX + (winXMouseHalf + 1) / 2 * mouseXOffset, ; X of resized window
            winY + (winYMouseHalf + 1) / 2 * mouseYOffset, ; Y of resized window
            winW - winXMouseHalf * mouseXOffset, ; W of resized window
            winH - winYMouseHalf * mouseYOffset, ; H of resized window
            winId
        )
    }
}

; Convenience Macros
; ------------------
InputTimeTracking() {
    if not WinActive("Time Tracking") {
        TrayTip("Time tracking page not open")
        return ; Time tracking window not open, bail out
    }

    ; Populate Drivewyze/Drivewyze/Software
    autocompletePrefixes := ["Dr", "D", "So"]
    for prefix in autocompletePrefixes {
        Send(prefix)
        Sleep(100) ; Wait for the slow auto complete
        Send("{Down}{Tab}")
    }

    ; SRED and navigate to Monday
    Send("{Tab}")
    Sleep(100) ; Wait for slow SRED button
    Send("{Space}{Tab 2}")

    ; 40 hour work week
    Loop 5 {
        Send("8{Tab}")
    }

    ; Tab over to save
    Send("{Tab}")
}

#t::InputTimeTracking()


; Titlebar Setup
; --------------
; Abandoned due to not playing nice with komorebi

; TitlebarExes := "WindowsTerminal.exe" ; String to make useage easier
; TitlebarBorderExes := "Code.exe,vivaldi.exe" ; String to make useage easier

; RemoveTitlebarBorder(id) {
;     ; https://www.autohotkey.com/docs/v2/misc/WinTitle.htm
;     winTitle := id = "A" ? "A" : "ahk_id " . id ; "A" if "A", else "ahk_id id"
;     winExe := WinGetProcessName(winTitle)

;     if (InStr(TitlebarExes, winExe)) {
;         WinSetStyle("-0xC00000", winTitle)
;     } else if (InStr(TitlebarBorderExes, winExe)) {
;         WinSetStyle("-0xC40000", winTitle)
;     }
; }

; RemoveExistingTitlebars() {
;     winIds := WinGetList(,, "Program Manager")
;     for winId in winIds {
;         RemoveTitlebarBorder(winId)
;     }
; }

; InitTitlebarHook() {
;     Gui().Opt("+LastFound")
;     winID := WinExist()

;     DllCall("RegisterShellHookWindow", "UInt", winID)
;     msgNum := DllCall("RegisterWindowMessage", "Str", "SHELLHOOK")
;     OnMessage(msgNum, RemoveNewTitlebar)
; }

; ; TODO: Not currently working
; RemoveNewTitlebar(wParam, lParam, *) {
;     TrayTip("yo") ; Not being hit
;     if (wParam == 1) {
;         Sleep(10)
;         RemoveTitlebarBorder(lParam)
;     }
; }

; ; Force toggle titlebar/titlebar + borders
; #Home:: WinSetStyle("^0xC00000", "A")
; #+Home:: WinSetStyle("^0xC40000", "A")

; ======================
; Startup Initialization
; ======================
InitMenu()
StartKomorebi()
; StartYasb()

; =====================
; Hotkeys
; =====================
; Disable the Office hyper hotkey with the following registry edit:
; REG ADD HKCU\Software\Classes\ms-officeapp\Shell\Open\Command /t REG_SZ /d rundll32
; See https://www.autohotkey.com/boards/viewtopic.php?p=389016&sid=9c2303e42961b09efbfad34ca1d62486#p389016

#O::LockWindows()
#LButton::DragWindow("LButton")
#RButton::ResizeWindow("RButton")

; Komorebi
; --------
#!m::Komorebic("manage") ; Force management of window
#!+m::Komorebic("unmanage") ; Stop management of window
#!r::Komorebic("retile")
#!p::Komorebic("toggle-pause")

; Workspace movement
#1::Komorebic("focus-workspace 0")
#2::Komorebic("focus-workspace 1")
#3::Komorebic("focus-workspace 2")
#4::Komorebic("focus-workspace 3")
#5::Komorebic("focus-workspace 4")
#6::Komorebic("focus-workspace 5")

#+1::Komorebic("send-to-workspace 0")
#+2::Komorebic("send-to-workspace 1")
#+3::Komorebic("send-to-workspace 2")
#+4::Komorebic("send-to-workspace 3")
#+5::Komorebic("send-to-workspace 4")
#+6::Komorebic("send-to-workspace 5")

; Window Movement
#h::Komorebic("focus left")
#j::Komorebic("focus down")
#k::Komorebic("focus up")
#l::Komorebic("focus right")

#+h::Komorebic("move left")
#+j::Komorebic("move down")
#+k::Komorebic("move up")
#+l::Komorebic("move right")
#+Enter::Komorebic("promote")

#=::Komorebic("resize-axis horizontal increase")
#-::Komorebic("resize-axis horizontal decrease")
#+=::Komorebic("resize-axis vertical increase")
#+-::Komorebic("resize-axis vertical decrease")

; Monitor Movement
#.::Komorebic("cycle-monitor next")
#,::Komorebic("cycle-monitor previous")
#+.::Komorebic("cycle-send-to-monitor next")
#+,::Komorebic("cycle-send-to-monitor previous")

; Stacking ignored

; Layouts
#[::Komorebic("cycle-layout next")
#]::Komorebic("cycle-layout previous")
#m::Komorebic("toggle-monocle")
#f::Komorebic("toggle-float")
#\::Komorebic("toggle-window-based-work-area-offset")

; Program Launching
; -----------------
#q::Komorebic("close") ; TODO: Should this be a regular AHK close?
#b::Run("C:\Program Files\Zen Browser\zen.exe")
#Enter::Run("C:\Program Files\Alacritty\alacritty.exe")
