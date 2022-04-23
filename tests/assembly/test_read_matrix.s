.import ../../src/read_matrix.s
.import ../../src/utils.s

.data
file_path: .asciiz "inputs/test_read_matrix/test_input.bin"

.text
main:
    # Read matrix into memory
    addi sp,sp,-8
    la a0,file_path 
    mv a1,sp
    addi a2,sp,4
    jal read_matrix

    # Print out elements of matrix
    mv a0,a0
    lw a1,0(sp)
    lw a2,4(sp)
    jal print_int_array  
    
    # Terminate the program
    jal exit