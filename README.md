# dotfiles

macOS 个人配置，使用 GNU Stow 管理符号链接。

| 目录 | 链接位置 |
|------|----------|
| `zsh/` | `~/.zshrc` + `~/.zshrc.d/` |
| `tmux/` | `~/.tmux.conf` |
| `hammerspoon/` | `~/.hammerspoon/` |
| `karabiner/` | `~/.config/karabiner/` |

## 新机器初始化

**第一步：安装 Homebrew 和 Stow**

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install stow
```

**第二步：克隆并安装所有工具**

```bash
git clone git@github.com:Kappiee/dotfiles.git ~/dotfiles
cd ~/dotfiles
brew bundle          # 根据 Brewfile 一键安装所有依赖
```

**第三步：安装 Oh My Zsh 和插件**

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k

git clone https://github.com/Aloxaf/fzf-tab \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab

git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

**第四步：创建符号链接**

```bash
# 如果 ~/.zshrc 等文件已存在，先备份
mv ~/.zshrc ~/.zshrc.bak

stow --target="$HOME" zsh tmux hammerspoon karabiner
```

**第五步：创建机器专属配置**

`~/.zshrc.local` 不进仓库，用于存放各机器差异化的内容：

```bash
# ~/.zshrc.local 示例
export https_proxy=http://127.0.0.1:7897
export BARK_KEY="xxx"
pm() { node /path/to/pm/product-pm2.js "$@" }
```

## 日常同步

```bash
# 推送
git add . && git commit -m "feat: 更新配置" && git push

# 另一台机器拉取（符号链接已存在，无需重新 stow）
git pull
```
