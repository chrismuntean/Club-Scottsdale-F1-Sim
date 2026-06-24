#Requires AutoHotkey v2.0
#SingleInstance Force

^!x::ExitKiosk()  ; Ctrl+Alt+X closes the launcher

ShowLoadingScreen()

; Launch FanaLab and give it time to initialize the wheel
Run("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\FanaLab.lnk")
Sleep(8000)

; Launch ACC via Steam
Run("C:\Program Files (x86)\Steam\steam.exe -applaunch 805550")
ProcessWait("acc.exe", 60)

HideLoadingScreen()

Loop {
    if !ProcessExist("acc.exe") {
        ShowLoadingScreen()
        Run("C:\Program Files (x86)\Steam\steam.exe -applaunch 805550")
        ProcessWait("acc.exe", 60)
        HideLoadingScreen()
    }
    Sleep(2000)
}

ShowLoadingScreen() {
    global LoadingGui
    LoadingGui := Gui("-Caption +AlwaysOnTop +ToolWindow")
    LoadingGui.BackColor := "0D0D0D"

    screenW := A_ScreenWidth
    screenH := A_ScreenHeight

    LoadingGui.SetFont("s40 cWhite Bold", "Segoe UI")
    LoadingGui.Add("Text", "x0 y" (screenH/2 - 60) " w" screenW " Center", "Loading game...")

    LoadingGui.SetFont("s14 c808080", "Segoe UI")
    LoadingGui.Add("Text", "x0 y" (screenH/2 + 10) " w" screenW " Center", "Auto-launcher by chrismuntean.dev")

    LoadingGui.Show("x0 y0 w" screenW " h" screenH)
}

HideLoadingScreen() {
    global LoadingGui
    if IsSet(LoadingGui)
        LoadingGui.Destroy()
}
