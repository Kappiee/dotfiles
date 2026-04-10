export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  fzf-tab
  zsh-autosuggestions
)

# zsh-completions 插件路径（OMZ 加载前注册）
fpath+=${ZSH_CUSTOM:-$ZSH/custom}/plugins/zsh-completions/src
fpath+=$HOME/.oh-my-zsh/custom/zsh-completions

source $ZSH/oh-my-zsh.sh
