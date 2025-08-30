	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_zmmul1p0"
	.file	"main.c"
	.text
	.globl	main                            # -- Begin function main
	.p2align	2
	.type	main,@function
main:                                   # @main
# %bb.0:
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	sw	s0, 8(sp)                       # 4-byte Folded Spill
	lui	s0, %hi(.L.str)
	addi	s0, s0, %lo(.L.str)
	li	a1, 10
	li	a2, 20
	mv	a0, s0
	call	printf
	lui	a0, %hi(.L.str.1)
	addi	a0, a0, %lo(.L.str.1)
	li	a1, 10
	li	a2, 20
	call	printf
	lui	a0, %hi(.L.str.2)
	addi	a0, a0, %lo(.L.str.2)
	call	printf
	li	a1, 15
	li	a2, 40
	mv	a0, s0
	call	printf
	lui	a0, %hi(.L.str.3)
	addi	a0, a0, %lo(.L.str.3)
	call	printf
	lui	s0, %hi(.L.str.4)
	addi	s0, s0, %lo(.L.str.4)
	li	a2, 1
	li	a4, 1
	mv	a0, s0
	li	a1, 0
	li	a3, 0
	call	printf
	li	a1, 1
	li	a2, 2
	li	a3, 1
	li	a4, 2
	mv	a0, s0
	call	printf
	li	a1, 2
	li	a2, 3
	li	a3, 2
	li	a4, 3
	mv	a0, s0
	call	printf
	li	a1, 3
	li	a2, 4
	li	a3, 3
	li	a4, 4
	mv	a0, s0
	call	printf
	li	a1, 4
	li	a2, 5
	li	a3, 4
	li	a4, 5
	mv	a0, s0
	call	printf
	li	a0, 0
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	lw	s0, 8(sp)                       # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.type	.L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"a = %d, b = %d\n"
	.size	.L.str, 16

	.type	.L.str.1,@object                # @.str.1
.L.str.1:
	.asciz	"*p = %d, *q = %d\n"
	.size	.L.str.1, 18

	.type	.L.str.2,@object                # @.str.2
.L.str.2:
	.asciz	"After modification:\n"
	.size	.L.str.2, 21

	.type	.L.str.3,@object                # @.str.3
.L.str.3:
	.asciz	"Array elements using pointer:\n"
	.size	.L.str.3, 31

	.type	.L.str.4,@object                # @.str.4
.L.str.4:
	.asciz	"arr[%d] = %d, *(r+%d) = %d\n"
	.size	.L.str.4, 28

	.ident	"Homebrew clang version 20.1.8"
	.section	".note.GNU-stack","",@progbits
	.addrsig
