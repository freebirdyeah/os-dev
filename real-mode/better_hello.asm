[org 0x7c00]			; wont work without this directive, will start reading IVT garbage

start:
	msg: db 'HELLO WORLD!', 0
	mov si, msg
	call print_string
	jmp $				; inf loop

print_string:
	lodsb				; loads string byte to `al` from [si], increments si
	cmp al, 0
	je done

	mov ah, 0x0e
	int 0x10
	jmp print_string

done:
	ret

times 510-($-$$) db 0
dw 0xaa55
