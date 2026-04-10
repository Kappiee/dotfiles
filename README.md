# dotfiles

macOS 公共配置，使用 GNU Stow 管理符号链接。
机器专属配置由独立私有仓库 [dotfiles-local](https://github.com/Kappiee/dotfiles-local) 管理。

| 目录 | 链接位置 |
|---|---|
| `zsh/` | `~/.zshrc` + `~/.zshrc.d/` |
| `tmux/` | `~/.tmux.conf` + `~/.tmux.d/` |
| `hammerspoon/` | `~/.hammerspoon/` |
| `karabiner/` | `~/.config/karabiner/` |

## 新机器初始化

### 一键安装（推荐）

```bash
git clone git@github.com:Kappiee/dotfiles.git ~/dotfiles
DOTFILES_LOCAL_REPO=git@github.com:Kappiee/dotfiles-local.git bash ~/dotfiles/install.sh
```

`install.sh` 会自动完成：Homebrew → Brewfile → Oh My Zsh + 插件 → stow → dotfiles-local 克隆与配置。

---

### 手动安装

如果只需要公共配置（不含机器专属）：

```bash
git clone git@github.com:Kappiee/dotfiles.git ~/dotfiles
bash ~/dotfiles/install.sh
```

之后按需手动配置 dotfiles-local（见其 README）。

## 日常同步

```bash
git add . && git commit -m "..." && git push
# 另一台机器
git pull
```
