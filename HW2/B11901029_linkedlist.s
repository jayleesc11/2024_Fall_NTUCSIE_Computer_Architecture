.globl	__start

.rodata
        msg: .asciiz "Empty!"
        newline: .asciiz "\n"
.text

push_front_list:             
        ### if(list == NULL)return; ###
        beqz    a0, LBB0_2
        ### save ra、s0 ###
        addi    sp, sp, -16
        sw      ra, 12(sp)                      
        sw      s0, 8(sp)                       
        sw      s1, 4(sp)                       
        mv      s1, a1
        mv      s0, a0
        ### node_t *new_node = (node_t*)sbrk(sizeof(*new_node)); ###
        li      a0, 8
        call    sbrk
        ### new_node->value = value; ###
        sw      s1, 0(a0)
        ### new_node->next = list->head; ###
        lw      a1, 0(s0)
        sw      a1, 4(a0)
        ### list->head = new_node; ###
        sw      a0, 0(s0)
LBB0_2:
        ### exit handling ###
        lw      ra, 12(sp)                      
        lw      s0, 8(sp)                       
        lw      s1, 4(sp)                       
        addi    sp, sp, 16
        ret
        
print_list:
############################################
#  TODO: Print out the linked list         #
#                                          #
        beqz    a0, return       # if (!cur) return;
        addi    sp, sp, -8
        sw      ra, 4(sp)
        sw      a0, 0(sp)
        
        # recursive
        lw      a0, 4(a0)        # a0 = cur->next
        call    print_list
        
        # print value
        lw      a0, 0(sp)        # a0 = cur
        lw      a0, 0(a0)        # a0 = cur->value
        call    print_int
        
        lw      ra, 4(sp)
        addi    sp, sp, 8
        ret
############################################
      
sort_list:
############################################
#  TODO: Sort the linked list              #
#                                          #
        beqz a0, return          # if (!head) return;
        mv t0, a0                # cur (t0) = head (a0)
        
outer_loop:
        beqz t0, return          # while (cur)
        lw t1, 4(t0)             # nxt (t1) = cur->next;
        li t2, 0                 # swapped (t2) = 0;
        
inner_loop:
        beqz t1, inner_done      # while (nxt)
        lw t3, 0(t0)             # cur->value
        lw t4, 0(t1)             # nxt->value
        ble t3, t4, no_swap      # if (cur->value > nxt->value) swap
        
        # swap
        sw t4, 0(t0)             # cur->value = nxt->value
        sw t3, 0(t1)             # nxt->value = cur->value
        li t2, 1                 # swapped = 1
     
no_swap:
        lw t1, 4(t1)             # nxt = nxt->next
        j inner_loop
        
inner_done:
        lw t0, 4(t0)             # cur = cur->next
        bnez t2, outer_loop      # if (swapped == 0) break;
        ret
        
return:
        ret
############################################

__start:
        ### save ra、s0 ###                                   
        addi    sp, sp, -16
        sw      ra, 12(sp)                      
        sw      s0, 8(sp)                                            
        ### read the numbers of the linked list ###
        call    read_int
        ### if(nums == 0) output "Empty!" ###
        beqz    a0, LBB2_2
        ### if(nums <= 0) exit
        mv      s0, a0
        blez    a0, exit
LBB2_1:                                
        call    read_int
        ### set push_front_list argument ###
        mv      a1, a0
        mv      a0, sp
        call    push_front_list
        addi    s0, s0, -1
        bnez    s0, LBB2_1
        lw      a0, 0(sp)
        j       LBB2_3
LBB2_2:
        call    print_str
        j       exit
LBB2_3:
        mv      s0, a0
        call    print_list
        call    print_newline
        mv      a0, s0
        call    sort_list
        mv      a0, s0
        call    print_list
exit:   
        ### exit handling ###
        li      a0, 0
        lw      ra, 12(sp)                      
        lw      s0, 8(sp)                       
        addi    sp, sp, 16
	li a0,	10
	ecall

read_int:
	li	a0, 5
	ecall
	jr	ra

sbrk:
	mv	a1, a0
	li	a0, 9
	ecall
	jr	ra
 
print_int:
	mv 	a1, a0
	li	a0, 1
	ecall
	li	a0, 11
	li	a1, ' '
	ecall
	jr	ra

print_str:
        li      a0, 4
        la      a1, msg
        ecall
        jr      ra

print_newline:
        li      a0, 4
        la      a1, newline
        ecall
        jr      ra                        