.code16

/* MBR Bootloader Code */
.org 0 /* make sure code starts at 0x0 */

.text
_start:
    /* Ensure segment registers are set properly */

    /* %cs is set to 0x7C00 by BIOS--no need to do anything with it. */
    mov     $0x00, %ax
    mov     %ax, %ds
    mov     %ax, %ss
    mov     %ax, %es

    call clrscr

    mov     $0x0e, %di
    lea     running, %si
    call printstr
    call printOK

    mov     $0x14, %di
    lea     reading, %si
    call printstr

    call readprog

    call printOK


    /* Hang */
top:
    jmp     top

/* Functions */
clrscr:
    mov     $0x00, %ah
    mov     $0x07, %al
    int     $0x10
    ret

printch:
    push    %bp
    mov     %sp, %bp

    movb     (%si), %al
    mov     $0x0e, %ah
    int     $0x10

    pop     %bp
    ret

printstr:
    push    %bp
    mov     %sp, %bp

    mov     $0x00, %cx
nextch:
    call printch

    add     $0x01, %si
    add     $0x01, %cx

    cmp     %cx, %di
    jg nextch;

    pop     %bp
    ret

readprog:
    push    %bp
    mov     %sp, %bp

    /* Sectors on disk are read into es:bx, so set %bx to right after bootloader
     * in memory.
     * */
    mov     $0x7e00, %bx

    mov     $0x02, %ah /* INT Service Code */
    mov     $0x01, %al /* Num sectors to read */

    mov     $0x00, %ch /* Cylinder Number */
    mov     $0x02, %cl /* Sector Number */

    mov     $0x00, %dh /* Drive Head */
    /* %dl need not be set as it is the same drive */

    INT $0x13

    pop     %bp
    ret

printOK:
    push    %bp
    mov     %sp, %bp

    mov     $0x04, %di
    lea     OK, %si
    call printstr

    pop     %bp
    ret

running:
    .string "Running MBR..."
reading:
    .string "Reading from disk..."
OK:
    .string "OK\n\r"

.org 510
.word 0xaa55 /* Magic Number */
