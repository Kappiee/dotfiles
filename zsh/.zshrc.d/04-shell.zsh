export NVM_DIR="$HOME/.nvm"

# source 脚本列表 — 存在则加载，不存在跳过
shells=(
  "$NVM_DIR/nvm.sh"
  "$NVM_DIR/bash_completion"
  "$HOME/.fzf.zsh"
  "$(brew --prefix fzf 2>/dev/null)/shell/key-bindings.zsh"
)

for _s in "${shells[@]}"; do
  [[ -s "$_s" ]] && source "$_s"
done
unset shells _s

# jump — eval 方式加载，自带 j() 函数和补全
command -v jump &>/dev/null && eval "$(jump shell zsh)"

# AWS CLI
[[ -x /usr/local/bin/aws_completer ]] && complete -C '/usr/local/bin/aws_completer' aws
