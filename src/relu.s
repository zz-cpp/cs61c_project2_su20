.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the (numbers) of elements in the array
# Returns:
#	None
#
# If the length of the vector is less than 1, 
# this function exits with error code 8.
# ==============================================================================
relu:
    # Prologue
    addi sp,sp,-12
    sw s0,0(sp)
    sw s1,4(sp)
    sw s2,8(sp)

loop_start:
    mv s0,a0   
    mv s1,a1    
    li s2,0     
    
loop_continue:
    bge s2 s1 loop_end
    slli t0,s2,2 # p = p + i * stripe
    add t0,t0,s0
    lw t1, 0(t0) # p[i] 
    bge t1,x0,add # if p[i] >= 0, jump add
    sw,x0 0(t0) # p[i] = 0 
    jal x0,loop_continue  # jump to x0,loop_continue and save position to ra
    
add:
    addi s2,s2,1
    jal x0,loop_continue

loop_end:

    # Epilogue
    lw s0,0(sp)
    lw s1,4(sp)
    lw s2 8(sp)
    addi sp,sp,12

    
	ret