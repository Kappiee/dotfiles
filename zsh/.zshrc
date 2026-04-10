# p10k instant prompt — 必须在所有输出之前，保持在文件最顶部
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# 加载所有模块（按文件名顺序）
for _f in "$HOME"/.zshrc.d/*.zsh; do
  source "$_f"
done
unset _f

# 机器专属配置（不进仓库，各机器自行维护）
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# p10k 主题 — 必须在文件最末尾
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
