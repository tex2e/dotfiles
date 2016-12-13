#!/bin/bash -e

# ランダムな一時ファイル名を生成
filename=`cat /dev/urandom | LC_CTYPE=C tr -dc 'a-z0-9' | head -c 30`

# 標準入力を一時ファイルに保存
cat > "$filename"

# 引数がなければウィンドウにプロット
if [ $# -eq 0 ]
then

gnuplot -p <<EOF
set nokey
plot '$filename' with line
EOF

# 引数があれば png に出力
else

gnuplot <<EOF
set nokey
set terminal png
set output '$1'
plot '$filename' with line
EOF

fi

rm "$filename"
