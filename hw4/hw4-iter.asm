.data
	overflow: .asciz "The maximum number that does not lead to overflow when computing the factorial is equal to "
	signs: .asciz "! = "
.text
main:
	li s11 2147483647 # max int32
	li s2 1		# counter. It is equal to 0 at first because factorial is defined for every whole n >= 0
	li s1 1	# stores 1 in order to check for 1 in factorial subroutine
	li a1 1 # initial result of computing factorial (0! = 1)
for_main:
	mv a0 s2
	div s3 s11 s2 # s3 = max_value / n
	blt s3 a1 end # if max_value / n < (n-1)! -> stop the cycle else -> continue to compute factorials
	jal fact # jump to subroutine that is computing factorial of number stored in a0
	mv a1 a0 # move the result in a1
	addi s2 s2 1
	j for_main # continue the cycle
end:
	jal fact # jump to subroutine that is computing factorial of number stored in a0
	la a0 overflow
	li a7 4
	ecall
	mv a0 s2
	addi a0 a0 -1
	li a7 1
	ecall
	li a7 10
	ecall
fact:
 	beqz a0 iszero
	mv t0 a0
	mv t1 a0 # initial value of n
	li t6 1 # here will be final result
for_fact:
	beq t0 s1 break 	# if t0 <= 1 -> break
	mul t6 t6 t0 # computing factorial
	addi t0 t0 -1 # t0 = n - 1
	j for_fact
iszero:
	li t6 1
break:
	mv a0 t1
	li a7 1
	ecall
	la a0 signs
	li a7 4
	ecall
	mv a0 t6
	li a7 1
	ecall
	li a0 '\n'
	li a7 11
	ecall
	mv a0 t6 # return value
	ret # return from the subroutine
