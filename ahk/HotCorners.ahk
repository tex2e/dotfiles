
;;
;; Hot Corners
;;
#Persistent  ; Keeps script running persisitantly
SetTimer, HotCorners, 0  ; HotCorners is name of timer, will be reset every 0 seconds until process is killed
return
HotCorners:  ; Timer content
CoordMode, Mouse, Screen  ; Coordinate mode - coords will be passed to mouse related functions, with coords relative to entire screen

IsCorner(cornerID)
{
  WinGetPos, X, Y, Xmax, Ymax, Program Manager ; get desktop size
  MouseGetPos, MouseX, MouseY, OutputVarWin, OutputVarControl, 1
  T = 5  ; adjust tolerance value (pixels to corner) if desired
  CornerTopLeft := (MouseY < T and MouseX < T)
  CornerTopRight := (MouseY < T and MouseX > Xmax - T)
  CornerBottomLeft := (MouseY > Ymax - T and MouseX < T)
  CornerBottomRight := ((MouseY > Ymax - T and MouseX > Xmax - T) or (OutputVarControl = "TrayShowDesktopButtonWClass1"))

  if (cornerID = "TopLeft"){
    return CornerTopLeft
  }
  else if (cornerID = "TopRight"){
    return CornerTopRight
  }
  else if (cornerID = "BottomLeft"){
    return CornerBottomLeft
  }
  else if (cornerID = "BottomRight") {
    return CornerBottomRight
  }
}

; Show Task View (Open Apps Overview)
if IsCorner("TopRight")
{
  Send, {LWin down}{a down}
  Send, {LWin up}{a up}
  Loop
  {
    if ! IsCorner("TopRight")
      break ; exits loop when mouse is no longer in the corner
  }
}

; Show Action Center
if IsCorner("BottomRight")
{
  Send, {Esc}#b{Left}{Left}{Enter}
  Loop
  {
    if ! IsCorner("BottomRight")
      break ; exits loop when mouse is no longer in the corner
  }
}
