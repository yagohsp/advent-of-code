%include "../consts.asm"
%include "macros.asm"
%include "utils.asm"

default rel

PUZZLE_BUFFER_SIZE	equ	1024*1024	; 1MB

section .data
	filename	db	"puzzle.txt", NULL
	multiple_lf	db	LF, LF, LF, LF, LF, LF, NULL

section .bss
	puzzle		resb	PUZZLE_BUFFER_SIZE
	result_buffer	resb	100
	groups		resq	3

section .text
global _start
_start:
	sys_open filename, O_RDONLY
	mov rbx, rax		 	; rbx = file descriptor

	sys_read rbx, puzzle, PUZZLE_BUFFER_SIZE

	lea rbx, [puzzle]
	mov r12, 2

	mov r15d, 0

.iter_group:
	cmp [rbx], NULL
	je .done

	cmp [rbx], LF
	jne .not_lf

	inc rbx
	dec r12 
	js .sum_group

.not_lf:
	mov rdi, [rbx]
	call ascii_to_bitmask

	or [groups + r12 * 8], rax	; join number to bitmask 

	inc rbx
	jmp .iter_group

.sum_group:
	mov rax, [groups]	; get number used by 
	and rax, [groups + 8]
	and rax, [groups + 16]
	bsf rax, rax

	cmp rax, 28
	ja .is_lowercase

; is uppercase
	add rax, 27
	jmp .sum

.is_lowercase:
	sub rax, 31

.sum:
	add r15, rax

	mov r12, 2
	mov qword [groups], 0
	mov qword [groups + 8], 0
	mov qword [groups + 16], 0
	jmp .iter_group


	jmp .done
	
.done:
	mov rdi, r15
	mov rsi, result_buffer
	call print_uint

	sys_exit 0
