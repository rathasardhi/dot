###################################Functions##########################################################


# Source global definitions
if [ -f /etc/bashrc ]; then
       . /etc/bashrc

fi

# Safe and colorized file operations
#alias cp='cp -i'          # Prompt before overwrite
alias mv='mv -i'
alias rm='rm -i'          # Confirm before deleting
alias mkdir='mkdir -p'    # Avoid errors if folder exists

# List with colors, sizes, dates
alias ls='ls --color=auto'
alias ll='ls -lhF'        # Long listing, human-readable sizes
alias la='ls -A'          # All except . and ..
alias l='ls -CF'          # Column output

# Fast directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Clear screen
alias c='clear'

alias df='df -h'           # Disk usage
alias du='du -h'           # Directory sizes
alias free='free -h'       # RAM usage
alias psu='ps aux | less'  # See running processes
alias ports='ss -tulwn'    # Listening ports
alias top='htop'           # Use htop if installed
alias ip='ip -c a'         # Colored IP info

alias update='sudo apt update'
alias upgrade='sudo apt upgrade'
alias install='sudo apt install'
alias remove='sudo apt remove'
alias autoremove='sudo apt autoremove'
alias search='apt search'
alias show='apt show'
alias cleanup='sudo apt autoclean && sudo apt autoremove'


alias docs='cd ~/Documents'
alias dls='cd ~/Downloads'
alias proj='cd ~/Projects'
alias rtconf='nano ~/.rtorrent.rc'
alias brc='nano ~/.bashrc'
alias src='source ~/.bashrc'


alias pingg='ping google.com'
alias myip='curl ifconfig.me'
alias flushdns='sudo systemd-resolve --flush-caches'


alias rmall='rm -rf'             # BE VERY CAREFUL
alias chx='chmod +x'             # Make file executable
alias sdn='shutdown now'
alias rs='reset'                 # Reset terminal if it breaks



# shell options

set -o noclobber


# font fix
alias xt='xterm -bg black -fg white &'

# BitchX settings
export IRCNAME="frnk"


# Expand the history size
export HISTFILESIZE=1000000
export HISTSIZE=500000000

# Set the default editor
export EDITOR=vim
export VISUAL=vim
eval "$(zoxide init bash)"  # or zsh if you use zsh




# Set up fzf key bindings and fuzzy completion
eval "$(fzf --bash)"

source /home/ak/.scripts/fzf-tab-completion/bash/fzf-bash-completion.sh
source /home/ak/bin/bashc
bind -x '"\t": fzf_bash_completion'

# alias to show the date
alias da='date "+%Y-%m-%d %A %T %Z"'
alias m='mpv'


# Source pywal colors (required)
[ -f "${HOME}/.cache/wal/colors.sh" ] && source "${HOME}/.cache/wal/colors.sh"

hex_to_rgb() {
    hex="${1#"#"}"  # Remove leading #
    r=$((16#${hex:0:2}))
    g=$((16#${hex:2:2}))
    b=$((16#${hex:4:2}))
    echo "$r;$g;$b"
}

# Convert pywal color15 and color2 to RGB
fg_rgb=$(hex_to_rgb "$color15")
symbol_rgb=$(hex_to_rgb "$color2")

# Set PS1: 2 lines — first is prompt, second is where you type
PS1="\[\e[38;2;${fg_rgb}m\]\w\n\[\e[38;2;${symbol_rgb}m\]\$\[\e[0m\] "





vpn (){
sudo openvpn /home/ak/Downloads/vpn/nl-free-1.protonvpn.udp.ovpn
}




cdf() {
  local dir
  dir=$(find . -type d 2> /dev/null | fzf +m) && cd "$dir"
}







alias vf='nvim $(fzf)'





loader ()
{

instaloader  --no-videos --no-captions --no-metadata-json --no-compress-json --count 100  $1

}


fdisk() {
      sudo fdisk -l
}

tm() {
timedatectl show-timesync


}



# Directory navigation aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias f='fish'
alias v='nvim'

#export PATH=$PATH:.bin/
export PATH=$PATH:/mount/500g/scripts/
export PATH=$PATH:/home/ak/.bin/
PS1='[\u@\h \w \D{%Y-%m-%d %H:%M:%S}] \$ '  # Date in YYYY-MM-DD HH:MM:SS format
#export TERM=rxvt-256color


# Created by `pipx` on 2025-06-04 11:13:31
export PATH="$PATH:/home/ak/.local/bin"
export PATH="$PATH:/home/ak/bin"
[[ -f "$HOME/.cache/wal/colors.sh" ]] && source "$HOME/.cache/wal/colors.sh"
# Load pywal colors
[ -f "${HOME}/.cache/wal/colors.sh" ] && source "${HOME}/.cache/wal/colors.sh"

# Convert hex to RGB
hex_to_rgb() {
    hex="${1#"#"}"
    r=$((16#${hex:0:2}))
    g=$((16#${hex:2:2}))
    b=$((16#${hex:4:2}))
    echo "$r;$g;$b"
}

# Generate RGB from pywal colors
fg_rgb=$(hex_to_rgb "$color15")
symbol_rgb=$(hex_to_rgb "$color2")

# Set 2-line prompt
export PS1="\[\e[38;2;${fg_rgb}m\]\w\n\[\e[38;2;${symbol_rgb}m\]\$\[\e[0m\] "
# Load pywal LS_COLORS
[ -f "$HOME/.cache/wal/lscolors" ] && eval "$(cat "$HOME/.cache/wal/lscolors")"
alias ls='ls --color=auto'
#export GDK_SCALE=1
#export GDK_DPI_SCALE=1.25
#export QT_SCALE_FACTOR=1.25
bind '"\C-l": "\C-u reset\C-m"'
export TERM=xterm-256color
#set -o vi
export NNN_PLUG='p:preview-tui'
export NNN_FIFO='/tmp/nnn.fifo'
export NNN_PLUG='v:video-preview'
export NNN_PLUG='t:nnn-thumbs'
export NNN_PLUG='g:nnn-grid-thumbs'

#alias gemma="python3 ~/ai_assistant_gemma_chat.py"
