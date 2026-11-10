%include "../consts.asm"
%include "macros.asm"
%include "utils.asm"

default rel

BUFFER_SIZE		equ	1024*1024 + 1

section .data
	filename	db	"puzzle.txt", NULL

section .bss
	buffer		resb	BUFFER_SIZE	

section .text
global _start
_start:
	sys_open filename, O_RDONLY
	mov rbx, rax	; file descriptor

	sys_read rbx, buffer, BUFFER_SIZE
	mov [buffer + rax], NULL

	mov ebx, 0	; result sum
	mov r12, buffer ; buffer pointer

.iter_line:
	cmp byte [r12], NULL
	jz .done

	mov rdi, r12
	call str_to_uint 
	push rax	; start num first range
	mov r12, rdi	; move buffer pointer to the end of string
	inc r12		; jump '-'

	mov rdi, r12
	call str_to_uint 
	push rax	; end num first range
	mov r12, rdi	; move buffer pointer to the end of string
	inc r12		; jump ','

	mov rdi, r12
	call str_to_uint 
	push rax	; start num second range
	mov r12, rdi	; move buffer pointer to the end of string
	inc r12		; jump '-'

	mov rdi, r12
	call str_to_uint 
	push rax	; end num second range
	mov r12, rdi	; move buffer pointer to the end of string
	inc r12		; jump ','


	; pop arguments in reverse
	pop rcx 
	pop rdx 
	pop rsi 
	pop rdi 
	
	call do_pairs_fully_contain
	add rbx, rax

	cmp byte [r12], LF
	jne .iter_line

.done:
	mov rdi, rbx
	mov rsi, buffer
	call print_uint

	sys_exit 0



; in	rdi = 1-start, rsi = 1-end, rdx = 2-start, rcx = 2-end
; out 	rax = bool fully contain or not 
do_pairs_fully_contain:
; if first contais the second 1-start <= 2-start && 1-end >= 2-end
	cmp rdi, rdx
	ja .try_inverse	 
	cmp rsi, rcx	
	jb .try_inverse

	jmp .it_contains 

; if second contains the first 2-start <= 1-start && 2-end >= 1-end
.try_inverse:
	cmp rdx, rdi
	ja .not_contains 
	cmp rcx, rsi
	jb .not_contains 

.it_contains:
	mov rax, TRUE
	ret

.not_contains:
	mov rax, FALSE
	ret
