.data
n: .word 5
arr: .word 5, 14, 7, 1, 8

.text

.globl main

main: 
lw $s0, n           #value of n
la $t1, arr         #base address of arr
sub $t0, $s0, 1     #n-1

move $s1, $zero     #initialize with zero -- i

outer_loop:
sub $t2, $t0, $s1   #t2 = n-i-1
move $s2, $zero     #initialize with zero -- j

inner_loop:
sll $t5, $s2, 2
addi $t6, $t5, 4
add $t7, $t1, $t5
add $t8, $t1, $t6   
lw $s4, 0($t7)      #s4 = arr[j]
lw $s5, 0($t8)      #s5 = arr[j+1]
slt $s6, $s4, $s5   #s6 = 1 if s4 < s5
beq $s6, 1, inner_loop_condition
sw $s5, 0($t7)
sw $s4, 0($t8)

inner_loop_condition:
addi $s2, $s2, 1        #j++
slt $t3, $s2, $t2       #t3 = 1 if j < n-i -1
bne $t3,1,exit_inner_loop
j inner_loop

exit_inner_loop:

outer_loop_condition:
addi $s1, $s1, 1        #i++
slt $t4, $s1, $t0       #t4 = 1 if i < n-1
bne $t4,1,exit_outer_loop
j outer_loop

exit_outer_loop:

# printing
printing_data:
move $s3,$zero      #storing i
print_loop:
sll $s4,$s3,2
add $t3,$s4,$t1
lw $a0, 0($t3)
li $v0,1
syscall
# loop condition
addi $s3, $s3, 1
slt	$s6, $s3, $s0		
bne $s6,0,print_loop

li $v0,10
syscall
.end