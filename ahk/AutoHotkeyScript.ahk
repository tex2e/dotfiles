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
;; CapsLockをCtrlキーにする。
;; Windows上のVirtualBoxにマッピングする用にInsertキーもCtrlキーにする。
;;
Insert::Return

F13 & q::
Insert & q::
  if GetKeyState("Shift") {
    Send ^+q
    return
  }
  Send ^q
  return
F13 & w::
Insert & w::
  if GetKeyState("Shift") {
    Send ^+w
    return
  }
  Send ^w
  return
F13 & r::
Insert & r::
  if GetKeyState("Shift") {
    Send ^+r
    return
  }
  Send ^r
  return
F13 & t::
Insert & t::
  if GetKeyState("Shift") {
    Send ^+t
    return
  }
  Send ^t
  return
F13 & y::
Insert & y::
  if GetKeyState("Shift") {
    Send ^+y
    return
  }
  Send ^y
  return
F13 & i::
Insert & i::
  if GetKeyState("Shift") {
    Send ^+i
    return
  }
  Send ^i
  return
F13 & s::
Insert & s::
  if GetKeyState("Shift") {
    Send ^+s
    return
  }
  Send ^s
  return
F13 & g::
Insert & g::
  if GetKeyState("Shift") {
    Send ^+g
    return
  }
  Send ^g
  return
F13 & l::
Insert & l::
  if GetKeyState("Shift") {
    Send ^+l
    return
  }
  Send ^l
  return
F13 & z::
Insert & z::
  if GetKeyState("Shift") {
    Send ^+z
    return
  }
  Send ^z
  return
F13 & x::
Insert & x::
  if GetKeyState("Shift") {
    Send ^+x
    return
  }
  Send ^x
  return
F13 & c::
Insert & c::
  if GetKeyState("Shift") {
    Send ^+c
    return
  }
  Send ^c
  return
F13 & v::
Insert & v::
  if GetKeyState("Shift") {
    Send ^+v
    return
  }
  Send ^v
  return
F13 & LButton::
Insert & LButton::
  if GetKeyState("Shift") {
    Send ^+{LButton}
    return
  }
  Send ^{LButton}
  return
F13 & Left::
Insert & Left::
  if GetKeyState("Shift") {
    Send ^+{Left}
    return
  }
  Send ^{Left}
  return
F13 & Right::
Insert & Right::
  if GetKeyState("Shift") {
    Send ^+{Right}
    return
  }
  Send ^{Right}
  return
F13 & Up::
Insert & Up::
  if GetKeyState("Shift") {
    Send ^+{Up}
    return
  }
  Send ^{Up}
  return
F13 & Down::
Insert & Down::
  if GetKeyState("Shift") {
    Send ^+{Down}
    return
  }
  Send ^{Down}
  return
F13 & Space::
Insert & Space::
  if GetKeyState("Shift") {
    Winset, Alwaysontop, , A  ; 常に最前面に表示
    return
  }
  Send ^#k          ; Keypirinha (Windows Launcher)
  return
F13 & 1::^1
Insert & 1::^1
F13 & 2::^2
Insert & 2::^2
F13 & 3::
Insert & 3::
  IfWinActive, ahk_exe Code.exe
    Send ^3         ; VSCode
  else
    Send ^/         ; 左手だけでコメントアウト
  return
F13 & 4::
Insert & 4::
  IfWinActive, ahk_exe Code.exe
    Send ^4         ; VSCode
  else
    Send ^+/        ; 左手だけでコメントアウト解除
  return
F13 & 5::^5
Insert & 5::^5
F13 & 6::^6
Insert & 6::^6
F13 & 7::^7
Insert & 7::^7
F13 & 8::^8
Insert & 8::^8
F13 & 9::^9
Insert & 9::^9
F13 & 0::^0
Insert & 0::^0
F13 & ,::^,
Insert & ,::^,
F13 & /::^/
Insert & /::^/


;;
;; カスタムマップ
;;
!s::!PrintScreen    ; 左手だけでスクリーンショット

; 日付の入力
::dd::
  FormatTime,TimeString,,M/d
  Send %TimeString%
  Return
::ddd::
  FormatTime,TimeString,,yyyy/MM/dd
  Send %TimeString%
  Return
::dddd::
  FormatTime,TimeString,,yyyy-MM-dd
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
Insert & Tab:: Send #{Tab}

;;
;; MacOS風のキーボード操作
;;
; IME右クリック > プロパティ > 詳細設定 > 全般 > 編集操作 > キー設定 変更
;   無変換 : IME-オフ
;   変換 : IME-オン
;
F13 & k::
Insert & k::
  if GetKeyState("Shift") {
    Send ^+k
    return
  }
  Send {F7}                       ; Ctrl-kでカタカナに変換
  return
F13 & j::
Insert & j::
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
Insert & f::
  if GetKeyState("Shift") {
    Send ^+f
    return
  }
  Send {Right}                    ; forward_char
  return
F13 & p::
Insert & p::
  if GetKeyState("Shift") {
    Send ^+p
    return
  }
  Send {Up}                       ; previous_line
  return
F13 & n::
Insert & n::
  if GetKeyState("Shift") {
    Send ^+n
    return
  }
  Send {Down}                     ; next_line
  return
F13 & b::
Insert & b::
  if GetKeyState("Shift") {
    Send ^+b
    return
  }
  Send {Left}                     ; backward_char
  return
F13 & a::
Insert & a::
  if GetKeyState("Shift") {
    Send ^+a
    return
  }
  Send {HOME}                     ; move_beginning_of_line
  return
F13 & e::
Insert & e::
  if GetKeyState("Shift") {
    Send ^+e
    return
  }
  Send {END}                      ; move_end_of_line
  return
F13 & d::
Insert & d::
  if GetKeyState("Shift") {
    Send ^+d
    return
  }
  Send {Del}                      ; delete_char
  return
F13 & h::
Insert & h::
  if GetKeyState("Shift") {
    Send ^+h
    return
  }
  Send {BS}                       ; delete_backward_char
  return
F13 & o::
Insert & o::
  if GetKeyState("Shift") {
    Send {HOME}{Enter}{Up}
    return
  }
  Send {END}{Enter}               ; open_line
  return
F13 & m::
Insert & m::
  if GetKeyState("Shift") {
    Send ^+m
    return
  }
  Send {Enter}                    ; newline
  return
F13 & u::
Insert & u::
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
F13 & l::
Insert & l::
  Send !d
  return

; Open Command Window
#c::Send !dcmd{Enter}         ; cmd
!#c::Send !dpowershell{Enter} ; powershell
F13 & g::
Insert & g::
  Send {AppsKey}s             ; gitbash
  return

; Create New Text
; 右クリックの新規作成の内容を編集したいときは ShellNewHandler.exe を使う
^+m::
F13 & m::
Insert & m::
 if GetKeyState("Shift") {
   Send {AppsKey}x{Up}{Up}{Enter}
   return
 }
 Send ^m
 return

#IfWinActive
