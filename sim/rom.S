.org 0x0
.global _start
_start:
    ori    x4, x4, -100
    ori    x5, x5, 10
    add    x6, x5, x4
    sub    x7, x5, x4
    xor    x8, x5, x4    
    and    x9, x5, x4      
    or     x10, x5, x4
    sltu   x11, x5, x4       
    slt    x12, x5, x4      
    sll    x13, x5, x4
    srl    x14, x5, x4
    sra    x15, x5, x4