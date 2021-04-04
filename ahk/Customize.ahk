; My Dotfiles

;;
;; Explorer
;;
;#IfWinActive ahk_class CabinetWClass
;
;^+m::
;F13 & m::
;  if GetKeyState("Shift") {
;    Send {AppsKey}x{Up}{Up}{Up}{Enter}
;    return
;  }
;  Send ^m
;  return
;
;#IfWinActive
