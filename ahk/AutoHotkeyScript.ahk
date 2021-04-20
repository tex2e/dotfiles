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

;;
;; CapsLockをCtrlキーにする
;;
F13 & q::
  if GetKeyState("Shift") {
    Send ^+q
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
F13 & LButton::
  if GetKeyState("Shift") {
    Send ^+{LButton}
    return
  }
  Send ^{LButton}
  return
F13 & Left::
  if GetKeyState("Shift") {
    Send ^+{Left}
    return
  }
  Send ^{Left}
  return
F13 & Right::
  if GetKeyState("Shift") {
    Send ^+{Right}
    return
  }
  Send ^{Right}
  return
F13 & Up::
  if GetKeyState("Shift") {
    Send ^+{Up}
    return
  }
  Send ^{Up}
  return
F13 & Down::
  if GetKeyState("Shift") {
    Send ^+{Down}
    return
  }
  Send ^{Down}
  return
F13 & Space::
  if GetKeyState("Shift") {
    Winset, Alwaysontop, , A  ; 常に最前面に表示
    return
  }
  Send ^#k          ; Keypirinha (Windows Launcher)
  return
F13 & 1::^1
F13 & 2::^2
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
F13 & 5::^5
F13 & 6::^6
F13 & 7::^7
F13 & 8::^8
F13 & 9::^9
F13 & 0::^0
F13 & ,::^,
F13 & /::^/


;;
;; カスタムマップ
;;
!s::!PrintScreen    ; 左手だけでスクリーンショット

; ウィンドウを閉じる
!MButton::!F4

; 日付の入力
::ddd::
  FormatTime,TimeString,,yyyy/MM/dd
  Send %TimeString%
  Return
::dd::
  FormatTime,TimeString,,M/d
  Send %TimeString%
  Return

; Excelで結合セルの複数行に貼り付ける
!+v::
  Sleep, 1000
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
; マウスの第5ボタン(BrowserForward)を押しながら第4ボタン(BrowserBack)でエクスプローラー起動
XButton2 & XButton1::#e
XButton1::Send {XButton1}
XButton2::Send {XButton2}

; プログラム起動のショートカット
#n:: Run, Notepad.exe                       ; Notepad
#c:: Run, cmd.exe, %A_MyDocuments%          ; cmd.exe
!#c:: Run, powershell.exe, %A_MyDocuments%  ; PowerShell

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
    Send {HOME}{Enter}{Up}
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
;; Explorer
;;
#IfWinActive ahk_class CabinetWClass
; Focus Location Editor
F13 & l::Send !d

; Open Command Window
#c::Send !dcmd{Enter}         ; cmd
!#c::Send !dpowershell{Enter} ; powershell
F13 & g::Send {AppsKey}s      ; gitbash

; Create New Text
; 右クリックの新規作成の内容を編集したいときは ShellNewHandler.exe を使う
^+m::
F13 & m::
 if GetKeyState("Shift") {
   Send {AppsKey}x{Up}{Up}{Enter}
   return
 }
 Send ^m
 return

#IfWinActive
