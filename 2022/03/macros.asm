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
