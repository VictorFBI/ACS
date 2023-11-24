.include "macrolib.asm"

.data
	ans: .space 100
	str: .asciz "Sample data"
	substr: .asciz "ta\n"
.text
.global main
main:
	read_file(s10)
	print_str_imm("Input substring: ")
	read_str(s11)
	find_substr_index(s10, s11, s9)
	int_to_string(s9, ans)
	la s11 ans
	write_file(s11)
	print_str_imm("Would you like the program to additionally output the answer to the console? Y/N?")
	newline
	survey(s10)
	beqz s10 finish
	print_str(s11)
finish:
	exit
	
