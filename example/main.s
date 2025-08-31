	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_zmmul1p0"
	.file	"main.c"
	.text
	.globl	main                            # -- Begin function main
	.p2align	2
	.type	main,@function
main:                                   # @main
# %bb.0:
	addi	sp, sp, -160
	sw	ra, 156(sp)                     # 4-byte Folded Spill
	sw	s0, 152(sp)                     # 4-byte Folded Spill
	addi	s0, sp, 160
	li	a0, 0
	sw	a0, -152(s0)                    # 4-byte Folded Spill
	sw	a0, -12(s0)
	sw	a0, -80(s0)
	sw	a0, -84(s0)
	sw	a0, -88(s0)
	sw	a0, -92(s0)
	sw	a0, -96(s0)
	sw	a0, -100(s0)
	sw	a0, -104(s0)
	sw	a0, -108(s0)
	sw	a0, -112(s0)
	sw	a0, -116(s0)
	li	a1, 1
	sw	a1, -120(s0)
	sw	a0, -124(s0)
	j	.LBB0_1
.LBB0_1:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_3 Depth 2
	lw	a1, -124(s0)
	li	a0, 3
	blt	a0, a1, .LBB0_8
	j	.LBB0_2
.LBB0_2:                                #   in Loop: Header=BB0_1 Depth=1
	li	a0, 0
	sw	a0, -128(s0)
	j	.LBB0_3
.LBB0_3:                                #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	lw	a1, -128(s0)
	li	a0, 3
	blt	a0, a1, .LBB0_6
	j	.LBB0_4
.LBB0_4:                                #   in Loop: Header=BB0_3 Depth=2
	lw	a1, -124(s0)
	slli	a0, a1, 2
	lw	a2, -128(s0)
	add	a0, a0, a2
	addi	a0, a0, 1
	slli	a3, a1, 4
	addi	a1, s0, -76
	add	a1, a1, a3
	slli	a2, a2, 2
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
	li	a0, 0
	sw	a0, -132(s0)
	j	.LBB0_9
.LBB0_9:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_11 Depth 2
	lw	a1, -132(s0)
	li	a0, 3
	blt	a0, a1, .LBB0_18
	j	.LBB0_10
.LBB0_10:                               #   in Loop: Header=BB0_9 Depth=1
	li	a0, 0
	sw	a0, -136(s0)
	j	.LBB0_11
.LBB0_11:                               #   Parent Loop BB0_9 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	lw	a1, -136(s0)
	li	a0, 3
	blt	a0, a1, .LBB0_16
	j	.LBB0_12
.LBB0_12:                               #   in Loop: Header=BB0_11 Depth=2
	lw	a1, -132(s0)
	slli	a2, a1, 4
	addi	a0, s0, -76
	add	a2, a0, a2
	lw	a3, -136(s0)
	slli	a3, a3, 2
	add	a2, a2, a3
	lw	a3, 0(a2)
	slli	a2, a1, 2
	addi	a1, s0, -92
	add	a2, a1, a2
	lw	a1, 0(a2)
	add	a1, a1, a3
	sw	a1, 0(a2)
	lw	a1, -132(s0)
	slli	a1, a1, 4
	add	a1, a0, a1
	lw	a2, -136(s0)
	slli	a2, a2, 2
	add	a1, a1, a2
	lw	a3, 0(a1)
	addi	a1, s0, -108
	add	a2, a1, a2
	lw	a1, 0(a2)
	add	a1, a1, a3
	sw	a1, 0(a2)
	lw	a1, -132(s0)
	slli	a1, a1, 4
	add	a1, a0, a1
	lw	a2, -136(s0)
	slli	a2, a2, 2
	add	a1, a1, a2
	lw	a2, 0(a1)
	lw	a1, -112(s0)
	add	a1, a1, a2
	sw	a1, -112(s0)
	lw	a1, -132(s0)
	slli	a1, a1, 4
	add	a0, a0, a1
	lw	a1, -136(s0)
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a1, 0(a0)
	lw	a0, -116(s0)
	xor	a0, a0, a1
	sw	a0, -116(s0)
	lw	a0, -132(s0)
	lw	a1, -136(s0)
	bne	a0, a1, .LBB0_14
	j	.LBB0_13
.LBB0_13:                               #   in Loop: Header=BB0_11 Depth=2
	lw	a0, -132(s0)
	slli	a1, a0, 4
	addi	a0, s0, -76
	add	a0, a0, a1
	lw	a1, -136(s0)
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a1, 0(a0)
	lw	a0, -120(s0)
	mul	a0, a0, a1
	sw	a0, -120(s0)
	j	.LBB0_14
.LBB0_14:                               #   in Loop: Header=BB0_11 Depth=2
	j	.LBB0_15
.LBB0_15:                               #   in Loop: Header=BB0_11 Depth=2
	lw	a0, -136(s0)
	addi	a0, a0, 1
	sw	a0, -136(s0)
	j	.LBB0_11
.LBB0_16:                               #   in Loop: Header=BB0_9 Depth=1
	j	.LBB0_17
.LBB0_17:                               #   in Loop: Header=BB0_9 Depth=1
	lw	a0, -132(s0)
	addi	a0, a0, 1
	sw	a0, -132(s0)
	j	.LBB0_9
.LBB0_18:
	li	a0, 0
	sw	a0, -140(s0)
	j	.LBB0_19
.LBB0_19:                               # =>This Inner Loop Header: Depth=1
	lw	a1, -140(s0)
	li	a0, 3
	blt	a0, a1, .LBB0_28
	j	.LBB0_20
.LBB0_20:                               #   in Loop: Header=BB0_19 Depth=1
	lw	a0, -140(s0)
	slli	a1, a0, 2
	addi	a0, s0, -92
	add	a0, a0, a1
	lw	a0, 0(a0)
	srli	a1, a0, 31
	add	a1, a0, a1
	andi	a1, a1, -2
	sub	a0, a0, a1
	bnez	a0, .LBB0_22
	j	.LBB0_21
.LBB0_21:                               #   in Loop: Header=BB0_19 Depth=1
	lw	a1, -140(s0)
	slli	a2, a1, 2
	addi	a0, s0, -92
	add	a0, a0, a2
	lw	a2, 0(a0)
	lui	a0, %hi(.L.str)
	addi	a0, a0, %lo(.L.str)
	call	printf
	j	.LBB0_23
.LBB0_22:                               #   in Loop: Header=BB0_19 Depth=1
	lw	a1, -140(s0)
	slli	a2, a1, 2
	addi	a0, s0, -92
	add	a0, a0, a2
	lw	a2, 0(a0)
	lui	a0, %hi(.L.str.1)
	addi	a0, a0, %lo(.L.str.1)
	call	printf
	j	.LBB0_23
.LBB0_23:                               #   in Loop: Header=BB0_19 Depth=1
	lw	a0, -140(s0)
	slli	a1, a0, 2
	addi	a0, s0, -108
	add	a0, a0, a1
	lw	a0, 0(a0)
	srli	a1, a0, 31
	add	a1, a0, a1
	andi	a1, a1, -2
	sub	a0, a0, a1
	bnez	a0, .LBB0_25
	j	.LBB0_24
.LBB0_24:                               #   in Loop: Header=BB0_19 Depth=1
	lw	a1, -140(s0)
	slli	a2, a1, 2
	addi	a0, s0, -108
	add	a0, a0, a2
	lw	a2, 0(a0)
	lui	a0, %hi(.L.str.2)
	addi	a0, a0, %lo(.L.str.2)
	call	printf
	j	.LBB0_26
.LBB0_25:                               #   in Loop: Header=BB0_19 Depth=1
	lw	a1, -140(s0)
	slli	a2, a1, 2
	addi	a0, s0, -108
	add	a0, a0, a2
	lw	a2, 0(a0)
	lui	a0, %hi(.L.str.3)
	addi	a0, a0, %lo(.L.str.3)
	call	printf
	j	.LBB0_26
.LBB0_26:                               #   in Loop: Header=BB0_19 Depth=1
	j	.LBB0_27
.LBB0_27:                               #   in Loop: Header=BB0_19 Depth=1
	lw	a0, -140(s0)
	addi	a0, a0, 1
	sw	a0, -140(s0)
	j	.LBB0_19
.LBB0_28:
	lw	a1, -112(s0)
	lui	a0, %hi(.L.str.4)
	addi	a0, a0, %lo(.L.str.4)
	call	printf
	lw	a1, -116(s0)
	lui	a0, %hi(.L.str.5)
	addi	a0, a0, %lo(.L.str.5)
	call	printf
	lw	a1, -120(s0)
	lui	a0, %hi(.L.str.6)
	addi	a0, a0, %lo(.L.str.6)
	call	printf
	li	a0, 0
	sw	a0, -144(s0)
	sw	a0, -148(s0)
	j	.LBB0_29
.LBB0_29:                               # =>This Inner Loop Header: Depth=1
	lw	a1, -148(s0)
	li	a0, 15
	blt	a0, a1, .LBB0_32
	j	.LBB0_30
.LBB0_30:                               #   in Loop: Header=BB0_29 Depth=1
	lw	a0, -148(s0)
	srai	a1, a0, 31
	srli	a1, a1, 30
	add	a1, a0, a1
	andi	a1, a1, -4
	sub	a1, a0, a1
	sll	a1, a0, a1
	lw	a0, -144(s0)
	or	a0, a0, a1
	sw	a0, -144(s0)
	j	.LBB0_31
.LBB0_31:                               #   in Loop: Header=BB0_29 Depth=1
	lw	a0, -148(s0)
	addi	a0, a0, 1
	sw	a0, -148(s0)
	j	.LBB0_29
.LBB0_32:
	lw	a1, -144(s0)
	lui	a0, %hi(.L.str.7)
	addi	a0, a0, %lo(.L.str.7)
	call	printf
	li	a0, 0
	lw	ra, 156(sp)                     # 4-byte Folded Reload
	lw	s0, 152(sp)                     # 4-byte Folded Reload
	addi	sp, sp, 160
	ret
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.type	.L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"Row %d sum is even: %d\n"
	.size	.L.str, 24

	.type	.L.str.1,@object                # @.str.1
.L.str.1:
	.asciz	"Row %d sum is odd: %d\n"
	.size	.L.str.1, 23

	.type	.L.str.2,@object                # @.str.2
.L.str.2:
	.asciz	"Column %d sum is even: %d\n"
	.size	.L.str.2, 27

	.type	.L.str.3,@object                # @.str.3
.L.str.3:
	.asciz	"Column %d sum is odd: %d\n"
	.size	.L.str.3, 26

	.type	.L.str.4,@object                # @.str.4
.L.str.4:
	.asciz	"Total sum: %d\n"
	.size	.L.str.4, 15

	.type	.L.str.5,@object                # @.str.5
.L.str.5:
	.asciz	"XOR of all elements: %d\n"
	.size	.L.str.5, 25

	.type	.L.str.6,@object                # @.str.6
.L.str.6:
	.asciz	"Product of diagonal elements: %d\n"
	.size	.L.str.6, 34

	.type	.L.str.7,@object                # @.str.7
.L.str.7:
	.asciz	"Shift XOR result: %d\n"
	.size	.L.str.7, 22

	.ident	"Homebrew clang version 20.1.8"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym printf
