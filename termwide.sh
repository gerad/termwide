#!/bin/bash

# the goals of this prompt are:
#
# - give plenty of room for the command
# - don't start causing weird terminal cursor issues when inside a deeply nested
#   directory
# - help visually distinguish one command from the next
# - visually indicate when on another machine
#
# thanks to qmrw for a heavy bash-based cleanup
#
# based heavily on termwide prompt by Giles - created 2 November 98
# http://www.linuxselfhelp.com/howtos/Bash-Prompt/Bash-Prompt-HOWTO-12.html
#
# install by cloning this file and adding: 
#   . /path/to/script/termwide.sh
# to .profile or similar

function prompt_command {
    PS_PWD="${PWD/$HOME/~}"
    PS_FILL=""

    local len_prompt=$(echo -n "[${USER}@$(hostname -s) 00:00 AM ${PS_PWD}]" | wc -c | tr -d " ")
    local len_rfill=$((COLUMNS - len_prompt - 1))
    while [[ $len_rfill > 0 ]]; do
        PS_FILL="${PS_FILL}―"
        len_rfill=$((len_rfill - 1))
    done

    if [[ $len_rfill < 0 ]]; then
        local len_cut=$((3 - len_rfill))
        PS_PWD="...$(echo -n $PS_PWD | sed -e "s/\(^.\{$len_cut\}\)\(.*\)/\2/")"
    fi
}

PROMPT_COMMAND=prompt_command

function termwide {
    local esc_host="\[\033[1;37m\]"
    if [ `hostname -s` == 'bit' ]; then esc_host=""; fi
    local esc_gray="\[\033[1;37m\]"
    local esc_nocolor="\[\033[0m\]"

    case $TERM in
        xterm*) esc_titlebar='\[\033]0;\w\007\]' ;;
        *)      esc_titlebar=""                        ;;
    esac

    PS1="$esc_titlebar$esc_gray[\u@$esc_host\h$esc_gray:\${PS_PWD} \${PS_FILL} \@]\n\
\$$esc_nocolor "
    PS2=">$esc_nocolor "
}

termwide

# vim: ts=4 sw=4 et
