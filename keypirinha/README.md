
# Keypirinha

Windows用アプリ起動ランチャーの設定


### インストール手順

1. [Keypirinha](https://keypirinha.com/download.html) をダウンロード
2. %USERPROFILE%\Documents\Apps\ に Keypirinha フォルダを配置
3. setup-win-adin.cmd を管理者権限で実行
4. %USERPROFILE%\Documents\Apps\Keypirinha\keypirinha.exe を実行
    - 以降はWindows起動時に開始されます

### 検索対象

以下のフォルダが検索対象に含まれるため、事前にフォルダを作成しておくこと
- %USERPROFILE%\Documents\Apps\
- %USERPROFILE%\Desktop\shortcuts\


### 注意事項

- Keypirinhaの検索でヒットするようにしたい場合は、指定のフォルダに exe やショートカットなどのファイルを配置すること
  - Exeファイルは「%AppData%\Microsoft\Windows\Start Menu」直下もしくは「Documents\Apps\」内に配置
  - その他ファイルは「Desktop\shortcuts\」内に配置
