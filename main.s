.code16

/* MBR Bootloader Code */
.org 0 /* make sure code starts at 0x0 */

entry:
    mov     $0x1234, %ax
    mov     %ax, %ds

top:
    jmp     top

.org 510
.word 0xaa55 /* Magic Number */
