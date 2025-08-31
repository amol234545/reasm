	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_zmmul1p0"
	.file	"main.c"
	.text
	.globl	main                            # -- Begin function main
	.p2align	2
	.type	main,@function
main:                                   # @main
# %bb.0:
	addi	sp, sp, -144
	sw	ra, 140(sp)                     # 4-byte Folded Spill
	sw	s0, 136(sp)                     # 4-byte Folded Spill
	addi	s0, sp, 144
	li	a0, 0
	sw	a0, -140(s0)                    # 4-byte Folded Spill
	sw	a0, -12(s0)
	lui	a1, %hi(.L__const.main.matrix1)
	addi	a1, a1, %lo(.L__const.main.matrix1)
	addi	a0, s0, -48
	li	a2, 36
	sw	a2, -144(s0)                    # 4-byte Folded Spill
	call	memcpy
	lw	a2, -144(s0)                    # 4-byte Folded Reload
	lui	a1, %hi(.L__const.main.matrix2)
	addi	a1, a1, %lo(.L__const.main.matrix2)
	addi	a0, s0, -84
	call	memcpy
                                        # kill: def $x11 killed $x10
	lw	a0, -140(s0)                    # 4-byte Folded Reload
	sw	a0, -124(s0)
	j	.LBB0_1
.LBB0_1:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_3 Depth 2
	lw	a1, -124(s0)
	li	a0, 2
	blt	a0, a1, .LBB0_8
	j	.LBB0_2
.LBB0_2:                                #   in Loop: Header=BB0_1 Depth=1
	li	a0, 0
	sw	a0, -128(s0)
	j	.LBB0_3
.LBB0_3:                                #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	lw	a1, -128(s0)
	li	a0, 2
	blt	a0, a1, .LBB0_6
	j	.LBB0_4
.LBB0_4:                                #   in Loop: Header=BB0_3 Depth=2
	lw	a0, -124(s0)
	slli	a1, a0, 2
	slli	a0, a0, 4
	sub	a3, a0, a1
	addi	a0, s0, -48
	add	a0, a0, a3
	lw	a1, -128(s0)
	slli	a2, a1, 2
	add	a0, a0, a2
	lw	a0, 0(a0)
	addi	a1, s0, -84
	add	a1, a1, a3
	add	a1, a1, a2
	lw	a1, 0(a1)
	add	a0, a0, a1
	addi	a1, s0, -120
	add	a1, a1, a3
	add	a1, a1, a2
	sw	a0, 0(a1)
	j	.LBB0_5
.LBB0_5:                                #   in Loop: Header=BB0_3 Depth=2
	lw	a0, -128(s0)
	addi	a0, a0, 1
	sw	a0, -128(s0)
	j	.LBB0_3
.LBB0_6:                                #   in Loop: Header=BB0_1 Depth=1
	j	.LBB0_7
.LBB0_7:                                #   in Loop: Header=BB0_1 Depth=1
	lw	a0, -124(s0)
	addi	a0, a0, 1
	sw	a0, -124(s0)
	j	.LBB0_1
.LBB0_8:
	lui	a0, %hi(.L.str)
	addi	a0, a0, %lo(.L.str)
	call	printf
	li	a0, 0
	sw	a0, -132(s0)
	j	.LBB0_9
.LBB0_9:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_11 Depth 2
	lw	a1, -132(s0)
	li	a0, 2
	blt	a0, a1, .LBB0_16
	j	.LBB0_10
.LBB0_10:                               #   in Loop: Header=BB0_9 Depth=1
	li	a0, 0
	sw	a0, -136(s0)
	j	.LBB0_11
.LBB0_11:                               #   Parent Loop BB0_9 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	lw	a1, -136(s0)
	li	a0, 2
	blt	a0, a1, .LBB0_14
	j	.LBB0_12
.LBB0_12:                               #   in Loop: Header=BB0_11 Depth=2
	lw	a0, -132(s0)
	slli	a1, a0, 2
	slli	a0, a0, 4
	sub	a1, a0, a1
	addi	a0, s0, -120
	add	a0, a0, a1
	lw	a1, -136(s0)
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a1, 0(a0)
	lui	a0, %hi(.L.str.1)
	addi	a0, a0, %lo(.L.str.1)
	call	printf
	j	.LBB0_13
.LBB0_13:                               #   in Loop: Header=BB0_11 Depth=2
	lw	a0, -136(s0)
	addi	a0, a0, 1
	sw	a0, -136(s0)
	j	.LBB0_11
.LBB0_14:                               #   in Loop: Header=BB0_9 Depth=1
	j	.LBB0_15
.LBB0_15:                               #   in Loop: Header=BB0_9 Depth=1
	lw	a0, -132(s0)
	addi	a0, a0, 1
	sw	a0, -132(s0)
	j	.LBB0_9
.LBB0_16:
	li	a0, 0
	lw	ra, 140(sp)                     # 4-byte Folded Reload
	lw	s0, 136(sp)                     # 4-byte Folded Reload
	addi	sp, sp, 144
	ret
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.type	.L__const.main.matrix1,@object  # @__const.main.matrix1
	.section	.rodata,"a",@progbits
	.p2align	2, 0x0
.L__const.main.matrix1:
	.word	1                               # 0x1
	.word	2                               # 0x2
	.word	3                               # 0x3
	.word	4                               # 0x4
	.word	5                               # 0x5
	.word	6                               # 0x6
	.word	7                               # 0x7
	.word	8                               # 0x8
	.word	9                               # 0x9
	.size	.L__const.main.matrix1, 36

	.type	.L__const.main.matrix2,@object  # @__const.main.matrix2
	.p2align	2, 0x0
.L__const.main.matrix2:
	.word	9                               # 0x9
	.word	8                               # 0x8
	.word	7                               # 0x7
	.word	6                               # 0x6
	.word	6                               # 0x6
	.word	4                               # 0x4
	.word	3                               # 0x3
	.word	2                               # 0x2
	.word	1                               # 0x1
	.size	.L__const.main.matrix2, 36

	.type	.L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"Result of matrix addition:"
	.size	.L.str, 27

	.type	.L.str.1,@object                # @.str.1
.L.str.1:
	.asciz	"%d"
	.size	.L.str.1, 3

	.ident	"Homebrew clang version 20.1.8"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym printf
