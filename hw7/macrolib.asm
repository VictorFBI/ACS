# Prints string tranferred by immediate value
.macro print_str(%str_imm)
.data
	str: .asciz %str_imm
.text
	push(a0)
	push(a7)
	la a0 str
	li a7 4
	ecall
	pop(a7)
	pop(a0)
.end_macro

# Puts the program to sleep for the given amount of milliseconds
.macro sleep(%time_imm)
	push(a0)
	push(a7)
	li a0 %time_imm
	li a7 32
	ecall
	pop(a7)
	pop(a0)
.end_macro

.macro read_int_a0
	push(a7)
	li a7 5
	ecall
	pop(a7)
.end_macro

# Converts number stored in the given register to the format required for the digital
# lab simulator to display it according to the given task
.macro convert_number_for_digital_lab(%num_reg)
	push(s10)
	li s10 16
	blt %num_reg s10 only_digit
	j need_to_divide
only_digit: 
	convert_digit_for_digital_lab(%num_reg)
	j finish
need_to_divide:
	rem %num_reg %num_reg s10
	convert_digit_for_digital_lab(%num_reg)
	addi %num_reg %num_reg 128
finish:
.end_macro

# Converts digit stored in the given register to the format required for the digital
# lab simulator to display it. It is helping macros, so only correct data is provided in %num_reg
.macro convert_digit_for_digital_lab(%num_reg)
	beqz a0 is_zero
	
	addi a0 a0 -1
	beqz a0 is_one
	addi a0 a0 1
	
	addi a0 a0 -2
	beqz a0 is_two
	addi a0 a0 2
	
	addi a0 a0 -3
	beqz a0 is_three
	addi a0 a0 3
	
	addi a0 a0 -4
	beqz a0 is_four
	addi a0 a0 4
	
	addi a0 a0 -5
	beqz a0 is_five
	addi a0 a0 5
	
	addi a0 a0 -6
	beqz a0 is_six
	addi a0 a0 6
	
	addi a0 a0 -7
	beqz a0 is_seven
	addi a0 a0 7
	
	addi a0 a0 -8
	beqz a0 is_eight
	addi a0 a0 8
	
	addi a0 a0 -9
	beqz a0 is_nine
	addi a0 a0 9
	
	addi a0 a0 -10
	beqz a0 is_ten
	addi a0 a0 10
	
	addi a0 a0 -11
	beqz a0 is_eleven
	addi a0 a0 11
	
	addi a0 a0 -12
	beqz a0 is_twelve
	addi a0 a0 12
	
	addi a0 a0 -13
	beqz a0 is_thirteen
	addi a0 a0 13
	
	addi a0 a0 -14
	beqz a0 is_fourteen
	addi a0 a0 14
	
	addi a0 a0 -15
	beqz a0 is_fifteen
	addi a0 a0 15
is_one:
	li a0 6
	j finish
is_zero:
	li a0 63 
	j finish
is_two:
	li a0 0x5b
	j finish
is_three:
	li a0 79
	j finish
is_four:
	li a0 0x66
	j finish
is_five:
	li a0 109
	j finish
is_six:
	li a0 125
	j finish
is_seven:
	li a0 7
	j finish
is_eight:
	li a0 127
	j finish
is_nine:
	li a0 111
	j finish
is_ten:
	li a0 119
	j finish
is_eleven:
	li a0 124
	j finish
is_twelve:
	li a0 57
	j finish
is_thirteen:
	li a0 94
	j finish
is_fourteen:
	li a0 121
	j finish
is_fifteen:
	li a0 113
	j finish	
finish:
.end_macro
# Terminates the program
.macro exit
	li a7 10
	ecall
.end_macro

# Pushes the register to the stack
.macro push(%x_reg)
	addi sp sp -4
	sw %x_reg (sp)	
.end_macro

# Restores the register from the stack
.macro pop(%x_reg)
	lw %x_reg (sp)
	addi sp sp 4
.end_macro
