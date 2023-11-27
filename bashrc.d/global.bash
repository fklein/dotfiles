# Display the current week number
alias kw='date +%V'

# Mirror srdout to stederr, useful for seeing data going through a pipe
alias peek='tee >(cat 1>&2)'

# Trim trailing whitespace from a file
alias rtrim="sed -i 's/\s\s*$//g'"

# Add an "alert" alias for long running commands. Use like so: sleep 10; alert
if command -v notify-send >/dev/null; then
    alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
fi

# Change directory to the location of a file
jump() { cd "$(dirname "$1")" ; }
complete -f jump

# Create a new directory and change into it
mcd() { mkdir -p "$1" && cd "$1" ; }
complete -d mcd

# An extended "cd" command that keeps track of visited directories (based on pushd/popd)
# Shameless rip-off of https://linuxgazette.net/109/misc/marinov/acd_func.sh
cdhistory () {
    local -i stacksize=${CDHISTORY_SIZE:-15}
    local newdir

    # Without parameters use $HOME
    newdir="${1:-${HOME}}"
    shift

    # "--" lists the curent stack
    if [[ ${newdir} ==  "--" ]]; then
        dirs -v
        return 0
    fi

    # "-<N>" selects stack item at index N
    if [[ ${newdir} == '-'* ]]; then
        local index=${newdir:1}
        newdir="$(dirs "+${index:-1}")" || return 1
    fi

    # Change to the new directory, pushing it to the top of the stack
    # '~' at the start of a path has to be substituted with ${HOME}
    pushd "${newdir/#~/${HOME}}" "${@}" >/dev/null || return 2
    newdir="$(pwd)"

    # Trim the stack to size and remove any duplicates of the current directory
    local idx=1 thisdir
    while thisdir="$(dirs +${idx} 2>/dev/null)"; do
        if (( ${idx} > ${stacksize} )) || [[ "${thisdir/#~/${HOME}}" == "${newdir}" ]]; then
            popd -n +${idx} 1>/dev/null 2>/dev/null
            continue
        fi
        ((idx++))
    done

    return 0
}

# Bind Alt+W to show the history of visited directories
bind -x "\"\ew\":cdhistory -- ;"

# Enable command completion for the "cdhistory" function
# Wraps the standard completion implementation for "cd" with custom behaviour
_cdhistory() {
    local cur prev
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    # Only handle completions for "-*" and "--*"
    [[ ${cur} == --* ]] && return
    if [[ ${cur} == -* ]]; then
        compopt -o nosort 2>/dev/null
        local index=0
        # Find the indices in the directory stack that match the number typed so far
        while read olddir; do
            if [[ ${index} == ${cur:1}* ]]; then
                # Valid completions would technically be the matching index numbers ("-N")
                # However, since these numbers by themselves are not really meaningful
                # include the directory name and display completions as "N (DIRNAME)"
                COMPREPLY+=("$index (${olddir})")
            fi
            (( index++ ))
        done < <(dirs -p)

        # Bash will attempt to add the longest common part of all completions
        # to the command line. Since our completions are not really valid options,
        # prevent that by adding an empty item (which is not displayed).
        (( ${#COMPREPLY[@]} > 1 )) && COMPREPLY+=("")

        # If there only one possible completion, bash will automatically select it.
        # Since our completions are not really valid options, use only the directory name.
        if (( ${#COMPREPLY[@]} == 1 )); then
            local d=${COMPREPLY[0]}
            d="${d#* \(}" ; d="${d%)}"
            COMPREPLY[0]="${d}"
        fi
        return 0
    fi

    # Let default "cd" completion handle anything else
    if type -t _cd >/dev/null; then
        _cd "${@}"
    else
        local IFS=$'\n'
        COMPREPLY=( $(compgen -d -- "${cur}") )
    fi
}

complete -o nospace -F _cdhistory cdhistory

# Replace the "cd" built-in with our history-enabled function
alias cd='cdhistory'
complete -o nospace -F _cdhistory cd


# Colorize text with terminal escape sequences
# Usage: colorize [format,...] [format,...] -- [text ...]
colorize() {
    local escapecodes
    declare -A escapecodes=(
        # Common
        [reset]=$'\e[0m' [bold]=$'\e[1m' [dim]=$'\e[2m' [italic]=$'\e[3m' [underline]=$'\e[4m'
        [blink]=$'\e[5m' [invert]=$'\e[7m' [invisible]=$'\e[8m' [strikethrough]=$'\e[9m'
        # Text
        [default]=$'\e[39m'
        [black]=$'\e[30m'   [white]=$'\e[97m'
        [gray]=$'\e[90m'    [lightgray]=$'\e[37m'
        [red]=$'\e[31m'     [lightred]=$'\e[91m'
        [green]=$'\e[32m'   [lightgreen]=$'\e[92m'
        [yellow]=$'\e[33m'  [lightyellow]=$'\e[93m'
        [blue]=$'\e[34m'    [lightblue]=$'\e[94m'
        [magenta]=$'\e[35m' [lightmagenta]=$'\e[95m'
        [cyan]=$'\e[36m'    [lightcyan]=$'\e[96m'
        # Background
        [bgdefault]=$'\e[49m'
        [bgblack]=$'\e[40m'     [bgwhite]=$'\e[107m'
        [bggray]=$'\e[100m'     [bglightgray]=$'\e[47m'
        [bgred]='\e[41m'        [bglightred]='\e[101m'
        [bggreen]='\e[42m'      [bglightgreen]='\e[102m'
        [bgyellow]=$'\e[43m'    [bglightyellow]=$'\e[103m'
        [bgblue]='\e[44m'       [bglightblue]='\e[104m'
        [bgmagenta]=$'\e[45m'   [bglightmagenta]=$'\e[105m'
        [bgcyan]=$'\e[46m'      [bglightcyan]=$'\e[106m'
    )
    local fmtseq=$''
    local fmtreset="${escapecodes[reset]}"
    # Parse the format specifiers
    while (( $# > 0 )); do
        [[ "$1" == "--" ]] && { shift ; break ; }
        local format
        for format in ${1//,/ }; do
            if [[ -z "${escapecodes[${format}]+IsSet}" ]]; then
                echo "${FUNCNAME[0]}: unknown format \"${format}\"" >&2
                return 1
            fi
            fmtseq+="${escapecodes[${format}]}"
        done
        shift
    done
    # Print formated text from stdin if no text parameters are given
    if (( $# == 0 )); then
        local stdin
        while read -r stdin; do
            printf "${fmtseq}%s${fmtreset}\n" "${stdin}"
        done
    fi
    # Print formated text parameters
    while (( $# > 0 )); do
        printf "${fmtseq}%s${fmtreset}" "${1}"
        shift
        (( $# > 0 )) && printf " " || printf "\n"
    done
}

