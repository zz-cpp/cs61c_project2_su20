.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
#
# If the length of the vector is less than 1, 
# this function exits with error code 5.
# If the stride of either vector is less than 1,
# this function exits with error code 6.
# =======================================================
dot:
    addi t0,zero,1
    blt a2 ,t0,exit01
    blt a3,t0,exit02
    blt a4,t0,exit02

    # Prologue
    

    # s0 -> int * v0; s1 -> int * v1; 
    # s2 -> int length; 
    # s3 -> int stride_v0; 
    # s4 -> int stride_v1
    

    # t0 -> int sum; 
    # t1 -> int i
    add t0,zero,zero
    add t1,zero,zero
    addi t5,zero,4  #  a word of 4 byte
loop_start:
    beq t1, a2, loop_end # if i >= size  then loop_end
    # t2 -> v0[i]
    mul t2,t1,a3
    mul t2,t2,t5     # transform pointer arithmetic
    add t2,t2,a0
    lw t2,0(t2)

  
    # t3 -> v1[i]
    mul t3,t1,a4
    mul t3,t3,t5 # transform pointer arithmetic
    add t3,t3,a1
    lw t3,0(t3)
    # sum = add()
    mul t4,t2,t3
    add t0,t0,t4
    # i = i + 1
    addi t1,t1,1

    j loop_start

loop_end:

    
    add a0,zero,t0

    # Epilogue
   
    ret
exit01:
    addi a1,zero,5
    jal exit2
exit02:
  
    addi a1,x0,6
    jal exit2