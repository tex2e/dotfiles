
# Brew

Brewでインストールしたパッケージ一覧の作成と、エイリアスの設定


### インストール手順

1. brewインストール
2. `brew tap homebrew/aliases` でHomebrewエイリアスをインストール
3. `setup-linux.sh` を実行

### Brewfile作成

Brewでインストールしたパッケージ一覧

#### 一覧作成方法

    brew bundle dump --force --global

または

    brew file


#### 一覧復元方法

    brew bundle --global



<br>

### Brew-Graph 導入

不要パッケージ削除のための、依存関係グラフの作成

インストール手順：

```
brew install martido/brew-graph/brew-graph
brew install graphviz
```

依存関係グラフ作成手順：

```
brew graph --installed | dot -Tpng -ograph.png
open graph.png
```
