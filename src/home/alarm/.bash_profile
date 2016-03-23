#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# https://wiki.archlinux.org/index.php/Start_X_at_Login
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
