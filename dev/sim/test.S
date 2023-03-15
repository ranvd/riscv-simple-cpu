.org 0x0
.global _start
_start:
    lui x1, 0x1111
    auipc x2, 0x1111
    add x3, x1, x2
    