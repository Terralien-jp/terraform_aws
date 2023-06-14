#!/bin/bash

# pm2から現在のPIDを取得
current_pid=$(pm2 jlist | jq '.[] | .pid')

# PIDファイルのパスを指定
pid_file="/path/to/your/pidfile"

# PIDファイルが存在しない場合に新規作成
if [ ! -f "$pid_file" ]; then
    touch "$pid_file"
fi

# ファイルから前回のPIDを読み込む
previous_pid=$(cat "$pid_file")

# 現在のPIDと前回のPIDが一致しない場合
if [ "$current_pid" != "$previous_pid" ]; then
    # エラーメッセージをログに出力
    logger -s "PID has changed from $previous_pid to $current_pid" 2>>/var/log/message
fi

# 現在のPIDをPIDファイルに保存
echo "$current_pid" > "$pid_file" || { echo "Failed to write to $pid_file. Check permissions."; exit 1; }
