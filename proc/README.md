# /proc - Process Information Pseudo-Filesystem

## Purpose
A virtual filesystem that provides an interface to kernel data structures. Contains information about processes and system resources in real-time.

## Key Characteristics
- **Virtual**: Files don't exist on disk (created in memory)
- **Dynamic**: Content changes in real-time
- **Read-mostly**: Used primarily for reading system info
- **No disk space**: Takes zero disk space

## What "Pseudo-filesystem" Means
`/proc` doesn't contain real files. When you read a file in `/proc`, the kernel generates the content on-the-fly from its internal data structures.

## Process Information

### Per-Process Directories
Each running process has a directory named by its PID:
```
/proc/
├── 1/                  # Init process (systemd/init)
├── 1234/              # Process with PID 1234
├── 5678/              # Another process
└── self/              # Symlink to current process
```

### Inside a Process Directory
```
/proc/1234/
├── cmdline            # Command line arguments
├── cwd → /path/       # Current working directory (symlink)
├── environ            # Environment variables
├── exe → /bin/bash    # Executable (symlink)
├── fd/                # File descriptors
│   ├── 0 → /dev/pts/0  # stdin
│   ├── 1 → /dev/pts/0  # stdout
│   └── 2 → /dev/pts/0  # stderr
├── maps               # Memory mappings
├── stat               # Process status
├── status             # Human-readable status
├── limits             # Resource limits
└── task/              # Threads
```

## System Information Files

### CPU & Memory
- `/proc/cpuinfo` - CPU information (cores, model, speed)
- `/proc/meminfo` - Memory usage statistics
- `/proc/loadavg` - System load averages
- `/proc/uptime` - System uptime

### Filesystems & Mounts
- `/proc/mounts` - Mounted filesystems
- `/proc/filesystems` - Supported filesystem types
- `/proc/partitions` - Partition information

### Network
- `/proc/net/dev` - Network interface statistics
- `/proc/net/tcp` - TCP connections
- `/proc/net/udp` - UDP connections
- `/proc/net/route` - Routing table

### System
- `/proc/version` - Kernel version
- `/proc/cmdline` - Kernel command line
- `/proc/modules` - Loaded kernel modules
- `/proc/devices` - Character and block devices

## Common Use Cases

### Check CPU info
```bash
cat /proc/cpuinfo
# Or just count cores
nproc
grep -c processor /proc/cpuinfo
```

### Check memory usage
```bash
cat /proc/meminfo
# Or formatted
free -h
```

### View system uptime
```bash
cat /proc/uptime
# Output: 123456.78 456789.01
# First: seconds since boot
# Second: idle time (sum of all cores)
```

### Check process information
```bash
# Command that started a process
cat /proc/1234/cmdline | tr '\0' ' '

# Process status
cat /proc/1234/status

# What files a process has open
ls -l /proc/1234/fd/

# Where process executable is located
readlink /proc/1234/exe
```

### Network connections
```bash
# TCP connections
cat /proc/net/tcp

# Better formatted
ss -tuna
netstat -tuna
```

### Current process info
```bash
# Your current shell's PID
echo $$

# Info about your shell
cat /proc/self/status
cat /proc/$$/status  # Same thing
```

## /proc/sys - Kernel Tuning

The `/proc/sys/` subdirectory contains tunable kernel parameters:

### Network Settings
```
/proc/sys/net/
├── ipv4/
│   ├── ip_forward              # Enable IP forwarding
│   ├── tcp_keepalive_time      # TCP keepalive
│   └── icmp_echo_ignore_all    # Ignore ping
└── core/
    └── somaxconn               # Socket listen backlog
```

### View/Modify Settings
```bash
# View IP forwarding status
cat /proc/sys/net/ipv4/ip_forward

# Enable IP forwarding (temporary)
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward

# Or use sysctl
sudo sysctl -w net.ipv4.ip_forward=1

# Make permanent (add to /etc/sysctl.conf)
net.ipv4.ip_forward=1
```

### System Settings
```
/proc/sys/kernel/
├── hostname           # System hostname
├── ostype            # OS type (Linux)
├── osrelease         # Kernel release
├── pid_max           # Maximum PID value
└── threads-max       # Max threads
```

### File System Settings
```
/proc/sys/fs/
├── file-max          # Max open files (system-wide)
├── file-nr           # Current open files
└── inode-max         # Max inodes
```

## Practical Examples

### 1. Find which process is using a port
```bash
# Find PID using port 80
sudo lsof -i :80
# Or
sudo ss -lptn | grep :80

# Then check process details
cat /proc/PID/cmdline
```

### 2. Monitor process memory
```bash
# Check memory usage of a process
cat /proc/1234/status | grep VmRSS
cat /proc/1234/status | grep VmSize
```

### 3. See what files a process has open
```bash
ls -l /proc/1234/fd/
lsof -p 1234
```

### 4. Check system load
```bash
cat /proc/loadavg
# Output: 0.52 0.58 0.59 2/567 12345
# 1-min, 5-min, 15-min load averages
# running/total processes
# last PID
```

### 5. View kernel command line
```bash
cat /proc/cmdline
# Shows boot parameters passed to kernel
```

### 6. List all processes
```bash
ls -d /proc/[0-9]*
# Or better
ps aux
```

## System Monitoring Tools

Many tools read from `/proc`:

- `ps` - Process status (reads /proc/*/stat)
- `top`, `htop` - Interactive process viewer
- `free` - Memory usage (reads /proc/meminfo)
- `uptime` - System uptime (reads /proc/uptime)
- `vmstat` - Virtual memory statistics
- `iostat` - I/O statistics
- `lsof` - List open files (reads /proc/*/fd/)

## Writing to /proc

Some files in `/proc` can be written to (with root):

```bash
# Sync filesystems
echo 3 | sudo tee /proc/sys/vm/drop_caches

# Trigger kernel panic (BE CAREFUL!)
echo c | sudo tee /proc/sysrq-trigger

# Adjust swappiness
echo 10 | sudo tee /proc/sys/vm/swappiness
```

## Comparison: /proc vs /sys

| Directory | Purpose | Content |
|-----------|---------|---------|
| `/proc` | Process & system info | Processes, memory, network |
| `/sys` | Device & driver info | Hardware, drivers, kernel objects |

Think of:
- `/proc` → "What's running and how's the system?"
- `/sys` → "What hardware do I have and how is it configured?"

## Important Files Reference

### System Info
- `/proc/version` - Kernel version string
- `/proc/uptime` - System uptime in seconds
- `/proc/loadavg` - Load averages
- `/proc/meminfo` - Memory information
- `/proc/cpuinfo` - CPU information

### Process Info
- `/proc/PID/cmdline` - Command line
- `/proc/PID/status` - Process status
- `/proc/PID/environ` - Environment
- `/proc/PID/fd/` - Open file descriptors
- `/proc/PID/maps` - Memory maps

### Network Info
- `/proc/net/dev` - Interface stats
- `/proc/net/tcp` - TCP sockets
- `/proc/net/udp` - UDP sockets
- `/proc/net/route` - Routing table

## Troubleshooting

### Permission denied
Many files in `/proc` require root access:
```bash
# Regular user
cat /proc/1/environ  # Permission denied

# With sudo
sudo cat /proc/1/environ
```

### Binary/unreadable files
Some files contain binary data:
```bash
# Use hexdump or strings
sudo strings /proc/kcore
sudo hexdump -C /proc/kcore | head
```

### Process directory disappeared
Processes come and go - if you get "No such file":
```bash
cat /proc/12345/status  # No such file
# Process probably ended
```

## Security Note
`/proc` exposes sensitive system information. On multi-user systems:
- Process owners can read their own `/proc/PID/` entries
- Root can read all entries
- Some entries (like environment variables) may contain secrets

## Fun Facts
- `/proc/kcore` represents the entire physical memory (don't try to `cat` it!)
- `/proc/self` always points to the current process
- You can crash your system by writing to certain `/proc` files (be careful!)
