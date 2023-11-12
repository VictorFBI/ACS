.include "macrolib.s"
.eqv SIZE 100
.data
	buf1:    .space SIZE     # Буфер для первой строки
	buf2:    .space SIZE     # Буфер для второй строки
	buf3:    .space SIZE     # Буфер для третьей строки
	buf4:    .space SIZE     # Буфер для четвертой строки
	buf5:    .space SIZE     # Буфер для пятой строки
	buf6:    .space SIZE     # Буфер для шестой строки
	empty_test_str: .asciz ""   # Пустая тестовая строка
	short_test_str: .asciz "not_empty"     # Короткая тестовая строка
	long_test_str:  .asciz "a roza upala na lapu azora" # Длинная тестовая строка
.text
.global main
main:
	# First test
	la a1 buf1
	la a2 empty_test_str
	print_str_imm("Source string is \"")
	print_str_reg(a2)
	print_str_imm("\"")
	newline
	strncpy(a1, a2, 3)
	print_str_imm("We copied first 3 symbols. Copied string is \"")
	print_str_reg(a1)
	print_str_imm("\"")
	newline
	newline
	
	
	# Second test
	la a1 buf2
	la a2 short_test_str
	print_str_imm("Source string is \"")
	print_str_reg(a2)
	print_str_imm("\"")
	newline
	strncpy(a1, a2, 100)
	print_str_imm("We copied first 100 symbols. Copied string is \"")
	print_str_reg(a1)
	print_str_imm("\"")
	newline
	newline
	
	# Third test
	la a1 buf3
	la a2 long_test_str
	print_str_imm("Source string is \"")
	print_str_reg(a2)
	print_str_imm("\"")
	newline
	strncpy(a1, a2, 12)
	print_str_imm("We copied first 12 symbols. Copied string is \"")
	print_str_reg(a1)
	print_str_imm("\"")
	newline
	newline
	
	# Fourth test
	la a1 buf4
	print_str_imm("Input string: ")
	li a7 8
	ecall
	mv a2 a0
	print_str_imm("Source string is \"")
	print_str_reg(a2)
	print_str_imm("\"")
	newline
	strncpy(a1, a2, 7)
	print_str_imm("We copied first 7 symbols. Copied string is \"")
	print_str_reg(a1)
	print_str_imm("\"")
	newline
	newline
	
	# Fifth test
	la a1 buf5
	print_str_imm("Input string: ")
	li a7 8
	ecall
	mv a2 a0
	print_str_imm("Source string is \"")
	print_str_reg(a2)
	print_str_imm("\"")
	newline
	strncpy(a1, a2, 0)
	print_str_imm("We copied first 0 symbols. Copied string is \"")
	print_str_reg(a1)
	print_str_imm("\"")
	newline
	newline
	
	# Sixth test
	la a1 buf6
	print_str_imm("Input string: ")
	li a7 8
	ecall
	mv a2 a0
	print_str_imm("Source string is \"")
	print_str_reg(a2)
	print_str_imm("\"")
	newline
	strncpy(a1, a2, -5)
	print_str_imm("We copied first -5 symbols. Copied string is \"")
	print_str_reg(a1)
	print_str_imm("\"")
	newline
	
	exit