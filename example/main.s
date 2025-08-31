	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_zmmul1p0"
	.file	"main.c"
	.text
	.globl	main                            # -- Begin function main
	.p2align	2
	.type	main,@function
main:                                   # @main
# %bb.0:
	addi	sp, sp, -64
	sw	ra, 60(sp)                      # 4-byte Folded Spill
	sw	s0, 56(sp)                      # 4-byte Folded Spill
	addi	s0, sp, 64
	li	a0, 0
	sw	a0, -52(s0)                     # 4-byte Folded Spill
	sw	a0, -12(s0)
	li	a1, 10
	sw	a1, -16(s0)
	sw	a0, -28(s0)
	sw	a0, -32(s0)
	sw	a0, -36(s0)
	li	a0, 1
	sw	a0, -40(s0)
	lui	a0, %hi(.L.str)
	addi	a0, a0, %lo(.L.str)
	call	printf
                                        # kill: def $x11 killed $x10
	lw	a0, -52(s0)                     # 4-byte Folded Reload
	sw	a0, -20(s0)
	j	.LBB0_1
.LBB0_1:                                # =>This Inner Loop Header: Depth=1
	lw	a0, -20(s0)
	lw	a1, -16(s0)
	bge	a0, a1, .LBB0_7
	j	.LBB0_2
.LBB0_2:                                #   in Loop: Header=BB0_1 Depth=1
	lw	a1, -20(s0)
	li	a0, 1
	blt	a0, a1, .LBB0_4
	j	.LBB0_3
.LBB0_3:                                #   in Loop: Header=BB0_1 Depth=1
	lw	a1, -20(s0)
	srai	a0, a1, 31
	sw	a1, -48(s0)
	sw	a0, -44(s0)
	j	.LBB0_5
.LBB0_4:                                #   in Loop: Header=BB0_1 Depth=1
	lw	a2, -32(s0)
	lw	a0, -28(s0)
	lw	a1, -40(s0)
	lw	a3, -36(s0)
	add	a0, a0, a3
	add	a1, a2, a1
	sltu	a2, a1, a2
	add	a0, a0, a2
	sw	a1, -48(s0)
	sw	a0, -44(s0)
	lw	a0, -40(s0)
	lw	a1, -36(s0)
	sw	a1, -28(s0)
	sw	a0, -32(s0)
	lw	a0, -48(s0)
	lw	a1, -44(s0)
	sw	a1, -36(s0)
	sw	a0, -40(s0)
	j	.LBB0_5
.LBB0_5:                                #   in Loop: Header=BB0_1 Depth=1
	lw	a1, -48(s0)
	lui	a0, %hi(.L.str.1)
	addi	a0, a0, %lo(.L.str.1)
	call	printf
	j	.LBB0_6
.LBB0_6:                                #   in Loop: Header=BB0_1 Depth=1
	lw	a0, -20(s0)
	addi	a0, a0, 1
	sw	a0, -20(s0)
	j	.LBB0_1
.LBB0_7:
	lui	a0, %hi(.L.str.2)
	addi	a0, a0, %lo(.L.str.2)
	call	printf
	li	a0, 0
	lw	ra, 60(sp)                      # 4-byte Folded Reload
	lw	s0, 56(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 64
	ret
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.type	.L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"Fibonacci Sequence: "
	.size	.L.str, 21

	.type	.L.str.1,@object                # @.str.1
.L.str.1:
	.asciz	"%d "
	.size	.L.str.1, 4

	.type	.L.str.2,@object                # @.str.2
.L.str.2:
	.asciz	"\n"
	.size	.L.str.2, 2

	.ident	"Homebrew clang version 20.1.8"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym printf
