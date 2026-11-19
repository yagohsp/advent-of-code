%macro sys_exit 1
	mov rax, 60
	mov rdi, %1
	syscall
%endmacro

%macro sys_open 2
	mov rax, SYS_open
	mov rdi, %1		; filename
	mov rsi, %2		; permission mode
	syscall
%endmacro

%macro sys_read 3
	mov rax, SYS_read
	mov rdi, %1		; file descriptor
	mov rsi, %2		; buffer
	mov rdx, %3		; buffer size
	syscall
%endmacro

%macro PRINT_LIT 1
    %ifstr %1
	[section .rodata]

	%%str: 	db 	%1
	%%len: 	equ	$ - %%str

	__?SECT?__
	pushfq
	push rdi
	push rsi
	push rax
	push rdx
	push rcx
	push r11

	lea rdi, [%%str]
	mov rsi, %%len
	call print_str

	pop r11
	pop rcx
	pop rdx
	pop rax
	pop rsi
	pop rdi
	popfq
    %else
    	%error "argument must be a string literal"
    %endif
%endmacro
