default rel

%include "../consts.asm"
%include "macros.asm"
%include "utils.asm"

PUZZLE_BUFFER_SIZE	equ	1024*1024
MAX_FOLDERS		equ	1000
MAX_FOLDER_NAME_LEN	equ	21

struc Folder
	.name		resb 	MAX_FOLDER_NAME_LEN
	.parent 	resb 	1
	.first_child	resb	1
	.next_brother	resb	1
	.size		resb	8
endstruc

section .data
	filename	db	"puzzle.txt", NULL
	cur_delete_size	dq	30000000

section .bss
	puzzle		resb	PUZZLE_BUFFER_SIZE
	folders		resb	Folder_size * MAX_FOLDERS
	folders_count	resb	1
	dir_stack	resb	100
	size_to_delete	resq	1

section .text
global _start
_start:
	sys_open filename, O_RDONLY
	mov rdi, rax
	sys_read rdi, puzzle, PUZZLE_BUFFER_SIZE

	lea rbx, [puzzle]
	xor r12, r12		; dir stack count

	; add root folder
	STR_LIT "/"
	mov rdi, rax
	mov rsi, 0
	call add_folder

.read_line:
	cmp byte [rbx], 0
	je .exit

	cmp byte [rbx + 2], 'l'
	je .next_line

	cmp byte [rbx], 'd'
	je .add_folder

	movzx eax, byte [rbx]
	sub rax, '0'
	cmp rax, 9
	jbe .add_file

	cmp byte [rbx + 5], '/'
	je .cd_root

	cmp byte [rbx + 2], 'c'
	je .cd

.add_folder:
	lea rdi, [rbx + 4]
	movzx esi, byte [dir_stack + r12 - 1]
	call add_folder
	jmp .next_line

.add_file:
	lea rdi, [rbx]
	call str_to_uint

	mov rsi, rax
	movzx edi, byte [dir_stack + r12 - 1]
	call add_size_to_folder
	jmp .next_line

.cd_root:
	mov r12, 1
	mov byte [dir_stack], 1

	jmp .next_line

.cd:
	cmp byte [rbx + 5], '.'
	je .cd_back

	lea rdi, [rbx + 5]
	movzx esi, byte [dir_stack + r12 - 1]
	call get_folder_by_name
	mov byte [dir_stack + r12], al
	inc r12

	jmp .next_line

.cd_back: 
	dec r12	
	mov byte [dir_stack + r12], 0
	jmp .next_line

.next_line:
	mov rdi, rbx
	call jump_line
	mov rbx, rdi
	jmp .read_line

.exit:
	mov rdi, 1
	call sum_folder_size

	; mov rax, [size_to_delete]
	mov rsi, 70000000
	sub rsi, rax
	mov rax, 30000000
	sub rax, rsi

	mov [size_to_delete], rax

	mov rdi, 1
	call sum_folder_size

	mov rax, [cur_delete_size]
	PRINT_UINT rax

	sys_exit 0


; in 	rdi = *name, rsi = parent position
; out 	rax = folder position
add_folder:
	; new folder addr
	push rdi
	movzx edi, byte [folders_count]
	inc rdi 			; index to position
	call get_folder_addr
	mov r8, rax
	pop rdi

	; copy name
	push rsi
	lea rsi, [r8 + Folder.name]
	call copy_str
	pop rsi

	inc byte [folders_count]	; update total folders quantity

	; update parent position
	mov byte [r8 + Folder.parent], sil

	cmp sil, 0			; check if is a root folder
	je .end

	mov rdi, rsi
	movzx esi, byte [folders_count]
	call add_folder_child

.end:
	movzx eax, byte [folders_count]
	ret

; in 	rdi = folder position
; out	rax = *folder
get_folder_addr:
	movzx eax, dil
	shl rax, 5		
	lea rax, [rax + folders]

	ret

; in	rdi = parent position, rsi = new child position
add_folder_child:
	; get parent first child
	call get_folder_addr
	add rax, Folder.first_child 	

.loop:
	cmp byte [rax], 0
	je .set_child

	movzx edi, byte [rax]
	call get_folder_addr
	add rax, Folder.next_brother
	jmp .loop

.set_child:
	mov byte [rax], sil

	ret
		
; in	rdi = folder name, rsi = parent position
; out	rax = folder position
get_folder_by_name:
	mov r8, 0

.next_folder:
	inc r8

	mov r9, r8
	shl r9, 5
	lea r10, [folders + r9]

	; compare names
	cmp byte [r10 + Folder.name], 0
	je .not_found

	call str_len

	push rsi
	mov rsi, r10
	mov rdx, rax
	call cmp_str
	pop rsi
	cmp rax, TRUE 
	jne .next_folder

	; compare parents
	cmp byte [r10 + Folder.parent], sil
	jne .next_folder
	
	; found
	mov rax, r8
	ret
	
.not_found:
	mov rax, 0
	ret

; in 	rdi = folder position, rsi = size
add_size_to_folder:
	call get_folder_addr
	lea rax, [rax + Folder.size]
	mov rcx, [rax]
	add rcx, rsi
	mov [rax], rcx
	ret

; in 	rdi = folder position 
sum_folder_size:
	push rbp
	mov rbp, rsp

	call get_folder_addr
	push rax

	mov r9, [rax + Folder.size]

	lea rdi, [rax + Folder.first_child]
	movzx edi, byte [rdi]
	cmp rdi, 0
	jz .check_size

	push r9
	call sum_folder_size
	pop r9
	add r9, rax

.check_size:
	mov r10, [rsp]
	; PRINT_STR r10, 1
	; PRINT_LIT " - "
	; PRINT_UINT r9
	; PRINT_LIT `\n`

	cmp [size_to_delete], 0
	je .sum_next_brother

	cmp r9, [size_to_delete]
	jb .sum_next_brother

	cmp r9, [cur_delete_size]
	ja .sum_next_brother

	mov [cur_delete_size], r9

.sum_next_brother:
	mov r10, [rsp]
	movzx edi, byte [r10 + Folder.next_brother]
	cmp rdi, 0
	je .return_value

	push r9
	call sum_folder_size
	pop r9
	add r9, rax

.return_value:
	mov rax, r9

	leave
	ret
