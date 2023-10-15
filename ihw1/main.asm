.include "macrolib.asm"
.data
	.align 2
	arr_a: .space 40
	arr_b: .space 40
.text
main:
	print_str("Enter number of elements of the array (between 1 and 10 inclusively): ")
	read_int_in(s1) # s1 stores the size of the array
	if_less(s1, 1, jump_error)
	if_greater(s1, 10, jump_error)
	print_str("Input elements of the array:\n")
	read_array(arr_a, s1)
	print_str("Entered array: ")
	print_array(arr_a, s1)
	print_char('\n')
	print_str("New array: ")
	build_array_b(arr_a, arr_b, s1)
	print_array(arr_b, s1)
	print_char('\n')
	exit
error:
	print_str("You entered incorrect number of elements")
	exit
	
	
	
