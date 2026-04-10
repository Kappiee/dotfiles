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
)

join_by() {
  local separator="$1"
  shift
  printf '%s' "$1" "${@/#/$separator}"
}

path=$(join_by ":" "${paths[@]}")
export PATH="$path"
