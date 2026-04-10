autoload -U colors && colors

# zsh 核心补全系统初始化
autoload bashcompinit && bashcompinit
autoload -U compinit
zmodload zsh/complist
compinit
_comp_options+=(globdots)
