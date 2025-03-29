#!/bin/bash

# Function to display help
show_help() {
    echo "Usage: $0 -u <remote_user> -h <remote_host> [-k <ssh_key_path>]"
    echo ""
    echo "Options:"
    echo "  -u   Remote user (e.g., root)"
    echo "  -h   Remote host (e.g., example.com)"
    echo "  -k   SSH key path (default: ~/.ssh/id_ed25519)"
    echo "  -H   Show this help message"
    exit 0
}

# Default values
SSH_KEY_PATH="$HOME/.ssh/id_ed25519"

# Parse command-line arguments
while getopts "u:h:k:H" opt; do
    case ${opt} in
        u) REMOTE_USER=$OPTARG ;;
        h) REMOTE_HOST=$OPTARG ;;
        k) SSH_KEY_PATH=$OPTARG ;;
        H) show_help ;;
        *) show_help ;;
    esac
done

# Check if required parameters are provided
if [[ -z "$REMOTE_USER" || -z "$REMOTE_HOST" ]]; then
    echo "❌ Error: Remote user and host are required."
    show_help
fi

echo "🔑 Checking if SSH key exists at $SSH_KEY_PATH..."
if [ ! -f "$SSH_KEY_PATH" ]; then
    echo "⚡ Generating a new SSH key..."
    ssh-keygen -t ed25519 -C "$USER@$(hostname)" -f "$SSH_KEY_PATH" -N ""
else
    echo "✅ SSH key already exists: $SSH_KEY_PATH"
fi

echo "🚀 Copying the public key to the remote server..."
ssh-copy-id -i "$SSH_KEY_PATH.pub" "$REMOTE_USER@$REMOTE_HOST"

echo "🔧 Setting correct permissions on the remote server..."
ssh "$REMOTE_USER@$REMOTE_HOST" << EOF
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    touch ~/.ssh/authorized_keys
    chmod 600 ~/.ssh/authorized_keys
EOF

echo "✅ Testing SSH connection..."
if ssh -o BatchMode=yes -o ConnectTimeout=5 "$REMOTE_USER@$REMOTE_HOST" "echo '🎉 SSH connection successful!'"; then
    echo "🚢 Your SSH setup is ready!"
else
    echo "❌ SSH connection failed. Please check your setup."
fi
