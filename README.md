# SSH Key Setup Automation

This script automates the process of generating an SSH key, adding it to a remote server, and verifying the connection. It is useful for setting up passwordless SSH authentication for Docker or other automated systems.

## Features
- Generates an **Ed25519** SSH key (if not already present).
- Copies the public key to the **remote server**.
- Ensures correct SSH directory and file permissions.
- Verifies SSH connection.
- Accepts command-line arguments for flexibility.

## Requirements
- Linux/macOS with Bash
- OpenSSH installed (`ssh-keygen`, `ssh-copy-id`)
- Access to the remote server with a password (for the first-time setup)

## Installation
Clone this repository or manually download the script:

```bash
git clone https://github.com/your-repo/ssh-key-setup.git
cd ssh-keys-setup
chmod +x ssh_keys_setup.sh
```

## Usage
Run the script with the required parameters:

```bash
./setup_ssh.sh -u <remote_user> -h <remote_host>
```

### Example:
```bash
./setup_ssh.sh -u root -h example.com
```

To specify a **custom SSH key path**:
```bash
./setup_ssh.sh -u root -h example.com -k ~/.ssh/custom_key
```

To display the **help message**:
```bash
./setup_ssh.sh -H
```

## What This Script Does
1. **Checks if an SSH key exists** at the specified path.
2. **Generates a new key** if one is not found.
3. **Copies the public key** to the remote server using `ssh-copy-id`.
4. **Ensures the correct permissions** on `~/.ssh` and `authorized_keys`.
5. **Tests the SSH connection** for successful authentication.

## Troubleshooting
### Permission Issues
Ensure the correct permissions on the remote server:
```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

### Connection Issues
Try manually adding the key:
```bash
cat ~/.ssh/id_ed25519.pub | ssh user@remote-host "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"
```

