# Моделирование функции strncpy(char* dest, char* src, size_t num)
# dest = a1
# src = a2
# num = a3
.text
.global strncpy 
strncpy:
	li t0 0 # counter
	bltz a3 end
loop:
	beq t0 a3 end # if counter reached the num
	lb t2 (a2) # load the current byte from a2 to t2
	beqz t2 end # if t2 == '\0'
	sb t2 (a1) # store the t2 into a1
	addi a1 a1 1 # move towards a1
	addi a2 a2 1 # move towards a2
	addi t0 t0 1 # increase the counter by 1
	j loop
end:
	ret
	
