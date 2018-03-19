## count.asm - count the occurences of a specific
## character in string "str".
## Indexed addressing used to access array elements.
##
##	t0 - holds each byte from string in turn
##	t1 - index into array
##	t2 - count of occurences
##	t3 - hold the character to count
##

#################################################################
#								#
#			text segment				#
#								#
#################################################################

	.text
	.globl main
main:
	li $t1,0	# $t1 will be the array index
	li $t2,0	# $t2 will be the counter
	lb $t3,char	# and $t3 will hold the char

loop:	
	lb $t0,str($t1)	# fetch next char
	beqz $t0,strEnd # if it's a null, exit loop
	bne $t0,$t3,con	# not null; same as char?
	addi $t2,$t2,1	# yes, incrememt counter
con:	
	addi $t1,$t1,1	# increase inde
	j loop 			# and continue
strEnd:
	la $a0,ans		# system call to print
	li $v0,4		# cut a message
	syscall

	move $a0,$t2	# system call to print
	li $v0,1		# out the count worked out
	syscall

	la $a0,end1		# syscall call to print
	li $v0,4		# out a newline
	syscall

	li $v0,10
	syscall		# au revoir...

#################################################################
#								#
#			data segment				#
#								#
#################################################################

	.data
str:	.asciiz "abceebceebeebbacacb"
char:	.asciiz "z"
ans:	.asciiz "Count is "
end1:	.asciiz "\n"

##
## end of file count.asm
