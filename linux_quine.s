	.file	"linux_quine.c"
	.intel_syntax noprefix
	.text
	.globl	code
	.section	.rodata
.LC0:
	.string	"/*\n"
	.align 8
.LC1:
	.string	" * Linux x86-64 Quine with Inline Assembly\n"
	.align 8
.LC2:
	.string	" * Demonstrates C, x86-64 Assembly, and Linux syscalls\n"
.LC3:
	.string	" * \n"
	.align 8
.LC4:
	.string	" * This program prints its own source code using:\n"
	.align 8
.LC5:
	.string	" * - C for structure and logic\n"
	.align 8
.LC6:
	.string	" * - Inline x86-64 assembly for system calls\n"
	.align 8
.LC7:
	.string	" * - Linux write() syscall (syscall number 1)\n"
.LC8:
	.string	" */\n"
.LC9:
	.string	"\n"
.LC10:
	.string	"#include <unistd.h>\n"
	.align 8
.LC11:
	.string	"// The quine data - contains the source code as a string\n"
.LC12:
	.string	"char *code[] = {\n"
	.data
	.align 32
	.type	code, @object
	.size	code, 120
code:
	.quad	.LC0
	.quad	.LC1
	.quad	.LC2
	.quad	.LC3
	.quad	.LC4
	.quad	.LC5
	.quad	.LC6
	.quad	.LC7
	.quad	.LC8
	.quad	.LC9
	.quad	.LC10
	.quad	.LC9
	.quad	.LC11
	.quad	.LC12
	.quad	0
	.text
	.globl	asm_write
	.type	asm_write, @function
asm_write:
.LFB0:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	DWORD PTR [rbp-20], edi
	mov	QWORD PTR [rbp-32], rsi
	mov	QWORD PTR [rbp-40], rdx
	mov	eax, DWORD PTR [rbp-20]
	mov	rsi, QWORD PTR [rbp-32]
	mov	rdx, QWORD PTR [rbp-40]
	mov	edi, eax
#APP
# 41 "linux_quine.c" 1
	mov $1, %rax
	syscall
	
# 0 "" 2
#NO_APP
	mov	QWORD PTR [rbp-8], rax
	nop
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	asm_write, .-asm_write
	.globl	asm_strlen
	.type	asm_strlen, @function
asm_strlen:
.LFB1:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	QWORD PTR [rbp-24], rdi
	mov	rax, QWORD PTR [rbp-24]
	mov	rdi, rax
#APP
# 53 "linux_quine.c" 1
	xor %rcx, %rcx
	1:
	cmpb $0, (%rdi,%rcx,1)
	je 2f
	inc %rcx
	jmp 1b
	2:
	
# 0 "" 2
#NO_APP
	mov	rax, rcx
	mov	QWORD PTR [rbp-8], rax
	mov	rax, QWORD PTR [rbp-8]
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	asm_strlen, .-asm_strlen
	.globl	print
	.type	print, @function
print:
.LFB2:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 8
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	mov	rdi, rax
	call	asm_strlen
	mov	rdx, rax
	mov	rax, QWORD PTR [rbp-8]
	mov	rsi, rax
	mov	edi, 1
	call	asm_write
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	print, .-print
	.section	.rodata
.LC13:
	.string	"\""
.LC14:
	.string	"\",\n"
	.text
	.globl	print_quoted
	.type	print_quoted, @function
print_quoted:
.LFB3:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 8
	mov	QWORD PTR [rbp-8], rdi
	mov	edi, OFFSET FLAT:.LC13
	call	print
	mov	rax, QWORD PTR [rbp-8]
	mov	rdi, rax
	call	print
	mov	edi, OFFSET FLAT:.LC14
	call	print
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	print_quoted, .-print_quoted
	.section	.rodata
.LC15:
	.string	"};\n"
	.align 8
.LC16:
	.string	"// Linux system call: write(fd, buf, count)\n"
	.align 8
.LC17:
	.string	"// Uses inline x86-64 assembly to make syscall directly\n"
	.align 8
.LC18:
	.string	"void asm_write(int fd, const char *buf, size_t count) {\n"
.LC19:
	.string	"    long ret;\n"
	.align 8
.LC20:
	.string	"    // x86-64 Linux syscall convention:\n"
	.align 8
.LC21:
	.string	"    // rax = syscall number (1 = write)\n"
	.align 8
.LC22:
	.string	"    // rdi = fd (file descriptor)\n"
	.align 8
.LC23:
	.string	"    // rsi = buf (buffer pointer)\n"
	.align 8
.LC24:
	.string	"    // rdx = count (number of bytes)\n"
.LC25:
	.string	"    __asm__ volatile (\n"
	.align 8
.LC26:
	.string	"        \"mov $1, %%rax\\n\\t\"      // syscall number 1 (write)\n"
	.align 8
.LC27:
	.string	"        \"syscall\\n\\t\"             // invoke kernel\n"
	.align 8
.LC28:
	.string	"        : \"=a\"(ret)               // output: rax -> ret\n"
	.align 8
.LC29:
	.string	"        : \"D\"(fd), \"S\"(buf), \"d\"(count)  // inputs: rdi, rsi, rdx\n"
	.align 8
.LC30:
	.string	"        : \"rcx\", \"r11\", \"memory\"  // clobbered by syscall\n"
.LC31:
	.string	"    );\n"
.LC32:
	.string	"}\n"
	.align 8
.LC33:
	.string	"// Custom strlen using inline assembly\n"
	.align 8
.LC34:
	.string	"size_t asm_strlen(const char *s) {\n"
.LC35:
	.string	"    size_t len;\n"
	.align 8
.LC36:
	.string	"        \"xor %%rcx, %%rcx\\n\\t\"   // rcx = 0 (counter)\n"
	.align 8
.LC37:
	.string	"        \"1:\\n\\t\"                  // label 1\n"
	.align 8
.LC38:
	.string	"        \"cmpb $0, (%%rdi,%%rcx,1)\\n\\t\"  // compare byte at s[rcx] with 0\n"
	.align 8
.LC39:
	.string	"        \"je 2f\\n\\t\"               // if zero, jump to label 2\n"
	.align 8
.LC40:
	.string	"        \"inc %%rcx\\n\\t\"           // increment counter\n"
	.align 8
.LC41:
	.string	"        \"jmp 1b\\n\\t\"              // loop back to label 1\n"
	.align 8
.LC42:
	.string	"        \"2:\\n\\t\"                  // label 2\n"
	.align 8
.LC43:
	.string	"        : \"=c\"(len)               // output: rcx -> len\n"
	.align 8
.LC44:
	.string	"        : \"D\"(s)                  // input: rdi = s\n"
.LC45:
	.string	"        : \"memory\"\n"
.LC46:
	.string	"    return len;\n"
.LC47:
	.string	"void print(const char *s) {\n"
	.align 8
.LC48:
	.string	"    asm_write(1, s, asm_strlen(s));\n"
	.align 8
.LC49:
	.string	"void print_quoted(const char *s) {\n"
.LC50:
	.string	"    print(\"\\\"\");\n"
.LC51:
	.string	"    print(s);\n"
.LC52:
	.string	"    print(\"\\\",\\n\");\n"
.LC53:
	.string	"int main() {\n"
.LC54:
	.string	"    int i;\n"
.LC55:
	.string	"    \n"
	.align 8
.LC56:
	.string	"    // Print the code array declaration part\n"
	.align 8
.LC57:
	.string	"    for (i = 0; code[i]; i++) {\n"
.LC58:
	.string	"        print(code[i]);\n"
.LC59:
	.string	"    }\n"
	.align 8
.LC60:
	.string	"    // Print the code array contents (quoted)\n"
	.align 8
.LC61:
	.string	"        print_quoted(code[i]);\n"
	.align 8
.LC62:
	.string	"    // Print the rest of the source code\n"
.LC63:
	.string	"    print(\"};\");\n"
	.align 8
.LC64:
	.string	"    // ... rest printed above ...\n"
.LC65:
	.string	"    return 0;\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB4:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	DWORD PTR [rbp-4], 0
	jmp	.L7
.L8:
	mov	eax, DWORD PTR [rbp-4]
	cdqe
	mov	rax, QWORD PTR code[0+rax*8]
	mov	rdi, rax
	call	print
	add	DWORD PTR [rbp-4], 1
.L7:
	mov	eax, DWORD PTR [rbp-4]
	cdqe
	mov	rax, QWORD PTR code[0+rax*8]
	test	rax, rax
	jne	.L8
	mov	DWORD PTR [rbp-4], 0
	jmp	.L9
.L10:
	mov	eax, DWORD PTR [rbp-4]
	cdqe
	mov	rax, QWORD PTR code[0+rax*8]
	mov	rdi, rax
	call	print_quoted
	add	DWORD PTR [rbp-4], 1
.L9:
	mov	eax, DWORD PTR [rbp-4]
	cdqe
	mov	rax, QWORD PTR code[0+rax*8]
	test	rax, rax
	jne	.L10
	mov	edi, OFFSET FLAT:.LC15
	call	print
	mov	edi, OFFSET FLAT:.LC9
	call	print
	mov	edi, OFFSET FLAT:.LC16
	call	print
	mov	edi, OFFSET FLAT:.LC17
	call	print
	mov	edi, OFFSET FLAT:.LC18
	call	print
	mov	edi, OFFSET FLAT:.LC19
	call	print
	mov	edi, OFFSET FLAT:.LC20
	call	print
	mov	edi, OFFSET FLAT:.LC21
	call	print
	mov	edi, OFFSET FLAT:.LC22
	call	print
	mov	edi, OFFSET FLAT:.LC23
	call	print
	mov	edi, OFFSET FLAT:.LC24
	call	print
	mov	edi, OFFSET FLAT:.LC25
	call	print
	mov	edi, OFFSET FLAT:.LC26
	call	print
	mov	edi, OFFSET FLAT:.LC27
	call	print
	mov	edi, OFFSET FLAT:.LC28
	call	print
	mov	edi, OFFSET FLAT:.LC29
	call	print
	mov	edi, OFFSET FLAT:.LC30
	call	print
	mov	edi, OFFSET FLAT:.LC31
	call	print
	mov	edi, OFFSET FLAT:.LC32
	call	print
	mov	edi, OFFSET FLAT:.LC9
	call	print
	mov	edi, OFFSET FLAT:.LC33
	call	print
	mov	edi, OFFSET FLAT:.LC34
	call	print
	mov	edi, OFFSET FLAT:.LC35
	call	print
	mov	edi, OFFSET FLAT:.LC25
	call	print
	mov	edi, OFFSET FLAT:.LC36
	call	print
	mov	edi, OFFSET FLAT:.LC37
	call	print
	mov	edi, OFFSET FLAT:.LC38
	call	print
	mov	edi, OFFSET FLAT:.LC39
	call	print
	mov	edi, OFFSET FLAT:.LC40
	call	print
	mov	edi, OFFSET FLAT:.LC41
	call	print
	mov	edi, OFFSET FLAT:.LC42
	call	print
	mov	edi, OFFSET FLAT:.LC43
	call	print
	mov	edi, OFFSET FLAT:.LC44
	call	print
	mov	edi, OFFSET FLAT:.LC45
	call	print
	mov	edi, OFFSET FLAT:.LC31
	call	print
	mov	edi, OFFSET FLAT:.LC46
	call	print
	mov	edi, OFFSET FLAT:.LC32
	call	print
	mov	edi, OFFSET FLAT:.LC9
	call	print
	mov	edi, OFFSET FLAT:.LC47
	call	print
	mov	edi, OFFSET FLAT:.LC48
	call	print
	mov	edi, OFFSET FLAT:.LC32
	call	print
	mov	edi, OFFSET FLAT:.LC9
	call	print
	mov	edi, OFFSET FLAT:.LC49
	call	print
	mov	edi, OFFSET FLAT:.LC50
	call	print
	mov	edi, OFFSET FLAT:.LC51
	call	print
	mov	edi, OFFSET FLAT:.LC52
	call	print
	mov	edi, OFFSET FLAT:.LC32
	call	print
	mov	edi, OFFSET FLAT:.LC9
	call	print
	mov	edi, OFFSET FLAT:.LC53
	call	print
	mov	edi, OFFSET FLAT:.LC54
	call	print
	mov	edi, OFFSET FLAT:.LC55
	call	print
	mov	edi, OFFSET FLAT:.LC56
	call	print
	mov	edi, OFFSET FLAT:.LC57
	call	print
	mov	edi, OFFSET FLAT:.LC58
	call	print
	mov	edi, OFFSET FLAT:.LC59
	call	print
	mov	edi, OFFSET FLAT:.LC55
	call	print
	mov	edi, OFFSET FLAT:.LC60
	call	print
	mov	edi, OFFSET FLAT:.LC57
	call	print
	mov	edi, OFFSET FLAT:.LC61
	call	print
	mov	edi, OFFSET FLAT:.LC59
	call	print
	mov	edi, OFFSET FLAT:.LC55
	call	print
	mov	edi, OFFSET FLAT:.LC62
	call	print
	mov	edi, OFFSET FLAT:.LC63
	call	print
	mov	edi, OFFSET FLAT:.LC64
	call	print
	mov	edi, OFFSET FLAT:.LC65
	call	print
	mov	edi, OFFSET FLAT:.LC32
	call	print
	mov	eax, 0
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4:
	.size	main, .-main
	.ident	"GCC: (GNU) 15.2.1 20251111 (Red Hat 15.2.1-4)"
	.section	.note.GNU-stack,"",@progbits
