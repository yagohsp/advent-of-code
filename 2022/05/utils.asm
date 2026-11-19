section .text
; print 
; in 		rdi = *buffer, rsi = string len
global print
print_str:
	sub rsp, rsi
	xor eax, eax		; counter	

.next_char:
	movzx edx, byte [rdi + rax]
	cmp rdx, 9
	ja .stack_char
	or rdx, 110000b

.stack_char:
	mov [rsp + rax], dl

	inc rax

	cmp rax, rsi
	jne .next_char

.print:
	mov rax, SYS_write
	mov rdi, STDOUT 
	mov rdx, rsi		; string len
	mov rsi, rsp		; stack buffer
	syscall

	add rsp, rdx
	ret

; str_to_uint
; in		rdi = *string
; out		rax = int, rdi = *end string
global str_to_uint
str_to_uint:
	mov eax, 0

	movzx edx, byte [rdi] ; char holder
	cmp rdx, '0'
	jb .done
	cmp rdx, '9'
	ja .done

	sub rdx, '0' 	; parse ascii to int 
	add rax, rdx

	inc rdi

.iter:
	movzx edx, byte [rdi]
	cmp rdx, '0'
	jb .done
	cmp rdx, '9'
	ja .done

	sub rdx, '0' 	; parse ascii to int 

	imul rax, 10
	add rax, rdx

	inc rdi
	jmp .iter

.done:
	ret

; jump_line
; in 	rdi = *buffer
; out 	rax = *next line
global jump_line
jump_line:
.loop:
	cmp [rdi], LF
	je .done
	inc rdi
	jmp .loop

.done:
	inc rdi
	mov rax, rdi
	ret
