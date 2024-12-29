.globl __start

.rodata
    division_by_zero: .string "division by zero"
    
.data
    JumpTable: .word L0, L1, L2, L3, L4, L5, L6

.text
__start:
    # Read first operand
    li a0, 5
    ecall
    mv s0, a0
    # Read operation
    li a0, 5
    ecall
    mv s1, a0
    # Read second operand
    li a0, 5
    ecall
    mv s2, a0

###################################
#  TODO: Develop your calculator  #
#                                 #
    la t0, JumpTable
    slli t1, s1, 2
    add t2, t1, t0
    lw t3, 0(t2)
    jr t3

L0: add s3, s0, s2
    j output
     
L1: sub s3, s0, s2
    j output
    
L2: mul s3, s0, s2
    j output
    
L3: beq s2, zero, division_by_zero_except
    div s3, s0, s2
    j output
    
L4: blt s0, s2, minA
    mv s3, s2
    j output

minA:
    mv s3, s0
    j output
    
L5: addi t0, zero, 2        # t0 = 2
    blt s0, t0, base        # A = 0,1
    mv a0, s2
    call pow
    mv s3, a1
    j output
    
base:
    mv s3, s0
    j output

pow:
    addi sp, sp, -8
    sw ra, 4(sp)
    sw a0, 0(sp)
    bgtz a0, elsepow     # n >= 1
    li a1, 1
    addi sp, sp, 8
    ret

elsepow:
    addi a0, a0, -1
    call pow
    mv t0, a1
    lw a0, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 8
    mul a1, s0, t0
    ret

L6: mv a0, s0
    call fact
    mv s3, a1
    j output

fact:
    addi sp, sp, -8
    sw ra, 4(sp)
    sw a0, 0(sp)
    addi t0, zero, 2        # t0 = 1
    bge a0, t0, elsefact    # n >= 2
    li a1, 1
    addi sp, sp, 8
    ret

elsefact:
    addi a0, a0, -1
    call fact
    mv t1, a1
    lw a0, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 8
    mul a1, a0, t1
    ret
    
###################################

output:
    # Output the result
    li a0, 1
    mv a1, s3
    ecall

exit:
    # Exit program(necessary)
    li a0, 10
    ecall

division_by_zero_except:
    li a0, 4
    la a1, division_by_zero
    ecall
    j exit
