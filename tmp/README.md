# /tmp - Temporary Files

## Purpose
Storage for temporary files that can be deleted at any time. Used by programs and users to store short-term data.

## Key Characteristics
- **Temporary**: Files may be deleted automatically
- **World-writable**: All users can create files here
- **Volatile**: Content not guaranteed to persist
- **Fast**: Often mounted as tmpfs (RAM-based)

## Key Features

### Cleanup Policies
Files in `/tmp` are typically deleted:
- **On reboot**: Always cleared
- **After 10 days**: Default on many distributions
- **Manual cleanup**: System admin can clean anytime
- **systemd-tmpfiles**: Automatic periodic cleanup

### tmpfs Mounting
Many modern systems mount `/tmp` in RAM:
```bash
df -h /tmp
# Filesystem   Size  Used Avail Use% Mounted on
# tmpfs        3.9G  156M  3.7G   4% /tmp
```

Benefits:
- ✓ Very fast (RAM speed)
- ✓ Automatically cleared on reboot
- ✓ No disk I/O wear

Drawbacks:
- ✗ Limited by RAM size
- ✗ Uses system memory
- ✗ Lost on crash

## Permissions

```bash
ls -ld /tmp
drwxrwxrwt 15 root root 4096 Dec 18 10:00 /tmp
```

- `rwxrwxrwx` (777): Everyone can read, write, execute
- `t` (sticky bit): Only owner can delete their files

## The Sticky Bit

The 't' at the end is crucial:
```bash
# With sticky bit (t)
drwxrwxrwt  # Users can only delete their own files

# Without sticky bit (dangerous!)
drwxrwxrwx  # Users could delete anyone's files
```

Set sticky bit:
```bash
sudo chmod +t /tmp
# or
sudo chmod 1777 /tmp
```

## Common Uses

### 1. Application Temporary Files
```bash
/tmp/
├── npm-12345/           # npm cache
├── pip-build-1234/      # pip builds
├── mozilla_user0/       # Firefox cache
├── .X11-unix/           # X11 sockets
└── systemd-private-*/   # systemd private tmp
```

### 2. User Downloads/Testing
```bash
# Download file temporarily
cd /tmp
wget https://example.com/file.tar.gz
tar -xzf file.tar.gz
```

### 3. Inter-Process Communication
```bash
# Create named pipe
mkfifo /tmp/mypipe

# Create Unix socket
nc -lU /tmp/mysocket
```

### 4. Build Artifacts
```bash
# Compile in /tmp
cd /tmp
git clone https://github.com/user/repo.git
cd repo && make
```

### 5. Script Temporary Files
```bash
#!/bin/bash
TEMP_FILE=$(mktemp /tmp/myscript.XXXXXX)
echo "data" > "$TEMP_FILE"
process_data "$TEMP_FILE"
rm "$TEMP_FILE"
```

## Creating Secure Temporary Files

### mktemp Command
```bash
# Create temporary file
TMPFILE=$(mktemp)
echo "data" > "$TMPFILE"
rm "$TMPFILE"

# With custom template
TMPFILE=$(mktemp /tmp/myapp.XXXXXX)

# Create temporary directory
TMPDIR=$(mktemp -d)
cd "$TMPDIR"
# ... do work ...
rm -rf "$TMPDIR"

# Create in current directory
TMPFILE=$(mktemp ./temp.XXXXXX)
```

### Why Use mktemp?
- Creates unique filenames (avoids collisions)
- Sets secure permissions (600)
- Prevents race conditions
- Returns absolute path

## Storage Limits

### Check Available Space
```bash
df -h /tmp
du -sh /tmp
```

### Disk vs RAM
```bash
# Check if tmpfs
mount | grep /tmp
# tmpfs on /tmp type tmpfs (rw,nosuid,nodev)

# If tmpfs, limited by RAM
free -h
```

### Quota Issues
```bash
# If /tmp fills up
du -sh /tmp/* | sort -h
# Find and remove large files
```

## Cleanup Policies

### systemd-tmpfiles
Modern systems use systemd:
```bash
# Configuration
cat /usr/lib/tmpfiles.d/tmp.conf
# d /tmp 1777 root root 10d
# Clear files older than 10 days

# Manual cleanup
sudo systemd-tmpfiles --clean
```

### Manual Cleanup
```bash
# Find old files
find /tmp -type f -mtime +7

# Delete old files (careful!)
sudo find /tmp -type f -mtime +7 -delete

# Clean empty directories
sudo find /tmp -type d -empty -delete
```

### On Boot
Most systems clear `/tmp` on reboot:
- tmpfs: Automatically cleared (in RAM)
- Disk-based: Cleared by init scripts

## Security Considerations

### Sticky Bit Protection
```bash
# Create file
touch /tmp/myfile

# Other users can't delete it
sudo -u otheruser rm /tmp/myfile
# rm: cannot remove '/tmp/myfile': Operation not permitted

# Only you or root can delete
rm /tmp/myfile  # Works
```

### Race Conditions
❌ **Insecure**:
```bash
# Predictable filename
FILE="/tmp/myapp.$$"
echo "data" > "$FILE"
# Attacker can guess filename and create symlink
```

✅ **Secure**:
```bash
# Random, unpredictable filename
FILE=$(mktemp)
echo "data" > "$FILE"
```

### Symlink Attacks
❌ **Vulnerable**:
```bash
rm -rf /tmp/myapp  # If /tmp/myapp is a symlink to /home...
```

✅ **Safe**:
```bash
# Check if it's a symlink first
if [ -L "/tmp/myapp" ]; then
  echo "Symlink detected!"
  exit 1
fi
rm -rf /tmp/myapp
```

### Private Temp Directories
```bash
# Create private temp dir
TMPDIR=$(mktemp -d)
chmod 700 "$TMPDIR"  # Only you can access

# Use it
cd "$TMPDIR"
# ... work ...

# Clean up
cd
rm -rf "$TMPDIR"
```

## /tmp vs Other Temp Directories

| Directory | Persistence | Cleanup | Use Case |
|-----------|-------------|---------|----------|
| `/tmp` | Until reboot or 10 days | Aggressive | Short-term files |
| `/var/tmp` | Survives reboot | Conservative (30 days) | Longer-term temp files |
| `$TMPDIR` | User-defined | User's responsibility | Portable scripts |
| `~/.cache` | Persistent | Manual | Application caches |

### When to Use What

**Use /tmp for:**
- Session-specific files
- Short-lived data
- Build artifacts
- Quick tests

**Use /var/tmp for:**
- Files needed across reboots
- Larger temporary files
- Log rotation temp files
- Package manager caches

## Common Patterns

### Script Template
```bash
#!/bin/bash
set -euo pipefail

# Create temp directory
TMPDIR=$(mktemp -d)
trap "rm -rf '$TMPDIR'" EXIT  # Clean up on exit

# Use temp directory
cd "$TMPDIR"
# ... do work ...

# Automatic cleanup via trap
```

### Download and Extract
```bash
cd /tmp
wget https://example.com/package.tar.gz
tar -xzf package.tar.gz
cd package
./configure && make
sudo make install
cd
rm -rf /tmp/package*
```

### Named Pipe Communication
```bash
# Terminal 1
mkfifo /tmp/mypipe
cat /tmp/mypipe

# Terminal 2
echo "Hello" > /tmp/mypipe
```

### Socket Files
```bash
# Create socket
nc -lU /tmp/mysocket &

# Connect to socket
nc -U /tmp/mysocket
```

## System Temporary Directories

### Per-Service Private /tmp
systemd can isolate services:
```ini
# /etc/systemd/system/myservice.service
[Service]
PrivateTmp=yes
# Service sees unique /tmp, not shared
```

Location:
```
/tmp/systemd-private-xxxxx-myservice.service-yyyyy/tmp/
```

### X11 Sockets
```bash
ls -la /tmp/.X11-unix/
# srwxrwxrwx 1 root root 0 X0
# Used by X Window System
```

### D-Bus Sockets (user)
```bash
# In /tmp or /run/user/UID/
ls -la /tmp/dbus-*
```

## Monitoring and Maintenance

### Watch Space Usage
```bash
watch -n 5 df -h /tmp
```

### Find Large Files
```bash
du -sh /tmp/* | sort -h | tail -10
```

### Find Files by Age
```bash
# Files older than 7 days
find /tmp -type f -mtime +7 -ls

# Files accessed in last hour
find /tmp -type f -amin -60 -ls

# Files modified today
find /tmp -type f -mtime 0 -ls
```

### Find Files by Size
```bash
# Files larger than 100MB
find /tmp -type f -size +100M -ls

# Total size of old files
find /tmp -type f -mtime +7 -exec du -ch {} + | grep total
```

## Configuration

### systemd-tmpfiles Config
```bash
# /etc/tmpfiles.d/custom.conf

# d: create directory
# /tmp: path
# 1777: permissions
# root root: owner group
# 10d: clean after 10 days

d /tmp 1777 root root 10d

# Don't clean certain directories
x /tmp/important
```

### Mount Options
```bash
# /etc/fstab
tmpfs /tmp tmpfs defaults,size=4G,mode=1777 0 0
```

Options:
- `size=4G`: Max 4GB
- `mode=1777`: Permissions with sticky bit
- `nosuid`: Prevent setuid binaries
- `noexec`: Prevent execution (breaks some apps)
- `nodev`: Prevent device files

## Troubleshooting

### /tmp is Full
```bash
# Check what's using space
du -sh /tmp/* | sort -h

# Clean old files
sudo find /tmp -type f -mtime +1 -delete

# If tmpfs, increase size
sudo mount -o remount,size=8G /tmp
```

### Permission Issues
```bash
# Check sticky bit
ls -ld /tmp
# Should show 't' at end

# Fix permissions
sudo chmod 1777 /tmp
```

### Can't Delete File
```bash
# Not owner?
ls -l /tmp/file

# Immutable attribute?
lsattr /tmp/file
sudo chattr -i /tmp/file

# File in use?
lsof /tmp/file
```

## Best Practices

✅ **Do:**
- Use `mktemp` for creating temp files
- Clean up after yourself
- Use trap for automatic cleanup
- Check available space before large operations
- Use appropriate permissions (600 for sensitive data)

❌ **Don't:**
- Store important data in /tmp
- Use predictable filenames
- Assume files will persist
- Store secrets unencrypted
- Delete files you don't own (unless root)

## Summary

- `/tmp` is for temporary files
- Cleared on reboot (and periodically)
- World-writable with sticky bit
- Often tmpfs (RAM-based)
- Use `mktemp` for security
- Not for permanent storage
- Clean up your own files
