complete -cf sudo
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
export HISTCONTROL=ignoredups




export TERM=xterm-256color

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
alias open="xdg-open"
alias f="fish"
alias ll='ls -laht'
alias l='ls -aC'
alias df='df -h'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'
# Aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias cdm='cd /mount/500g/Media/music'

shopt -u autocd
shopt -u cdspell
blk='\[\033[01;30m\]'   # Black
red='\[\033[01;31m\]'   # Red
grn='\[\033[01;32m\]'   # Green
ylw='\[\033[01;33m\]'   # Yellow
blu='\[\033[01;34m\]'   # Blue
pur='\[\033[01;35m\]'   # Purple
cyn='\[\033[01;36m\]'   # Cyan
wht='\[\033[01;37m\]'   # White
clr='\[\033[00m\]'      # Reset
#set -o vi
# Press c to clear the terminal screen.
alias c='clear'

# Press h to view the bash history.
alias h='history'

# Display the directory structure better.
alias tree='tree --dirsfirst -F'
function find_largest_files() {
    du -h -x -s -- * | sort -r -h | head -20;
}



alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'
# This is GOLD for finding out what is taking so much space on your drives!
alias diskspace="du -S | sort -n -r |more"
# Show me the size (sorted) of only the folders in this directory
alias folders="find . -maxdepth 1 -type d -print | xargs du -sk | sort -rn"





#Functions
phone ()
{
ssh -p 8022 localhost@192.168.29.202
}

lapt ()
{
ssh ak@192.168.29.241
}





cdf ()
{
cd "$(find -type d | fzf)"
}

fopen ()
{
xdg-open "$(find -type f | fzf)"

}

today()
{
    echo This is a `date +"%A %d in %B of %Y (%r)"` return
}



mkcd ()
{
  mkdir -p -- "$1" && cd -P -- "$1"
}


  rsong() {

    song=`ls /home/ak/mp3 | sort -R | head -n 1`

    songfile=/home/ak/mp3/$song

    echo $song

    mpv  "$songfile"


}


  run() {

number=$1

shift

for i in `seq $number`; do

  $@

done

} 

mi()

{

cd /mount/500g/dl/incom/inco/ ;
ls *.mp4 &&  mpv "$(fzf -e --keep-right --layout=reverse )"

}



 

mM()

{

cd /mount/500g/Media/MOVIES ;
ls *.mkv &&  mpv "$(fzf -e --keep-right --layout=reverse)"

}



mm()

{

cd /mount/500g/Media/music ;
ls *.mkv &&  mpv "$(fzf -e --keep-right --layout=reverse)"


}





ms()

{

cd /mount/500g/Media/shows ;
ls *.mkv &&  mpv "$(fzf -e --keep-right --layout=reverse)"


}





mu()

{

cd /mount/500g/Media/.ul ;
ls *.mkv &&  mpv "$(fzf -e --keep-right --layout=reverse)"

}



mx()

{

cd /mount/500g/.x2 ;
ls *.mkv &&  mpv "$(fzf -e --keep-right --layout=reverse )"

}



m3()

{

cd /home/ak/mp3 ;
ls *.mkv &&  mpv "$(fzf -e --keep-right --layout=reverse )"


}







m3d()

{

cd /mount/500g/Media/music/ ;
while [ 0 ] ; do mpv "$(ls *.opus | dmenu -l 20  -fn Hack-18)" ; done


}



music()
{
while [ 0 ]
do
cd /mount/500g/Media/music

cd "$(ls | fzf)"
ls
mpv --no-video "$(find -type f | fzf)"




#cd "$(ls | fzf)"

#mpv "$(ls | fzf)"
done

}

 play_song()

 {
    mpg123 "$1"
}








bind -x '"\C-x\C-h":__man'
 __man(){ man $(awk '{print $1}'<<<$READLINE_LINE);}





# minimal but extremely useful prompt for long scroll histories
export PS1=`printf "\033[40m$ \033[32m"`



# bind ctrl-r/s to up/down



#PS1="\u@\h:\w$ "
# Base16 Shell
#BASE16_SHELL="$HOME/.config/base16-shell/"
#[ -n "$PS1" ] && \
 #   [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
  #      source "$BASE16_SHELL/profile_helper.sh"



alias catf='cat "$(fzf)"'

alias vimf='vim "$(fzf)"'


alias install='sudo pacman -S' 


alias mpvf='mpv "$(fzf)"'




set show-all-if-ambiguous on
set completion-ignore-case on





# Easy extract
extract () {
  if [ -f $1 ] ; then
    case $1 in
        *.tar.bz2)   tar xvjf $1    ;;
        *.tar.gz)    tar xvzf $1    ;;
        *.bz2)       bunzip2 $1     ;;
        *.rar)       rar x $1       ;;
        *.gz)        gunzip $1      ;;
        *.tar)       tar xvf $1     ;;
        *.tbz2)      tar xvjf $1    ;;
        *.tgz)       tar xvzf $1    ;;
        *.zip)       unzip $1       ;;
        *.Z)         uncompress $1  ;;
        *.7z)        7z x $1        ;;
        *)           echo "don't know how to extract '$1'..." ;;
    esac
else
    echo "'$1' is not a valid file!"
fi
}

HISTFILESIZE=40000
HISTSIZE=40000
HISTTIMEFORMAT="[%Y-%m-%d %H:%M:%S] "
HISTCONTROL="ignoreboth"



# green prompt on my machine, yellow prompt on remotes
if [ -n "$SSH_CLIENT" ]; then
    export PS1='\[\e[1;33m\][\u@\h \W]\$\[\e[0m\] '
else
    export PS1='\[\e[1;32m\][\u@\h \W]\$\[\e[0m\] '
fi





export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

export HISTFILESIZE=20000
export HISTSIZE=10000
shopt -s histappend
# Combine multiline commands into one in history
shopt -s cmdhist
# Ignore duplicates, ls without options and builtin commands
HISTCONTROL=ignoredups
export HISTIGNORE="&:ls:[bf]g:exit"#
# don't put duplicate lines in the history. See bash(1) for more options
HISTCONTROL=ignoredups
# ... and ignore same sucessive entries.
HISTCONTROL=ignoreboth




function fawk {
    first="awk '{print "
    last="}'"
    cmd="${first}\$${1}${last}"
    eval $cmd
}






# smart advanced completion, download from
# http://bash-completion.alioth.debian.org/
if [[ -f $HOME/local/bin/bash_completion ]]; then
    . $HOME/local/bin/bash_completion
fi



function __setprompt {
  local BLUE="\[\033[0;34m\]"
  local NO_COLOUR="\[\033[0m\]"
  local SSH_IP=`echo $SSH_CLIENT | awk '{ print $1 }'`
  local SSH2_IP=`echo $SSH2_CLIENT | awk '{ print $1 }'`
  if [ $SSH2_IP ] || [ $SSH_IP ] ; then
    local SSH_FLAG="@\h"
  fi
  PS1="$BLUE[\$(date +%H:%M)][\u$SSH_FLAG:\w]\\$ $NO_COLOUR"
  PS2="$BLUE>$NO_COLOUR "
  PS4='$BLUE+$NO_COLOUR '
}
__setprompt
cl()
{
        last_dir="$(ls -Frt | grep '/$' | tail -n1)"
        if [ -d "$last_dir" ]; then
                cd "$last_dir"
        fi
}



bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'

if [ -f /etc/bash_completion ]; then
   . /etc/bash_completion
fi

LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=00:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.7z=01;31:*.ace=01;31:*.alz=01;31:*.apk=01;31:*.arc=01;31:*.arj=01;31:*.bz=01;31:*.bz2=01;31:*.cab=01;31:*.cpio=01;31:*.crate=01;31:*.deb=01;31:*.drpm=01;31:*.dwm=01;31:*.dz=01;31:*.ear=01;31:*.egg=01;31:*.esd=01;31:*.gz=01;31:*.jar=01;31:*.lha=01;31:*.lrz=01;31:*.lz=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.lzo=01;31:*.pyz=01;31:*.rar=01;31:*.rpm=01;31:*.rz=01;31:*.sar=01;31:*.swm=01;31:*.t7z=01;31:*.tar=01;31:*.taz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tgz=01;31:*.tlz=01;31:*.txz=01;31:*.tz=01;31:*.tzo=01;31:*.tzst=01;31:*.udeb=01;31:*.war=01;31:*.whl=01;31:*.wim=01;31:*.xz=01;31:*.z=01;31:*.zip=01;31:*.zoo=01;31:*.zst=01;31:*.avif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:*~=00;90:*#=00;90:*.bak=00;90:*.crdownload=00;90:*.dpkg-dist=00;90:*.dpkg-new=00;90:*.dpkg-old=00;90:*.dpkg-tmp=00;90:*.old=00;90:*.orig=00;90:*.part=00;90:*.rej=00;90:*.rpmnew=00;90:*.rpmorig=00;90:*.rpmsave=00;90:*.swp=00;90:*.tmp=00;90:*.ucf-dist=00;90:*.ucf-new=00;90:*.ucf-old=00;90:';
export LS_COLORS
