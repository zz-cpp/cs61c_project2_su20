.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   The order of error codes (checked from top to bottom):
#   If the dimensions of m0 do not make sense, 
#   this function exits with exit code 2.
#   If the dimensions of m1 do not make sense, 
#   this function exits with exit code 3.
#   If the dimensions don't match, 
#   this function exits with exit code 4.
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d


# Returns:
#	None (void), sets d = matmul(m0, m1)
# =======================================================
matmul:
    
    # Error checks
    bne a2,a4,exit04


    # Prologue
    addi sp,sp,-32
    sw s0,0(sp)
    sw s1,4(sp)
    sw s2,8(sp)
    sw s3,12(sp)
    sw s4,16(sp)
    sw s5,20(sp)
    sw,s6,24(sp)
    sw,ra,28(sp)
    
    
    add s0,zero,zero   # int i = 0
    add s1,zero,zero   # int j = 0
    mv s2,a0            # address of m0
    mv s3,a1            # row of m0
    mv s4,a2            # col of m0 
    mv s5,a3            # address of m1
    mv s6,a5            # col of m1

   
    # add space for a6
    addi sp,sp,-4
    sw a6,0(sp)
    # release the space

    

outer_loop_start:
    bge s0,s3,outer_loop_end
    mv s1,zero

inner_loop_start:
    bge s1,s6,inner_loop_end

    # step1 comclude the address of v0
    addi t0,zero,4
    mul t1,s0,s4    # get bias 0f v0 is m0 col
    mul t2,t1,t0    # i * col * 4
    add a0,s2,t2    # i * col * 4 + base

    # step2 comclude the address of v1 --> &m1[0][j]
    mul t3,s1,t0
    add a1,t3,s5    # &m1[0][j]

    # step3  the length of the vectors
    mv a2,s4        # length of competing
    addi a3,zero,1  # stripe
    mv a4,s6        # stripe

    # print a0
    # addi sp,sp,-8
    # sw a0,0(sp)
    # sw a1,4(sp)

    # add a1,zero,a0
    # jal print_int

    # li a1 '\n'
    # jal print_char

    # lw a0,0(sp)
    # lw a1,4(sp)
    # addi sp,sp,8

    # print a1
    # addi sp,sp,-8
    # sw a0,0(sp)
    # sw a1,4(sp)

    #add a1,zero,a1
    #jal print_int

    #li a1 '\n'
    #jal print_char

    #lw a0,0(sp)
    #lw a1,4(sp)
    #addi sp,sp,8



    # print a2
    #addi sp,sp,-8
    #sw a0,0(sp)
    #sw a1,4(sp)

    #add a1,zero,a2
    #jal print_int

    #li a1 '\n'
    #jal print_char

    #lw a0,0(sp)
    #lw a1,4(sp)
    #addi sp,sp,8

    # print a3
    # addi sp,sp,-8
    # sw a0,0(sp)
    # sw a1,4(sp)

    # add a1,zero,a3
    # jal print_int

    # li a1 '\n'
    # jal print_char

    # lw a0,0(sp)
    # lw a1,4(sp)
    # addi sp,sp,8

    # print a4
    # addi sp,sp,-8
    # sw a0,0(sp)
    # sw a1,4(sp)

    # add a1,zero,a4
    # jal print_int

    # li a1 '\n'
    # jal print_char

    # lw a0,0(sp)
    # lw a1,4(sp)
    # addi sp,sp,8

    jal ra,dot
    # assigm the &d[i][j]
    addi t0,zero,4

    mul t1,s0,s6
    add t2,t1,s1
    mul t3,t2,t0
 
    lw t4,0(sp)
    add t5,t3,t4    # address of d[i][j]
    
    sw a0,0(t5)     # assign

    addi s1,s1,1
    j inner_loop_start

inner_loop_end:
    addi s0,s0,1
    j outer_loop_start


outer_loop_end:

    addi sp,sp,4


    # Epilogue
    lw s0,0(sp)
    lw s1,4(sp)
    lw s2,8(sp)
    lw s3,12(sp)
    lw s4,16(sp)
    lw s5,20(sp)
    lw s6,24(sp)
    lw ra,28(sp)
    addi sp,sp,32

    ret

exit04:
    addi a1,zero,4
    jal exit2
    