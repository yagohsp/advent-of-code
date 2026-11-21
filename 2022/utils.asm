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
