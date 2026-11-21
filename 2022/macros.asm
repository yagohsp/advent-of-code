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
	lea rdi, [%%str]
	mov rsi, %%len
	call print_str

    %else
    	%error "argument must be a string literal"
    %endif
%endmacro

%macro PRINT_STR 2
	mov rdi, %1
	mov rsi, %2
	call print_str
%endmacro

%macro PRINT_UINT 1
	sub rsp, 64

	mov rdi, %1
	mov rsi, rsp
	call uint_to_str

	mov [rsp + rax], LF

	lea rdi, [rsp]
	lea rsi, [rax + 1]
	call print_str

	add rsp, 64
%endmacro

%macro STR_LIT 1
    %ifstr %1
	[section .rodata]

	%%str: 	db 	%1, NULL

	__?SECT?__
	lea rax, [%%str]

    %else
    	%error "argument must be a string literal"
    %endif
%endmacro
