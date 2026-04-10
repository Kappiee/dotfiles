paths=(
  /usr/local/bin
  /usr/bin
  /bin
  /usr/sbin
  /sbin
  /Library/Apple/usr/bin
  /opt/homebrew/bin
  /opt/homebrew/sbin
  /opt/local/bin
  /opt/local/sbin
  ${HOME}/.local/bin
  ${HOME}/go/bin
  ${HOME}/.cargo/bin
  /opt/local/lib/postgresql15/bin
  ${HOME}/Library/Python/3.9/bin
)

join_by() {
  local separator="$1"
  shift
  printf '%s' "$1" "${@/#/$separator}"
}

path=$(join_by ":" "${paths[@]}")
export PATH="$path"

# nvm — 管理 node 版本，影响 PATH 中 node 的指向
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
