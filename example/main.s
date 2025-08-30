	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_zmmul1p0"
	.file	"main.c"
	.text
	.globl	factorial                       # -- Begin function factorial
	.p2align	2
	.type	factorial,@function
factorial:                              # @factorial
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
	li	a0, 10
	sw	a0, -12(s0)
	j	.LBB0_9
.LBB0_2:
	li	a0, 1
	sw	a0, -20(s0)
	lw	a0, -16(s0)
	sw	a0, -24(s0)
	j	.LBB0_3
.LBB0_3:                                # =>This Inner Loop Header: Depth=1
	lw	a1, -24(s0)
	li	a0, 0
	bge	a0, a1, .LBB0_8
	j	.LBB0_4
.LBB0_4:                                #   in Loop: Header=BB0_3 Depth=1
	lw	a1, -24(s0)
	lw	a0, -20(s0)
	mul	a0, a0, a1
	sw	a0, -20(s0)
	lw	a0, -20(s0)
	srli	a1, a0, 31
	add	a1, a0, a1
	andi	a1, a1, -2
	sub	a0, a0, a1
	bnez	a0, .LBB0_6
	j	.LBB0_5
.LBB0_5:                                #   in Loop: Header=BB0_3 Depth=1
	lw	a1, -24(s0)
	lw	a2, -20(s0)
	lui	a0, %hi(.L.str)
	addi	a0, a0, %lo(.L.str)
	call	printf
	j	.LBB0_7
.LBB0_6:                                #   in Loop: Header=BB0_3 Depth=1
	lw	a1, -24(s0)
	lw	a2, -20(s0)
	lui	a0, %hi(.L.str.1)
	addi	a0, a0, %lo(.L.str.1)
	call	printf
	j	.LBB0_7
.LBB0_7:                                #   in Loop: Header=BB0_3 Depth=1
	lw	a0, -24(s0)
	addi	a0, a0, -1
	sw	a0, -24(s0)
	j	.LBB0_3
.LBB0_8:
	lw	a0, -20(s0)
	sw	a0, -12(s0)
	j	.LBB0_9
.LBB0_9:
	lw	a0, -12(s0)
	lw	ra, 28(sp)                      # 4-byte Folded Reload
	lw	s0, 24(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 32
	ret
.Lfunc_end0:
	.size	factorial, .Lfunc_end0-factorial
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
	li	a1, 6
	sw	a1, -16(s0)
	sw	a0, -20(s0)
	li	a1, -5
	sw	a1, -24(s0)
	li	a1, 4
	sw	a1, -28(s0)
	li	a1, 3
	sw	a1, -32(s0)
	li	a1, 5
	sw	a1, -36(s0)
	sw	a0, -40(s0)
	j	.LBB1_1
.LBB1_1:                                # =>This Inner Loop Header: Depth=1
	lw	a0, -40(s0)
	lw	a1, -36(s0)
	bge	a0, a1, .LBB1_4
	j	.LBB1_2
.LBB1_2:                                #   in Loop: Header=BB1_1 Depth=1
	lw	a0, -40(s0)
	slli	a1, a0, 2
	addi	a0, s0, -32
	sw	a0, -44(s0)                     # 4-byte Folded Spill
	add	a0, a0, a1
	lw	a1, 0(a0)
	lui	a0, %hi(.L.str.2)
	addi	a0, a0, %lo(.L.str.2)
	call	printf
	lw	a0, -44(s0)                     # 4-byte Folded Reload
	lw	a1, -40(s0)
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a0, 0(a0)
	call	factorial
	lui	a0, %hi(.L.str.3)
	addi	a0, a0, %lo(.L.str.3)
	call	printf
	j	.LBB1_3
.LBB1_3:                                #   in Loop: Header=BB1_1 Depth=1
	lw	a0, -40(s0)
	addi	a0, a0, 1
	sw	a0, -40(s0)
	j	.LBB1_1
.LBB1_4:
	li	a0, 0
	lw	ra, 44(sp)                      # 4-byte Folded Reload
	lw	s0, 40(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 48
	ret
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.type	.L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"%d! = %d (even)"
	.size	.L.str, 16

	.type	.L.str.1,@object                # @.str.1
.L.str.1:
	.asciz	"%d! = %d (odd)"
	.size	.L.str.1, 15

	.type	.L__const.main.numbers,@object  # @__const.main.numbers
	.section	.rodata,"a",@progbits
	.p2align	2, 0x0
.L__const.main.numbers:
	.word	3                               # 0x3
	.word	4                               # 0x4
	.word	4294967291                      # 0xfffffffb
	.word	0                               # 0x0
	.word	6                               # 0x6
	.size	.L__const.main.numbers, 20

	.type	.L.str.2,@object                # @.str.2
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str.2:
	.asciz	"Computing factorial(%d)"
	.size	.L.str.2, 24

	.type	.L.str.3,@object                # @.str.3
.L.str.3:
	.asciz	"----"
	.size	.L.str.3, 5

	.ident	"Homebrew clang version 20.1.8"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym factorial
	.addrsig_sym printf
