.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
#   If any file operation fails or doesn't write the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
#
# If you receive an fopen error or eof, 
# this function exits with error code 53.
# If you receive an fwrite error or eof,
# this function exits with error code 54.
# If you receive an fclose error or eof,
# this function exits with error code 55.
# ==============================================================================
write_matrix:

    # Prologue
    addi sp,sp,-24
    sw s0,0(sp)
    sw s1,4(sp)
    sw s2,8(sp)
    sw s3,12(sp)
    sw s4,16(sp)
    sw ra,20(sp)


    mv s0,a0
    mv s1,a1
    mv s2,a2    # number of rows
    mv s3,a3    # number of col
  

    # open or create a file 
    mv a1,a0
    addi a2,zero,1
    jal fopen

    addi t0,zero,-1
    beq a0,t0,error53

    mv s4,a0    # save descriptor
    
    #push row
    addi sp,sp,-4
    sw s2,0(sp)

    # write the row into file 
   

    mv a1,s4
    add a2,sp,zero
    addi a3,zero,1
    addi a4,zero,4

    jal fwrite

    addi t0,zero,1
    bne a0,t0,error54

    # push col
    sw s3,0(sp)
    

    # write the col into file 
    mv a1,s4
    add a2,sp,zero
    addi a3,zero,1
    addi a4,zero,4

    jal fwrite

    addi t0,zero,1
    bne a0,t0,error54

    # release stack
    addi sp,sp,4

    # write the matrix
    mul t0,s2,s3
   
    mv a1,s4
    mv a2,s1
    mv a3,t0
    addi a4,zero,4

    jal fwrite

    mul t0,s2,s3
    bne a0,t0,error54

    # close the file
    mv a1,s4
    jal fclose

    addi t0,zero,-1
    beq t0,a0,error55 
    

    # Epilogue
    lw s0,0(sp)
    lw s1,4(sp)
    lw s2,8(sp)
    lw s3,12(sp)
    lw s4,16(sp)
    lw ra,20(sp)
    addi sp,sp,24


    ret

    error53:
        addi a1,zero,53
        jal exit2
     error54:
        addi a1,zero,54
        jal exit2
    error55:
        addi a1,zero,55
        jal exit2