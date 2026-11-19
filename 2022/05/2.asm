default rel

%include "../consts.asm"
%include "macros.asm"
%include "utils.asm"

%macro print_stack 0
	mov rdi, crates
	mov rsi, [crates_qtd]
	call stack_print

	PRINT_LIT `\n`
%endmacro

struc Stack
	.len: resb 1
	.values: resb 50
endstruc

BUFFER_SIZE	equ	1024*1024*5
MIN_CRATES_QTD	equ	10
filename	db	"puzzle.txt", NULL

section .bss
	puzzle		resb	BUFFER_SIZE
	crates		resb	Stack_size * MIN_CRATES_QTD
	crates_qtd	resb	1

section .text
global _start
_start:
	sys_open filename, O_RDONLY
	mov rdi, rax			; file descriptor

	sys_read rdi, puzzle, BUFFER_SIZE

	lea rbx, puzzle
	inc rbx			; crate value

	xor r12d, r12d		; stack index
	jmp .iter_crate 

.iter_line:
	xor r12d, r12d		; stack index

	cmp byte [rbx], "1"
	je .next_puzzle_section

.iter_crate:
	cmp byte [rbx], " "
	je .next_crate

	mov rdi, crates
	mov rsi, r12
	movzx rdx, byte [rbx]
	call stack_push

.next_crate:
	cmp byte [rbx + 2], LF		
	lea rbx, [rbx + 4]	
	lea r12, [r12 + 1]
	jne .iter_crate	

	jmp .iter_line

.next_puzzle_section:
	; jump crates index line
	mov rdi, rbx
	call jump_line
	mov rbx, rax

	; get last crate index
	lea rdi, [rbx - 3]
	call str_to_uint
	mov [crates_qtd], rax

	movzx r12d, byte [crates_qtd]
	dec r12

.iter_reverse:
	cmp r12, 0
	js .iter_move

	mov rdi, crates
	mov rsi, r12
	call stack_reverse

	dec r12
	jmp .iter_reverse

.iter_move:
	cmp byte [rbx], 0
	je .end

	mov rdi, rbx
	call jump_line
	mov rbx, rax

	; jump to move quantity
	add rbx, 5

	mov rdi, rbx
	call str_to_uint
	mov r12, rax		; move quantity
	mov rbx, rdi		; jump number

	; moves occur from a crate to another
	add rbx, 6		; jump to the "from" crate index
	mov rdi, rbx
	call str_to_uint
	mov r13, rax		; "from" crate number
	dec r13			; parse to index
	mov rbx, rdi		; jump number

	add rbx, 4		; jump to the "to" crate index
	mov rdi, rbx
	call str_to_uint
	mov r14, rax		; "from" crate index
	dec r14			; parse to index

	mov r15, r12

.loop_pop:
	cmp r15, 0
	je .loop_push

	mov rdi, crates
	mov rsi, r13
	call stack_pop
	push rax

	dec r15
	jmp .loop_pop

.loop_push:
	cmp r12, 0
	je .iter_move

	mov rdi, crates
	mov rsi, r14
	pop rdx
	call stack_push

	dec r12
	jmp .loop_push

.end:
	; print_stack

	mov rdi, crates
	movzx esi, byte [crates_qtd]
	call stack_print_all_top

	sys_exit 0


; in	rdi = *stack, rsi = index, rdx = value
stack_push:
	imul rax, rsi, Stack_size
	lea rax, [rdi + rax]		; *stack 
	add rax, Stack.len		; *stack len

	lea rcx, [rax + Stack.values]	; *stack base
	movzx r8d, byte [rax]
	add rcx, r8			; *stack top

	mov [rcx], dl			; store value
	inc [rax]			; inc stack len

	ret

; in	rdi = *stack, rsi = stack index
; out	rax = removed value
stack_pop:
	imul r10, rsi, Stack_size
	lea r10, [rdi + r10]		; *stack
	add r10, Stack.len		; *stack len

	mov r8, r10
	add r8, Stack.values		; *stack base

	movzx r9d, byte [r10] 
	add r8, r9			; *stack top
	dec r8

	mov rax, [r8]			; value to be removed

	mov byte [r8], 0		; zero top value
	dec [r10]			; dec len

	ret

; in	rdi = *stack, rsi = stack index
stack_reverse:
	imul r10, rsi, Stack_size
	lea r10, [rdi + r10]		; *stack
	add r10, Stack.len		; *stack len

	mov r8, r10
	add r8, Stack.values		; *stack base

	movzx r9d, byte [r10] 
	add r9, r8			
	dec r9				; *stack top

.loop:
	cmp r8, r9
	je .end

	; swap values using temp regs
	movzx r10d, byte [r8]	
	movzx r11d, byte [r9]	
	mov [r9], r10b
	mov [r8], r11b

	inc r8
	cmp r8, r9
	je .end
	dec r9

	jmp .loop

.end:
	ret
	

; in	rdi = *stack, rsi = stack quantity
stack_print:
	mov r8, rdi
	mov r9, rsi

	xor r10d, r10d
.loop:
	cmp r10, r9
	je .done

	mov rdi, r8
	mov rsi, Stack_size
	call print_str

	PRINT_LIT `\n`

	add r8, Stack_size
	inc r10

	jmp .loop
.done:
	ret


; in	rdi = *stack, rsi = stack quantity
stack_print_all_top:
	add r8, Stack.len
	mov r8, rdi

	mov r9, rsi

	xor r10d, r10d
.loop:
	cmp r10, r9
	je .done

	movzx ebx, byte [r8]	; get stack length
	add r8, rbx		; move to top

	mov rdi, r8
	mov rsi, 1
	call print_str

	sub r8, rbx		; move back to base
	add r8, Stack_size
	inc r10

	jmp .loop
.done:
	ret
