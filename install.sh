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

# ── Symlinks（stow）──────────────────────────────────────────────────────────
modules=(zsh tmux hammerspoon karabiner)

for module in "${modules[@]}"; do
  target_check="$DOTFILES_DIR/$module"
  [[ ! -d "$target_check" ]] && continue

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

# ── dotfiles-local（可选私有配置）────────────────────────────────────────────
if [[ -n "${DOTFILES_LOCAL_REPO:-}" ]]; then
  DOTFILES_LOCAL="${DOTFILES_LOCAL:-$HOME/dotfiles-local}"
  if [[ ! -d "$DOTFILES_LOCAL/.git" ]]; then
    info "Cloning dotfiles-local..."
    git clone "$DOTFILES_LOCAL_REPO" "$DOTFILES_LOCAL"
  else
    info "Updating dotfiles-local..."
    git -C "$DOTFILES_LOCAL" pull
  fi

  info "Setting up pm context..."
  PM_ACTIVE="$HOME/.config/pm/active"
  if [[ ! -f "$PM_ACTIVE" ]]; then
    mkdir -p "$(dirname "$PM_ACTIVE")"
    echo "zf" > "$PM_ACTIVE"
    success "pm context set to: zf"
  else
    success "pm context already set: $(cat "$PM_ACTIVE")"
  fi

  stow --target="$HOME" --dir="$DOTFILES_LOCAL" --ignore='pm' --ignore='company' --restow .
  success "Stowed: dotfiles-local"
else
  warn "DOTFILES_LOCAL_REPO not set, skipping private config"
  warn "To set up: DOTFILES_LOCAL_REPO=git@github.com:Kappiee/dotfiles-local.git bash install.sh"
fi

echo ""
success "Done. Open a new terminal or run: source ~/.zshrc"
