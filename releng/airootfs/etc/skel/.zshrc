# ~/.zshrc - simple friendly zsh setup
export TERM=xterm-256color
export LANG=C.UTF-8
# prompt: simple
PROMPT='%F{green}%n@%m%f:%F{blue}%~%f %# '
# basic aliases
alias ll='ls -la'
alias la='ls -A'
# useful PATH additions (if needed)
if [ -d "$HOME/.local/bin" ]; then
  PATH="$HOME/.local/bin:$PATH"
fi
# load completion if available
if [ -f /usr/share/zsh/site-functions/_git ]; then
  autoload -U compinit && compinit
fi
