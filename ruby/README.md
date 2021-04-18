
# Ruby

Rubyスクリプト一覧


### 自作スクリプト作成手順

1. .rbファイルを作成し、shebang に `#!/usr/bin/env ruby` を記述する
2. .dotfiles/bin/ に呼び出し用Bashファイルを作成する

    ```bash
    #!/bin/bash
    $(dirname $0)/../ruby/MyScript.rb $*
    ```
