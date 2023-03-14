.org 0x0
.global _start
_start:
    ori x1, x4, 5
    ori x2, x4, 1
    ori x3, x2, 2 // expect 3
    ori x4, x2, 4 // expect 5
    ori x5, x4, 2 // expect 7
    