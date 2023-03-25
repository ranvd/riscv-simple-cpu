.org 0x0000
# .text			# Define beginning of text section
.global	_start		# Define entry _start

# _start:
	# auipc x1, 0x1
	# addi  x1, x1, 24
_start:
	la x1, _array # 
	lh x2, 1(x1)
	sw x2, 0(x1)
	lh x3, 1(x1)
	# addi x3, x0, 0x10
	# addi x4, x0, 0x100
	
# .data
_array:	
	.byte 0x10
	.byte 0x20
	.byte 0x30
	.byte 0x40

	.end			# End of file
