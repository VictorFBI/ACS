.include "macrolib.asm"
.data	
	.align 2
	array: .space 40
.text
main:
	print_str("Enter the size of the array (between 1 and 10): ")
	read_int (s0)	# s0 stores array size
	li a7 1
	blt s0 a7 invalid_number
	li a7 10
	bgt s0 a7 invalid_number
	print_str("Input elemets of the array:\n")
	read_array(array, s0) # s0 stores the size of the array
	sum_array(array, s0)  # s0 stores the size of the array
	#  a0 stores last valid sum
	#  a1 stores the number of last valid numbers that do not lead to overflow
	mv a2 a0 # now a2 stores last valid sum (because a0 register can be changed in other macros)
	beq a1 s0 all_numbers_valid
	print_str("You overflowed, but the last correct value of sum is ")
	print_int(a2)
	li a7 1
	beq a1 a7 only_one
	print_str(". It is an aggregation of first ")
	print_int(a1)
	print_str(" numbers\n")
	exit
only_one:
	print_str(". It is the first element of the array\n")
	exit
all_numbers_valid:
	print_str("No overflow. The sum is ")
	print_int(a2)
	print_char('\n')
	exit
invalid_number:
	print_str("You entered incorrect number of elements\n")
	exit