########## Begin of Set function ########
set:
  add $t0, $zero, $zero                # i=0
  Loop: sll $t1, $t0, 2                # 4i
        add $t2, $a0, $t1              # a[i]
		sw  $a2, 0($t2)                # a[i++] = v
		addi $t0, $t0, 1               # i++
		slt $t3, $t0, $a1
		beq $t3, $zero, exit
		j Loop
  exit: add $v0, $t0, $zero
        jr $ra
########## End of Set function ##########