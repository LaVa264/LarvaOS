#include "interrupt.h"
#include <string.h>

struct idt_desc idt_descriptors[TOTAL_INTERRUPTS];
struct idtr_desc idt_register;

void set_interrupt_handler(int pos, void *address)
{
    struct idt_desc *desc = &idt_descriptors[pos];

    desc->offset_1 = (uint32_t)address & 0x0000ffff; // Lower part of interrupt function's offset address.
    desc->selector = KERNEL_CODE_SELECTOR;
    desc->zero = 0x00;
    desc->type_attributes = 0xEE;             // 32-bit Interrupt Gate.
    desc->offset_1 = (uint32_t)address >> 16; // Higher part of interrupt function's offset address.
}

void init_interrupt_descriptor_table()
{
    size_t size_of_descriptor_table = sizeof(idt_descriptors);

    memset(idt_descriptors, 0, size_of_descriptor_table);

    idt_register.limit = size_of_descriptor_table - 1; // One less than the size of the IDT in bytes.
    idt_register.base = (uint32_t)idt_descriptors;     // The linear address of the Interrupt Descriptor Table (not the physical address, paging applies).
}