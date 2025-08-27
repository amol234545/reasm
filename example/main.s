	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_a2p1_c2p0_zmmul1p0_zaamo1p0_zalrsc1p0"
	.file	"main.c"
	.text
	.globl	main                            # -- Begin function main
	.p2align	1
	.type	main,@function
main:                                   # @main
# %bb.0:
	addi	sp, sp, -32
	sw	ra, 28(sp)                      # 4-byte Folded Spill
	sw	s0, 24(sp)                      # 4-byte Folded Spill
	addi	s0, sp, 32
	li	a0, 0
	sw	a0, -20(s0)                     # 4-byte Folded Spill
	sw	a0, -12(s0)
	sw	a0, -16(s0)
	lw	a0, -16(s0)
	addi	a0, a0, 5
	sw	a0, -16(s0)
	lw	a0, -16(s0)
	addi	a0, a0, -3
	sw	a0, -16(s0)
	lw	a0, -16(s0)
	addi	a1, a0, 2
	lui	a0, %hi(.L.str)
	addi	a0, a0, %lo(.L.str)
	call	printf
                                        # kill: def $x11 killed $x10
	lw	a0, -20(s0)                     # 4-byte Folded Reload
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
	.asciz	"Hello, world! %d"
	.size	.L.str, 17

	.ident	"Homebrew clang version 20.1.8"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym printf
