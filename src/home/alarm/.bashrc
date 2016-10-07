#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Path
PATH=$HOME/bin:$PATH

# Autostart
if [[ -d $HOME/bin/autostart-console.d ]]; then
    for f in $HOME/bin/autostart-console.d/*; do sh "$f"; done
fi

# Aliases
# https://wiki.archlinux.org/index.php/Bash#Aliases

# Modified commands
alias diff='colordiff'
alias grep='grep --color=auto'
alias more='less'
alias df='df -h'
alias du='du -c -h'
alias mkdir='mkdir -p -v'
alias nano='nano -w'
alias ping='ping -c 5'
alias dmesg='dmesg -HL'
alias exit='clear && exit'
alias logout='clear && logout'
alias bc='bc -ql'
alias c='curl -OL'

# New commands
alias da='date "+%A, %B %d, %Y [%T]"'
alias du1='du --max-depth=1'
alias hist='history | grep'
alias openports='ss --all --numeric --processes --ipv4 --ipv6'
alias pgg='ps -Af | grep'
alias ..='cd ..'

# ls
alias ls='ls -hF -1 --color=auto --group-directories-first --time-style=long-iso'
alias lr='ls -R'                    # recursive ls
alias ll='ls -l'
alias la='ll -A'
alias lx='ll -BX'                   # sort by extension
alias lz='ll -rS'                   # sort by size
alias lt='ll -rt'                   # sort by date
alias lm='la | more'

# Safety features
alias cp='cp -i'
alias mv='mv -i'
alias rm=' timeout 3 rm -Iv --one-file-system'
alias ln='ln -i'
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'
alias cls=' echo -ne "\033c"'

# Make Bash error tolerant
alias :q=' exit'
alias :Q=' exit'
alias :x=' exit'
alias cd..='cd ..'

# Locale
export LANG="en_US.UTF-8"
export LC_COLLATE=C

# Editor
export EDITOR="nano"

# Colored less
export LESS="-R"

PS1='[\u@\h \W]\$ '
