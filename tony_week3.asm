.data
error_str: .asciiz "ERROR"    
arg1: .word 0
arg2: .word 0
op: .word 0

.globl main
.text
main:
    # First we check that the number of arguments is 3.
    li $t0, 3
    bne $t0, $a0, error
    
    # Then we load the first argument.
    lw $t0, 0($a1)
    sw $t0, arg1
    
    # If it starts with a 't', we test if it's 'true'.
    li $t0, 116
    lw $s0, arg1
    lb $t1, 0($s0)
    beq $t0, $t1, true_parse1
    
    #If it starts with an 'f', we test if it's 'false'.
    li $t0, 102
    beq $t0, $t1, false_parse1
    
    # If it doesn't start with either, it's an error!
    j error
    
    # Done parsing the first argument, time to parse the operation.
done_parsing1:
    # If it starts with an 'a', then we check if it's 'and'.
    li $t0, 97
    lw $s0, 4($a1)
    lb $t1, 0($s0)
    beq $t0, $t1, and_parsing
    
    # If it starts with an 'o', then we check if it's 'or'.
    li $t0, 111
    beq $t0, $t1, or_parsing
    
    # Otherwise, it's an error.
    j error
    
# Really should be labeled 'done_parsing_op', we forgot to change it when we added or!
done_parsing_and:
    # Same thing as when we parse the first true/false argument, but now we check the second argument. 
    li $t0, 116
    lw $s0, 8($a1)
    lb $t1, 0($s0)
    beq $t0, $t1, true_parse2
    
    li $t0, 102
    beq $t0, $t1, false_parse2
    
    j error

# Done parsing all of the arguments!
# arg1 and arg2 will have a 1 if 'true' and a 0 if 'false'.
# op will a 0 if it's 'and' and a 1 if it's 'or'.
done_parsing2:
    # Load both of the arguments and the operation.
    lw $t0, arg1
    lw $t1, arg2
    lw $t2, op
    beqz $t2, and_op
    j or_op
    
# Like we saw in the class, the result of the 'and' operation
# is just multiplying the argument values together!
and_op:
    mul $t2, $t0, $t1
    j print
    
# 'Or' was a bit harder, we had to add them and check if the result was greater than 0.
or_op:
    add $t2, $t0, $t1
    li $t3, 0
    bgt $t2, $t3, grtr
    j less
grtr:
    li $t2, 1
    j print
less:
    li $t2, 0
    j print

# Both operations put the answer in $t2, so we just print that register!
print:
    li $v0, 1
    move $a0, $t2
    syscall

    li $v0, 10
    syscall
    
###   
#  These are all the string comparisons we make. How could you generalize this to work with any string stored in a label?
#  You'd want to use a loop and go byte-by-byte, stop if the bytes aren't equal and continue until you find a null character!
###
true_parse1:
    li $t0, 114
    lb $t1, 1($s0)
    bne $t0, $t1, error
    li $t0, 117
    lb $t1, 2($s0)
    bne $t0, $t1, error
    li $t0, 101
    lb $t1, 3($s0)
    bne $t0, $t1, error
    li $t0, 0
    lb $t1, 4($s0)
    bne $t0, $t1, error
    
    li $t0, 1
    sw $t0, arg1
    j done_parsing1
    
false_parse1:
    li $t0, 97
    lb $t1, 1($s0)
    bne $t0, $t1, error
    li $t0, 108
    lb $t1, 2($s0)
    bne $t0, $t1, error
    li $t0, 115
    lb $t1, 3($s0)
    bne $t0, $t1, error
    li $t0, 101
    lb $t1, 4($s0)
    bne $t0, $t1, error
    li $t0, 0
    lb $t1, 5($s0)
    bne $t0, $t1, error

    li $t0, 0
    sw $t0, arg1
    j done_parsing1
    
true_parse2:
    li $t0, 114
    lb $t1, 1($s0)
    bne $t0, $t1, error
    li $t0, 117
    lb $t1, 2($s0)
    bne $t0, $t1, error
    li $t0, 101
    lb $t1, 3($s0)
    bne $t0, $t1, error
    li $t0, 0
    lb $t1, 4($s0)
    bne $t0, $t1, error
    
    li $t0, 1
    sw $t0, arg2
    j done_parsing2
    
false_parse2:
    li $t0, 97
    lb $t1, 1($s0)
    bne $t0, $t1, error
    li $t0, 108
    lb $t1, 2($s0)
    bne $t0, $t1, error
    li $t0, 115
    lb $t1, 3($s0)
    bne $t0, $t1, error
    li $t0, 101
    lb $t1, 4($s0)
    bne $t0, $t1, error
    li $t0, 0
    lb $t1, 5($s0)
    bne $t0, $t1, error

    li $t0, 0
    sw $t0, arg2
    j done_parsing2
    
and_parsing:
    li $t0, 110
    lb $t1, 1($s0)
    bne $t0, $t1, error
    li $t0, 100
    lb $t1, 2($s0)
    bne $t0, $t1, error
    li $t0, 0
    lb $t1, 3($s0)
    bne $t0, $t1, error
    
    li $t0, 0
    sw $t0, op
    
    j done_parsing_and
or_parsing:
    li $t0, 114
    lb $t1, 1($s0)
    bne $t0, $t1, error
    li $t0, 0
    lb $t1, 2($s0)
    bne $t0, $t1, error
    
    li $t0, 1
    sw $t0, op
    
    j done_parsing_and
    
error:
    li $v0, 4
    la $a0, error_str
    syscall
