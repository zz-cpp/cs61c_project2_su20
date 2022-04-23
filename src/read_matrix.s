.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
#
# If you receive an fopen error or eof, 
# this function exits with error code 50.
# If you receive an fread error or eof,
# this function exits with error code 51.
# If you receive an fclose error or eof,
# this function exits with error code 52.
# ==============================================================================
read_matrix:

    # Prologue
    addi sp,sp,-32
    sw s0,0(sp)
    sw s1,4(sp)
    sw s2,8(sp)
    sw s3,12(sp)  # file descriptor
    sw s4,16(sp)  # pointer
    sw s5,20(sp)
    sw s6,24(sp)
    sw ra,28(sp)

    mv s0,a0    # the pointer to string representing the filename
    mv s1,a1    # pointer to an integer: row
    mv s2,a2    # a pointer to an integer: col

    # stp1: open
    mv a1,s0
    add a2,zero,zero
    jal fopen

    addi t0,zero,-1   
    beq a0, t0, error50 # if a0 == t1 then target
    
    mv s3,a0    # file descriptor

    # step2: read about row and col of martiex 
    addi a0,zero,8
    jal malloc
    addi t0,zero,-1
    beq a0,t0,error48

    add s4,a0,zero

    # step3: allow for space of a martriex
    mv a1,s3
    mv a2,s4
    addi a3,zero,8
    jal fread

    addi t0,zero,8
    bne a0,t0,error51

    lw t0,0(s4)
    lw t1,4(s4)

    sw t0,0(s1)
    sw t1,0(s2)

    mul t2,t0,t1
    addi sp,sp,-4
    sw t2,0(sp)     # save matrix element number to stack

    addi t0,zero,4
    mul t2,t0,t2

    add a0,zero,t2
    jal malloc

    addi t0,zero,-1
    beq a0,t0,error48

    mv s5,a0    # s5 -> space of a martriex

    # read data of matrix with a loop

    add s6,zero,s5
    read_inner_matrix:
        add a1,zero,s3
        mv a2,s6
        addi a3,zero,4

        jal fread
    
        addi t0,zero,4
        bne a0,t0,error51

        lw t1,0(sp)
        addi t1,t1,-1   # int i = num_element; then i - 1
        sw t1,0(sp)
            
        addi s6,s6,4    # update s6 = s6 + 4

        bgt t1, zero, read_inner_matrix # gf  then jump

    
    add a0,zero,s4
    jal free      # relase memory

    add a1,s3 zero
    jal fclose

    bne a0,zero,error52

    mv a0,s5

    addi sp,sp,4    # rsume the stack where saving the number of matrix

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

    error48:
        addi a1,zero,48
        jal exit2

    error50:
        addi a1,zero,50
        jal exit2

    error51:
        addi a1,zero,51
        jal exit2

    error52:
         addi a1,zero,52
        jal exit2
