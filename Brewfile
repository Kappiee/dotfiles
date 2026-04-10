# Brewfile
# 用法：brew bundle install
# 检查缺失：brew bundle check

# ── 必须安装 ──────────────────────────────────────────────────────────────────
brew "git"
brew "stow"        # dotfiles 符号链接管理
brew "neovim"      # 编辑器（EDITOR=nvim）
brew "fzf"         # 模糊搜索（fzf-tab 插件 + key-bindings 依赖）
brew "jump"        # j 命令目录跳转
brew "tmux"        # 终端复用器（dotfiles/tmux 配置依赖）
cask "hammerspoon"        # 窗口管理（dotfiles/hammerspoon 配置依赖）
cask "karabiner-elements" # 键盘重映射（dotfiles/karabiner 配置依赖）

# ── 可选（dotfiles 中有引用但有守卫，未安装不影响启动）────────────────────────
# brew "awscli"    # 04-shell.zsh 中配置了 aws_completer 补全
