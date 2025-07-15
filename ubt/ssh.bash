rm -rf t.bash
vim t.bash
bash t.bash

# 定义变量
USER="root"
PASSWORD="zj123456"
KEY_PATH="$HOME/.ssh/id_rsa.pub"
PRIVATE_KEY_PATH="$HOME/.ssh/id_rsa"
HOSTS=(
    "192.168.182.201"
    "192.168.182.202"
    "192.168.182.203"
    "master"
    "slave1"
    "slave2"
)

# 检查SSH key是否存在，如果不存在则创建一个
if [ ! -f "$KEY_PATH" ]; then
  echo "SSH key not found at $KEY_PATH, creating one..."
  ssh-keygen -t rsa -b 2048 -f "$PRIVATE_KEY_PATH" -N ""
fi

# 遍历所有主机并执行 ssh-copy-id 命令
for HOST in "${HOSTS[@]}"; do
  SSH_COPY_ID_CMD="ssh-copy-id -i $KEY_PATH $USER@$HOST"
  
  expect << EOF
    spawn $SSH_COPY_ID_CMD
    expect {
      "The authenticity of host" {
        send "yes\r"
        exp_continue
      }
      "root@$HOST's password:" {
        send "$PASSWORD\r"
        exp_continue
      }
      "All keys were skipped because they already exist on the remote system" {
        send_user "All keys already exist on $HOST.\n"
        exit 0
      }
      eof
    }
EOF

done
