.org 0x0000
# .text			# Define beginning of text section
.global	_start		# Define entry _start

_start:
	li x1, 1
	li x2, 2
	mul x3, x2, x1
