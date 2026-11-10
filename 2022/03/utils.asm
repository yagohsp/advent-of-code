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

; read_lines 	reads a text and divide into lines
; in		rdi = lines, rsi = text, rdx = text len
; out 		rax = num of lines, rdx = *end of text
struc Line
	.ptr: resq 1
	.len: resq 1
endstruc
global read_lines
read_lines:
	xor r8d, r8d	; char index
	xor r9d, r9d	; start line index
	xor r10d, r10d	; line counter

	cmp rdx, 0
	jbe .done

.iter:
	movzx eax, byte [rsi + r8]

	cmp rax, LF
	je .add_line

	cmp rax, NULL
	je .check_null

	inc r8
	loop .iter

	jmp .done
	
.add_line:
	lea r11, [rsi + r9] 		; pointer to line start in text
	mov [rdi + Line.ptr], r11

	mov r11, r8
	sub r11, r9 	; line len = char_index - start_line_index 
	mov [rdi + Line.len], r11

	add rdi, Line_size

	inc r10
	inc r8
	mov r9, r8

	loop .iter
	jmp .done

.check_null:
	cmp r8, r9 
	je .done
	jmp .add_line

.done:
	mov rax, r10	; num of lines
	mov rdx, rsi	; num of chars
	add rdx, r8	
	dec rdx		; sum and get char at end of text
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
