[org 0x7c00]				; wont work without this directive, will start reading IVT garbage

start:
	mov si, sp
	mov bx, 0
	call print_hex
	call print_newline

	mov si, bp
	mov bx, 0
	call print_hex
	call print_newline

	jmp $					; inf loop

; only for 16-bit
print_hex:
	pusha
	.loop:
		cmp bx, 4
		je .done
		; x86 is lsb-first (need to look at lower nibble then upper)
		; moves lower nibble
		mov ax, si
		and al, 0b00001111
		cmp al, 9
		jle .digit
		add al, 7

		.digit:
			add al, '0'			; adding '0' sets num to corresponding ascii char

		inc bx
		shr si, 4
		mov ah, 0x0e
		int 0x10
		jmp .loop

	.done:
		popa
		ret

print_newline:
	pusha
	mov ah, 0x0e
	mov al, 0x0d			; carriage return
	int 0x10
	mov al, 0x0a			; line feed
	int 0x10
	popa
	ret

times 510-($-$$) db 0
dw 0xaa55
