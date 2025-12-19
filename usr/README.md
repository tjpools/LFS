# /usr - User Programs and Data

## Purpose
Contains the majority of user utilities, applications, libraries, and shared data. The "usr" historically meant "Unix System Resources" (not "user").

## Key Characteristics
- **Shareable**: Can be mounted read-only or shared via NFS
- **Static**: Doesn't change during normal operation
- **Large**: Usually the largest directory hierarchy
- **Non-essential**: System can boot without /usr (though barely)

## Main Structure

```
/usr/
├── bin/            # User command binaries
├── sbin/           # System administration binaries (non-essential)
├── lib/            # Libraries for /usr/bin and /usr/sbin
├── lib64/          # 64-bit libraries
├── include/        # C header files
├── share/          # Architecture-independent shared data
├── src/            # Source code
├── local/          # Locally installed software
├── games/          # Game binaries
└── libexec/        # Helper programs
```

## /usr/bin - User Binaries

Non-essential command binaries for all users:

### Categories
- **Development**: gcc, make, git, python
- **Editors**: vim, nano, emacs
- **Networking**: ssh, curl, wget, nc
- **File tools**: find, xargs, tar, zip
- **Text processing**: awk, sed, sort, uniq
- **System monitoring**: top, htop, iostat

### Examples
```bash
/usr/bin/
├── python3         # Python interpreter
├── gcc             # C compiler
├── git             # Version control
├── vim             # Text editor
├── ssh             # Secure shell
├── curl            # URL transfer tool
├── find            # File search
└── docker          # Container platform
```

## /usr/bin vs /bin

| Directory | Purpose | Essential |
|-----------|---------|-----------|
| `/bin` | Essential commands (ls, cat, bash) | Boot & single-user mode |
| `/usr/bin` | Additional user commands | Normal operation |

**Note**: Many modern distros merge `/bin` → `/usr/bin` (UsrMerge).

## /usr/sbin - System Binaries

Non-essential system administration binaries:

```bash
/usr/sbin/
├── useradd         # Create users
├── groupadd        # Create groups
├── cron            # Job scheduler
├── sshd            # SSH daemon
├── apache2         # Web server
├── nginx           # Web server
└── named           # DNS server
```

## /usr/lib - Libraries

Shared libraries for programs in `/usr/bin` and `/usr/sbin`:

```
/usr/lib/
├── x86_64-linux-gnu/    # 64-bit libraries (Debian/Ubuntu)
│   ├── libc.so.*       # C library
│   ├── libssl.so.*     # OpenSSL
│   └── libpython3.*.so # Python library
├── gcc/                 # GCC libraries
├── python3/             # Python standard library
├── systemd/             # systemd files
└── firmware/            # Device firmware
```

## /usr/include - Header Files

C/C++ header files for development:

```
/usr/include/
├── stdio.h          # Standard I/O
├── stdlib.h         # Standard library
├── string.h         # String operations
├── sys/             # System headers
│   ├── types.h
│   └── socket.h
├── linux/           # Linux kernel headers
└── openssl/         # OpenSSL headers
```

Used when compiling programs:
```bash
gcc -I/usr/include myprogram.c
```

## /usr/share - Shared Data

Architecture-independent data files:

```
/usr/share/
├── applications/    # Desktop application launchers
│   └── firefox.desktop
├── doc/            # Documentation
│   └── package-name/
├── man/            # Manual pages
│   ├── man1/      # User commands
│   ├── man5/      # File formats
│   └── man8/      # System admin
├── icons/          # Icon themes
├── fonts/          # Font files
├── locale/         # Translations
├── zoneinfo/       # Timezone data
└── pixmaps/        # Images
```

### Documentation
```bash
# Man pages
/usr/share/man/man1/ls.1.gz

# Read with man command
man ls

# Package documentation
/usr/share/doc/apache2/
```

### Desktop Files
```bash
# Application launchers
/usr/share/applications/firefox.desktop

[Desktop Entry]
Name=Firefox
Exec=/usr/bin/firefox
Icon=firefox
Type=Application
```

### Localization
```bash
# Translations
/usr/share/locale/es/LC_MESSAGES/

# Set language
LANG=es_ES.UTF-8 program
```

## /usr/local - Locally Installed Software

For software installed by system administrator (not package manager):

```
/usr/local/
├── bin/            # Local binaries
├── sbin/           # Local system binaries
├── lib/            # Local libraries
├── include/        # Local headers
├── share/          # Local shared data
│   └── man/       # Local man pages
└── src/            # Local source code
```

### Purpose
- Software compiled from source
- Custom scripts and tools
- Third-party software not in repos
- Override system packages

### Installation Example
```bash
# Download and compile
cd /tmp
wget https://example.com/software.tar.gz
tar -xzf software.tar.gz
cd software

# Configure for /usr/local
./configure --prefix=/usr/local

# Build and install
make
sudo make install

# Binary installed to
/usr/local/bin/software
```

## /usr/src - Source Code

Kernel source and other source files:

```
/usr/src/
├── linux-headers-5.15.0-91/    # Kernel headers
├── linux-source-5.15.0/        # Kernel source
└── custom-modules/              # Custom kernel modules
```

### Kernel Headers
Required for compiling kernel modules:
```bash
# Install kernel headers
sudo apt install linux-headers-$(uname -r)

# Location
ls /usr/src/linux-headers-$(uname -r)/
```

## /usr/games - Games

Game binaries (if separated from /usr/bin):

```bash
/usr/games/
├── fortune         # Random fortune
├── cowsay          # ASCII cow
├── sl              # Steam locomotive
└── nethack         # Dungeon crawler
```

## Library Search Path

Programs search for libraries in order:

1. Directories in `LD_LIBRARY_PATH`
2. `/etc/ld.so.conf` and `/etc/ld.so.conf.d/*.conf`
3. `/lib`, `/usr/lib`

```bash
# View library cache
ldconfig -p

# Update cache
sudo ldconfig
```

## PATH Variable

Commands are found via PATH:

```bash
echo $PATH
# /usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games

# Search order:
# 1. /usr/local/bin  (local override)
# 2. /usr/bin        (system programs)
# 3. /bin            (essential programs)
# 4. /usr/local/games
# 5. /usr/games
```

## Hierarchy Priority

```
/usr/local/     # Highest priority (local admin)
/usr/           # System packages
/               # Essential (boot)
```

### Override System Package
```bash
# System has vim 8.2 in /usr/bin/vim
# Install vim 9.0 to /usr/local/bin/vim
# /usr/local/bin is first in PATH
# vim now runs 9.0
```

## Package Manager Integration

### Debian/Ubuntu (apt)
```bash
# apt installs to /usr
apt list --installed | head
dpkg -L package-name
```

### Red Hat/Fedora (dnf/yum)
```bash
# dnf installs to /usr
dnf list installed
rpm -ql package-name
```

### Arch Linux (pacman)
```bash
# pacman installs to /usr
pacman -Q
pacman -Ql package-name
```

## Finding Programs and Files

### Which Command
```bash
which python3
# /usr/bin/python3

which -a python3
# Shows all instances in PATH
```

### Whereis Command
```bash
whereis python3
# python3: /usr/bin/python3 /usr/lib/python3 /usr/share/man/man1/python3.1.gz
```

### Find Package Files
```bash
# Debian/Ubuntu
dpkg -L package-name

# Red Hat/Fedora
rpm -ql package-name

# Arch Linux
pacman -Ql package-name
```

## Common Tasks

### Install from Source
```bash
# Download
wget https://example.com/app.tar.gz
tar -xzf app.tar.gz
cd app

# Build
./configure --prefix=/usr/local
make

# Install
sudo make install

# Result:
# /usr/local/bin/app
# /usr/local/lib/libapp.so
# /usr/local/share/man/man1/app.1
```

### Check Library Dependencies
```bash
ldd /usr/bin/python3
# Shows which libraries it uses

ldd /usr/bin/python3 | grep ssl
# libssl.so.1.1 => /usr/lib/x86_64-linux-gnu/libssl.so.1.1
```

### Search Man Pages
```bash
# Search by command
man ls

# Search by keyword
man -k network
apropos network

# Show all sections
man -a intro
```

### Create Desktop Launcher
```bash
# /usr/share/applications/myapp.desktop
[Desktop Entry]
Type=Application
Name=My Application
Exec=/usr/local/bin/myapp
Icon=/usr/share/pixmaps/myapp.png
Categories=Development;
```

## UsrMerge

Modern distributions merge directories:

```
/bin → /usr/bin
/sbin → /usr/sbin
/lib → /usr/lib
/lib64 → /usr/lib64
```

Check your system:
```bash
ls -ld /bin
# lrwxrwxrwx 1 root root 7 /bin -> usr/bin
```

Benefits:
- Simplified filesystem
- No /usr mount issues
- Easier maintenance

## Disk Usage

```bash
# Total /usr size
du -sh /usr

# By subdirectory
du -sh /usr/* | sort -h

# Largest directories
du -h /usr | sort -h | tail -20
```

Common sizes:
- `/usr/share` - 2-5 GB (docs, locales, icons)
- `/usr/lib` - 1-3 GB (libraries)
- `/usr/bin` - 500 MB - 1 GB (programs)

## Security Considerations

### Read-Only Mount
```bash
# /etc/fstab
/dev/sda2  /usr  ext4  ro  0  2

# Remount read-write for updates
sudo mount -o remount,rw /usr

# Remount read-only
sudo mount -o remount,ro /usr
```

### File Permissions
```bash
# Binaries: world-executable
ls -l /usr/bin/ls
-rwxr-xr-x 1 root root 133792 /usr/bin/ls

# Libraries: world-readable
ls -l /usr/lib/libc.so.6
-rwxr-xr-x 1 root root 1824496 /usr/lib/libc.so.6

# Setuid programs
find /usr/bin -perm -4000 -ls
```

## Backup Strategies

### System Packages (Don't Backup)
```bash
# Can reinstall via package manager
# Just keep list:
dpkg --get-selections > package-list.txt
# Restore:
dpkg --set-selections < package-list.txt
apt-get dselect-upgrade
```

### /usr/local (Do Backup)
```bash
# Custom installations
sudo tar -czf usr_local_backup.tar.gz /usr/local

# Restore
sudo tar -xzf usr_local_backup.tar.gz -C /
```

## Best Practices

✅ **Do:**
- Use package manager for software in `/usr`
- Install custom software to `/usr/local`
- Keep `/usr` read-only when possible
- Document custom installations

❌ **Don't:**
- Manually modify package-managed files
- Install to `/usr` without package manager
- Mix package manager and manual installs
- Delete files from `/usr` without uninstalling

## Summary

- `/usr` contains most user programs and libraries
- `/usr/bin` - User commands
- `/usr/lib` - Shared libraries
- `/usr/share` - Data files, docs, translations
- `/usr/local` - Administrator's custom installs
- Managed by package manager (except /usr/local)
- Can be mounted read-only for security
- UsrMerge merges / and /usr directories
