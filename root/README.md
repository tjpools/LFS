# /root - Root User's Home Directory

## Purpose
The home directory for the root user (superuser/administrator). Similar to `/home/username` but for the system administrator.

## Key Characteristics
- **Root user only**: Only accessible by root
- **Separate from /home**: Not in `/home/root`
- **Located at root**: Directly under `/`
- **Secure**: Restricted permissions (700)

## Why Not /home/root?

The root user's home is at `/root` instead of `/home/root` for important reasons:

1. **Early Boot Access**: Available even if `/home` is on a separate partition
2. **Security**: Isolated from regular user directories
3. **Historical**: Unix tradition dating back decades
4. **Clarity**: Makes it obvious this is the admin account

## Typical Structure

```
/root/
├── .bashrc              # Bash configuration
├── .bash_profile        # Login script
├── .bash_history        # Command history
├── .profile             # Shell profile
├── .ssh/                # SSH keys and config
│   ├── id_rsa          # Private SSH key
│   ├── id_rsa.pub      # Public SSH key
│   ├── authorized_keys  # Allowed SSH keys
│   └── config          # SSH client config
├── .config/             # Application configs
├── .local/              # Local data
├── .cache/              # Cache files
├── scripts/             # Admin scripts
├── backups/             # System backups
└── .vimrc              # Vim configuration
```

## Permissions

```bash
drwx------ 10 root root 4096 Dec 18 10:00 /root
```
- Owner: root
- Group: root
- Mode: 700 (rwx------)
- Only root can read, write, or enter

## Accessing /root

### As Root
```bash
# Switch to root
sudo -i
cd ~  # Now in /root

# Or
sudo su -
pwd   # /root
```

### As Regular User (fails)
```bash
$ cd /root
bash: cd: /root: Permission denied

$ ls /root
ls: cannot open directory '/root': Permission denied
```

### With sudo (specific operations)
```bash
# List contents
sudo ls -la /root

# Read a file
sudo cat /root/.bashrc

# Edit a file
sudo vim /root/script.sh
```

## What Goes in /root?

### System Administration Tools
```bash
/root/scripts/
├── backup.sh           # Backup scripts
├── monitoring.sh       # System monitoring
├── cleanup.sh          # Cleanup scripts
└── maintenance.sh      # Maintenance tasks
```

### Configuration Files
- `.bashrc` - Root's bash configuration
- `.vimrc` - Vim settings for root
- `.ssh/config` - SSH configuration

### Temporary Work
- Downloads for system installation
- Extracted archives
- Testing files

### SSH Keys
```
/root/.ssh/
├── id_rsa              # Private key for root
├── id_rsa.pub          # Public key
├── authorized_keys     # Keys allowed to SSH as root
└── known_hosts         # Known SSH hosts
```

## Important Files

### .bashrc
Root's bash configuration:
```bash
# /root/.bashrc
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
alias ll='ls -la'
alias update='apt update && apt upgrade'

# Colored prompt (red for warning!)
PS1='\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
```

### .bash_history
Contains root's command history:
```bash
sudo cat /root/.bash_history
# Shows all commands run as root
```

### .profile
Login script for root:
```bash
# /root/.profile
PATH="/usr/local/sbin:/usr/local/bin:$PATH"
export PATH
```

## Environment Variables

When you become root:
```bash
sudo -i  # Login as root

echo $HOME     # /root
echo $USER     # root
echo $LOGNAME  # root
echo $PWD      # /root
```

## Common Tasks

### Create admin script
```bash
sudo vim /root/backup.sh
sudo chmod +x /root/backup.sh
```

### Store sensitive credentials
```bash
# Database passwords, API keys, etc.
sudo vim /root/.secrets
sudo chmod 600 /root/.secrets
```

### SSH as root (if enabled)
```bash
# From remote machine
ssh root@server

# Using key
ssh -i ~/.ssh/id_rsa root@server
```

## Root vs sudo

### sudo approach (recommended)
```bash
# Run single command as root
sudo apt update

# Work in your own home
cd ~/scripts
sudo ./admin_script.sh
```

### Root login approach
```bash
# Become root
sudo -i

# Now in /root
cd ~/scripts
./admin_script.sh
```

**Best Practice**: Use `sudo` for single commands, `sudo -i` for extended admin sessions.

## SSH Root Login

### Check if enabled
```bash
sudo grep PermitRootLogin /etc/ssh/sshd_config
```

### Common Settings
```
PermitRootLogin no                    # Disabled (secure)
PermitRootLogin yes                   # Enabled (insecure)
PermitRootLogin prohibit-password     # Only with SSH keys
PermitRootLogin forced-commands-only  # Only for specific commands
```

### Security Best Practice
```bash
# Disable root SSH login
sudo vim /etc/ssh/sshd_config
# Set: PermitRootLogin no

# Restart SSH
sudo systemctl restart sshd
```

## /root vs /home/user

| Aspect | /root | /home/user |
|--------|-------|------------|
| Owner | root | Regular user |
| Permissions | 700 | 755 or 700 |
| Purpose | System administration | Personal use |
| Location | `/root` | `/home/username` |
| Available | Always (on root partition) | May be separate partition |

## Backup Considerations

### What to backup
```bash
# SSH keys (critical!)
/root/.ssh/

# Configuration files
/root/.bashrc
/root/.vimrc

# Admin scripts
/root/scripts/

# Credentials
/root/.secrets
```

### Backup command
```bash
sudo tar -czf root_backup_$(date +%Y%m%d).tar.gz \
  /root/.ssh \
  /root/.bashrc \
  /root/.vimrc \
  /root/scripts
```

### Restore
```bash
sudo tar -xzf root_backup.tar.gz -C /
```

## Disk Usage

Check space used by /root:
```bash
sudo du -sh /root
sudo du -sh /root/* | sort -h
```

## Security Best Practices

✅ **Do:**
- Keep SSH private keys secure (600 permissions)
- Use strong passwords/keys for root
- Audit root's command history periodically
- Backup /root/.ssh/ directory
- Use `sudo` instead of becoming root when possible

❌ **Don't:**
- Enable root SSH login with password
- Share root credentials
- Store sensitive data in world-readable files
- Leave root sessions open unattended
- Use root for daily tasks

## Troubleshooting

### Can't access /root
```bash
# Check if you have sudo privileges
sudo -l

# Become root
sudo -i

# If sudo doesn't work, you need admin to grant access
```

### Lost root password
Boot from Live USB and reset:
```bash
# Mount root filesystem
sudo mount /dev/sda1 /mnt

# Change root into it
sudo chroot /mnt

# Change password
passwd root

# Exit and reboot
exit
sudo umount /mnt
sudo reboot
```

### Permission errors
```bash
# Fix ownership
sudo chown -R root:root /root

# Fix permissions
sudo chmod 700 /root
sudo chmod 700 /root/.ssh
sudo chmod 600 /root/.ssh/id_rsa
```

## Root Shell Prompt

Typically shows:
```bash
# As root (red color warning)
root@hostname:~#

# The # symbol indicates root
# Regular users see $
```

## Interesting Notes

- The `~` (tilde) expands to:
  - `/root` when you're root
  - `/home/username` when you're a regular user
- Root's PATH includes `/sbin` and `/usr/sbin` (system binaries)
- Root bypasses most permission checks
- Root can read/write/delete anything (with great power...)
