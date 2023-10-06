.data
	hint: .asciz "Enter the number of elements of the array: "
	total_sum: .asciz "Total sum is "
	odd_numbers: .asciz "The number of odd numbers is "
	even_numbers: .asciz "The number of even numbers is "
	.align 2		# Now every cell is stored only 4-byte value (4 = 2^2)
	array: .space 40
	error: .asciz "You entered incorrect number of elements"
	overflow_error: .asciz "You overflowed, but the last correct value of sum is "
	valid_numbers: .asciz ". It is an aggregation of first "
	numbers: .asciz " numbers"
.text
	la a0 hint
	li a7 4
	ecall
	
	li a7 5
	ecall
	mv s1 a0 		# Размер массива
	
	li s0 0
	la t0 array  
	
	li a7 1
	blt s1 a7 invalid_number
	li a7 10
	bgt s1 a7 invalid_number
	li a7 5
fill:   
	ecall 
	mv t2 a0
	sw      t2 (t0)         # Запись числа по адресу в t0
        addi    t0 t0 4	       # Увеличим адрес на размер слова в байтах
        addi    s0 s0 1      
        bltu    s0 s1 fill      # Если не вышли за границу массива
li t6 0				# total sum 
la t0 array
li s0 0
li sp -2147483648		# min int value
li gp 2147483647			# max int value
sum: 
	lw a0 (t0)
	addi t0 t0 4
	addi s0 s0 1   
	bgtz t6 greater
	j less
greater:
	sub t5 gp t6 		# t5 stores a value that we can afford yourself to add
	mv tp s0
	blt t5 a0 overflow
	j addition
less:
	sub t5 sp t6		# t5 stores a value that we can afford yourself to subtract
	mv tp s0
	blt a0 t5 overflow
addition:
	add t6 t6 a0   
	blt s0 s1 sum
        j after_sum
invalid_number:
	la a0 error
	li a7 4
	ecall
	li a7 10
	ecall
overflow:
	lw a0 (t0)
	addi t0 t0 4
	addi s0 s0 1
	blt s0 s1 overflow
	la a0 overflow_error
	li a7 4
	ecall
	mv a0 t6
	li a7 1
	ecall
	la a0 valid_numbers
	li a7 4
	ecall
	li a7 1
	sub tp tp a7
	mv a0 tp
	ecall
	la a0 numbers
	li a7 4
	ecall
	li a0 '\n'
	li a7 11
	ecall
	j init
after_sum:
	la a0 total_sum
	li a7 4
	ecall
	li a7 1
	mv a0 t6
	ecall
	li a0 '\n'
	li a7 11
	ecall
init:
	li s0 0
	li t4 0				# total amount of even numbers
	li t5 0				# total amount of odd numbers
	la t0 array
count: 
	lw a0 (t0)
	addi t0 t0 4
	addi s0 s0 1   
	li a7 2
	rem a6 a0 a7
	beqz a6 even
	bnez a6 odd
continue:       
	blt s0 s1 count
        j finally
even:
	addi t4 t4 1
	j continue
odd:
	addi t5 t5 1
	j continue
finally:	
	la a0 odd_numbers
	li a7 4
	ecall
	li a7 1
	mv a0 t5
	ecall
	li a0 '\n'
	li a7 11
	ecall
	
	la a0 even_numbers
	li a7 4
	ecall
	li a7 1
	mv a0 t4
	ecall
	li a0 '\n'
	li a7 11
	ecall
	
	li a7 10
	ecall
