# /run - Runtime Variable Data

## Purpose
Contains runtime data for processes that need to store information early in the boot process. Files here are always removed at reboot.

## Key Characteristics
- **Temporary**: Cleared on every boot
- **tmpfs**: Stored in RAM (not on disk)
- **Early boot**: Available before other filesystems mount
- **Modern**: Replaces various locations like `/var/run`

## What is tmpfs?

`tmpfs` is a temporary filesystem stored in RAM:
- Super fast (RAM speed)
- Disappears on reboot
- Size limited by available RAM
- Uses swap if RAM is full

```bash
df -h /run
# Filesystem   Size  Used Avail Use% Mounted on
# tmpfs        1.9G  1.2M  1.9G   1% /run
```

## Why /run Exists

Before `/run`, different distros used different locations:
- `/var/run` (but /var might not be mounted yet)
- `/dev/.something` (hacky)
- `/lib/init/rw/` (weird)

FHS 3.0 standardized on `/run` to solve these issues.

## Typical Structure

```
/run/
├── systemd/           # systemd runtime data
│   ├── system/       # System service state
│   └── users/        # User session state
├── lock/             # Lock files
├── user/             # Per-user runtime directories
│   └── 1000/        # Runtime dir for UID 1000
├── dbus/             # D-Bus system socket
│   └── system_bus_socket
├── utmp              # Currently logged in users
├── NetworkManager/   # Network Manager state
├── cups/             # Print system socket
├── sshd.pid          # SSH daemon PID
├── crond.pid         # Cron daemon PID
├── docker.sock       # Docker socket (sometimes)
└── udev/             # udev runtime data
```

## Common Subdirectories

### /run/systemd/
Systemd's runtime state:
```bash
ls /run/systemd/
# system/          - Service states
# users/           - User sessions
# sessions/        - Login sessions
# seats/           - Physical seats (multi-seat)
# netif/           - Network interfaces
```

### /run/user/UID/
Per-user runtime directory:
```bash
ls /run/user/1000/
# systemd/         - User systemd instance
# pulse/           - PulseAudio socket
# dbus-1/          - User D-Bus session
# gnupg/           - GPG agent socket
# gvfs/            - GNOME Virtual Filesystem
```

Environment variable:
```bash
echo $XDG_RUNTIME_DIR
# /run/user/1000
```

### /run/lock/
Lock files to prevent simultaneous access:
```bash
# Example lock file
/run/lock/myapp.lock
```

## PID Files

Programs store their process ID here:
```bash
cat /run/sshd.pid
# 1234

# Verify it's running
ps -p $(cat /run/sshd.pid)
```

### Common PID files
- `/run/sshd.pid` - SSH daemon
- `/run/crond.pid` - Cron daemon
- `/run/nginx.pid` - Nginx web server
- `/run/dockerd.pid` - Docker daemon

## Unix Sockets

Inter-process communication sockets:
```bash
ls -la /run/*.sock
# srwxrwxrwx 1 root root 0 Dec 18 10:00 /run/docker.sock
# srwxrwxrwx 1 root root 0 Dec 18 10:00 /run/dbus/system_bus_socket
```

- First character `s` = socket
- Used for local IPC (faster than network)

## User Login Tracking

### /run/utmp
Tracks currently logged-in users:
```bash
# View logged in users
who
w
users

# These commands read /run/utmp
```

Format is binary - use tools, don't read directly.

## Practical Examples

### 1. Check if a service is running
```bash
# Via PID file
if [ -f /run/sshd.pid ]; then
  echo "SSH daemon is running"
  cat /run/sshd.pid
fi
```

### 2. View user runtime directory
```bash
# Your runtime directory
ls -la $XDG_RUNTIME_DIR

# All user runtime dirs
ls -la /run/user/
```

### 3. Socket communication
```bash
# Talk to Docker via socket
curl --unix-socket /run/docker.sock http://localhost/version

# Check D-Bus
dbus-monitor --system  # Uses /run/dbus/system_bus_socket
```

### 4. Check logged in users
```bash
who        # Uses /run/utmp
w          # Uses /run/utmp
last       # Uses /var/log/wtmp (permanent log)
```

### 5. Systemd runtime info
```bash
# System state
systemctl status

# User session
systemctl --user status
```

## /run vs Other Temp Directories

| Directory | Purpose | Persistence | Access |
|-----------|---------|-------------|--------|
| `/run` | System runtime data | Cleared on boot | Root mostly |
| `/tmp` | Temporary user files | Cleared periodically | All users |
| `/var/tmp` | Temporary files | Survives reboot | All users |
| `/dev/shm` | Shared memory | tmpfs, cleared on boot | All users |

## Creating Runtime Files

### As a System Service
```bash
# Service creates PID file
echo $$ > /run/myservice.pid

# Create socket
nc -lU /run/myservice.sock
```

### As a Regular User
Users should use `$XDG_RUNTIME_DIR`:
```bash
# Create user runtime file
touch $XDG_RUNTIME_DIR/myapp.pid

# Create user socket
nc -lU $XDG_RUNTIME_DIR/myapp.sock
```

## Permissions

### /run itself
```bash
drwxr-xr-x  root root  /run
```
- Owned by root
- World-readable
- Only root can write

### User directories
```bash
drwx------ user user  /run/user/1000
```
- Owned by user
- Only user can access
- Created by systemd-logind

## Size and Limits

### Check size
```bash
df -h /run
du -sh /run
du -sh /run/* | sort -h
```

### Typical size
- Usually 10-50% of RAM
- Default: 50% of RAM (configurable)

### Change size (temporary)
```bash
sudo mount -o remount,size=2G /run
```

### Change size (permanent)
Add to `/etc/fstab`:
```
tmpfs /run tmpfs defaults,size=2G 0 0
```

## Systemd Integration

### System Units
```bash
# Service runtime directory
RuntimeDirectory=myservice
# Creates /run/myservice owned by service user

# In service file:
[Service]
RuntimeDirectory=myapp
RuntimeDirectoryMode=0755
```

### User Units
```bash
# Uses /run/user/UID/myapp/
RuntimeDirectory=myapp
```

## Troubleshooting

### /run is full
```bash
# Check what's using space
du -sh /run/* | sort -h

# Clean up old files (carefully!)
sudo find /run -type f -mtime +1 -delete

# Increase size
sudo mount -o remount,size=2G /run
```

### Permission denied in /run/user/UID
```bash
# Check ownership
ls -ld $XDG_RUNTIME_DIR

# Should match your UID
echo $UID

# Fix if needed (as root)
sudo chown -R $UID:$UID /run/user/$UID
```

### Missing $XDG_RUNTIME_DIR
```bash
# If variable is unset
if [ -z "$XDG_RUNTIME_DIR" ]; then
  export XDG_RUNTIME_DIR=/run/user/$(id -u)
fi
```

## Security Considerations

### Sensitive Data
⚠️ Don't store secrets in `/run`:
- It's in RAM (can be swapped to disk)
- Some directories are world-readable
- Use proper secrets management instead

### Sockets
Unix sockets in `/run` control system services:
```bash
# Docker socket gives root access
# Never chmod 777 /run/docker.sock!

# Check socket permissions
ls -l /run/docker.sock
srw-rw---- 1 root docker /run/docker.sock
```

## Historical Context

### Old way (pre-/run)
```bash
/var/run → /run       # Compatibility symlink
/var/lock → /run/lock # Compatibility symlink
```

### Migration
Modern systems have `/run`, older systems use `/var/run`:
```bash
# Check what your system uses
ls -ld /var/run
# lrwxrwxrwx 1 root root 6 /var/run -> ../run
```

## Summary

Key points about `/run`:
- ✓ Temporary (cleared on boot)
- ✓ In RAM (fast, no disk I/O)
- ✓ Early boot availability
- ✓ Runtime process data (PIDs, sockets)
- ✓ Per-user runtime directories
- ✗ Not for permanent storage
- ✗ Limited by RAM size
- ✗ Gone after reboot
