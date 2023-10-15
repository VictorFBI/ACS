# Read array by the label %label with size equal to %size_reg 
.macro read_array(%label, %size_reg)
	push(t0)
	push(s0)
	la t0 %label # t0 contains array
	li s0 0 # counter
while:
	bge s0 %size_reg break # if counter >= size of the array -> break
	read_int_in(a1)
	sw a1(t0)
	addi t0 t0 4
	addi s0 s0 1
	j while
break:
	pop(t0)
	pop(s0)
.end_macro

# Print array of the size% size_reg by the label %label
.macro print_array(%label, %size_reg)
	push(t0)
	push(s0)
	la t0 %label # t0 contains array
	li s0 0 # counter
while:
	bge s0 %size_reg break # if counter >= size of the array -> break
	lw a0(t0)
	print_int(a0)
	print_char(' ')
	addi s0 s0 1
	addi t0 t0 4
	j while
break:
	pop(t0)
	pop(s0)
.end_macro

# Read an integer from the keyboard in the register %dest apart from a0 register
.macro read_int_in(%dest)
	push(a0)
	li a7 5
	ecall
	mv %dest a0
	pop(a0)
.end_macro

# Read an integer from the keyboard in the register a0
.macro read_int_in_a0
	li a7 5
	ecall
.end_macro

# Print the integer from the %int_reg register
.macro print_int(%int_reg)
	push(a0)
	li a7 1
	mv a0 %int_reg
	ecall
	pop(a0)
.end_macro

# Print the string, immediately transferred in the macro (string is transferred immediately, not by the label or register)
.macro print_str(%str)
.data
	str: .asciz %str
.text
	push(a0)
	la a0 str
	li a7 4
	ecall
	pop(a0)
.end_macro

# Print the character, immediately transferred in the macro (character is transferred immediately, not by the label or register)
.macro print_char(%char_imm)
	push(a0)
	li a7 11
	li a0 %char_imm
	ecall 
	pop(a0)
.end_macro

# Analogy of the if-statement in higher level languages (the logic is written in the comment below)
.macro if_less(%first_reg, %second_imm, %macro_name) # if (first < second) { macro_name() }
	push(a7)
	li a7 %second_imm
	bge %first_reg a7 break # if first >= second -> break (condition does not hold)
	%macro_name()
break:
	pop(a7)
.end_macro

# Analogy of the if-statement in higher level languages (the logic is written in the comment below)
.macro if_greater(%first_reg, %second_imm, %macro_name) # if (first > second) { macro_name() }
	push(a7)
	li a7 %second_imm
	ble %first_reg a7 break  # if first <= second -> break (condition does not hold)
	%macro_name()
break:
	pop(a7)
.end_macro

# Build the array b using array a according to the rule from the variant 8
.macro build_array_b(%label_a, %label_b, %size_reg)
	push(t0)
	push(t1)
	push(s0)
	la t0  %label_a # t0 contains array a
	la t1 %label_b # t1 contains array b
	li s0 0 # counter
while:
	bge s0, %size_reg, break # if counter >= size of the array -> break
	lw a0(t0)
	rule
	sw a1(t1)
	addi s0 s0 1
	addi t1 t1 4
	addi t0 t0 4
	j while
break:
	pop(t0)
	pop(t1)
	pop(s0)
.end_macro

# The rule which is used to from the array b (see variant 8)
.macro rule # а0 contains the current element of the array a
	push(s2)
	li s2 0 # indicates whether we add 5 or subtract 5(1 if yes, 0 if no)
	if_less(a0, -5, sub5)
	if_greater(a0, 5, add5)
	if_less(s2, 1, annul) # annul only in the case if we did not add or subtract 5. Then s2 == 0 (or s2 < 1)
	pop(s2)
.end_macro

# Add 5 to the number stored in a1 register. This is part of the realization of the rule that is used to change array a to build array b. a1 will store the number which will be added to array b
.macro add5
	li s2 1 # indicates whether we add 5 or subtract 5(1 if yes, 0 if no)
	mv a1 a0
	addi a1 a1 5 
.end_macro

# Subtract 5 from the number stored in a1 register. This is part of the realization of the rule that is used to change array a to build array b. a1 will store the number which will be added to array b
.macro sub5
	li s2 1 # indicates whether we add 5 or subtract 5(1 if yes, 0 if no)
	mv a1 a0
	addi a1 a1  -5 
.end_macro

# Annul a1 register. This is part of the realization of the rule that is used to change array a to build array b. a1 will store the number which will be added to array b
.macro annul
	li a1 0
.end_macro

# Macro for the correct processing of the corectness of the entered size
.macro jump_error
	j error
.end_macro

# Saving given register on the stack
.macro push(%x)
	addi	sp sp -4
	sw	%x (sp)
.end_macro

# Popping value from the top of the stack to the given register
.macro pop(%x)
	lw	%x (sp)
	addi	sp sp 4
.end_macro

# Finishing of the program
.macro exit
	li a7 10
	ecall
.end_macro
