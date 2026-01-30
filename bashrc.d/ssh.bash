SSH_ENV="${HOME}/.ssh/agent-environment"

start_ssh_agent() {
    echo "Initialising new SSH agent ..."
    /usr/bin/ssh-agent | sed 's/^echo/# echo/' >"${SSH_ENV}"
    chmod 600 "${SSH_ENV}"
    source "${SSH_ENV}" >/dev/null
    /usr/bin/ssh-add
}

if [[ -f ${SSH_ENV} ]]; then
    source "${SSH_ENV}" >/dev/null
    [[ -S ${SSH_AUTH_SOCK} ]] || start_ssh_agent
else
    start_ssh_agent
fi
