#Requires AutoHotkey v2.0

; Send <Alt+F13> with <Alt+Escape> - Windows 11
; Allows to use <Alt+Escape> mapping in Neovim on Windows 11
!Esc::
{
  static skip := false

  if skip
    return

  skip := true

  SendInput("!{F13}")
  KeyWait("Esc")

  skip := false
}

; <Super+`> open WT
#`:: {
  ; Windows Terminal class
  winTitle := "ahk_class CASCADIA_HOSTING_WINDOW_CLASS"

  if WinActive(winTitle) {
    ; Minimize if already focused
    WinMinimize(winTitle)
  }
  else if WinExist(winTitle) {
    ; Focus existing terminal
    WinActivate(winTitle)
  }
  else {
    Run("C:\Users\" . A_Username . "\AppData\Local\Microsoft\WindowsApps\wt.exe")
    ; Wait for up to 1 second (10 * 100ms)
    Loop 10 {
      Sleep 100
      if WinExist(winTitle) {
        WinActivate(winTitle)
        break
      }
    }
  }
}
