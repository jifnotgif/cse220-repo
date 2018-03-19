##############################
# Calculate the length of the string
##############################
.data

    some_string: .asciiz "this is a string"

.text

    li $t0, 0 # Counter for the length of the string
    la $a0, some_string # Load the address of the string
    str_len_loop:
        lb $t1, 0($a0) # Load the char that is located at the current location of the address
        beqz $t1, str_len_loop_end # Check if the character is null which indicates the end of the string

        addi $t0, $t0, 1 # Increment the counter
        addi $a0, $a0, 1 # Increment the string pointer
        j str_len_loop

    str_len_loop_end:

    move $a0, $t0 # Move the counter
    li $v0, 1
    syscall

    li $v0, 10
    syscall


##############################
# Convert a given string that represents a number to an actual integer
##############################
.data
    string: .asciiz "123"

.text

    la $s0, string
    li $s1, 0 # Store the number
    loop:
        lb $a0, ($s0)
        beqz $a0, end_loop
        jal atoi_helper

		li $t0, 10
        mul $s1, $s1, $t0
        add $s1, $s1, $v0

        addi $s0, $s0, 1

        j loop

    end_loop:

    move $a0, $s1
    li $v0, 1
    syscall

    li $v0, 10
    syscall


# Convert ASCII chars to integers
atoi_helper:
    li $t0, '0'
    sub $v0, $a0, $t0 # Subtract the '0' ASCII value as an offset
    jr $ra

##############################
# Hamming distance is the number of differences in char between two binary strings
##############################

.data
    str1: .asciiz "1010"
    str2: .asciiz "0000"
    dist_str: .asciiz "Hamming distance: "
    newline: .asciiz "\n"
    err_str: .asciiz "Argument error\n"


.text:
    la $a0, str1
    jal strlen
    move $s0, $v0 # len of str1
    la $a0, str2
    jal strlen # len of str2 in v0
    bne $s0, $v0, hamming_err

    # strings are same len --> can compute hamming dist
    la $t0, str1
    la $t1, str2
    li $t3, 0 # dist

    hamming_loop:
        lb $t4, ($t0)
        lb $t5, ($t1)
        beqz $t4, hamming_end # reached end of str
        addi $t0, $t0, 1  # inc string
        addi $t1, $t1, 1  # inc string
        beq $t4, $t5, hamming_loop # equal --> dist doesn't change
        addi $t3, $t3, 1 # dist += 1
        j hamming_loop

    hamming_end:
        la $a0, dist_str
        li $v0, 4
        syscall
        
        move $a0, $t3
        li $v0, 1
        syscall
        
        la $a0, newline
        li $v0, 4
        syscall

        j exit

    hamming_err:
        la $a0, err_str
        li $v0, 4
        syscall
    
    exit:
        li $v0, 10 # exit
        syscall 
        

strlen:
    # a0 = addr of string
    # return len in v0

    li $v0, 0  # len
    strlen_loop:
        lb $t1, 0($a0)
        beqz $t1, strlen_end
        addi $v0, $v0, 1  # len += 1
        addi $a0, $a0, 1  # str += 1
        j strlen_loop
    strlen_end:
        jr $ra # return 
.data
    str1: .asciiz "1010"
    str2: .asciiz "0000"
    dist_str: .asciiz "Hamming distance: "
    newline: .asciiz "\n"
    err_str: .asciiz "Argument error\n"


.text:
    la $a0, str1
    jal strlen
    move $s0, $v0 # len of str1
    la $a0, str2
    jal strlen # len of str2 in v0
    bne $s0, $v0, hamming_err

    # strings are same len --> can compute hamming dist
    la $t0, str1
    la $t1, str2
    li $t3, 0 # dist

    hamming_loop:
        lb $t4, ($t0)
        lb $t5, ($t1)
        beqz $t4, hamming_end # reached end of str
        addi $t0, $t0, 1  # inc string
        addi $t1, $t1, 1  # inc string
        beq $t4, $t5, hamming_loop # equal --> dist doesn't change
        addi $t3, $t3, 1 # dist += 1
        j hamming_loop

    hamming_end:
        la $a0, dist_str
        li $v0, 4
        syscall
        
        move $a0, $t3
        li $v0, 1
        syscall
        
        la $a0, newline
        li $v0, 4
        syscall

        j exit

    hamming_err:
        la $a0, err_str
        li $v0, 4
        syscall
    
    exit:
        li $v0, 10 # exit
        syscall 
        

strlen:
    # a0 = addr of string
    # return len in v0

    li $v0, 0  # len
    strlen_loop:
        lb $t1, 0($a0)
        beqz $t1, strlen_end
        addi $v0, $v0, 1  # len += 1
        addi $a0, $a0, 1  # str += 1
        j strlen_loop
    strlen_end:
        jr $ra # return 