# ~/.bashrc: executed by bash(1) for non-login shells

# Exit if non-interactive
case $- in
*i*) ;;
*) return ;;
esac

### History ###
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=100000
HISTFILESIZE=200000
shopt -s checkwinsize

### Lesspipe (friendly less) ###
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

### Prompt ###
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi
case "$TERM" in
xterm-color | *-256color) color_prompt=yes ;;
esac
if [ "$color_prompt" = yes ] && [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt
case "$TERM" in
xterm* | rxvt*) PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1" ;;
esac

### Aliases ###
if [ -x /usr/bin/dircolors ]; then
  eval "$(dircolors -b ~/.dircolors 2>/dev/null || dircolors -b)"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"
alias lh="ls -CFh"

# Editors
export PATH="$HOME/.bin:$HOME/.local/bin:/usr/local/go/bin:$PATH"
alias nvim='nvim.appimage'

### Bun ###
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

### NVM ###
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

### Cargo ###
. "$HOME/.cargo/env" 2>/dev/null

### Oh-My-Posh ###
eval "$(oh-my-posh init bash --config ~/.config/theme/minimal.json)"

### Auto-start tmux ###
if command -v tmux >/dev/null 2>&1; then
  if [ -z "$TMUX" ] && [ "$TERM_PROGRAM" != "vscode" ]; then
    tmux attach-session -t work || tmux new-session -s work
  fi
fi
