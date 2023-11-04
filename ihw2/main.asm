.include "macrolib.asm"

.text
	print_str("Enter the number: ")
	read_double_in(fa1)
	cube_root_of(fa1, fa2) # fa1 stores source value, fa2 stores the result value
	print_str("The cube root of the input number is ")
	print_double_from(fa2)
	exit
