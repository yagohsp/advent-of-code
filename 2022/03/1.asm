%include "../consts.asm"
%include "macros.asm"
%include "utils.asm"

default rel

BUFFER_SIZE	equ	1024*1024	; 1MB
FILE_LINES_LEN	equ	500

section .data
	filename	db	"puzzle.txt", NULL

section .bss
	buffer		resb	BUFFER_SIZE
	lines		resb	Line_size * FILE_LINES_LEN

	result_buffer	resb	100

section .text
global _start
_start:
	sys_open filename, O_RDONLY
	mov rbx, rax 

	sys_read rbx, buffer, BUFFER_SIZE
	mov rdx, rax

	lea rdi, [lines]
	lea rsi, [buffer]
	call read_lines
	mov rbp, rax

	mov rdi, rax
	mov rsi, result_buffer
	call print_uint

	lea rbx, [lines]

	xor r8d, r8d	; sum result

.iter_line:
	mov rdi, [rbx + Line.ptr]
	mov rsi, [rbx + Line.len]	

	call get_line_value
	add r8, rax

	add rbx, Line_size

	dec rbp
	jnz .iter_line
	jmp done

; rdi = line ptr, rsi = line len
get_line_value:
	mov r12, rdi	; r12 = line ptr
	mov r13, rsi	; r13 = half size index
	shr r13, 1	; get half value
	dec r13 	; parse len to index

	xor r14, r14	; r14 = bitmask map

.iter_left:
	movzx edi, byte [r12]
	call ascii_to_bitmask
	or r14, rax	; add ascii bitmask to bitmask map

	inc r12		; move pointer to next char
	dec r13
	jns .iter_left

	mov r13, rsi	; r13 = half size index
	shr r13, 1	; get half value
	dec r13 	; parse len to index

.iter_right:
	movzx edi, byte [r12]	
	call ascii_to_bitmask
	test rax, r14	; add ascii bitmask to bitmask map
	jnz .hit

	inc r12 	; move pointer to next char
	dec r13
	jmp .iter_right

.hit:
	movzx eax, byte [r12]
	and rax, 31	; parse ascii to alphabet value
	
	mov rcx, rax
	add rcx, 26

	test [r12], 100000b 	; if is uppercase
	cmovz rax, rcx		; sum 26

	ret

done: 
	mov rdi, r8
	mov rsi, result_buffer
	call print_uint

	sys_exit 0
