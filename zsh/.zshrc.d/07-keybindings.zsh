# vi 模式
bindkey -v
export KEYTIMEOUT=1

# 方向键上下按已输入内容搜索历史
# 例如输入 git 再按上键，只显示 git 开头的历史命令
autoload -U up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search
