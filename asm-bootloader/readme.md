# booting

- the BIOS (TIL: BIOS stands for Basic I/O System) on boot has no notion of a filesystem so it must read specific sectors only, in CHS the boot sector is `C:0-H:0-S:0`. BIOS must determine if the boot sector of a disk actually permits booting or is simply data (as some disks might be connected as additional storage only)

- BIOS loops through each storage device and writes the first sector found into memory which has `0xaa55` (the magic number, little-endian)

a possible boot sector:

```asm
e9 fd ff 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
*
00 00 00 00 00 00 00 00 00 00 00 00 00 00 55 aa
```

> the first three bytes are instructions defined for an endless loop


bootloader code (from `resources/os-dev-start.pdf`):

```asm

; A simple boot sector program that loops forever.

loop: 						; Define a label , " loop " , that will allow
							; us to jump back to it , forever.
	jmp loop 				; Use a simple CPU instruction that jumps
							; to a new memory address to continue execution.
							; In our case , jump to the address of the current instruction.

times 510 -( $ - $$ ) db 0  ; When compiled , our program must fit into 512 bytes ,
							; with the last two bytes being the magic number ,
							; so here , tell our assembly compiler to pad out our
							; program with enough zero bytes ( db 0) to bring us to the 510th byte.

dw 0xaa55 					; Last two bytes ( one word ) form the magic number ,
							; so BIOS knows we are a boot sector.

```

makefile:

```make
# make run FILE=boot_sect.asm

run:
        nasm -f bin $(FILE) -o $(FILE:.asm=.bin)
        qemu-system-x86_64 -drive format=raw,file=$(FILE:.asm=.bin)
```
