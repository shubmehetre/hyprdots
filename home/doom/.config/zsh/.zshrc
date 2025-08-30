# .zshrc for Hyprland setup _ Shub

### --- Environment & Profile ---
[ -f ~/.profile ] && source ~/.profile

###############################################
# History
# #############################################
HISTSIZE=500000
SAVEHIST=500000
HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history"
mkdir -p "$(dirname "$HISTFILE")"
setopt appendhistory
setopt inc_append_history
setopt share_history
setopt hist_ignore_dups

###############################################
# General Options
# #############################################
setopt autocd                    # `cd somedir` → just type somedir
setopt interactive_comments      # allow comments in interactive shell
stty stop undef                  # disable ctrl-s freeze

###############################################
# Shell related Keybindings
# #############################################
bindkey -v                       # vi keybindings
bindkey '^R' history-incremental-search-backward

###############################################
# Shell vars
# #############################################
export KEYTIMEOUT=1

# Better man page pager (search + colors)
export MANPAGER="less -R --use-color -Dd+r -Du+b"
export PAGER="less -R --use-color -Dd+r -Du+b"

# Pretty colors for man
export LESS_TERMCAP_mb=$'\E[1;31m'
export LESS_TERMCAP_md=$'\E[1;36m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_us=$'\E[1;32m'
export LESS_TERMCAP_ue=$'\E[0m'


###############################################
# Vim keys in completion menu
# #############################################
autoload -Uz compinit && compinit # Load completion system

zmodload zsh/complist # Ensure the menuselect keymap exists before binding

# Vim keys in completion menu
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Edit line in vim with Ctrl-e
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

###############################################
# Cursor shape for different modes
# #############################################
function zle-keymap-select {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # block
        viins|main) echo -ne '\e[5 q';; # beam
    esac
}
zle -N zle-keymap-select
zle-line-init() { zle -K viins; echo -ne "\e[5 q"; }
zle -N zle-line-init
echo -ne '\e[5 q'
preexec() { echo -ne '\e[5 q'; }

###############################################
# Plugins via Zinit
# #############################################
source ~/.config/zsh/zinit/zinit.zsh

zinit light zsh-users/zsh-autosuggestions
# zinit light zsh-users/zsh-syntax-highlighting
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light Aloxaf/fzf-tab                # better tab completion
zinit light jeffreytse/zsh-vi-mode        # improves vi-mode UX

# Binds related to plugins
bindkey '^[[Z' autosuggest-accept
###############################################
# Starship Prompt
# #############################################
eval "$(starship init zsh)"

### --- Aliases / External Configs ---
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/aliasrc"

# [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc"
# [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc"

alias ll='ls -lah'
alias gs='git status'
alias v='nvim'
alias grep='grep --color=auto'
alias luamake=/home/doom/zzz/all_repos/lua-language-server/3rd/luamake/luamake

### --- lf (file manager) integration ---
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp" >/dev/null
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
# bindkey -s '^o' '^ulfcd\n'

### --- yazi (file manager) integration ---
yazicd() {
    tmp="$(mktemp -t yazi-cwd.XXXXXX)"
    yazi --cwd-file="$tmp" "$@"
    if [ -f "$tmp" ]; then
        cd "$(cat "$tmp")" || return
        rm -f "$tmp" > /dev/null
    fi
}
bindkey -s '^o' '^uyazicd\n'

# fzf file opener
ffc() {
  local file
  file=$(du -a "$HOME/.config" "$HOME/.local/bin" \
    --exclude="$HOME/.config/libreoffice" \
    --exclude="$HOME/.config/BraveSoftware" \
    --exclude="$HOME/.config/JetBrains" \
    --exclude="$HOME/.config/joplin-desktop" 2>/dev/null | \
    awk '{print $2}' | fzf --height 40% --layout=reverse --border)
  
  if [[ -n "$file" && -f "$file" ]]; then
    "${EDITOR:-vi}" "$file"
  fi
}

# Bind Ctrl+F to insert and run ffc
zvm_after_init() {
  bindkey -s '^f' 'ffc\n'
}

# bindkey -s '^f' 'ffc\n'

### --- Save last path ---
function cd {
    builtin cd "$@" || return
    pwd > ~/.cache/last_dir
}
