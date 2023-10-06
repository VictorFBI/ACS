.data
	 first: .asciz "Input divisible: "
	 second: .asciz "Input divisor: "
	 quotient: .asciz "Quotient is "
	 reminder: .asciz "Reminder is "
	 error: .asciz "You cannot divide by zero"
 .text
 main:
 	li a7, 4
 	la a0, first
 	ecall
 	
 	li a7, 5
 	ecall
 	mv t0, a0
 	
 	li a7, 4
 	la a0, second
 	ecall
 	
 	li a7 5
 	ecall
 	mv t1 a0
 	
 	beqz t1, end_if_0
 	
 	li s0, 1
 	li s1, 1
 	
 	bltz  t0, less0
after_less0:
 	bltz t1, less1
 	j pre
less0:
	li s0, -1
	j after_less0
less1:
	li s1, -1
	j pre
pre:
	mul t0, t0, s0
	mul t1, t1, s1
	mv t2, t0
	li s7, 0
while:
	blt t0, t1 after_while
 	li a7, -1
 	mul t1, t1, a7
 	add t0, t0, t1
 	mul t1, t1, a7
 	addi s7, s7, 1
 	j while
after_while:
	mul s2, s0, s1
	bltz s2, negative_whole 
	mv a5, s7
continue_if_negative:
	mul t1, t1, s7
	li a7, -1
	mul t1, t1, a7
	add a6, t2, t1
	bltz s0, negative_remains
	j end
negative_whole:
	mv a5, s7
	li a7, -1
	mul a5, a5, a7
	j continue_if_negative
negative_remains:
	li a7, -1
	mul a6, a6, a7
	j end
end_if_0:
	li a7, 4
	la a0, error
	ecall
	li a7, 10
	ecall
end:
	li a7, 4
	la a0, quotient
	ecall
	
	mv a0, a5
	li a7, 1
	ecall
	
	li a0, '\n'
	li a7, 11
	ecall
	
	li a7, 4
	la a0, reminder
	ecall
	
	mv a0, a6
	li a7, 1
	ecall
	
 	li a7, 10
 	ecall
