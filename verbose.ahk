#Requires AutoHotkey v2.0
#SingleInstance Force

LogStep(text) {
    FileAppend(FormatTime() " - " text "`n", A_ScriptDir "\launcher.log")
}

^!x:: {
    ExitKiosk()
}

global SpinnerFrames := ["|", "/", "-", "\"]
global SpinnerIndex := 1

LogStep("Script started")
ShowLoadingScreen("Loading FanaLab...")

; Launch FanaLab and give it time to initialize the wheel
Run("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\FanaLab.lnk")
LogStep("FanaLab launch fired")
Sleep(8000)

UpdateStatus("Starting Steam...")
Sleep(1500)

UpdateStatus("Opening Assetto Corsa Competizione...")
Run("C:\Program Files (x86)\Steam\steam.exe -applaunch 805550")
LogStep("Steam launch fired, waiting for game process")

if ProcessWait("AC2-Win64-Shipping.exe", 120) {
    LogStep("AC2-Win64-Shipping.exe process detected")
} else {
    LogStep("ProcessWait TIMED OUT waiting for AC2-Win64-Shipping.exe")
}

if WinWait("ahk_exe AC2-Win64-Shipping.exe", , 120) {
    LogStep("Game window exists")
} else {
    LogStep("WinWait TIMED OUT waiting for game window")
}

if WinWaitActive("ahk_exe AC2-Win64-Shipping.exe", , 120) {
    LogStep("Game window is active")
} else {
    LogStep("WinWaitActive TIMED OUT")
}

Sleep(2000)  ; let the intro video frame actually render before we click
CoordMode("Mouse", "Screen")
Click(A_ScreenWidth / 2, A_ScreenHeight / 2)
LogStep("Click sent")

Sleep(500)

try {
    HideLoadingScreen()
    LogStep("HideLoadingScreen completed")
} catch as err {
    LogStep("HideLoadingScreen FAILED: " err.Message)
}

Loop {
    if !ProcessExist("AC2-Win64-Shipping.exe") {
        LogStep("Game process no longer running, relaunching")
        ShowLoadingScreen("Opening Assetto Corsa Competizione...")
        Run("C:\Program Files (x86)\Steam\steam.exe -applaunch 805550")
        LogStep("Steam relaunch fired, waiting for game process")

        if ProcessWait("AC2-Win64-Shipping.exe", 120) {
            LogStep("AC2-Win64-Shipping.exe process detected (relaunch)")
        } else {
            LogStep("ProcessWait TIMED OUT (relaunch)")
        }

        if WinWait("ahk_exe AC2-Win64-Shipping.exe", , 120) {
            LogStep("Game window exists (relaunch)")
        } else {
            LogStep("WinWait TIMED OUT (relaunch)")
        }

        if WinWaitActive("ahk_exe AC2-Win64-Shipping.exe", , 120) {
            LogStep("Game window is active (relaunch)")
        } else {
            LogStep("WinWaitActive TIMED OUT (relaunch)")
        }

        Sleep(2000)
        CoordMode("Mouse", "Screen")
        Click(A_ScreenWidth / 2, A_ScreenHeight / 2)
        LogStep("Click sent (relaunch)")

        Sleep(500)

        try {
            HideLoadingScreen()
            LogStep("HideLoadingScreen completed (relaunch)")
        } catch as err {
            LogStep("HideLoadingScreen FAILED (relaunch): " err.Message)
        }
    }
    Sleep(2000)
}

ExitKiosk() {
    Run("explorer.exe")
    ExitApp()
}

ShowLoadingScreen(statusText) {
    global LoadingGui, SpinnerCtrl, StatusCtrl
    LoadingGui := Gui("-Caption +AlwaysOnTop +ToolWindow")
    LoadingGui.BackColor := "0D0D0D"
    screenW := A_ScreenWidth
    screenH := A_ScreenHeight
    LoadingGui.SetFont("s60 cWhite Bold", "Consolas")
    SpinnerCtrl := LoadingGui.Add("Text", "x0 y" (screenH/2 - 120) " w" screenW " Center", "|")
    LoadingGui.SetFont("s18 cWhite", "Segoe UI")
    StatusCtrl := LoadingGui.Add("Text", "x0 y" (screenH/2 + 10) " w" screenW " Center", statusText)
    LoadingGui.SetFont("s14 c808080", "Segoe UI")
    LoadingGui.Add("Text", "x0 y" (screenH - 80) " w" screenW " Center", "Auto-Launcher by chrismuntean.dev")
    LoadingGui.Show("x0 y0 w" screenW " h" screenH)
    SetTimer(SpinSpinner, 120)
}

SpinSpinner() {
    global SpinnerFrames, SpinnerIndex, SpinnerCtrl
    SpinnerCtrl.Value := SpinnerFrames[SpinnerIndex]
    SpinnerIndex := Mod(SpinnerIndex, SpinnerFrames.Length) + 1
}

UpdateStatus(text) {
    global StatusCtrl
    if IsSet(StatusCtrl)
        StatusCtrl.Value := text
}

HideLoadingScreen() {
    global LoadingGui
    SetTimer(SpinSpinner, 0)
    if IsSet(LoadingGui)
        LoadingGui.Destroy()
}
