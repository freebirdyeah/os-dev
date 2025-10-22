# make run FILE=boot_sect.asm

run:
	nasm -f bin $(FILE) -o $(FILE:.asm=.bin)
	qemu-system-x86_64 -drive format=raw,file=$(FILE:.asm=.bin)
