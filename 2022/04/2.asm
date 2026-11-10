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
	
	call do_pairs_overlap
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
do_pairs_overlap:
; 1-start <= 2-end && 2-start <= 1-end
	cmp rdi, rcx
	ja .dont_overlap
	cmp rdx, rsi
	ja .dont_overlap

.overlap:
	mov rax, TRUE
	ret

.dont_overlap:
	mov rax, FALSE
	ret
