.code16

/* MBR Bootloader Code */
.org 0 /* make sure code starts at 0x0 */

entry:
    //mov     $0x1234, %ax
    //mov     %ax, %ds

    call clrscr
    mov     $0x0b, %di
    call printstr

top:
    jmp     top

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
    lea     str, %si

nextch:
    call printch

    add     $0x01, %si
    add     $0x01, %cx

    cmp     %cx, %di
    jg nextch;

    pop    %bp
    ret

str:
    .string "Hello folks"

.org 510
.word 0xaa55 /* Magic Number */
