.org 0x0000
# .text			# Define beginning of text section
.global	_start		# Define entry _start

_start:
	addi x1, x0, 1
	addi x2, x0, 2
	bge x2, x1, func2 # if x2 >x1t1 then target
	jal func

func:
	addi x2, x0, 1
	jal func

func2:
	addi x3, x0, 16
	addi x4, x0, 16
	addi x5, x0, 16
	ret

# .data
# _array:	
# 	.byte 0x10
# 	.byte 0x20
# 	.byte 0x30
# 	.byte 0x40

# 	.end			# End of file
