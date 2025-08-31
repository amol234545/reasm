	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_zmmul1p0"
	.file	"main.c"
	.text
	.globl	fibonacci                       # -- Begin function fibonacci
	.p2align	2
	.type	fibonacci,@function
fibonacci:                              # @fibonacci
# %bb.0:
	addi	sp, sp, -32
	sw	ra, 28(sp)                      # 4-byte Folded Spill
	sw	s0, 24(sp)                      # 4-byte Folded Spill
	addi	s0, sp, 32
	sw	a0, -16(s0)
	lw	a1, -16(s0)
	li	a0, 0
	blt	a0, a1, .LBB0_2
	j	.LBB0_1
.LBB0_1:
	li	a0, 0
	sw	a0, -12(s0)
	j	.LBB0_5
.LBB0_2:
	lw	a0, -16(s0)
	li	a1, 1
	bne	a0, a1, .LBB0_4
	j	.LBB0_3
.LBB0_3:
	li	a0, 1
	sw	a0, -12(s0)
	j	.LBB0_5
.LBB0_4:
	lw	a0, -16(s0)
	addi	a0, a0, -1
	call	fibonacci
	sw	a0, -20(s0)                     # 4-byte Folded Spill
	lw	a0, -16(s0)
	addi	a0, a0, -2
	call	fibonacci
	mv	a1, a0
	lw	a0, -20(s0)                     # 4-byte Folded Reload
	add	a0, a0, a1
	sw	a0, -12(s0)
	j	.LBB0_5
.LBB0_5:
	lw	a0, -12(s0)
	lw	ra, 28(sp)                      # 4-byte Folded Reload
	lw	s0, 24(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 32
	ret
.Lfunc_end0:
	.size	fibonacci, .Lfunc_end0-fibonacci
                                        # -- End function
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
	sw	a0, -12(s0)
	li	a1, 12
	sw	a1, -16(s0)
	lw	a1, -16(s0)
	mv	a2, sp
	sw	a2, -20(s0)
	slli	a2, a1, 2
	addi	a2, a2, 15
	andi	a3, a2, -16
	mv	a2, sp
	sub	a2, a2, a3
	sw	a2, -36(s0)                     # 4-byte Folded Spill
	mv	sp, a2
	sw	a1, -24(s0)
	sw	a0, -28(s0)
	j	.LBB1_1
.LBB1_1:                                # =>This Inner Loop Header: Depth=1
	lw	a0, -28(s0)
	lw	a1, -16(s0)
	bge	a0, a1, .LBB1_4
	j	.LBB1_2
.LBB1_2:                                #   in Loop: Header=BB1_1 Depth=1
	lw	a0, -28(s0)
	call	fibonacci
	lw	a1, -36(s0)                     # 4-byte Folded Reload
	lw	a2, -28(s0)
	slli	a2, a2, 2
	add	a1, a1, a2
	sw	a0, 0(a1)
	j	.LBB1_3
.LBB1_3:                                #   in Loop: Header=BB1_1 Depth=1
	lw	a0, -28(s0)
	addi	a0, a0, 1
	sw	a0, -28(s0)
	j	.LBB1_1
.LBB1_4:
	li	a0, 0
	sw	a0, -32(s0)
	j	.LBB1_5
.LBB1_5:                                # =>This Inner Loop Header: Depth=1
	lw	a0, -32(s0)
	lw	a1, -16(s0)
	bge	a0, a1, .LBB1_8
	j	.LBB1_6
.LBB1_6:                                #   in Loop: Header=BB1_5 Depth=1
	j	.LBB1_7
.LBB1_7:                                #   in Loop: Header=BB1_5 Depth=1
	lw	a0, -32(s0)
	addi	a0, a0, 1
	sw	a0, -32(s0)
	j	.LBB1_5
.LBB1_8:
	li	a0, 0
	sw	a0, -12(s0)
	lw	a0, -20(s0)
	mv	sp, a0
	lw	a0, -12(s0)
	addi	sp, s0, -48
	lw	ra, 44(sp)                      # 4-byte Folded Reload
	lw	s0, 40(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 48
	ret
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.ident	"Homebrew clang version 20.1.8"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym fibonacci
