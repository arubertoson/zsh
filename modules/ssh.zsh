# Start SSH agent if not already running
if ! pgrep -u "$USER" ssh-agent >/dev/null 2>&1; then
    ssh-agent -s | grep -v "echo" > "$HOME/.ssh-agent.env"
fi

# Load SSH agent environment variables
if [ -f "$HOME/.ssh-agent.env" ]; then
    source "$HOME/.ssh-agent.env" > /dev/null
    if ! ssh-add -l >/dev/null 2>&1; then
        ssh-add
    fi
fi