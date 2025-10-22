# booting (but saying hello)

- CPU manufacturers keep their current CPUs compatible with old software, oldest CPU in the family which is still considered is the 8086 which had support for 16-bit instructions.

- so for backwards compatibiltiy, CPUs boot in 16-bit real mode and then switch to 32-bit or 64-bit

- to print a simple "hello", we cannot make use of any libraries. We need to make the BIOS do that for us using _interrupts_ which are basically a sort of API to the hardware, they are either:

	- software interrupts
	- hardware interrupts (ex: keyboard)

- each interrupt is represented by a unique number which is an index to the interrupt vector (a pointer to the memory address of an interrupt service routine, ISR). An ISR is just a sequence of machine instructions that deals with a separate interrupt (like our boot sector code). The table of interrupts is called Interrupt Vector Table (IVT):

```
Address    Interrupt    Points to...
0x0000  →  INT 0x00  →  [Address of divide-by-zero handler]
0x0004  →  INT 0x01  →  [Address of debugger handler]
...
0x0040  →  INT 0x10  →  [Address of BIOS video ISR]
0x004C  →  INT 0x13  →  [Address of BIOS disk ISR]
...
```

- instead of allocating an interrupt per ISR, BIOS just mulitplexes the ISRs based on the value set in one of the registers.

- looking up `int 10h` supported functions list we can see:

```
Teletype output: AH=0Eh | AL = Character, BH = Page Number, BL = Color (only in graphic mode)

```

so to print "hello":

```asm

mov ah, 0x0e

mov al, 'H'
int 0x10
mov al, 'e'
int 0x10
mov al, 'l'
int 0x10
mov al, 'l'
int 0x10
mov al, 'o'
int 0x10

jmp $

times 510-($-$$) db 0
dw 0xaa55 

```

