# Reads the content of the file in the %buf_reg register
# Do not call this macro with a0 register
.macro read_file(%buf_reg)
	push(a0)
	push(a1)
	push(a2)
	push(a7)
	push(t0)
	push(t4)
	push(t5)
	push(t6)
	push(s0)
	push(s1)
	push(s2)
	jal readfile
	mv %buf_reg a0
	pop(s2)
	pop(s1)
	pop(s0)
	pop(t6)
	pop(t5)
	pop(t4)
	pop(t0)
	pop(a7)
	pop(a2)
	pop(a1)
	pop(a0)
.end_macro

# Writes the string stored in the %str_reg register in the file named by the user
.macro write_file(%str_reg)
	push(a0)
	push(a1)
	push(a2)
	push(a7)
	push(t0)
	push(t4)
	push(t5)
	push(t6)
	push(s0)
	push(s1)
	push(s2)
	mv a3 %str_reg
	len(a3, a2)
	jal writefile
	pop(s2)
	pop(s1)
	pop(s0)
	pop(t6)
	pop(t5)
	pop(t4)
	pop(t0)
	pop(a7)
	pop(a2)
	pop(a1)
	pop(a0)
.end_macro

# Read a string (max size is 4096 symbols) into the given register except of a0 register
.macro read_str(%str_reg)
.data
	str: .space 4096
.text
	push(a0)
	push(a1)
	push(a7)
	la a0 str
	li a1 4096 
	li a7 8
	ecall
	mv %str_reg a0
	pop(a7)
	pop(a1)
	pop(a0)
.end_macro

# Prints a string from the given register except of a0 register
.macro print_str(%str_reg) 
	push(a0)
	push(a7)
	mv a0 %str_reg
	li a7 4
	ecall
	pop(a7)
	pop(a0)
.end_macro

.macro newline
	push(a0)
	push(a7)
	li a0 '\n'
	li a7 11
	ecall
	pop(a7)
	pop(a0)
.end_macro

# Prints immediate string
.macro print_str_imm(%str_imm)
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

# Converts int to the string
.macro int_to_string(%num_reg, %ans_label)
	la s0 %ans_label
	li s1 0
	mv s3 %num_reg
	addi s3 s3 1
	beqz s3 is_negative
	li s4 10
loop:
	beqz s3 finish
	rem s5 s3 s4
	addi s5 s5 48 # convert to ascii symbol
	sb s5 (s0)
	addi s0 s0 1
	addi s1 s1 1
	div s3 s3 s4
	j loop
finish:
	sub s0 s0 s1
	li s2 2
	div s3 s1 s2 # s3 = length / 2
	li s2 0 # counter
for:
	beq s2 s3 end # while (s2 != length / 2): swap(str[s2], str[length - s2 - 1]
	sub s4 s1 s2 # s4 = length - s2
	addi s4 s4 -1 # s4 = length - s2 - 1 
	add s0 s0 s2 # go to str[s2]
	lb s5 (s0) # s5 = str[s2]
	sub s0 s0 s2 # go back to str[0]
	add s0 s0 s4 # go to str[length - s2 - 1]
	lb s6 (s0) # s6 = str[length - s2 - 1]
	sb s5 (s0) # str[length - s2 - 1] = s5
	sub s0 s0 s4 # go back to str[0]
	add s0 s0 s2 # go to str[s2]
	sb s6 (s0) # str[s2] = s6
	sub s0 s0 s2 # go back to str[0]
	addi s2 s2 1 # ++s2
	j for
is_negative:
	# Hardcodes the recording of -1 to the given label
	li s1 45 # ascii code for -
	sb s1 (s0)
	addi s0 s0 1
	li s1 49 # ascii code for 1
	sb s1 (s0)
	addi s0 s0 -1 # recover s0, so s0 is pointing to the start of the string
end:	
.end_macro

# Computes the length of the given string
# Do not call the macro with t1 and s1 registers respectively
.macro len(%str_reg, %ans_reg)
	push(t1)
	push(t2)
	push(s1)
	mv t1 %str_reg
	li s1 0
loop:
	lb t2 (t1)
	beqz t2 end
	addi s1 s1 1
	addi t1 t1 1
	j loop
end:
	mv %ans_reg s1
	pop(s1)
	pop(t2)
	pop(t1)
.end_macro


# Checks if the substring for the given start register contains in the string
# If it contains, then flag = 1, otherwise flag = 0
# This is helping macro that will only be called with correct data, so no
# additional checkings are provided
.macro is_equal(%src_str_reg, %sub_str_reg, %start_reg, %flag_reg)
	mv t1 %src_str_reg
	mv t2 %sub_str_reg
	mv s1 %start_reg
	add t1 t1 s1
	li t5 '\n'
loop:
	lb t3 (t1)
	lb t4 (t2) 
	beq t4 t5 return
	beq t3 t4 is_equal
	j bad
is_equal:
	addi t1 t1 1
	addi t2 t2 1
	j loop
return:
	li %flag_reg 1
	j finish
bad:
	li %flag_reg 0
finish:
.end_macro

# Finds the index of the first occurency of the given substring in the given string
# The result is stored in the %ans_reg. String is considered to be zero-indexed. 
# Macro returns -1 if there is no occurencies of the given substring
.macro find_substr_index(%str_reg, %sub_str_reg, %ans_reg)
	len(%str_reg, s0) # s0 = str.length()
	len(%sub_str_reg, s2) # s2 = substr.length()
	addi s0 s0 1 # because string in the file does not contain \n symbol in the end
	bgt s2 s0 no_occurencies # if substr.length() > str.length() => no occurencies
	li s3 0 # first index
	sub s4 s0 s2 # last index
	addi s4 s4 1
loop:
	beq s3 s4 no_occurencies
	is_equal(%str_reg, %sub_str_reg, s3, %ans_reg)
	addi %ans_reg %ans_reg -1
	beqz %ans_reg finish
	addi s3 s3 1
	j loop
finish:
	addi s3 s3 -1
	mv %ans_reg s3
	j end	
no_occurencies:
	li %ans_reg -1
end:
.end_macro

# Terminates the program
.macro exit
	li a7 10
	ecall
.end_macro

.macro push(%x_reg)
	addi sp sp -4
	sw %x_reg (sp)
.end_macro

.macro pop(%x_reg)
	lw %x_reg (sp)
	addi sp sp 4
.end_macro
