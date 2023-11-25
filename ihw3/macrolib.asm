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
	.eqv    NAME_SIZE 256	# Размер буфера для имени файла
.eqv    TEXT_SIZE 512	# Размер буфера для текста

.data
	er_name_mes:    .asciz "Incorrect file name\n"
	er_read_mes:    .asciz "Incorrect read operation\n"
	file_name:      .space	NAME_SIZE		# Имячитаемого файла
	strbuf:	        .space   TEXT_SIZE		# Буфер для читаемого текста
.text
    print_str_imm("Input path to file for reading: ") # Вывод подсказки
    # Ввод имени файла с консоли эмулятора
    str_get(file_name, NAME_SIZE)
    open(file_name, READ_ONLY)
    li		s1 -1			# Проверка на корректное открытие
    beq		a0 s1 er_name	# Ошибка открытия файла
    mv   	s0 a0       	# Сохранение дескриптора файла

    # Выделение начального блока памяти для для буфера в куче
    allocate(TEXT_SIZE)		# Результат хранится в a0
    mv 		s3, a0			# Сохранение адреса кучи в регистре
    mv 		s5, a0			# Сохранение изменяемого адреса кучи в регистре
    li		s4, TEXT_SIZE	# Сохранение константы для обработки
    mv		s6, zero		# Установка начальной длины прочитанного текста
    ###############################################################
read_loop:
    # Чтение информации из открытого файла
    ###read(s0, strbuf, TEXT_SIZE)
    read_addr_reg(s0, s5, TEXT_SIZE) # чтение для адреса блока из регистра
    # Проверка на корректное чтение
    beq		a0 s1 er_read	# Ошибка чтения
    mv   	s2 a0       	# Сохранение длины текста
    add 	s6, s6, s2		# Размер текста увеличивается на прочитанную порцию
    # При длине прочитанного текста меньшей, чем размер буфера,
    # необходимо завершить процесс.
    bne		s2 s4 end_loop
    # Иначе расширить буфер и повторить
    allocate(TEXT_SIZE)		# Результат здесь не нужен, но если нужно то...
    add		s5 s5 s2		# Адрес для чтения смещается на размер порции
    b read_loop				# Обработка следующей порции текста из файла
end_loop:
    ###############################################################
    # Закрытие файла
    close(s0)
    #li   a7, 57       # Системный вызов закрытия файла
    #mv   a0, s0       # Дескриптор файла
    #ecall             # Закрытие файла
    ###############################################################
    # Установка нуля в конце прочитанной строки
    ###la	t0 strbuf	 # Адрес начала буфера
    mv	t0 s3		# Адрес буфера в куче
    add t0 t0 s6	# Адрес последнего прочитанного символа
    addi t0 t0 1	# Место для нуля
    sb	zero (t0)	# Запись нуля в конец текста
    ###############################################################
    # Вывод текста на консоль
    ###la 	a0 strbuf
    mv	a0	s3	# Адрес начала буфера из кучи
    # End of the program
    j finish
er_name:
    # Сообщение об ошибочном имени файла
    la		a0 er_name_mes
    li		a7 4
    ecall
    # И завершение программы
    exit
er_read:
    # Сообщение об ошибочном чтении
    la		a0 er_read_mes
    li		a7 4
    ecall
    # И завершение программы
    exit
finish:
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
		
.eqv	NAME_SIZE 256	# Размер буфера для имени файла

.data
	prompt:  .asciz "Input path to the finite file: "     # Путь до читаемого файла
	default_name: .asciz "testout.txt"      # Имя файла по умолчанию
	file_name: .space	NAME_SIZE		# Имя читаемого файла
.text
    # Вывод подсказки
    la		a0 prompt
    li		a7 4
    ecall
    
    # Ввод имени файла с консоли эмулятора
    la		a0 file_name
    li      a1 NAME_SIZE
    li      a7 8
    ecall
    # Убрать перевод строки
    li  t4 '\n'
    la  t5  file_name
    mv  t3 t5	# Сохранение начала буфера для проверки на пустую строку
loop:
    lb	t6  (t5)
    beq t4	t6	replace
    addi t5 t5 1
    b   loop
replace:
    beq t3 t5 default	# Установка имени введенного файла
    sb  zero (t5)
    mv   a0, t3 	# Имя, введенное пользователем
    b out
default:
    la   a0, default_name # Default name of the file

out:
    # Open (for writing) a file that does not exist
    li   a7, 1024     # system call for open file
    li   a1, 1        # Open for writing (flags are 0: read, 1: write)
    ecall             # open a file (file descriptor returned in a0)
    mv   s6, a0       # save the file descriptor

    # Write to file just opened
    li   a7, 64       # system call for write to file
    mv   a0, s6       # file descriptor
    mv   a1, a3 # address of buffer from which to write
    ecall             # write to file

    # Close the file
    li   a7, 57       # system call for close file
    mv   a0, s6       # file descriptor to close
    ecall             # close file
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

# Asks user to write Y or N for writing additional data in the console
.macro survey(%flag_reg)
	push(a2)
	push(a3)
	push(a4)
	read_str(a2)
	lb a3 (a2)
	li a4 'Y'
	beq a3 a4 yes
	li a4 'N' 
	beq a3 a4 no
loop:
	print_str_imm("Please, input only Y or N")
	newline
	read_str(a2)
	lb a3 (a2)
	li a4 'Y'
	beq a3 a4 yes
	li a4 'N' 
	beq a3 a4 no
	j loop
yes:
	li %flag_reg 1
	j finish
no:
	li %flag_reg 0
finish:
	pop(a4)
	pop(a3)
	pop(a2)
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

#-------------------------------------------------------------------------------
# Ввод строки в буфер заданного размера с заменой перевода строки нулем
# %strbuf - адрес буфера
# %size - целая константа, ограничивающая размер вводимой строки
.macro str_get(%strbuf, %size)
    la      a0 %strbuf
    li      a1 %size
    li      a7 8
    ecall
    push(s0)
    push(s1)
    push(s2)
    li	s0 '\n'
    la	s1	%strbuf
next:
    lb	s2  (s1)
    beq s0	s2	replace
    addi s1 s1 1
    b	next
replace:
    sb	zero (s1)
    pop(s2)
    pop(s1)
    pop(s0)
.end_macro

#-------------------------------------------------------------------------------
# Открытие файла для чтения, записи, дополнения
.eqv READ_ONLY	0	# Открыть для чтения
.eqv WRITE_ONLY	1	# Открыть для записи
.eqv APPEND	    9	# Открыть для добавления
.macro open(%file_name, %opt)
    li   	a7 1024     	# Системный вызов открытия файла
    la      a0 %file_name   # Имя открываемого файла
    li   	a1 %opt        	# Открыть для чтения (флаг = 0)
    ecall             		# Дескриптор файла в a0 или -1)
.end_macro

#-------------------------------------------------------------------------------
# Чтение информации из открытого файла
.macro read(%file_descriptor, %strbuf, %size)
    li   a7, 63       	# Системный вызов для чтения из файла
    mv   a0, %file_descriptor       # Дескриптор файла
    la   a1, %strbuf   	# Адрес буфера для читаемого текста
    li   a2, %size 		# Размер читаемой порции
    ecall             	# Чтение
.end_macro

#-------------------------------------------------------------------------------
# Чтение информации из открытого файла,
# когда адрес буфера в регистре
.macro read_addr_reg(%file_descriptor, %reg, %size)
    li   a7, 63       	# Системный вызов для чтения из файла
    mv   a0, %file_descriptor       # Дескриптор файла
    mv   a1, %reg   	# Адрес буфера для читаемого текста из регистра
    li   a2, %size 		# Размер читаемой порции
    ecall             	# Чтение
.end_macro

#-------------------------------------------------------------------------------
# Закрытие файла
.macro close(%file_descriptor)
    li   a7, 57       # Системный вызов закрытия файла
    mv   a0, %file_descriptor  # Дескриптор файла
    ecall             # Закрытие файла
.end_macro

#-------------------------------------------------------------------------------
# Выделение области динамической памяти заданного размера
.macro allocate(%size)
    li a7, 9
    li a0, %size	# Размер блока памяти
    ecall
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
	beqz s3 null
	addi s3 s3 1
	beqz s3 is_negative
	li s4 10
	addi s3 s3 -1
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
null:
	li s1 48 # ascii code for 0
	sb s1 (s0)
	j end
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
	li t5 '\n' # this symbol indicates about the end of the string, because the 
	# substring is being input via console
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
