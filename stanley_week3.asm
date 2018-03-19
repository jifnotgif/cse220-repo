########################################
# 1D Array
########################################
.data
    num_arr: .word 32, 53, 7, 43, 5 # A number array can be created by delimiting numbers using a comma
    num_len: .word 5

    min_num: .word 0x80000000 # INT_MIN
    max_num: .word 0x7fffffff # INT_MAX

    max_label: .asciiz "Max: "
    min_label: .asciiz "Min: "

    space: .asciiz " "
    newline: .asciiz "\n"

    .macro print_str(%str)
        la $a0, %str
        li $v0, 4
        syscall
    .end_macro

.text
    lw $t0, num_len # Load the value located at the word
    la $s0, num_arr # Load the address of where the array is located, so we can iterate through them
    li $t1, 0 # Counter for the loop
    lw $s1, min_num # Load the min num for comparison
    lw $s2, max_num # Load the max num for comparison
    arr_loop:
        beq $t1, $t0, arr_loop_end # Exit the loop when we reach the end of the array
        lw $t2, ($s0) # Load the word value at the current address pointed by $s0

        # Check if number is greater than the current max
        ble $t2, $s1, not_max # Branch if not greater than the current max
        la $s3, max_num
        move $s1, $t2
        sw $t2, ($s3) # Store the new max
        not_max:

        bgt $t2, $s1, not_min # Branch if not greater than the current max
        la $s3, min_num
        move $s2, $t2
        sw $s2, ($s3) # Store the new max
        not_min:

        # Print the number
        li $v0, 1
        move $a0, $t2
        syscall

        print_str(space)

        # Increment the addresses and pointer
        addi $s0, $s0, 4 # Increment by 4 to get to the next word
        addi $t1, $t1, 1 # Increment the counter

        j arr_loop

    arr_loop_end:
    
    print_str(newline)

    # Print out the max value
    print_str(max_label)
    lw $a0, max_num
    li $v0, 1
    syscall

    print_str(newline)

    # Print out the min value
    print_str(min_label)
    lw $a0, min_num
    li $v0, 1
    syscall

    li $v0, 10
    syscall

########################################
# 2D Array Example
########################################

########################################
# The basic fomrula for a 2D array given the base address, number of columns, number of rows, row index, and column index.
# This equation could be written as:
#       base_addr + I * size_of_a_row_in_bytes + j * size_of_column_in_bytes
# This can be simplified to:
#       base_addr + I * num_cols * size_of_element + j * size_of element
# And further simplified to:
#       base_addr + size_of_element * (I * num_cols + j)
########################################
.data
    matrix: .space 60 # 5x3 matrix of 4-byte words
    num_rows: .word 5
    num_cols: .word 3

.text
    main:
        # Load the variables
        la $t0, matrix
        lw $t1, num_rows # Number of rows
        lw $t2, num_cols # Number of columns

        li $t3, 0 # Temp counter to iterate through the rows. (i)
        li $t9, 65 # Value to store within the 2d array

        row_loop: # Loops through each loop 

            li $t4, 0 # Counter for columns moving from left to right. (j)

            col_loop: # Loop through the columns
                # All these assignments could easily be done just by adding 4 to the starting address, but that really only shows us how a 1-D array is implemented and not the principles of a 2-D array.

                mul $t5, $t3, $t2 # I * num_columns
                add $t5, $t5, $t4 # (I * num_columns) + j
                sll $t5, $t5, 2 # [(I * num_columns) + j] * 4
                add $t5, $t5, $t0 # (I * num_columns) + j + base_addr. Pretty much we will have to keep adding this offset to the base address.
                sw $t9, ($t5) # Store the value into the array

                # Increment
                addi $t4, $t4, 1 # j++
                addi $t9, $t9, 1 # Generate next value to save.
                blt $t4, $t2, col_loop # Keep running until j == num_columns
            col_loop_end:

            addi $t3, $t3, 1 # i++
            blt $t3, $t2, row_loop # Keep looping until i == num_rows
        
        row_loop_done:
    
        # Get specific element
        la $a0, matrix # Load address
        lw $a1, num_rows
        lw $a2, num_cols
        li $a3, 4 # Size of words

        addi $sp, $sp, -8
        li $t0, 0
        sw $t0, ($sp)
        li $t0, 0
        sw $t0, 4($sp)

        jal arr_get

        addi $sp, $sp, 8

        move $a0, $v0
        li $v0, 1
        syscall

        li $v0, 10
        syscall

    ########################################
    # Get an element in an array given i and j. (Note that there are no checks in this implementation and it is assumed that all parameters are valid)
    #
    # Arguments:
    #   $a0 = (base_addr) Base address of the array
    #   $a1 = (num_rows) number of rows
    #   $a2 = (num_cols) number of columns
    #   $a3 = (obj_size) size of object
    #   0($sp) = (i) desired row
    #   4($sp) = (j) desired column
    #
    # Returns:
    #   $v0 = the element at that index
    ########################################
    arr_get:
        lw $t0, 0($sp) # i
        lw $t1, 4($sp) # j

        # Calculate the offset
        move $t2, $a3 # sizeof(object)
        mul $t3, $t2, $a2 # row_size = num_cols * sizeof(obj)
        mul $t2, $t2, $t1 # sizeof(obj) * j
        add $t2, $t2, $t3 # offset = (num_rows * i) + (sizeof(obj) * j)

        add $t4, $a0, $t2 # Add to base address to get offset
        lw $v0, ($t4) # Get the value we want

        jr $ra

########################################
# Factorial
########################################

.data
    num: .word 6

.text
    # The main entry point of the program
    main:
        lw $a0, num # Load the value of the number we will be finding the factorial of

        jal factorial # Call the factorial function with number in arguments already

        move $a0, $v0
        li $v0, 1
        syscall

        li $v0, 10
        syscall

    ########################################
    # Helper function for finding the factorial
    #
    # Arguments:
    #   $a0 = (n) the number are currently multiplying
    #
    # Returns:
    #   $v0 = the result
    ########################################
    factorial:
        # Before doing anything, make sure to save the return address
        addi $sp, $sp, -8 # Allocate 4 bytes on the stack
        sw $a0, ($sp)
        sw $ra, 4($sp) # Store the return address at the top of the stack

        # Base Case #
        bgtz $a0, non_leaf # If param > 0, keep multiplying
        li $v0, 1 # Load 1 as return value
        j return

        non_leaf:

        addi $a0, $a0, -1 # Decrement
        jal factorial
        lw $a0, ($sp) # Load the original parameter
        mul $v0, $a0, $v0

        return:

        # Restore the old return address
        lw $ra, 4($sp)
        addi $sp, $sp, 8 # Free up memory
    
        jr $ra # Return