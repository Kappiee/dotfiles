# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
########################## 🔽 ENV 🔽 ###########################
#export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk11/Contents/Home"
#export M2_HOME="$HOME/.m2/wrapper/dists/apache-maven-3.6.3-bin/1iopthnavndlasol9gbrbg6bf2/apache-maven-3.6.3"
#export GOPATH=$HOME/go
#export LANG=en_US.UTF-8
#export EDITOR="nvim"
#export TMUX_TMPDIR=~/.tmux
#export GRAVEYARD="~/.local/share/Trash." # for rip command

# History in cache directory:
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE=~/.zsh_history
#source ~/.secrets
########################## 🔼 ENV 🔼 ##########################


########################## 🔽 PROXY 🔽 #########################
export https_proxy=http://127.0.0.1:33210 http_proxy=http://127.0.0.1:33210 all_proxy=socks5://127.0.0.1:33211
########################## 🔼 PROXY 🔼 #########################


########################## 🔽 PATH 🔽 ###########################
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
${HOME}/.m2/wrapper/dists/apache-maven-3.6.3-bin/1iopthnavndlasol9gbrbg6bf2/apache-maven-3.6.3/bin
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
########################## 🔼 PATH 🔼 ##########################

autoload -U colors && colors


########################## 🔽 OH MY ZSH 🔽 ###########################
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh" 
# source ~/powerlevel10k/powerlevel10k.zsh-theme
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(
  git
)
source $ZSH/oh-my-zsh.sh
########################## 🔼 OH MY ZSH 🔼 ########################### User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
