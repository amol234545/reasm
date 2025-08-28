	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_a2p1_c2p0_zmmul1p0_zaamo1p0_zalrsc1p0"
	.file	"main.c"
	.text
	.globl	main                            # -- Begin function main
	.p2align	1
	.type	main,@function
main:                                   # @main
# %bb.0:
	addi	sp, sp, -1072
	sw	ra, 1068(sp)                    # 4-byte Folded Spill
	sw	s0, 1064(sp)                    # 4-byte Folded Spill
	addi	s0, sp, 1072
	li	a0, 0
	sw	a0, -16(s0)
	li	a1, 5
	sw	a1, -28(s0)
	sw	a0, -1056(s0)
	li	a0, 1
	sw	a0, -20(s0)
	j	.LBB0_1
.LBB0_1:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_3 Depth 2
	lw	a1, -20(s0)
	lw	a0, -28(s0)
	blt	a0, a1, .LBB0_8
	j	.LBB0_2
.LBB0_2:                                #   in Loop: Header=BB0_1 Depth=1
	li	a0, 1
	sw	a0, -24(s0)
	j	.LBB0_3
.LBB0_3:                                #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	lw	a1, -24(s0)
	lw	a0, -20(s0)
	blt	a0, a1, .LBB0_6
	j	.LBB0_4
.LBB0_4:                                #   in Loop: Header=BB0_3 Depth=2
	lw	a0, -24(s0)
	addi	a0, a0, 48
	lw	a2, -1056(s0)
	addi	a1, a2, 1
	sw	a1, -1056(s0)
	addi	a1, s0, -1052
	add	a1, a1, a2
	sb	a0, 0(a1)
	j	.LBB0_5
.LBB0_5:                                #   in Loop: Header=BB0_3 Depth=2
	lw	a0, -24(s0)
	addi	a0, a0, 1
	sw	a0, -24(s0)
	j	.LBB0_3
.LBB0_6:                                #   in Loop: Header=BB0_1 Depth=1
	lw	a1, -1056(s0)
	addi	a0, a1, 1
	sw	a0, -1056(s0)
	addi	a0, s0, -1052
	add	a1, a1, a0
	li	a0, 10
	sb	a0, 0(a1)
	j	.LBB0_7
.LBB0_7:                                #   in Loop: Header=BB0_1 Depth=1
	lw	a0, -20(s0)
	addi	a0, a0, 1
	sw	a0, -20(s0)
	j	.LBB0_1
.LBB0_8:
	lw	a1, -1056(s0)
	addi	a0, s0, -1052
	add	a2, a0, a1
	li	a1, 0
	sw	a1, -1060(s0)                   # 4-byte Folded Spill
	sb	a1, 0(a2)
	call	print
	lw	a0, -1060(s0)                   # 4-byte Folded Reload
	lw	ra, 1068(sp)                    # 4-byte Folded Reload
	lw	s0, 1064(sp)                    # 4-byte Folded Reload
	addi	sp, sp, 1072
	ret
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.ident	"Homebrew clang version 20.1.8"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym print
