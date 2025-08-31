	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_zmmul1p0"
	.file	"main.c"
	.text
	.globl	main                            # -- Begin function main
	.p2align	2
	.type	main,@function
main:                                   # @main
# %bb.0:
	addi	sp, sp, -32
	sw	ra, 28(sp)                      # 4-byte Folded Spill
	sw	s0, 24(sp)                      # 4-byte Folded Spill
	addi	s0, sp, 32
	li	a0, 0
	sw	a0, -28(s0)                     # 4-byte Folded Spill
	sw	a0, -12(s0)
	lui	a0, 266752
	sw	a0, -16(s0)
	lui	a0, 268800
	sw	a0, -20(s0)
	lw	a0, -16(s0)
	lw	a1, -20(s0)
	call	__addsf3
	sw	a0, -24(s0)
	lw	a0, -16(s0)
	call	__extendsfdf2
	mv	a2, a0
	mv	a3, a1
	lui	a0, %hi(.L.str)
	addi	a0, a0, %lo(.L.str)
	call	printf
	lw	a0, -20(s0)
	call	__extendsfdf2
	mv	a2, a0
	mv	a3, a1
	lui	a0, %hi(.L.str.1)
	addi	a0, a0, %lo(.L.str.1)
	call	printf
	lw	a0, -24(s0)
	call	__extendsfdf2
	mv	a2, a0
	mv	a3, a1
	lui	a0, %hi(.L.str.2)
	addi	a0, a0, %lo(.L.str.2)
	call	printf
	lw	a0, -28(s0)                     # 4-byte Folded Reload
	lw	ra, 28(sp)                      # 4-byte Folded Reload
	lw	s0, 24(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 32
	ret
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.type	.L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"x = %f\n"
	.size	.L.str, 8

	.type	.L.str.1,@object                # @.str.1
.L.str.1:
	.asciz	"y = %f\n"
	.size	.L.str.1, 8

	.type	.L.str.2,@object                # @.str.2
.L.str.2:
	.asciz	"z = %f\n"
	.size	.L.str.2, 8

	.ident	"Homebrew clang version 20.1.8"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym printf
