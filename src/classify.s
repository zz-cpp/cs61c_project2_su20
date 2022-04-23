.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # 
    # If there are an incorrect number of command line args,
    # this function returns with exit code 49.
    #
    # Usage:
    #   main.s -m -1 <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>


    # verifying the number of command line arguments
    addi t0,zero,5
    bne t0,a0,error49


    # Prologue

    addi sp,sp,-32
    sw s0,0(sp)
    sw s1,4(sp)
    sw s2,8(sp)
    sw s3,12(sp)  
    sw s4,16(sp)  
    sw s5,20(sp)
    sw s6,24(sp)
    sw ra,28(sp)
    


    mv s0,a0
    mv s1,a1
    mv s2,a2


	# =====================================
    # LOAD MATRICES
    # =====================================


    # Load pretrained m0

    # create int*
    addi a0,zero,8
    jal malloc
    
    addi t0,zero,-1
    beq a0,t0,error48

    mv s3,a0    # heap memory of read_matrix for setting row and col

    # pass the value of double pointer  == pointer
    # get char*
    addi t0,s0,-4
    addi t1,zero,4
    mul t2,t0,t1
    add t3,s1,t2
    lw t4,0(t3)

    mv a0,t4
    mv a1,s3
    addi a2,s3,4

    jal read_matrix
    mv s4,a0

    # print s4
    # mv a0,s4    
    # lw a1,0(s3)
    # lw a2,4(s3)
    # jal print_int_array
    

    # Load pretrained m1

    # create int*
    addi a0,zero,8
    jal malloc

    addi t0,zero,-1
    beq a0,t0,error48

    mv s5,a0    # s5 is heap memory of read_matrix for setting row and col of m1
    # print s5

    # get char*
    addi t0,s0,-3
    addi t1,zero,4
    mul t2,t0,t1
    add t3,s1,t2
    lw t4,0(t3)

    mv a0,t4
    mv a1,s5
    addi a2,s5,4    #xxx

    jal read_matrix
    mv s6,a0        #xxx


    # Load input matrix

    # allow for space in stack
    addi sp,sp,-8

    # create int*
    addi a0,zero,8
    jal malloc

    addi t0,zero,-1
    beq a0,t0,error48

    sw a0, 0(sp)

    # get char*
    # why -2 : index begin with 0 and input is the second in reversing
    addi t0,s0,-2
    addi t1,zero,4
    mul t2,t0,t1
    add t3,s1,t2
    lw t4,0(t3)

    
    mv a0,t4
    # pass the pointer in stack about col and row in input
    lw t0,0(sp)     # m1 about col and row pointer in stack
    addi t1,t0,4

    mv a1,t0
    mv a2,t1

    jal read_matrix

    sw a0,4(sp)

    # okokokokokok

    # relase for space in stack


    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)


    # step1: m0 * input
    lw a1,0(s3)
    lw t0,0(sp)
    lw a5,4(t0)
    mul s0 a1,a5


    addi t0,zero,4
    mul s0,s0,t0    #  sum of size about elements in middle

    mv a0,s0

    jal malloc
    
    
    addi t0,zero,-1
    beq a0,t0,error48
    
    mv s0,a0        # now s0 is a pointer to the result matrix of m0 * input

    #xxxxxxxxxxxxxx
    mv a0,s4    # m0
    lw a1,0(s3)
    lw a2,4(s3)
    lw a3,4(sp)     # int * --> input
    lw t0,0(sp)     # int* about row and col in stack
    lw a4,0(t0)     # row of input
    lw a5,4(t0)     # col of input
    mv a6,s0

    jal matmul
    
    # print middle
    # mv a0,s0
    # addi a1,zero,3
    # addi a2,zero,1
    # jal print_int_array


    # step2: NONLINEAR LAYER: ReLU(m0 * input)

    lw t0,0(s3)
    lw t1,0(sp)
    lw t2,4(t1)

    mul t3,t0,t2

    mv a0,s0
    mv a1,t3

    jal relu


    # step3: LINEAR LAYER:    m1 * ReLU(m0 * input)  m0 * input == middle

    # allow for space  for result

    lw t0,0(s3)     # middle of row
    lw t1,0(sp)     
    lw t2,4(t1)     # middle of col

    lw t3,0(s5)     # m1 of row

    mul t4,t3,t0
    addi t5,zero,4
    mul t6,t4,t5    # sum byte of elements
    
    jal malloc


    addi t4,zero,-1
    beq t4,a0,error48
    # i know this is unnecessary only assume after calling except for s register that everything will change
    lw t0,0(s3)     # middle of row
    lw t1,0(sp)     
    lw t2,4(t1)     # middle of col  

    addi sp,sp,-4
    sw a0, 0(sp)

    mv a6,a0
    # begin mul
    mv a0,s6
    lw a1,0(s5)     # xxx
    lw a2,4(s5)     # xxx
    mv a3,s0
    mv a4,t0
    mv a5,t2
    lw a6,0(sp)

    jal matmul



    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    
    lw a0,16(s1)  # output file name
    
    lw a1,0(sp)
    
    lw t2,4(sp)     
    lw a3,4(t2)     # middle of col  
    lw a2,0(s5)     #  m1 of row

    jal write_matrix


    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    lw a0,0(sp)

    lw t1,4(sp)     
    lw t2,4(t1)     # middle of col  
    lw t3,0(s5)     #  m1 of row

    mul a1,t2,t3

    jal argmax


    bne s2,zero,no_print

    # Print classification
    # lw a1,0(t3)
    mv a1,a0    
    jal print_int
    

    # Print newline afterwards for clarity
    li a1 '\n'
    jal print_char

    # skip the print
    no_print:

    # relase the heap
    mv a0,s3
    jal free

    mv a0,s5
    jal free

    mv a0,s0
    jal free

    lw a0,8(sp)
    jal free

    lw a0,0(sp)
    jal free

    # middle stack
    addi sp,sp,12

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

    error49:
        addi a1,zero,49
        jal exit2