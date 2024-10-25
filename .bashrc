###################################Functions##########################################################


# Allow ctrl-S for history navigation (with ctrl-R)
stty -ixon
# Note: bind used instead of sticking these in .inputrc
if [[ $iatest > 0 ]]; then bind "set completion-ignore-case on"; fi

# Show auto-completion list automatically, without double tab
if [[ $iatest > 0 ]]; then bind "set show-all-if-ambiguous On"; fi

# Causes bash to append to history instead of overwriting it so if you start a new terminal, you have old session history
shopt -s histappend
PROMPT_COMMAND='history -a'


# Expand the history size
export HISTFILESIZE=10000
export HISTSIZE=500

# Don't put duplicate lines in the history and do not add lines that start with a space
export HISTCONTROL=erasedups:ignoredups:ignorespace


# Set the default editor
export EDITOR=vim
export VISUAL=vim


# To have colors for ls and all grep commands such as grep, egrep and zgrep
export CLICOLOR=1
export LS_COLORS='no=00:fi=00:di=00;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:*.xml=00;31:'
#export GREP_OPTIONS='--color=auto' #deprecated
alias grep="/usr/bin/grep $GREP_OPTIONS"
unset GREP_OPTIONS

# Edit this .bashrc file
alias ebrc='edit ~/.bashrc'

# Show help for this .bashrc file
alias hlp='less ~/.bashrc_help'








# Set up fzf key bindings and fuzzy completion
eval "$(fzf --bash)"

source /home/ak/.scripts/fzf-tab-completion/bash/fzf-bash-completion.sh
bind -x '"\t": fzf_bash_completion'

# alias to show the date
alias da='date "+%Y-%m-%d %A %T %Z"'
alias m='mpv'



# Search command line history
alias h="history | grep "
# Search files in the current folder
alias f="find . | grep "



# Alias's to show disk space and space used in a folder
alias diskspace="du -S | sort -n -r |more"
alias folders='du -h --max-depth=1'
alias folderssort='find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'
alias tree='tree -CAhF --dirsfirst'
alias treed='tree -CAFd'
alias mountedinfo='df -hT'
# Alias's for archives
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'

#######################################################
# Set the ultimate amazing command prompt
#######################################################

alias cpu="grep 'cpu ' /proc/stat | awk '{usage=(\$2+\$4)*100/(\$2+\$4+\$5)} END {print usage}' | awk '{printf(\"%.1f\n\", \$1)}'"
function __setprompt
{
	local LAST_COMMAND=$? # Must come first!

	# Define colors
	local LIGHTGRAY="\033[0;37m"
	local WHITE="\033[1;37m"
	local BLACK="\033[0;30m"
	local DARKGRAY="\033[1;30m"
	local RED="\033[0;31m"
	local LIGHTRED="\033[1;31m"
	local GREEN="\033[0;32m"
	local LIGHTGREEN="\033[1;32m"
	local BROWN="\033[0;33m"
	local YELLOW="\033[1;33m"
	local BLUE="\033[0;34m"
	local LIGHTBLUE="\033[1;34m"
	local MAGENTA="\033[0;35m"
	local LIGHTMAGENTA="\033[1;35m"
	local CYAN="\033[0;36m"
	local LIGHTCYAN="\033[1;36m"
	local NOCOLOR="\033[0m"
# Show error exit code if there is one
	if [[ $LAST_COMMAND != 0 ]]; then
		# PS1="\[${RED}\](\[${LIGHTRED}\]ERROR\[${RED}\])-(\[${LIGHTRED}\]Exit Code \[${WHITE}\]${LAST_COMMAND}\[${RED}\])-(\[${LIGHTRED}\]"
		PS1="\[${DARKGRAY}\](\[${LIGHTRED}\]ERROR\[${DARKGRAY}\])-(\[${RED}\]Exit Code \[${LIGHTRED}\]${LAST_COMMAND}\[${DARKGRAY}\])-(\[${RED}\]"
		if [[ $LAST_COMMAND == 1 ]]; then
			PS1+="General error"
		elif [ $LAST_COMMAND == 2 ]; then
			PS1+="Missing keyword, command, or permission problem"
		elif [ $LAST_COMMAND == 126 ]; then
			PS1+="Permission problem or command is not an executable"
		elif [ $LAST_COMMAND == 127 ]; then
			PS1+="Command not found"
		elif [ $LAST_COMMAND == 128 ]; then
			PS1+="Invalid argument to exit"
		elif [ $LAST_COMMAND == 129 ]; then
			PS1+="Fatal error signal 1"
		elif [ $LAST_COMMAND == 130 ]; then
			PS1+="Script terminated by Control-C"
		elif [ $LAST_COMMAND == 131 ]; then
			PS1+="Fatal error signal 3"
		elif [ $LAST_COMMAND == 132 ]; then
			PS1+="Fatal error signal 4"
		elif [ $LAST_COMMAND == 133 ]; then
			PS1+="Fatal error signal 5"
		elif [ $LAST_COMMAND == 134 ]; then
			PS1+="Fatal error signal 6"
		elif [ $LAST_COMMAND == 135 ]; then
			PS1+="Fatal error signal 7"
		elif [ $LAST_COMMAND == 136 ]; then
			PS1+="Fatal error signal 8"
		elif [ $LAST_COMMAND == 137 ]; then
			PS1+="Fatal error signal 9"
		elif [ $LAST_COMMAND -gt 255 ]; then
			PS1+="Exit status out of range"
		else
			PS1+="Unknown error code"
		fi
		PS1+="\[${DARKGRAY}\])\[${NOCOLOR}\]\n"
	else
		PS1=""
	fi

	# Date
       #PS1+="\[${DARKGRAY}\](\[${CYAN}\]\$(date +%a) $(date +%b-'%-m')" # Date
	PS1+="${BLUE} $(date +'%-I':%M:%S%P)\[${DARKGRAY}\])-" # Time

	# CPU
	PS1+="(\[${MAGENTA}\]CPU $(cpu)%"

	# Jobs
	PS1+="\[${DARKGRAY}\]:\[${MAGENTA}\]\j"

	# Network Connections (for a server - comment out for non-server)
	PS1+="\[${DARKGRAY}\]:\[${MAGENTA}\]Net $(awk 'END {print NR}' /proc/net/tcp)"

	PS1+="\[${DARKGRAY}\])-"

	# User and server
	local SSH_IP=`echo $SSH_CLIENT | awk '{ print $1 }'`
	local SSH2_IP=`echo $SSH2_CLIENT | awk '{ print $1 }'`
	if [ $SSH2_IP ] || [ $SSH_IP ] ; then
		PS1+="(\[${RED}\]\u@\h"
	else
		PS1+="(\[${RED}\]\u"
	fi

	# Current directory
	PS1+="\[${DARKGRAY}\]:\[${BROWN}\]\w\[${DARKGRAY}\])-"

	# Total size of files in current directory
	PS1+="(\[${GREEN}\]$(/bin/ls -lah | /bin/grep -m 1 total | /bin/sed 's/total //')\[${DARKGRAY}\]:"

	# Number of files
	PS1+="\[${GREEN}\]\$(/bin/ls -A -1 | /usr/bin/wc -l)\[${DARKGRAY}\])"

	# Skip to the next line
	PS1+="\n"

	if [[ $EUID -ne 0 ]]; then
		PS1+="\[${GREEN}\]>\[${NOCOLOR}\] " # Normal user
	else
		PS1+="\[${RED}\]>\[${NOCOLOR}\] " # Root user
	fi

	# PS2 is used to continue a command using the \ character
	PS2="\[${DARKGRAY}\]>\[${NOCOLOR}\] "

	# PS3 is used to enter a number choice in a script
	PS3='Please enter a number from above list: '

	# PS4 is used for tracing a script in debug mode
	PS4='\[${DARKGRAY}\]+\[${NOCOLOR}\] '
}
PROMPT_COMMAND='__setprompt'





phone ()
{
ssh -p 8022 localhost@192.168.29.202
}

lapt ()
{
ssh ak@192.168.29.242
}

vpn (){
sudo openvpn /home/ak/Downloads/vpn/jp-free-122024.protonvpn.udp.ovpn
}


ytaudio ()


{


yt-dlp  --extract-audio --audio-format mp3 -o "%(title)s.%(ext)s" $1


}

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











uu()
{


cd /mount/500g/.ul/
ls





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







mm()

{

cd /mount/500g/Media/music ;
ls * &&  mpv --no-video  "$(fzf )"


}





ms()

{

cd /mount/500g/Media/shows ;
ls *.mkv &&  mpv "$(fzf -e --keep-right --layout=reverse)"


}





mu()

{

cd /mount/500g/.ul ;
ls *.mkv &&  mpv "$(fzf -e --keep-right --layout=reverse)"

}



mx()

{

cd /mount/500g/.x2 ;
ls *.mkv &&  mpv "$(fzf -e --keep-right --layout=reverse )"

}












music()
{
#while [ 0 ]
#do
cd "/mount/500g/Media/music/"
cd  "$(ls | fzf)"
while [ 0 ]
do
mpv --no-video "$(ls|fzf)"
done



ytubeaudio()
{
 yt-dlp --extract-audio    -o "%(title)s.%(ext)s" $1
}
#done

}

 play_song()

 {
   mpv --no-video "$1" 
}










# Directory navigation aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias desk='sshfs ak@192.168.29.253:/home/ak/ desk/'
alias f='fish'
alias v='vim'
