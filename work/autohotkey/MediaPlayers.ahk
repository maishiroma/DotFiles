; AutoHotkey v2 script
; Note that this is for using an Apple Keyboard for Windows

; https://superuser.com/questions/651706/map-fn-home-to-screen-brightness-using-autohotkey
^F1::Run("C:\Users\MatthewShiroma\CLI_Tools\nircmd-x64\nircmd.exe changebrightness -10")
^F2::Run("C:\Users\MatthewShiroma\CLI_Tools\nircmd-x64\nircmd.exe changebrightness +10")

; https://www.itcentralpoint.com/how-to-have-apple-wireless-keyboard-volume-keys-and-others-work-in-windows-10
^F10::Send("{Volume_Mute}")
^F11::Send("{Volume_Down}")
^F12::Send("{Volume_Up}")

; https://www.instructables.com/Keyboard-Media-Controls-for-Windows-with-AutoHotKe/
^F7::Send("{Media_Prev}")
^F8::Send("{Media_Play_Pause}")
^F9::Send("{Media_Next}")