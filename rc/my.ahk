#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
; SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#IfWinActive ahk_class ConsoleWindowClass

^v:: ;;paste in command window
Send !{Space}ep
return

^w:: ;;delete previous word
Send ^{BackSpace}
Return

^u::   ;;erase to start of line
Send ^{Home}
Return

^k::   ;;erase to end of line
Send {F4}{End}
Return

^a::   ;;move to start of line
Send {Home}
Return

^e::   ;;move to end of line
Send {End}
Return

^f::   ;; move one word forward
Send ^{Right}
Return

^b::   ;;move one word back
Send ^{Left}
Return

#IfWinActive

#IfWinActive, ahk_class OMain ahk_exe MSACCESS.EXE
^a::
Send ^+{Right}
Send ^{Home}
Send ^+{End}
Return
#IfWinActive
