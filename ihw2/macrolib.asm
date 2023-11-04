# Print a string, transferred by immediate value, to the console 
.macro print_str(%str_imm)
.data
	str: .asciz %str_imm
.text
	push(a0)
	la a0 str
	li a7 4
	ecall
	pop(a0)
.end_macro

# Read an integer from the console to the register, transferred to macro
.macro read_double_in(%name_reg)
	li a7 7
	ecall
	fmv.d %name_reg fa0
.end_macro

# Print an integer, stored in the %name_reg register
.macro print_double_from(%name_reg)
	fmv.d fa0 %name_reg
	li a7 3
	ecall
.end_macro

# Computes the absolute value of %src_reg
.macro abs(%src_reg)
.data
	null: .double 0
.text
	fld ft0 null t0 # ft0 stores 0
	fle.d t1 %src_reg ft0 # src_reg <= 0 => src_reg = -src_reg (it is needed to be like this)
	li t0 -1 
	mul t1 t1 t0 # if (t1 == 1) => t1 = -1 but if (t1 == 0) => t1 = 0
	beqz t1 finish # if (t1 == 0) => src_reg > 0 => return src_reg
	# else t1 = -1 => ft1 = -ft1 and return ft1
	fcvt.d.w ft1 t1 
	fmul.d %src_reg, ft1, %src_reg
finish:
.end_macro

# Computes the cube root of the number, stored in %src_reg register, 
# the result is stored in the %dest_reg register. Macro is using fast converging
# iterative algorithm of computing nth root of the number

# Short implementation using C++ for the better understanding
#  double num;
#  if (num == 0) {
#    std::cout << 0.0;
#    return 0;
#  }
#  const double eps = 0.0005;
#  double root = num / 3;
#  double prev_root;
#  double rn;
#  do {
#    prev_root = root;
#    rn = num;
#    rn /= root;
#    rn /= root;
#    root = 0.5 * (root + rn);
#  } while (std::abs((root - prev_root) / root) > eps);
#  std::cout << root;
.macro cube_root_of(%src_reg, %dest_reg)
.data
	null: .double 0
	eps: .double 0.0005
	rootDegree: .double 3
	half: .double 0.5
.text
	fld fs0 null s0 # fs0 = 0
	feq.d t1 %src_reg fs0 # if num == 0 => t1 = 1
	addi t1 t1 -1 # if t1 == 1 => t1 = 0
	beqz t1 if_zero # if t1 == 0 => t1 was 1 => source num is 0 => ans = 0 (we handle it manually) 
	fld fs0 eps s0 # fs0 = eps (=0.05)
	fld fs3 rootDegree s3 # fs3 = rootDegree (=3) (the power of the root we are computing)
	fld fs5 half s5 # fs5 = half (=0.5)
	fdiv.d %dest_reg %src_reg fs3 # %dest_reg = root = num / 3,  %src_reg = num
	fmv.d fs4 %src_reg #fs4 = rn, %src_reg = num
while:
	fmv.d fs6 %dest_reg # prev_root = root
	fmv.d fs4 %src_reg # rn = num
	fdiv.d fs4 fs4 %dest_reg # rn /= root
	fdiv.d fs4 fs4 %dest_reg # rn /= root
	fadd.d %dest_reg %dest_reg fs4 # root = root + rn
	fmul.d %dest_reg %dest_reg fs5 # root = 0.5 * root (overall, root = 0.5*(root + rn))
	fsub.d fs7 %dest_reg fs6 # fs7 = root - prev_root
	fdiv.d fs7 fs7 %dest_reg # fs7 = (root - prev_root) / root
	abs(fs7) # fs7 = abs((root - prev_root) / root) 
	fle.d t1 fs7 fs0 # t1 = 1 if fs7 <= fs0, i.e. if abs((root - prev_root) / root) <= eps
	# and t1 = 0 if fs7 > fs0, i.e. if abs((root - prev_root) / root) > eps
	beqz t1 while # continue if abs((root - prev_root) / root) > eps
	j finish
if_zero:
	fmv.d %dest_reg fs0
finish:
.end_macro

# Saving given register on the stack
.macro push(%x_reg)
	addi	sp sp -4
	sw	%x_reg (sp)
.end_macro

# Popping value from the top of the stack to the given register
.macro pop(%x_reg)
	lw	%x_reg (sp)
	addi	sp sp 4
.end_macro

# Finishes the program
.macro exit
	li a7 10
	ecall
.end_macro
