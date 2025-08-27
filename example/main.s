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
	lui	a0, %hi(.L.str)
	addi	a0, a0, %lo(.L.str)
	call	printf
	lw	a0, -16(s0)
	addi	a2, a0, 2
	lui	a0, %hi(.L.str.1)
	addi	a0, a0, %lo(.L.str.1)
	lui	a1, %hi(.L.str.2)
	addi	a1, a1, %lo(.L.str.2)
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
	.asciz	"Hello, world! "
	.size	.L.str, 15

	.type	.L.str.1,@object                # @.str.1
.L.str.1:
	.asciz	"%s: %d"
	.size	.L.str.1, 7

	.type	.L.str.2,@object                # @.str.2
.L.str.2:
	.asciz	"Hi!"
	.size	.L.str.2, 4

	.ident	"Homebrew clang version 20.1.8"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym printf
