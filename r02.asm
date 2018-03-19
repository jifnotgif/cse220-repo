.data
numargs: .word 0
input_addr: .word 0
print_string: .asciiz "As a string: "
print_int: .asciiz "As an integer: "
print_hex: .asciiz "As hex: "
newline: .asciiz "\n"

.text
# Helper macro for accessing command line arguments via Label
.macro load_args
    sw $a0, numargs
    lw $t0, 0($a1)
    sw $t0, input_addr
.end_macro

.globl main
main:
	load_args()
	lw $t0, input_addr  # temporarily store input str

	la $a0, print_string
	li $v0, 4  # print string syscall
	syscall
	move $a0, $t0
	li $v0, 4
	syscall
	la $a0, newline
	li $v0, 4
	syscall

	# convert input to an int
	move $a0, $t0
	li $v0, 84  # atoi
	syscall
	move $t1, $v0  # v0 has result of atoi
	la $a0, print_int
	li $v0, 4
	syscall
	move $a0, $t1
	li $v0, 1  # print int
	syscall
	la $a0, newline
	li $v0, 4
	syscall

	la $a0, print_hex
	li $v0, 4
	syscall
	move $a0, $t1  # result of atoi
	li $v0, 34  # print in hex
	syscall

	li $v0, 10  # exit
	syscall
