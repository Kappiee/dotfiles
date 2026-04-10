#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

info()    { echo "[info]  $*"; }
success() { echo "[ok]    $*"; }
warn()    { echo "[warn]  $*"; }
confirm() {
  read -r -p "$1 [y/N] " reply
  [[ "$reply" =~ ^[Yy]$ ]]
}

# ── Homebrew ─────────────────────────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  success "Homebrew already installed"
fi

# ── Brewfile ─────────────────────────────────────────────────────────────────
info "Installing packages from Brewfile..."
brew bundle --file="$DOTFILES_DIR/Brewfile"
success "Brewfile done"

# ── Oh My Zsh ────────────────────────────────────────────────────────────────
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  info "Installing Oh My Zsh..."
  RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  success "Oh My Zsh already installed"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [[ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]]; then
  info "Installing Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    "$ZSH_CUSTOM/themes/powerlevel10k"
else
  success "Powerlevel10k already installed"
fi

if [[ ! -d "$ZSH_CUSTOM/plugins/fzf-tab" ]]; then
  info "Installing fzf-tab..."
  git clone https://github.com/Aloxaf/fzf-tab "$ZSH_CUSTOM/plugins/fzf-tab"
else
  success "fzf-tab already installed"
fi

if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
  info "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions \
    "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
  success "zsh-autosuggestions already installed"
fi

# ── custom submodule ─────────────────────────────────────────────────────────
info "Initializing custom submodule..."
git -C "$DOTFILES_DIR" submodule update --init --recursive
success "custom submodule ready"

# ── Symlinks（stow）──────────────────────────────────────────────────────────
modules=(zsh tmux hammerspoon karabiner custom)

for module in "${modules[@]}"; do
  target_check="$DOTFILES_DIR/$module"
  [[ ! -d "$target_check" ]] && continue

  # 检测冲突（目标位置已存在真实文件，非 symlink）
  conflicts=()
  while IFS= read -r -d '' file; do
    rel="${file#$target_check/}"
    target="$HOME/$rel"
    if [[ -e "$target" && ! -L "$target" ]]; then
      conflicts+=("$target")
    fi
  done < <(find "$target_check" -maxdepth 1 -mindepth 1 -print0)

  if [[ ${#conflicts[@]} -gt 0 ]]; then
    warn "Following files will conflict with stow $module:"
    for f in "${conflicts[@]}"; do echo "  $f"; done
    if confirm "  Back up and overwrite?"; then
      for f in "${conflicts[@]}"; do
        mv "$f" "${f}.bak"
        info "  Backed up: $f -> ${f}.bak"
      done
    else
      warn "Skipping $module"
      continue
    fi
  fi

  stow --target="$HOME" --dir="$DOTFILES_DIR" --restow "$module"
  success "Stowed: $module"
done

# ── .zshrc.local 由 custom submodule stow 管理，无需单独创建 ──────────────────

echo ""
success "Done. Open a new terminal or run: source ~/.zshrc"
