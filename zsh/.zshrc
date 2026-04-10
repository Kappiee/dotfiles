# p10k instant prompt — 必须在所有输出之前，保持在文件最顶部
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# 加载所有模块（按文件名顺序）
for _f in "$HOME"/.zshrc.d/*.zsh(N); do source "$_f"; done
# 加载机器专属模块（dotfiles-local stow 到 ~/.zshrc.d/local/，未安装时静默跳过）
for _f in "$HOME"/.zshrc.d/local/*.zsh(N); do source "$_f"; done
unset _f

# p10k 主题 — 必须在文件最末尾
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
