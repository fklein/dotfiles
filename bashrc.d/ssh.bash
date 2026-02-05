SSH_ENV="${HOME}/.ssh/agent-environment"

ssh_agent_init() {
    echo "Initialising new SSH agent ..."
    /usr/bin/ssh-agent | sed 's/^echo/# echo/' >"${SSH_ENV}"
    chmod 600 "${SSH_ENV}"
    source "${SSH_ENV}" >/dev/null
    /usr/bin/ssh-add
}

ssh_agent_isup() {
    [[ -f ${SSH_ENV} ]] || return 1
    source "${SSH_ENV}" >/dev/null
    # If either the socket does not exists or the process is down
    [[ -S ${SSH_AUTH_SOCK} ]] || return 1
    ps -p "${SSH_AGENT_PID}" >/dev/null 2>&1 || return 1
}

ssh_agent_isup || ssh_agent_init
