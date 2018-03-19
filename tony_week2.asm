.data 
Number: .asciiz "124"

.globl main
.text
main:

    # The following code implements ATOI in two different ways.
    # ATOI is a function that takes in an ascii string and converts it to an integer.

    li $t0, 0		# Stores initial i value.
    la $t8, Number	# Store the address of the number.
    la $t9, Number	# Also store the address of the number.
    
    loop1:
        lb $t1, 0($t8)		# Load the next character in the string.
        addi $t8, $t8, 1	# Move to the next character.
        beq $t1, 0, end_loop1	# Exit the loop if the character is the null terminator
        j loop1 		# Go back to the beginning of the loop.
    end_loop1:
    
    # Is there a better way to loop through this? Someone mentioned maybe switching where
    # the break statement is. Try it out.
    
    sub $t8, $t8, $t9	# Get the difference between the starting and ending addresses.
    addi $t8, $t8, -2	# Because we count the null terminator, we need to subtract TWO.
    
    li $t2, 0			# Initialize a counter.
    loop2:
        lb $t1, 0($t9)		# Load the first byte of the string AGAIN.
        addi $t1, $t1, -48	# Subtract 48 from the character we loaded.
    	# Again, why do we need to subtract this 48? Look at the ascii table!
    
    	# The following code we used to calculate the 10^X that we need to multiply by.
        li $t4, 10		# Store a 10 that we'll be using later.
        move $t5, $t8		# Copy the length of the string to $t5.
        li $t6, 1		# Start a sum at 1.
        loop3:
            beqz $t5, end_loop3	# Break if the length is 0.
            mult $t6, $t4	# Multiply the sum by 10,
            mflo $t6		# and store it in $t6.
            addi $t5, $t5, -1	# Subtract 1 from the total length.
            j loop3
        end_loop3:
    
    	# Multiply the byte by the number we just calculated.
    	# Then add it to the total sum.
        mult $t1, $t6
        mflo $t1
        add $t2, $t2, $t1
    
    	# Break if the byte is a 0.
    	# Otherwise, move forwards in the string and subtract 1 from the length. 
    	# What else are we using $t8 for? Why do we subtract 1? 
        beq $t8, 0, end_loop2
        addi $t8, $t8, -1
        addi $t9, $t9, 1
        j loop2
    end_loop2:
    
    # Print our result!
    move $a0, $t2
    li $v0, 1
    syscall
    
    # Although we didn't do this in recitation, here is the "better" way to do it.
    # The above way was a much better exercise though!
    la $t0, Number
    li $t1, 0
    li $t3, 10
    loop:
        lb $t2, 0($t0)
        beqz $t2, end_loop
        addi $t2, $t2, -48
        add $t1, $t1, $t2
        mul $t1, $t1, $t3
        addi $t0, $t0, 1
        j loop
    end_loop:
    div $t1, $t3
    mflo $t1
    
    move $a0, $t1
    li $v0, 1
    syscall
    
