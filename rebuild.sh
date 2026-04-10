#!/usr/bin/env bash
# rebuild.sh — 清除并重建所有 stow 符号链接
#
# 用法：
#   bash rebuild.sh                                          # 仅重建公共配置
#   DOTFILES_LOCAL=/path/to/dotfiles-local bash rebuild.sh  # 含私有配置
#
# 如果 DOTFILES_LOCAL 未传入，脚本会自动查找常见路径。

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

info()    { echo "[info]  $*"; }
success() { echo "[ok]    $*"; }
warn()    { echo "[warn]  $*"; }

# ── 自动查找 DOTFILES_LOCAL ───────────────────────────────────────────────────
if [[ -z "${DOTFILES_LOCAL:-}" ]]; then
  for candidate in \
    "$HOME/dotfiles-local" \
    "/Volumes/ssd770/dotfiles-local" \
    "$(dirname "$DOTFILES_DIR")/dotfiles-local"
  do
    if [[ -d "$candidate/.git" ]]; then
      DOTFILES_LOCAL="$candidate"
      info "Found dotfiles-local: $DOTFILES_LOCAL"
      break
    fi
  done
fi

PUBLIC_MODULES=(zsh tmux hammerspoon karabiner)

# ── Step 1: Unstow ────────────────────────────────────────────────────────────
info "Step 1: Unstowing existing symlinks..."

for module in "${PUBLIC_MODULES[@]}"; do
  [[ -d "$DOTFILES_DIR/$module" ]] || continue
  stow --target="$HOME" --dir="$DOTFILES_DIR" -D "$module" 2>/dev/null \
    && info "  Unstowed: $module" || true
done

if [[ -n "${DOTFILES_LOCAL:-}" && -d "$DOTFILES_LOCAL" ]]; then
  stow --target="$HOME" --dir="$DOTFILES_LOCAL" \
    --ignore='pm' --ignore='company' --ignore='README.*' -D . 2>/dev/null \
    && info "  Unstowed: dotfiles-local" || true
fi

# ── Step 2: 清理残留断链 ──────────────────────────────────────────────────────
info "Step 2: Cleaning stale symlinks..."

stale_dirs=(
  "$HOME"
  "$HOME/.zshrc.d"
  "$HOME/.hammerspoon"
  "$HOME/.config/karabiner"
)

for dir in "${stale_dirs[@]}"; do
  [[ -d "$dir" ]] || continue
  while IFS= read -r -d '' link; do
    warn "  Removing stale: $link"
    rm "$link"
  done < <(find "$dir" -maxdepth 1 -type l ! -exec test -e {} \; -print0 2>/dev/null)
done

# ── Step 3: 预建共享目录 ──────────────────────────────────────────────────────
info "Step 3: Preparing shared directories..."

# .zshrc.d 被 dotfiles 和 dotfiles-local 共享，必须是真实目录
if [[ -L "$HOME/.zshrc.d" ]]; then
  rm "$HOME/.zshrc.d"
fi
mkdir -p "$HOME/.zshrc.d"

# ── Step 4: Re-stow ───────────────────────────────────────────────────────────
info "Step 4: Re-stowing..."

for module in "${PUBLIC_MODULES[@]}"; do
  [[ -d "$DOTFILES_DIR/$module" ]] || continue
  stow --target="$HOME" --dir="$DOTFILES_DIR" --restow "$module"
  success "  Stowed: $module"
done

if [[ -n "${DOTFILES_LOCAL:-}" && -d "$DOTFILES_LOCAL" ]]; then
  stow --target="$HOME" --dir="$DOTFILES_LOCAL" \
    --ignore='pm' --ignore='company' --ignore='README.*' --restow .
  success "  Stowed: dotfiles-local"
else
  warn "  DOTFILES_LOCAL not found, skipping private config"
fi

echo ""
success "Rebuild complete."

# ── pm context 检查 ───────────────────────────────────────────────────────────
PM_ACTIVE="$HOME/.config/pm/active"
if [[ -f "$PM_ACTIVE" ]]; then
  success "pm context: $(cat "$PM_ACTIVE")"
else
  warn "pm context not set. Run: pm context use <name>"
fi
