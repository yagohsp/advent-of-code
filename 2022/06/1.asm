%include "../consts.asm"
%include "macros.asm"
%include "utils.asm"

PUZZLE_SIZE	equ 	1024*10

section .rodata
	filename	db	"puzzle.txt", NULL

section .bss
	puzzle		resb	PUZZLE_SIZE

section .text
global _start:
_start:
	sys_open filename, O_RDONLY
	mov rdi, rax

	sys_read rdi, puzzle, PUZZLE_SIZE
	lea rbx, puzzle
	lea r13, puzzle

	xor edi, edi
	xor r12d, r12d

	mov dil, byte [rbx]
	call ascii_to_bitmask
	xor r12, rax
	inc rbx

	mov dil, byte [rbx]
	call ascii_to_bitmask
	xor r12, rax
	inc rbx

	mov dil, byte [rbx]
	call ascii_to_bitmask
	xor r12, rax
	inc rbx

	mov dil, byte [rbx]
	call ascii_to_bitmask
	xor r12, rax
	inc rbx

.loop:
	popcnt rax, r12
	cmp rax, 4
	je .end

	mov dil, byte [rbx - 4]
	call ascii_to_bitmask
	xor r12, rax

	mov dil, byte [rbx]
	call ascii_to_bitmask
	xor r12, rax

	inc rbx
	jmp .loop

.end:
	sub rbx, r13

	mov rdi, rbx
	call print_uint

	sys_exit 0
