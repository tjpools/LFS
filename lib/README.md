# /lib - Essential Shared Libraries

## Purpose
Contains essential shared libraries needed by binaries in `/bin` and `/sbin` for booting the system and running in single-user mode.

## Key Characteristics
- **System critical**: Required for basic system operation
- **Shared libraries**: Code used by multiple programs
- **Kernel modules**: Device drivers and kernel extensions
- **Dynamic linking**: Libraries loaded at runtime

## Common Contents

### Shared Libraries
- `libc.so.*` - C standard library (fundamental)
- `libm.so.*` - Math library
- `libpthread.so.*` - POSIX threads library
- `libdl.so.*` - Dynamic linking loader
- `libcrypt.so.*` - Cryptography library

### Architecture-Specific Directories
- `/lib/x86_64-linux-gnu/` - 64-bit x86 libraries (Debian/Ubuntu)
- `/lib64/` - 64-bit libraries (Red Hat/Fedora)
- `/lib32/` - 32-bit libraries (on 64-bit systems)

### Kernel Modules
- `/lib/modules/$(uname -r)/` - Current kernel modules
  - `kernel/` - Core kernel modules
    - `drivers/` - Hardware drivers
    - `fs/` - Filesystem drivers
    - `net/` - Network drivers
  - `modules.dep` - Module dependencies

### Firmware
- `/lib/firmware/` - Binary firmware files for hardware

## Library Naming Convention

```
libname.so.major.minor.patch

Examples:
libc.so.6         # C library, major version 6
libssl.so.1.1     # OpenSSL library
libpthread.so.0   # Threading library
```

## Shared Library Loading

### The Dynamic Linker
- `/lib/ld-linux.so.*` - Dynamic linker/loader
- Loads shared libraries when programs start

### Library Search Path
1. Directories in `LD_LIBRARY_PATH`
2. Directories in `/etc/ld.so.conf` and `/etc/ld.so.conf.d/`
3. `/lib` and `/usr/lib`

## Common Commands

### List loaded libraries
```bash
# See which libraries a program uses
ldd /bin/bash

# Example output:
# linux-vdso.so.1
# libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6
```

### Update library cache
```bash
sudo ldconfig
```

### View library cache
```bash
ldconfig -p | grep libc
```

### Check module information
```bash
# List loaded kernel modules
lsmod

# Info about a specific module
modinfo e1000e
```

### Load/unload kernel modules
```bash
# Load a module
sudo modprobe module_name

# Unload a module
sudo modprobe -r module_name
```

## Kernel Modules

### Module Files
```
/lib/modules/5.15.0-91-generic/
├── kernel/
│   ├── drivers/        # Hardware drivers
│   │   ├── net/       # Network cards
│   │   ├── usb/       # USB devices
│   │   └── gpu/       # Graphics
│   ├── fs/            # Filesystems (ext4, xfs)
│   └── net/           # Networking protocols
├── modules.dep        # Module dependencies
└── modules.alias      # Module aliases
```

### Common Modules
- `e1000e` - Intel network card driver
- `ext4` - ext4 filesystem
- `nvidia` - NVIDIA graphics driver
- `usb_storage` - USB storage devices

## vs Other Library Directories

| Directory | Purpose |
|-----------|---------|
| `/lib` | Essential libraries for boot and single-user mode |
| `/usr/lib` | Non-essential shared libraries for user programs |
| `/usr/local/lib` | Libraries for locally compiled software |

## Symbolic Links

Most library files are symbolic links:
```bash
libc.so.6 -> libc-2.31.so
```
- `libc.so.6` - Soname (used by programs)
- `libc-2.31.so` - Real library file

## Firmware Files

Hardware often requires binary firmware:
```
/lib/firmware/
├── intel/           # Intel device firmware
├── nvidia/          # NVIDIA GPU firmware
├── rtl_nic/        # Realtek network cards
└── regulatory.db   # Wireless regulatory database
```

## Package Management

Libraries are typically managed by package manager:
```bash
# Find which package provides a library
dpkg -S /lib/x86_64-linux-gnu/libc.so.6  # Debian/Ubuntu
rpm -qf /lib64/libc.so.6                  # Red Hat/Fedora

# List files in a library package
dpkg -L libc6                             # Debian/Ubuntu
```

## Troubleshooting

### Missing library error
```bash
error while loading shared libraries: libfoo.so.1: cannot open shared object file

# Solutions:
1. Install the package providing the library
2. Update library cache: sudo ldconfig
3. Check LD_LIBRARY_PATH
```

### Module won't load
```bash
# Check module dependencies
modprobe --show-depends module_name

# Check for conflicts
dmesg | grep module_name
```

## Security Note
⚠️ Libraries run with the privileges of the calling program. Compromised libraries can be a security risk. Only install libraries from trusted sources.
