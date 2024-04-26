###################################Functions##########################################################
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

##################################history#############################################################export HISTFILESIZE=20000
export HISTSIZE=10000
shopt -s histappend
# Combine multiline commands into one in history
shopt -s cmdhist
# Ignore duplicates, ls without options and builtin commands
HISTCONTROL=ignoredups
export HISTIGNORE="&:ls:[bf]g:exit"




# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm-color)
    PS1='[${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\h\[\033[00m\]] \[\033[01;34m\]\w\[\033[00m\]\$ '
    ;;
*)
    PS1='[${debian_chroot:+($debian_chroot)}\h] \w\$ '
    ;;
esac

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
fi


extract () {
     if [ -f $1 ] ; then
         case $1 in
             *.tar.bz2)   tar xjf $1        ;;
             *.tar.gz)    tar xzf $1     ;;
             *.bz2)       bunzip2 $1       ;;
             *.rar)       rar x $1     ;;
             *.gz)        gunzip $1     ;;
             *.tar)       tar xf $1        ;;
             *.tbz2)      tar xjf $1      ;;
             *.tgz)       tar xzf $1       ;;
             *.zip)       unzip $1     ;;
             *.Z)         uncompress $1  ;;
             *.7z)        7z x $1    ;;
             *)           echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

#netinfo - shows network information for your system
netinfo ()
{
echo "--------------- Network Information ---------------"
/sbin/ifconfig | awk /'inet addr/ {print $2}'
/sbin/ifconfig | awk /'Bcast/ {print $3}'
/sbin/ifconfig | awk /'inet addr/ {print $4}'
/sbin/ifconfig | awk /'HWaddr/ {print $4,$5}'
myip=`lynx -dump -hiddenlinks=ignore -nolist http://checkip.dyndns.org:8245/ | sed '/^$/d; s/^[ ]*//g; s/[ ]*$//g' `
echo "${myip}"
echo "---------------------------------------------------"
}

#dirsize - finds directory sizes and lists them for the current directory
dirsize ()
{
du -shx * .[a-zA-Z0-9_]* 2> /dev/null | \
egrep '^ *[0-9.]*[MG]' | sort -n > /tmp/list
egrep '^ *[0-9.]*M' /tmp/list
egrep '^ *[0-9.]*G' /tmp/list
rm -rf /tmp/list
}

#copy and go to dir
cpg (){
  if [ -d "$2" ];then
    cp $1 $2 && cd $2
  else
    cp $1 $2
  fi
}

#move and go to dir
mvg (){
  if [ -d "$2" ];then
    mv $1 $2 && cd $2
  else
    mv $1 $2
  fi
}

# Directory navigation aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias lp='sshfs ak@192.168.29.241:/home/ak/ lapt/'















