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

; str_len
; in		rdi = *buffer
global str_len
str_len:
	mov rax, 0	; string len counter
	
.iter:
	cmp byte [rdi + rax], NULL
	je .done

	cmp byte [rdi + rax], LF
	je .done

	inc rax
	jmp .iter

.done:
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

; uint_to_str	
; in 		rdi = int number, rsi = *buffer 
; out		rax = string len
global uint_to_str
uint_to_str:
	mov rax, rdi
	mov rcx, 10

	mov r10, 0	; digits counter

; divide by 10, push remainder digit
.push_values:
	xor rdx, rdx
	div rcx	

	push rdx
	inc r10

	cmp rax, 0
	jne .push_values

	mov r11, r10

.parse_values:
	pop rax
	add rax, '0' 	; parse int to ascii

	mov [rsi], al
	inc rsi	

	dec r10
	cmp r10, 0
	jne .parse_values

	mov rax, r11
	sub rsi, rax

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

; copy_str
; in 	rdi = *string to copy, rsi = *buffer to paste
global copy_str
copy_str:
	xor eax, eax

.loop:
	cmp [rdi], NULL
	je .done
	
	cmp [rdi], LF
	je .done

	mov al, byte [rdi]
	mov byte [rsi], al

	inc rdi
	inc rsi
	jmp .loop

.done:
	ret

; cmp_str
; in	rdi = *first string, rsi = *second string, rdx = string len
; out	rax = is equal or not
cmp_str:
	push rdi
	push rsi
	mov rcx, rdx
	cld

	repe cmpsb
	jne .not_equal

	mov rax, TRUE
	jmp .done

.not_equal:
	mov rax, FALSE

.done:
	pop rsi
	pop rdi
	ret
