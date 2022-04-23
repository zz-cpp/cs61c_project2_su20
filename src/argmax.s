.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
#
# If the length of the vector is less than 1, 
# this function exits with error code 7.
# =================================================================
argmax:

    # Prologue
    addi sp,sp,-16
    sw s0,0(sp)
    sw s1,4(sp)
    sw s2,8(sp)
    sw s3,12(sp)

    # s0 -> int * ptr; s1 -> int size; s2-> int compare; s3 -> int index
    mv s0,a0
    mv s1,a1
    mv s2,x0
    mv s3,x0
    

    lw s2,0(s0)     # s3 -> ptr[0]
    addi t0,x0,1    # t0 -> int i = 1
loop_start:
    bge t0,s1,loop_end
    slli t1,t0,2    # t1 -> i * stripe
    add t1,s0,t1
    lw t1,0(t1)     # t1 -> ptr[i]
    bge s2, t1, loop_continue # if s2 >= t1 jump loop_continue
    addi s3,t0,0
    mv s2,t1
loop_continue:
    addi t0,t0,1
    j loop_start

loop_end:
    add a0, zero,s3

    # Epilogue
    lw s0,0(sp)
    lw s1,4(sp)
    lw s2,8(sp)
    lw s3,12(sp)
    addi sp,sp,16
    ret