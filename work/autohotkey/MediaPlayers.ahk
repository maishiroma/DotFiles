#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Note that this is for using an Apple Keyboard for Windows

;https://superuser.com/questions/651706/map-fn-home-to-screen-brightness-using-autohotkey
^F1::Run C:\Users\matthew.shiroma\bin\nircmd.exe changebrightness -10
^F2::Run C:\Users\matthew.shiroma\bin\nircmd.exe changebrightness +10

;https://www.itcentralpoint.com/how-to-have-apple-wireless-keyboard-volume-keys-and-others-work-in-windows-10
^F10::Volume_Mute
^F11::Volume_Down
^F12::Volume_Up

;https://www.instructables.com/Keyboard-Media-Controls-for-Windows-with-AutoHotKe/
^F7::Send {Media_Prev}
^F8::Send {Media_Play_Pause}
^F9::Send {Media_Next}