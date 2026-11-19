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

; ascii_to_bitmask	
; in	rdi = char value
; out	rax = char bitmask
global ascii_to_bitmask
ascii_to_bitmask:
	mov ecx, edi
	sub ecx, 'A'
	mov eax, 1
	shl rax, cl

	ret

; print_uint
; in	rdi = uint, rsi = *buffer
; out	rax = string len
global print_uint
print_uint:
	call uint_to_str
	mov [rsi + rax], LF	; mount string with LF
	inc rax			; add LF to string len

	mov rdi, rsi
	mov rsi, rax
	call print_str
	
	ret
