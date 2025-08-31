	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_zmmul1p0"
	.file	"main.c"
	.text
	.globl	main                            # -- Begin function main
	.p2align	2
	.type	main,@function
main:                                   # @main
# %bb.0:
	addi	sp, sp, -48
	sw	ra, 44(sp)                      # 4-byte Folded Spill
	sw	s0, 40(sp)                      # 4-byte Folded Spill
	addi	s0, sp, 48
	li	a0, 0
	sw	a0, -28(s0)                     # 4-byte Folded Spill
	sw	a0, -12(s0)
	lui	a0, 263680
	sw	a0, -16(s0)
	lui	a0, 262144
	sw	a0, -20(s0)
	lw	a0, -16(s0)
	sw	a0, -44(s0)                     # 4-byte Folded Spill
	lw	a1, -20(s0)
	mv	a0, a1
	call	__mulsf3
	lw	a1, -44(s0)                     # 4-byte Folded Reload
	sw	a0, -40(s0)                     # 4-byte Folded Spill
	mv	a0, a1
	call	__mulsf3
	lw	a1, -40(s0)                     # 4-byte Folded Reload
	call	__addsf3
	sw	a0, -24(s0)
	lw	a0, -16(s0)
	call	__fixsfsi
	sw	a0, -36(s0)                     # 4-byte Folded Spill
	lw	a0, -20(s0)
	call	__fixsfsi
	sw	a0, -32(s0)                     # 4-byte Folded Spill
	lw	a0, -24(s0)
	call	__fixsfsi
	lw	a1, -36(s0)                     # 4-byte Folded Reload
	lw	a2, -32(s0)                     # 4-byte Folded Reload
	mv	a3, a0
	lui	a0, %hi(.L.str)
	addi	a0, a0, %lo(.L.str)
	call	printf
	lw	a0, -28(s0)                     # 4-byte Folded Reload
	lw	ra, 44(sp)                      # 4-byte Folded Reload
	lw	s0, 40(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 48
	ret
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.type	.L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"Square of %d + square of %d = %d\n"
	.size	.L.str, 34

	.ident	"Homebrew clang version 20.1.8"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym printf
