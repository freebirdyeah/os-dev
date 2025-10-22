# more things about real mode

memory layout at boot:

```
0x00000000  ┌─────────────────────────┐
            │  Interrupt Vector Table │ (1 KB)
0x00000400  ├─────────────────────────┤
            │  BIOS Data Area         │
0x00000500  ├─────────────────────────┤
            │  Free/BIOS usage        │
            │                         │
0x00007C00  ├─────────────────────────┤ ← BOOT SECTOR HERE (512 bytes)
0x00007E00  ├─────────────────────────┤
            │  Free for use           │
            │  (stack, data, etc.)    │
            │                         │
0x0009FC00  ├─────────────────────────┤
            │  Extended BIOS Data     │
0x000A0000  ├─────────────────────────┤
            │  Video Memory           │
0x000C0000  ├─────────────────────────┤
            │  BIOS ROM               │
0x000F0000  └─────────────────────────┘

```

- the BIOS needs to store the boot sector somewhere in memory, however it cannot overwrite the stuff which is important to the BIOS such as the IVT, ISRs and system information, so we load in at `0x7c00`

- we can also implement the stack (works on only 16-bit boundaries in real mode) by setting two registers `bp` and `sp` which retain addresses of stack boundaries (should be set away from important regions of memory). Also, the stack grows downwards

- to prevent the values of registers from being changed, `pusha` and `popa` instructions at the beginning or end of any function preserve the original register values.

NOTE: on the using the `print_hex` function I wrote, I checked the auto-init values of `sp` and `bp` registers. Apparently, `bp` isn't a stack pointer but a general register used to manually track stack frames (was init'ed to `0000` which doesn't matter) but `sp` was init'ed to `00f6`! which is IVT territory!

better to set `sp` manually to a address far away!
