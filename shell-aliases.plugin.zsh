#!/usr/bin/env bash
# shellcheck disable=SC1117

##############################################################################
# Z Shell Aliases Configuration
##############################################################################

# Lock the screen (when going AFK)
alias afk='/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend'

# buzzphrase commit
# used for my presentation decks when I have nothing to say about the commit
alias bpc='git add -A . && git cam "$(buzzphrase 2)" && git push'

alias cp='cp -i' # copy file interactive

alias dnsflush='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder; echo "OK"' # Flush the DNS cache

# recursive dos2unix in current directory
alias dos2lf='dos2unix `find ./ -type f`'

alias edit='docker run -ti --rm -v $(pwd):/home/developer/workspace jare/vim-bundle'

# Empty the Trash on all mounted volumes and the main HDD.
# Also, clear Apple’s System Logs to improve shell startup speed.
# Finally, clear download history from quarantine. https://mths.be/bum
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"

# Files being opened
alias files.open='sudo fs_usage -e -f filesystem|grep -v CACHE_HIT|grep -v grep|grep open'
# Files used, anywhere on the filesystem
alias files.usage='sudo fs_usage -e -f filesystem|grep -v CACHE_HIT|grep -v grep'
# Files in use in the Users directory
alias files.usage.user='sudo fs_usage -e -f filesystem|grep -v CACHE_HIT|grep -v grep|grep Users'

alias flushdns='dnsflush' # memory is hard sometimes

alias game.seek='txt="";for i in {1..20};do txt=$txt"$i. ";done;txt=$txt" Ready or not, here I come";say $txt'

alias grep='grep --color=auto ' # Always enable colored `grep` output

alias h="history"

# Show active network interfaces
alias ifactive="ifconfig | pcregrep -M -o '^[^\t:]+:([^\n]|\n\t)*status: active'"

# IP addresses
alias ipaddr="dig +short myip.opendns.com @resolver1.opendns.com"
alias iplocal="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1
then
	colorflag="--color" # GNU `ls`
else
	colorflag="-G" # OS X `ls`
fi

# Directory listings
# LS_COLORS='no=01;37:fi=01;37:di=07;96:ln=01;36:pi=01;32:so=01;35:do=01;35:bd=01;33:cd=01;33:ex=01;31:mi=00;05;37:or=00;05;37:'
# -G Add colors to ls
# -l Long format
# -h Short size suffixes (B, K, M, G, P)
# -p Postpend slash to folders

alias l="ls -lhFp ${colorflag}" # List all files colorized in long format
alias la="ls -lahF ${colorflag}" # List all files colorized in long format, including dot files
alias ll="ls -lahp ${colorflag}"
alias ls="command ls ${colorflag}" # Always use color output for `ls`
alias lsd="ls -lhF ${colorflag} | grep --color=never '^d'" # List only directories

alias mv='mv -i' # move file interactive

# Show network connections
# Often useful to prefix with SUDO to see more system level network usage
alias network.connections='lsof -l -i +L -R -V'
alias network.established='lsof -l -i +L -R -V | grep ESTABLISHED'
alias network.externalip='curl -s http://checkip.dyndns.org/ | sed "s/[a-zA-Z<>/ :]//g"'
alias network.internalip="ifconfig en0 | egrep -o '([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)'"

alias path='echo -e ${PATH//:/\\n}' # Print each PATH entry on a separate line

# alias clipboard commands for linux systems to facilitate consistent interface for all systems
if [ ! "$(uname -s)" = "Darwin" ]
  # Copy and paste and prune the usless newline
  alias pbcopynn='tr -d "\n" | pbcopy'
then
	alias pbcopy='xclip -selection clipboard'
	alias pbpaste='xclip -selection clipboard -o'
fi

# firewall management
alias port-forward-enable="echo 'rdr pass inet proto tcp from any to any port 2376 -> 127.0.0.1 port 2376' | sudo pfctl -ef -"
alias port-forward-disable="sudo pfctl -F all -f /etc/pf.conf"
alias port-forward-list="sudo pfctl -s nat"

# push git repo, but first, use git-up to make sure you are in sync and rebased with the remote
alias pushup="git-up && git push"
# Set the extended MacOS attributes on a file such that Quicklook will open it as text
# alias qltext='xattr -wx com.apple.FinderInfo "54 45 58 54 21 52 63 68 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00" $1'
#alias qltext2='osascript -e tell application "Finder" to set file type of ((POSIX file "$1") as alias) to "TEXT"'

alias reload="exec \${SHELL} -l" # Reload the shell (i.e. invoke as a login shell)

alias sha265sum='shasum -a 256 ' # Print or Check SHA Checksums

alias spotoff='sudo mdutil -a -i off' # Disable Spotlight
alias spoton='sudo mdutil -a -i on' # Enable Spotlight

alias sudo='sudo ' # Enable aliases to be sudo’ed

# Get macOS Software Updates, and update installed Ruby gems, Homebrew, npm, and their installed packages
alias update='sudo softwareupdate -i -a; brew update; brew upgrade; brew cask upgrade --greedy; brew cleanup; mas upgrade; npm install npm -g; npm update -g; sudo gem update --system; sudo gem update; sudo gem cleanup'

alias vtop="vtop --theme wizard"

alias week='date +%V' # Get week number



# recursively show recently changed file
function changed() {
  find "$1" -type f -print0 | xargs -0 stat --format '%Y :%y %n' 2>/dev/null | sort -nr | cut -d: -f2-
}
