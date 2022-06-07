.org 0x0
.global _start
_start:
    ori   	x4, x2, 10      #16
    addi 	x5, x4, 5       #12
    xori  	x6, x5, -100    #15
    andi  	x7, x6, 10      #17
    sltiu  	x8, x5, 6       #14
    slti	x9, x6, -5      #13
    slli	x10, x4, 2      #18
    srli	x11, x6, 3      #19