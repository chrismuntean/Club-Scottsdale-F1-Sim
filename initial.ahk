#Requires AutoHotkey v2.0
#SingleInstance Force

; Launch FanaLab and give it time to initialize the wheel
Run("C:\Program Files (x86)\Fanatec\FanaLab\FanaLab.exe")
Sleep(8000)

; Launch ACC via Steam, skipping the Steam library UI
Run("C:\Program Files (x86)\Steam\steam.exe -applaunch 805550")

; Wait for the game process, then watch it
ProcessWait("acc.exe", 60)
Loop {
    if !ProcessExist("acc.exe") {
        ; Game closed: relaunch, or log out back to the lock screen
        Run("C:\Program Files (x86)\Steam\steam.exe -applaunch 805550")
        ProcessWait("acc.exe", 60)
    }
    Sleep(2000)
}
