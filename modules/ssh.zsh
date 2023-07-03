# Start SSH agent if not already running
# if ! pgrep -u "$USER" ssh-agent >/dev/null 2>&1; then
#     ssh-agent -s | grep -v "echo" > "$HOME/.ssh-agent.env"
# fi

# # Load SSH agent environment variables
# if [ -f "$HOME/.ssh-agent.env" ]; then
#     source "$HOME/.ssh-agent.env" > /dev/null
#     if ! ssh-add -l >/dev/null 2>&1; then
#         ssh-add
#     fi
# fi

# Start ssh-agent and add keys if not already running
SSH_ENV="$HOME/.ssh/environment"

function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add ~/.ssh/id_*;
}

# Source SSH settings, if applicable
if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi
