# Zsh Configuration

To set up this zsh configuration:

1. Clone this repository
2. Run `just bootstrap` to set up the environment
  - If this is the first run, you'll have to run using bash shell `./bootstrap`
3. Create a symbolic link of `.zshenv` to your home directory

## Management Commands

- `just bootstrap` - Initial setup (deterministic, tracks completion state)
- `just update` - Pull latest changes and update all components
- `just update <component>` - Update specific component (scripts, dotfiles, mise)
- `just setup-ssh [email] [profile]` - Generate SSH keys and configure GitHub (supports personal/work profiles)
  - `just setup-ssh` - Personal account, prompts for email
  - `just setup-ssh user@example.com` - Personal account with email
  - `just setup-ssh user@work.com work` - Work account
- `just status` - Check current setup status
- `just doctor` - Verify tool installations

See `just --list` for all available commands.
