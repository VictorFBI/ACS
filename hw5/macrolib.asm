# Print passed string
.macro print_str(%str)
.data
	str: .asciz %str
.text
	la a0 str
	li a7 4
	ecall
.end_macro

# Print passed char symbol
.macro print_char(%char)
	li a0 %char
	li a7 11
	ecall
.end_macro 

# Print an integer stored in %reg_int register
.macro print_int(%reg_int)
	mv a0 %reg_int
	li a7 1
	ecall
.end_macro

# Ends program
.macro exit
	li a7 10
	ecall
.end_macro

# Read an integer and write it in %reg_int register
.macro read_int (%reg_int)
	li a7 5
	ecall
	mv %reg_int a0
.end_macro

# Read array (max number of elements is 10, min is 1) in %array_reg register, %size_reg stores max number of elements
.macro read_array (%label, %size_reg)
main:
	la t0 %label # %array_reg stores array
	li t4 0 # counter
fill:   
	read_int(t2)
	sw      t2 (t0)        	       # Запись числа по адресу в t0
        addi    t0 t0 4	       # Увеличим адрес на размер слова в байтах
        addi    t4 t4 1      
        bltu    t4 %size_reg fill
.end_macro

# Sum elements of the passed array
.macro sum_array(%label, %size_reg)		
		la t0 %label
		li t3 0				# total sum 
		li t4 0				# counter
		li t5 -2147483648		# min int value
		li t6 2147483647			# max int value
sum: 
		lw a0 (t0)
		addi t0 t0 4
		addi t4 t4 1   
		bgtz t3 greater
		j less
greater:
		sub t2 t6 t3 		# t2 stores a value that we can afford yourself to add
		blt t2 a0 overflow
		j addition
less:
		sub t2 t5 t3		# t5 stores a value that we can afford yourself to subtract
		blt a0 t2 overflow
addition:
		mv a1 t4 		# a1 stores valid numbers
		add t3 t3 a0  
		blt t4 %size_reg sum
	        j after_sum
overflow:
		lw a0 (t0)
		addi t0 t0 4
		addi t4 t4 1
		blt t4 %size_reg overflow
after_sum:
		mv a0 t3 # return value: a0 stores last valid sum
		# one more return value: a1 stores the number of last valid numbers that do not lead to overflow 
.end_macro

