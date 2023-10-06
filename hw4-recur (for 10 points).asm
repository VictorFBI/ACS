.data
	overflow: .asciz "The maximum number that does not lead to overflow when computing the factorial is equal to "
	signs: .asciz "! = "
.text
main:
	li s11 2147483647 # max int32
	li s2 1		# counter. It is equal to 0 at first because factorial is defined for every whole n >= 0
	li a1 1 # initial result of computing factorial (0! = 1)
for_main:
	mv a0 s2
	div s3 s11 s2 # s3 = max_value / n
	blt s3 a1 end # if max_value / n < (n-1)! -> stop the cycle else -> continue to compute factorials
	jal fact # jump to subroutine that is computing factorial of number stored in a0
	jal print # jump to subroutine that is printing results of every computation
continue_main:
	addi s2 s2 1
	j for_main # continue the cycle
end:
	jal fact # jump to subroutine that is computing factorial of number stored in a0
	jal print # jump to subroutine that is printing results of every computation
	la a0 overflow
	li a7 4
	ecall
	mv a0 s2
	addi a0 a0 -1
	li a7 1
	ecall
	li a7 10
	ecall
fact:   addi    sp sp -4
        sw      ra (sp)         # Save ra
        mv      t1 a0           # Remember N in t1
        addi    a0 t1 -1        # Put n-1 в a0
        li      t0 1
        ble     a0 t0 done      # if n<2 -> it is done
        addi    sp sp -4        ## Save t1 in stack
        sw      t1 (sp)         ##
        jal     fact            # Compute (n-1)!
        lw      t1 (sp)         ## Remember t1
        addi    sp sp 4         ##
        mul     t1 t1 a0        # Multipling by(n-1)!
done:   mv      a0 t1           # Return value
        lw      ra (sp)         # Restore ra
        addi    sp sp 4         # Restore the top of the stack
        ret
print:
	mv a1 a0
	mv a0 s2
	li a7 1
	ecall
	la a0 signs
	li a7 4
	ecall
	mv a0 a1
	li a7 1
	ecall
	mv a1 a0
	li a0 '\n'
	li a7 11
	ecall
	ret   # return from the print subroutine
        
