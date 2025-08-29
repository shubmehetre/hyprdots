#!/bin/zsh

# profile file. Runs on login. Environmental variables are set here.

# If you don't plan on reverting to bash, you can remove the link in ~/.profile
# to clean up.

echo "profile: start $(date +%s.%N)" >> ~/.cache/login-timing.log
# Adds `~/.local/bin` to $PATH and also .local/bin/'s subfolders
# Below may cause late startups. need to test
# export PATH="$PATH:${$(find ~/.local/bin -type d -printf %p:)%:*}" 
export PATH="$PATH:$HOME/.local/bin"
# export PATH="$PATH:${$(find ~/.local/bin -type d -printf %p:)%:*}:${$(find ~/zzz/software -type d -printf %p:)%:*}"
echo "profile: after path $(date +%s.%N)" >> ~/.cache/login-timing.log

unsetopt PROMPT_SP

# Default programs:
export EDITOR="nvim"
export TERMINAL="ghostty"
export BROWSER="firefox"
export GPG_TTY=$(tty)

# ~/ Clean-up:
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_SRC_HOME="$HOME/.local/src"
export XDG_CACHE_HOME="$HOME/.cache"
export GTK2_RC_FILES="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-2.0/gtkrc-2.0"
export LESSHISTFILE="-"
export WGETRC="${XDG_CONFIG_HOME:-$HOME/.config}/wget/wgetrc"
export INPUTRC="${XDG_CONFIG_HOME:-$HOME/.config}/shell/inputrc"
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
export NVIM_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
export PASSWORD_STORE_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/password-store"
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"
export HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/history"

# Other program settings:
export FZF_DEFAULT_OPTS="--layout=reverse --height 40%"
export LESS=-R
export LESS_TERMCAP_mb="$(printf '%b' '␛[1;31m')"
export LESS_TERMCAP_md="$(printf '%b' '␛[1;36m')"
export LESS_TERMCAP_me="$(printf '%b' '␛[0m')"
export LESS_TERMCAP_so="$(printf '%b' '␛[01;44;33m')"
export LESS_TERMCAP_se="$(printf '%b' '␛[0m')"
export LESS_TERMCAP_us="$(printf '%b' '␛[1;32m')"
export LESS_TERMCAP_ue="$(printf '%b' '␛[0m')"
export LESSOPEN="| /usr/bin/highlight -O ansi %s 2>/dev/null"
export QT_QPA_PLATFORMTHEME="qt5ct"	# Have QT use gtk2 theme.
export MOZ_USE_XINPUT2="1"		# Mozilla smooth scrolling/touchpads.

echo "profile: before uwsm $(date +%s.%N)" >> ~/.cache/login-timing.log
# Start Hyprland
if [ -z "$XDG_SESSION_TYPE" ]; then
  if uwsm check may-start; then
    exec uwsm start hyprland.desktop
  fi
fi

