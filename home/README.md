# /home - User Home Directories

## Purpose
Contains personal directories for all regular (non-root) users. Each user has their own subdirectory for personal files, configurations, and data.

## Key Characteristics
- **User-owned**: Each user owns their home directory
- **Private**: By default, only the user can access their files
- **Customizable**: Users can organize as they wish
- **Persistent**: Survives system updates

## Typical Structure

### User Directory Example: /home/username/
```
/home/username/
├── Desktop/          # Desktop files (GUI systems)
├── Documents/        # Personal documents
├── Downloads/        # Downloaded files
├── Music/            # Audio files
├── Pictures/         # Images and photos
├── Videos/           # Video files
├── Public/           # Files shared with other users
├── Templates/        # Document templates
├── .config/          # Application configurations
├── .local/           # User-specific data
│   ├── bin/         # User's personal executables
│   ├── share/       # User's application data
│   └── state/       # Application state files
├── .cache/           # Application cache files
├── .bashrc          # Bash configuration
├── .bash_history    # Command history
├── .bash_logout     # Logout script
└── .profile         # Login script
```

## Hidden Files (Dotfiles)

Files starting with `.` are hidden by default:

### Configuration Files
- `.bashrc` - Bash shell configuration
- `.bash_profile` - Login shell configuration
- `.profile` - Shell-agnostic login config
- `.vimrc` - Vim editor configuration
- `.gitconfig` - Git configuration

### Application Data
- `.ssh/` - SSH keys and config
- `.gnupg/` - GPG keys
- `.config/` - Modern app configurations
- `.local/` - XDG user directories

### History & Cache
- `.bash_history` - Command history
- `.cache/` - Application caches
- `.lesshst` - Less command history

## Environment Variables

```bash
$HOME          # Path to user's home directory
$USER          # Current username
$PWD           # Current working directory
```

## Home Directory Shortcuts

```bash
~              # Current user's home
~/Documents    # Same as $HOME/Documents
~username      # Another user's home (if accessible)
cd             # Go to home (no arguments)
cd ~           # Go to home (explicit)
```

## Permissions

Default home directory permissions:
```bash
drwxr-xr-x  # 755 - User: rwx, Group: rx, Others: rx
# OR
drwx------  # 700 - User: rwx, Group: ---, Others: ---
```

More secure (700):
```bash
chmod 700 /home/username
```

## Common Tasks

### Create new user with home directory
```bash
sudo useradd -m -s /bin/bash username
```

### Switch to home directory
```bash
cd
# or
cd ~
# or
cd $HOME
```

### List hidden files
```bash
ls -la ~
```

### Check disk usage
```bash
du -sh ~/
df -h ~
```

### Backup home directory
```bash
tar -czf ~/backup_$(date +%Y%m%d).tar.gz ~/Documents ~/Pictures
```

## XDG Base Directory Specification

Modern Linux follows XDG standards:

- `~/.config/` - User configuration files
- `~/.local/share/` - User data files
- `~/.cache/` - Non-essential cached data
- `~/.local/state/` - State data (logs, history)

## Multi-User Considerations

### Shared Groups
Users can share files via groups:
```bash
# Create shared directory
sudo mkdir /home/shared
sudo chgrp developers /home/shared
sudo chmod 2775 /home/shared
```

### Disk Quotas
Admins can set disk quotas per user:
```bash
sudo quota -u username
```

## Security Notes

⚠️ **Important Security Practices**:
- Keep SSH private keys (`~/.ssh/id_rsa`) with 600 permissions
- Never share your home directory with 777 permissions
- Regularly review `~/.ssh/authorized_keys`
- Be cautious with setuid binaries in `~/bin`

## Skeleton Directory
When a new user is created, files from `/etc/skel/` are copied to their home directory.
