	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_a2p1_c2p0_zmmul1p0_zaamo1p0_zalrsc1p0"
	.file	"main.c"
	.text
	.globl	is_prime                        # -- Begin function is_prime
	.p2align	1
	.type	is_prime,@function
is_prime:                               # @is_prime
# %bb.0:
	addi	sp, sp, -32
	sw	ra, 28(sp)                      # 4-byte Folded Spill
	sw	s0, 24(sp)                      # 4-byte Folded Spill
	addi	s0, sp, 32
	sw	a0, -16(s0)
	lw	a1, -16(s0)
	li	a0, 1
	blt	a0, a1, .LBB0_2
	j	.LBB0_1
.LBB0_1:
	li	a0, 0
	sw	a0, -12(s0)
	j	.LBB0_9
.LBB0_2:
	li	a0, 2
	sw	a0, -20(s0)
	j	.LBB0_3
.LBB0_3:                                # =>This Inner Loop Header: Depth=1
	lw	a0, -20(s0)
	mul	a1, a0, a0
	lw	a0, -16(s0)
	blt	a0, a1, .LBB0_8
	j	.LBB0_4
.LBB0_4:                                #   in Loop: Header=BB0_3 Depth=1
	lw	a0, -16(s0)
	lw	a1, -20(s0)
	rem	a0, a0, a1
	bnez	a0, .LBB0_6
	j	.LBB0_5
.LBB0_5:
	li	a0, 0
	sw	a0, -12(s0)
	j	.LBB0_9
.LBB0_6:                                #   in Loop: Header=BB0_3 Depth=1
	j	.LBB0_7
.LBB0_7:                                #   in Loop: Header=BB0_3 Depth=1
	lw	a0, -20(s0)
	addi	a0, a0, 1
	sw	a0, -20(s0)
	j	.LBB0_3
.LBB0_8:
	li	a0, 1
	sw	a0, -12(s0)
	j	.LBB0_9
.LBB0_9:
	lw	a0, -12(s0)
	lw	ra, 28(sp)                      # 4-byte Folded Reload
	lw	s0, 24(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 32
	ret
.Lfunc_end0:
	.size	is_prime, .Lfunc_end0-is_prime
                                        # -- End function
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
	sw	a0, -12(s0)
	li	a0, 100
	sw	a0, -16(s0)
	li	a0, 1
	sw	a0, -20(s0)
	j	.LBB1_1
.LBB1_1:                                # =>This Inner Loop Header: Depth=1
	lw	a1, -20(s0)
	lw	a0, -16(s0)
	blt	a0, a1, .LBB1_7
	j	.LBB1_2
.LBB1_2:                                #   in Loop: Header=BB1_1 Depth=1
	lw	a0, -20(s0)
	call	is_prime
	beqz	a0, .LBB1_4
	j	.LBB1_3
.LBB1_3:                                #   in Loop: Header=BB1_1 Depth=1
	lw	a1, -20(s0)
	lui	a0, %hi(.L.str)
	addi	a0, a0, %lo(.L.str)
	call	printf
	j	.LBB1_5
.LBB1_4:                                #   in Loop: Header=BB1_1 Depth=1
	lw	a1, -20(s0)
	lui	a0, %hi(.L.str.1)
	addi	a0, a0, %lo(.L.str.1)
	call	printf
	j	.LBB1_5
.LBB1_5:                                #   in Loop: Header=BB1_1 Depth=1
	j	.LBB1_6
.LBB1_6:                                #   in Loop: Header=BB1_1 Depth=1
	lw	a0, -20(s0)
	addi	a0, a0, 1
	sw	a0, -20(s0)
	j	.LBB1_1
.LBB1_7:
	li	a0, 0
	lw	ra, 28(sp)                      # 4-byte Folded Reload
	lw	s0, 24(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 32
	ret
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.type	.L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"PRIME: %d"
	.size	.L.str, 10

	.type	.L.str.1,@object                # @.str.1
.L.str.1:
	.asciz	"%d"
	.size	.L.str.1, 3

	.ident	"Homebrew clang version 20.1.8"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym is_prime
	.addrsig_sym printf
