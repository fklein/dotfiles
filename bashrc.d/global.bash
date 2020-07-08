# Display the current week number
alias kw='date +%V'

# Mirror srdout to stederr, useful for seeing data going through a pipe
alias peek='tee >(cat 1>&2)'

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
