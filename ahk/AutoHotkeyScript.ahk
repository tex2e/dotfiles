#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

EnvGet, homedir, USERPROFILE

; 編集したらスタートアップに再登録する
; 1. AutoHotkeyScript.ahk を右クリックし、Compile Script を実行
; 2. win + R で「shell:startup」を入力
; 3. 常駐しているAutoHotkeyScriptの停止
; 4. AutoHotkeyScript.exe をスタートアップに移動


#Include Customize.ahk

;;
;; CapsLockをCtrlキーにする
;;
F13 & q::
  if GetKeyState("Shift") {
    Send ^+f
    return
  }
  Send ^q
  return
F13 & w::
  if GetKeyState("Shift") {
    Send ^+w
    return
  }
  Send ^w
  return
F13 & r::
  if GetKeyState("Shift") {
    Send ^+r
    return
  }
  Send ^r
  return
F13 & t::
  if GetKeyState("Shift") {
    Send ^+t
    return
  }
  Send ^t
  return
F13 & y::
  if GetKeyState("Shift") {
    Send ^+y
    return
  }
  Send ^y
  return
F13 & i::
  if GetKeyState("Shift") {
    Send ^+i
    return
  }
  Send ^i
  return
F13 & s::
  if GetKeyState("Shift") {
    Send ^+s
    return
  }
  Send ^s
  return
F13 & g::
  if GetKeyState("Shift") {
    Send ^+g
    return
  }
  Send ^g
  return
F13 & l::
  if GetKeyState("Shift") {
    Send ^+l
    return
  }
  Send ^l
  return
F13 & z::
  if GetKeyState("Shift") {
    Send ^+z
    return
  }
  Send ^z
  return
F13 & x::
  if GetKeyState("Shift") {
    Send ^+x
    return
  }
  Send ^x
  return
F13 & c::
  if GetKeyState("Shift") {
    Send ^+c
    return
  }
  Send ^c
  return
F13 & v::
  if GetKeyState("Shift") {
    Send ^+v
    return
  }
  Send ^v
  return
F13 & LButton::Send ^{LButton}
F13 & Left::Send ^{Left}
F13 & Right::Send ^{Right}
F13 & Up::Send ^{Up}
F13 & Down::Send ^{Down}
F13 & Space::Send ^{Space}
F13 & 1::^1
F13 & 5::^5
F13 & 6::^6
F13 & 0::^0
F13 & ,::^,
F13 & F1::Send ^{F1}
F13 & F2::Send ^{F2}
F13 & F3::Send ^{F3}


;;
;; カスタムマップ
;;
!s::!PrintScreen    ; 左手だけでスクリーンショット
F13 & 3::
  IfWinActive, ahk_exe Code.exe
    Send ^3         ; VSCode
  else
    Send ^/         ; 左手だけでコメントアウト
  return
F13 & 4::
  IfWinActive, ahk_exe Code.exe
    Send ^4         ; VSCode
  else
    Send ^+/        ; 左手だけでコメントアウト解除
  return

; 日付のリマップ
::ddd::
  FormatTime,TimeString,,yyyy/MM/dd
  Send %TimeString%
  Return
::dd::
  FormatTime,TimeString,,M/d
  Send %TimeString%
  Return


; Excelの複数行の結合セルに貼り付ける
!+v::
  Critical
  SetKeyDelay, 0
  Loop, parse, clipboard, `n, `r
  {
    line := StrReplace(A_LoopField, "`t")
    Send {F2}%line%{Enter}
  }
  Return

; Shift+ホイールで左右にスクロール
+WheelDown::WheelRight
+WheelUp::WheelLeft

; マウスの第4ボタン(BrowserBack)を押しながら第5ボタン(BrowserForward)でEnter
; ダイアログにEnterを入力したいけどマウスを動かしたくない＆マウスから手を放したくない人向け
XButton1 & XButton2::Send {Enter}
XButton1::Send {XButton1}
XButton2::Send {XButton2}

; プログラム起動のショートカット
#n:: Run, Notepad.exe                       ; Notepad
#c:: Run, cmd.exe, %A_MyDocuments%          ; cmd.exe
!#c:: Run, powershell.exe, %A_MyDocuments%  ; PowerShell
;#q:: DllCall("PowrProf\SetSuspendState", "int", 0, "int", 1, "int", 0) ; Sleep

; Ctrl+Tabでタスクビュー
F13 & Tab:: Send #{Tab}

;;
;; MacOS風のキーボード操作
;;
; IME右クリック > プロパティ > 詳細設定 > 全般 > 編集操作 > キー設定 変更
;   無変換 : IME-オフ
;   変換 : IME-オン
;
F13 & k::
if GetKeyState("Shift") {
    Send ^+k
    return
  }
  Send {F7}                       ; Ctrl-kでカタカナに変換
  return
F13 & j::
  if GetKeyState("Shift") {
    Send ^+j
    return
  }
  Send {F6}                       ; Ctrl-jでひらがなに変換
  return
vkE2::_                           ; アンダースコアをShiftなしで入力する

;;
;; Emacs風のキー入力
;;
F13 & f::
  if GetKeyState("Shift") {
    Send ^+f
    return
  }
  Send {Right}                    ; forward_char
  return
F13 & p::
  if GetKeyState("Shift") {
    Send ^+p
    return
  }
  Send {Up}                       ; previous_line
  return
F13 & n::
  if GetKeyState("Shift") {
    Send ^+n
    return
  }
  Send {Down}                     ; next_line
  return
F13 & b::
  if GetKeyState("Shift") {
    Send ^+b
    return
  }
  Send {Left}                     ; backward_char
  return
F13 & a::
  if GetKeyState("Shift") {
    Send ^+a
    return
  }
  Send {HOME}                     ; move_beginning_of_line
  return
F13 & e::
  if GetKeyState("Shift") {
    Send ^+e
    return
  }
  Send {END}                      ; move_end_of_line
  return
F13 & d::
  if GetKeyState("Shift") {
    Send ^+d
    return
  }
  Send {Del}                      ; delete_char
  return
F13 & h::
  if GetKeyState("Shift") {
    Send ^+h
    return
  }
  Send {BS}                       ; delete_backward_char
  return
F13 & o::
  if GetKeyState("Shift") {
    Send ^+o
    return
  }
  Send {END}{Enter}               ; open_line
  return
F13 & m::
  if GetKeyState("Shift") {
    Send ^+m
    return
  }
  Send {Enter}                    ; newline
  return
F13 & u::
  if GetKeyState("Shift") {
    Send ^+u
    return
  }
  Send ^z                         ; undo
  return


;;
;; 選択文字を「"」「'」「()」で囲む処理
;;

F13 & 7:: Enclose("'", "'")
F13 & 2::
  IfWinActive, ahk_exe Code.exe
    Send ^2                       ; VSCode
  else
    Enclose("""", """")
  return
F13 & 8:: Enclose("(", ")")
F13 & 9:: Enclose("(", ")")

Enclose(begin, end) {
  oldClipboard = %Clipboard%
  Clipboard =
  Send, ^c
  ClipWait
  If (!ErrorLevel) {
    StringRight, LastChar, Clipboard, 1
    If (LastChar != "`n") {
      WinGetTitle, CurrentWinTitle
      Clipboard = %begin%%Clipboard%%end%
      ClipWait
      WinActivate, %CurrentWinTitle%
      Send, ^v
      Sleep 150
    }
    Clipboard = %oldClipboard%
  }
  Return
}


;;
;; Explorer
;;
#IfWinActive ahk_class CabinetWClass
; Focus Location Editor
F13 & l::Send !d

; Open Command Window
#c::Send !dcmd{Enter}
!#c::Send !dpowershell{Enter}
F13 & g::Send {AppsKey}s      ; gitbash

#IfWinActive
