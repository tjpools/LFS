# Linux File System Structure

This directory contains a representation of the standard Linux Filesystem Hierarchy Standard (FHS).
Use this as a learning resource to understand where different types of files live in a Linux system.

## Quick Overview

```
/                   Root directory - everything starts here
├── bin/           Essential command binaries (for all users)
├── boot/          Boot loader files (kernel, initrd)
├── dev/           Device files
├── etc/           System configuration files
├── home/          User home directories
├── lib/           Essential shared libraries
├── media/         Mount points for removable media
├── mnt/           Temporary mount points
├── opt/           Optional/add-on application software
├── proc/          Virtual filesystem for process info
├── root/          Root user's home directory
├── run/           Runtime variable data
├── sbin/          System binaries (for system admin)
├── srv/           Service data
├── sys/           Virtual filesystem for kernel/device info
├── tmp/           Temporary files
├── usr/           User utilities and applications
└── var/           Variable data (logs, caches, etc.)
```

## Navigation Guide

Each directory contains a `README.md` file with:
- Purpose and description
- Typical contents
- Important subdirectories
- Real-world examples
- Common use cases

Start exploring from any directory to learn more!

---

## Epilogue: The Language of Linux

Linux was born from the marriage of **C** and **Assembly**, a union that perfectly balances power and portability. When Linus Torvalds began writing Linux in 1991, he chose C as the primary language because it provided:

- **Low-level control** - Direct hardware access when needed
- **Portability** - Code that could run on different architectures
- **Efficiency** - Performance close to assembly
- **Maintainability** - Readable, structured code

But C alone wasn't enough. For the most performance-critical sections—context switching, interrupt handling, system call entry points—Linus dropped down to **x86 assembly language**. This hybrid approach became Linux's DNA: mostly C (~98%) with strategic assembly where it matters.

### Living Example: linux_quine.c

To demonstrate this C-Assembly-Linux trinity, this repository includes `linux_quine.c`—a self-printing program (quine) that:

- Uses **C** for structure and logic
- Uses **inline x86-64 assembly** for raw performance
- Makes **direct Linux system calls** without any C library wrapper

When you run it, you're watching C and assembly collaborate, just as they do in the kernel:

```bash
# Compile and run the quine
gcc -o linux_quine linux_quine.c
./linux_quine

# See the raw syscalls to the kernel
strace -c ./linux_quine

# View the assembly GCC generated
gcc -S -masm=intel linux_quine.c -o linux_quine.s
less linux_quine.s
```

The program bypasses libc entirely, using inline assembly to invoke Linux syscall #1 (write) directly. This is the same mechanism the kernel uses internally—the same dance between C and assembly that makes Linux possible.

**See [README_QUINE.md](README_QUINE.md) for full details and exploration exercises.**

### Why This Matters

Understanding this C-Assembly-Linux relationship helps you understand:

- Why `/proc` and `/sys` expose kernel data structures as files
- How system calls bridge userspace and kernel space  
- Why device files in `/dev` represent hardware as file descriptors
- How everything in Linux is designed around this elegant abstraction

Linux isn't just an operating system—it's a philosophy: give programmers powerful, low-level tools (C + assembly) but wrap them in simple, universal interfaces (files, processes, syscalls). This filesystem you're exploring is the visible manifestation of that philosophy.

**Now explore the directories and see how it all comes together!** 🐧
