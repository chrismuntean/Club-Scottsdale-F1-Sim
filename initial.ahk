#Requires AutoHotkey v2.0
#SingleInstance Force

^!x:: {
    ExitKiosk()
}

global SpinnerFrames := ["|", "/", "-", "\"]
global SpinnerIndex := 1

ShowLoadingScreen("Loading FanaLab...")

; Launch FanaLab and give it time to initialize the wheel
Run("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\FanaLab.lnk")
Sleep(8000)

UpdateStatus("Starting Steam...")
Sleep(1500)

UpdateStatus("Opening Assetto Corsa Competizione...")
Run("C:\Program Files (x86)\Steam\steam.exe -applaunch 805550")
ProcessWait("acc.exe", 120)

Sleep(4000)
HideLoadingScreen()

Loop {
    if !ProcessExist("acc.exe") {
        ShowLoadingScreen("Opening Assetto Corsa Competizione...")
        Run("C:\Program Files (x86)\Steam\steam.exe -applaunch 805550")
        ProcessWait("acc.exe", 120)
        Sleep(4000)
        HideLoadingScreen()
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

    ; Spinner, dead center
    LoadingGui.SetFont("s60 cWhite Bold", "Consolas")
    SpinnerCtrl := LoadingGui.Add("Text", "x0 y" (screenH/2 - 120) " w" screenW " Center", "|")

    ; Status line, just below the spinner
    LoadingGui.SetFont("s18 cWhite", "Segoe UI")
    StatusCtrl := LoadingGui.Add("Text", "x0 y" (screenH/2 + 10) " w" screenW " Center", statusText)

    ; Brand, pinned to bottom center
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
    SetTimer(SpinSpinner, 0)  ; stop the spinner timer so it doesn't error on a destroyed control
    if IsSet(LoadingGui)
        LoadingGui.Destroy()
}
