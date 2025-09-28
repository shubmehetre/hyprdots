#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# There are 3 different types of shells in bash: the login shell, normal shell
# and interactive shell. Login shells read ~/.profile and interactive shells
# read ~/.bashrc; in our setup, /etc/profile sources ~/.bashrc - thus all
# settings made here will also take effect in a login shell.
#
# NOTE: It is recommended to make language settings in ~/.profile rather than
# here, since multilingual X sessions would not work properly if LANG is over-
# ridden in every subshell.
#
# NOTE: This file is meant for Prompt, shell functions, aliases

# Prompt (with colors)
# In bash, you use \e[...m instead of $fg[...] etc.
PS1="\[\e[1;31m\][\[\e[1;36m\]\w\[\e[1;31m\]]\[\e[0m\] > "

# History
HISTSIZE=500000
HISTFILESIZE=500000
HISTFILE=~/.cache/bash/history
shopt -s histappend # append to history, don’t overwrite
PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# Disable ctrl-s freeze
stty stop undef

# Auto-cd equivalent
shopt -s autocd

# Completion (bash built-in)
if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

# Vi mode
set -o vi
bind -m vi-insert '"\C-r": reverse-search-history'
bind -m vi-insert '"\C-o": "lfcd\n"'
bind '"\C-f": "ffc\n"'
bind -m vi-insert '"\C-e": "\C-x\C-e"'
bind '"\e[3~": delete-char' # Delete key fix (like bindkey '^[[P')

# Use lf to switch directories (ctrl-o)
lfcd() {
  tmp="$(mktemp)"
  lf -last-dir-path="$tmp" "$@"
  if [ -f "$tmp" ]; then
    dir="$(cat "$tmp")"
    rm -f "$tmp" >/dev/null
    [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
  fi
}

# Save path on cd
cd() {
  builtin cd "$@" || return
  pwd >~/.cache/last_dir
}

# Make Ctrl+L clear the screen
bind '"\C-l": clear-screen'

################################################################
#### ALIASES
################################################################
#!/bin/sh

# Use neovim for vim if present.
[ -x "$(command -v nvim)" ] && alias vim="nvim" vdiff="nvim -d"

# sudo not required for some system commands
for command in mount umount sv pacman updatedb su; do
  alias $command="sudo $command"
done
unset command

# autoremove
# alias cleanup="pacman -R --noconfirm $(pacman -Qdtq)"

# Verbosity and settings that you pretty much just always are going to want.
alias \
  cp="cp -v" \
  mv="mv -v" \
  rm="rm -v" \
  bc="bc -ql" \
  mkd="mkdir -pv" \
  yt="yt-dlp --add-metadata -i" \
  yta="yt -x --audio-format opus -f bestaudio/best -o '%(title)s.%(ext)s'" \
  ytao="yt -x -f bestaudio/best -o '%(playlist_index)s-%(title)s.%(ext)s'" \
  ffmpeg="ffmpeg -hide_banner" \
  kindle_mount="mount -o rw,user,uid=1000,gid=998,umask=007"
# yta="yt -x --audio-format opus --cookies-from-browser brave -f bestaudio/best -o '%(title)s.%(ext)s'" \

# Colorize commands when possible.
alias \
  ls="exa -h --color=auto --group-directories-first" \
  l="exa	-al --color=auto --group-directories-first" \
  ll="exa	-al --color=auto --group-directories-first" \
  lll="exa -al --color=auto --group-directories-first" \
  grep="grep --color=auto" \
  diff="diff --color=auto" \
  ccat="highlight --out-format=ansi"

# These common commands are just too long! Abbreviate them.
alias \
  ka="killall" \
  gs="git status" \
  ga="git commit -a" \
  gp="git push" \
  trem="transmission-remote" \
  YT="youtube-viewer" \
  sdn="sudo shutdown -h now" \
  e="$EDITOR" \
  v="$EDITOR" \
  p="sudo pacman" \
  xi="sudo xbps-install" \
  xr="sudo xbps-remove -R" \
  xq="xbps-query" \
  z="zathura" \
  pwn="ssh hacker@pwn.college" \
  nyx="ssh nyx@192.168.1.125" 2>/dev/null
alias \
  magit="nvim -c MagitOnly" \
  ref="shortcuts >/dev/null; source ${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc ; source ${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc" \
  weath="less -S ${XDG_DATA_HOME:-$HOME/.local/share}/weatherreport"
# remaps script
alias remaps="source $HOME/.local/bin/remaps"

# mount sdb1
alias cold="mount /dev/sdb1 $HOME/external/oldie/"
alias ucold="umount -l /dev/sdb1"

# unmute
alias unmute="amixer sset Master unmute"

# play music
alias \
  hood="mpv --shuffle /home/doom/zzz/songs/playlists/The_Hood/ --no-video" \
  home="mpv --shuffle /home/doom/zzz/songs/playlists/Home/" \
  gully="mpv --shuffle /home/doom/zzz/songs/playlists/Bandana_GAnG/" \
  focus="mpv --shuffle /home/doom/zzz/songs/focus/" \
  anon="mpv /home/doom/zzz/songs/focus/Programming\ _\ Coding\ _\ Hacking\ music\ vol.18\ \(ANONYMOUS\ HEADQUARTERS\)-Z-VfaG9ZN_U.opus"

# xclip: always get contents in clipboard
alias xclip="xclip -selection clipboard"

# webserver : racknerd.com.
alias rack="ssh root@107.173.229.10"

# rsync to webserver
# alias syncsite="hugo ; rsync -rtvzP ./public/ root@216.127.171.229:/var/www/shubmehetre --delete"
alias sitesync="hugo -s ~/zzz/repos/main_site/ ; rsync -rtvzP --delete-after ~/zzz/repos/main_site/public/ root@107.173.229.10:/var/www/shubmehetre"

# mpd restart
alias mpdr="systemctl --user restart mpd.service"

# Start promox VM Spice sessions
alias rdp="remote-viewer /home/doom/zzz/files/proxmox_spice_files/*"

# run c code in vim
alias run="clear; gcc % ; ./a.out"

# fzf

ffc() { du -a $HOME $HOME/.config $HOME/.local/bin \
  --exclude '.config/libreoffice' \
  --exclude '.config/BraveSoftware' \
  --exclude '.config/JetBrains' \
  --exclude '.config/joplin-desktop' |
  awk '{print $2}' | fzf | xargs -r $EDITOR; }

ff() { fzf | xargs -r -I {} $EDITOR {}; }

# Timer
timer() {
  (nohup python3 -u "$HOME/.local/bin/timer.py" "$1" >/dev/null 2>&1 &)
}
