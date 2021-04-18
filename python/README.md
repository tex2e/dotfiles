
# Python

Pythonスクリプト一覧


### 自作スクリプト作成手順

1. .pyファイルを作成し、shebang に `#!/usr/bin/env python3` を記述する
2. .dotfiles/bin/ に呼び出し用Bashファイルを作成する

    ```bash
    #!/bin/bash
    $(dirname $0)/../python/MyScript.py $*
    ```
