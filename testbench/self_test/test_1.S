.org 0x0000
# .text			# Define beginning of text section
.global	_start		# Define entry _start

_start:
	li gp, 16
	li tp, 8
	add a4, gp, tp
	li t2, 0
	bne gp, tp, func
	j else

else:
	li x10, 1
	j exit

func:
	li x10, 8
	
exit:
	nop
	nop