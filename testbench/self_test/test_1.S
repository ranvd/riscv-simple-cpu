.org 0x0000
# .text			# Define beginning of text section
.global	_start		# Define entry _start

func:
	addi x2, x0, 1
	ret

_start:
	jal func  # jump to func and save position to ra
	addi x3, x1, 1
	
	# la x1, func2
	# ret
	# addi x10, x0, 16


	# la x1, _array # 
	# lh x2, 1(x1)
	# sw x2, 0(x1)
	# lh x3, 1(x1)
	# addi x3, x0, 0x10
	# addi x4, x0, 0x100

# func2:
# 	addi x3, x0, 0
# 	addi x4, x0, 0
# 	addi x5, x0, 0
# 	ret

# .data
# _array:	
# 	.byte 0x10
# 	.byte 0x20
# 	.byte 0x30
# 	.byte 0x40

# 	.end			# End of file
