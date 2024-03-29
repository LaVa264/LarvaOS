[BITS 32]
section .asm

global load_interrupt_descriptor_table
global enable_interrupts
global disable_interrupts
global no_interrupt
extern no_interrupt_handler

load_interrupt_descriptor_table:
    ; Make new call frame.
    ; Some compilers may produce an 'enter' instruction instead.
    push ebp            ; Save old call frame.
    mov ebp, esp        ; Initialize new call frame.

    mov ebx, [ebp+8]    ; Get first argument that is passed by the caller.
                        ; In this case, it is address of IDT register. 
    lidt [ebx]          ; Load Interrupt Descriptor Table.

    pop ebp             ; Restore old call frame.
    ret                 ; Return.

enable_interrupts:
    sti
    ret

disable_interrupts:
    cli
    ret

; Interrupt wrapper.
no_interrupt:
    pushad
    call no_interrupt_handler
    popad
    iret