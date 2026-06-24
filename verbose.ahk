#Requires AutoHotkey v2.0
#SingleInstance Force

LogStep(text) {
    FileAppend(FormatTime() " - " text "`n", "C:\Kiosk\launcher.log")
}

^!x:: {
    ExitKiosk()
}

global SpinnerFrames := ["|", "/", "-", "\"]
global SpinnerIndex := 1

LogStep("Script started")
ShowLoadingScreen("Loading FanaLab...")
Run("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\FanaLab.lnk")
Sleep(8000)

UpdateStatus("Starting Steam...")
Sleep(1500)

UpdateStatus("Opening Assetto Corsa Competizione...")
Run("C:\Program Files (x86)\Steam\steam.exe -applaunch 805550")
LogStep("Steam launch fired, waiting for process")

ProcessWait("acc.exe", 120)
LogStep("acc.exe process detected")

WinWait("ahk_exe acc.exe", , 120)
LogStep("acc.exe window exists")

WinWaitActive("ahk_exe acc.exe", , 120)
LogStep("acc.exe window is active")

Sleep(2000)
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
