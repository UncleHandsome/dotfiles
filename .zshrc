function precmd { 
    local TERMWIDTH
    (( TERMWIDTH = ${COLUMNS} - 1 ))

    ###
    # Truncate the path if it's too long.
    
    PR_FILLBAR=""
    PR_PWDLEN=""
    
    local promptsize=${#${(%):---(%n@%m:%l)---()--}}
    local pwdsize=${#${(%):-%~}}
    
    if [[ "$promptsize + $pwdsize" -gt $TERMWIDTH ]]; then
	    ((PR_PWDLEN=$TERMWIDTH - $promptsize))
    else
	PR_FILLBAR="\${(l.(($TERMWIDTH - ($promptsize + $pwdsize)))..${PR_HBAR}.)}"
    fi
}


#setopt extended_glob
#preexec () {
#    if [[ "$TERM" == "screen" ]]; then
#	local CMD=${1[(wr)^(*=*|sudo|-*)]}
#	echo -n "\ek$CMD\e\\"
#    fi
#}


setprompt () {
    ###
    # Need this so the prompt will work.

    setopt prompt_subst


    ###
    # See if we can use colors.

    autoload colors zsh/terminfo
    if [[ "$terminfo[colors]" -ge 8 ]]; then
	colors
    fi
    for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
	eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
	eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
	(( count = $count + 1 ))
    done
    PR_NO_COLOUR="%{$terminfo[sgr0]%}"


    ###
    # See if we can use extended characters to look nicer.
    
    typeset -A altchar
    set -A altchar ${(s..)terminfo[acsc]}
    PR_SET_CHARSET="%{$terminfo[enacs]%}"
    PR_SHIFT_IN="%{$terminfo[smacs]%}"
    PR_SHIFT_OUT="%{$terminfo[rmacs]%}"
    #PR_HBAR=${altchar[q]:--}
    PR_HBAR=${altchar[q]:--}
    PR_ULCORNER=${altchar[l]:--}
    PR_LLCORNER=${altchar[m]:--}
    PR_LRCORNER=${altchar[j]:--}
    PR_URCORNER=${altchar[k]:--}

    
    ###
    # Decide if we need to set titlebar text.
    
    case $TERM in
	xterm*)
	    PR_TITLEBAR=$'%{\e]0;%(!.-=*[ROOT]*=- | .)%n@%m:%~ | ${COLUMNS}x${LINES} | %y\a%}'
	    ;;
	screen)
	    PR_TITLEBAR=$'%{\e_screen \005 (\005t) | %(!.-=[ROOT]=- | .)%n@%m:%~ | ${COLUMNS}x${LINES} | %y\e\\%}'
	    ;;
	*)
	    PR_TITLEBAR=''
	    ;;
    esac
    
    
    ###
    # Decide whether to set a screen title
    if [[ "$TERM" == "screen" ]]; then
	PR_STITLE=$'%{\ekzsh\e\\%}'
    else
	PR_STITLE=''
    fi
    
    ###
    # Finally, the prompt.

    PROMPT='$PR_SET_CHARSET$PR_STITLE${(e)PR_TITLEBAR}\
$PR_CYAN$PR_SHIFT_IN$PR_ULCORNER$PR_BLUE$PR_HBAR$PR_SHIFT_OUT(\
$PR_GREEN%(!.%SROOT%s.%n)$PR_GREEN@%m:%l\
$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_CYAN$PR_HBAR${(e)PR_FILLBAR}$PR_BLUE$PR_HBAR$PR_SHIFT_OUT(\
$PR_MAGENTA%$PR_PWDLEN<...<%~%<<\
$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_CYAN$PR_URCORNER$PR_SHIFT_OUT\

$PR_CYAN$PR_SHIFT_IN$PR_LLCORNER$PR_BLUE$PR_HBAR$PR_SHIFT_OUT(\
%(?..$PR_LIGHT_RED%?$PR_BLUE:)\
$PR_YELLOW%D{%H:%M}\
$PR_LIGHT_BLUE:%(!.$PR_RED.$PR_WHITE)%#$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_NO_COLOUR '

    RPROMPT=' $PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_BLUE$PR_HBAR$PR_SHIFT_OUT\
($PR_YELLOW%D{%a,%b%d}$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_CYAN$PR_LRCORNER$PR_SHIFT_OUT$PR_NO_COLOUR'

    PS2='$PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_BLUE$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT(\
$PR_LIGHT_GREEN%_$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT$PR_NO_COLOUR '
}

setprompt


if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias tel='luit -encoding big5 telnet'
alias bs2='luit -encoding big5 telnet bs2.to'
alias ptt='luit -encoding big5 telnet ptt.cc'
alias libido='luit -encoding big5 telnet libido.cx'
alias l='ls -FC'
alias ll='ls -lhF'
alias git-log='git log --oneline --decorate --graph'
alias linux-style='indent -nbad -bap -nbc -bbo -hnl -br -brs -c33 -cd33 -ncdb -ce -ci4 -cli0 -d0 -di1 -nfc1 -i8 -ip0 -l80 -lp -npcs -nprs -npsl -sai  -saf -saw -ncs -nsc -sob -nfca -cp33 -ss -ts8 -il1'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias untar='tar zxvf'

setopt autocd # Automatically cd when a path is given
unsetopt beep    # No beeps please!
setopt correct # correct commands
setopt correctall # correct all the words in the command line
setopt ALL_EXPORT

setopt appendhistory
setopt histreduceblanks
setopt histignorespace
setopt histignorealldups
setopt histverify               # when using ! cmds, confirm first
setopt SHARE_HISTORY            # share history between open shells
setopt INC_APPEND_HISTORY       # append history as command are entered
setopt HIST_NO_STORE            # don't save 'history' cmd in history
setopt EXTENDED_HISTORY         # add timestamps to history
setopt autopushd pushdminus pushdsilent pushdtohome pushdignoredups # push directories visited automatically onto stack

setopt automenu # Automatically use menu completion after the second consecutive request for completion, for example by pressing the TAB key repeatedly
setopt MENUCOMPLETE
setopt autolist                 # Filename Completion
setopt listpacked               # compact completion lists
setopt longlistjobs
setopt extendedglob             # weird & wacky pattern matching - yay zsh!
setopt nolisttypes              # show types in completion
setopt completeinword           # not just at the end
setopt alwaystoend              # when complete from middle, move cursor
setopt MARK_DIRS                # adds slash to end of completed dirs
setopt globdots                 # find dotfiles easier
setopt NUMERIC_GLOB_SORT
setopt nomatch
setopt notify
unsetopt COMPLETE_IN_WORD # move to end of the word after completition
unsetopt autoparamslash

setopt SH_WORD_SPLIT # passes "foo bar" as "foo" "bar" to commands. Backward compatibility with sh/ksh
setopt cdablevars               # avoid the need for an explicit $
setopt nopromptcr               # don't add \n which overwrites cmds with no \n
unsetopt promptcr
setopt interactivecomments      # escape commands so i can use them later
setopt recexact
setopt rcquotes
setopt HASH_CMDS
setopt HASH_DIRS
setopt clobber      # > and >> will work as expected.

unsetopt BG_NICE                # Don't nice background process
setopt nohup                    # don't kill background on logout
setopt autoresume
setopt AUTO_CONTINUE
