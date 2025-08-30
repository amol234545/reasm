	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_zmmul1p0"
	.file	"main.c"
	.text
	.globl	main                            # -- Begin function main
	.p2align	2
	.type	main,@function
main:                                   # @main
# %bb.0:
	addi	sp, sp, -32
	sw	ra, 28(sp)                      # 4-byte Folded Spill
	sw	s0, 24(sp)                      # 4-byte Folded Spill
	sw	s1, 20(sp)                      # 4-byte Folded Spill
	sw	s2, 16(sp)                      # 4-byte Folded Spill
	sw	s3, 12(sp)                      # 4-byte Folded Spill
	lui	s0, %hi(.L.str)
	addi	s0, s0, %lo(.L.str)
	li	a1, 10
	li	a2, 20
	mv	a0, s0
	call	printf
	lui	a0, %hi(.L.str.1)
	addi	a0, a0, %lo(.L.str.1)
	li	a1, 10
	li	a2, 20
	call	printf
	lui	a0, %hi(.L.str.2)
	addi	a0, a0, %lo(.L.str.2)
	call	printf
	li	a1, 15
	li	a2, 40
	mv	a0, s0
	call	printf
	lui	a0, %hi(.L.str.3)
	addi	a0, a0, %lo(.L.str.3)
	call	printf
	li	s0, 0
	lui	s2, %hi(.L__const.main.arr)
	addi	s2, s2, %lo(.L__const.main.arr)
	lui	s1, %hi(.L.str.4)
	addi	s1, s1, %lo(.L.str.4)
	li	s3, 5
.LBB0_1:                                # =>This Inner Loop Header: Depth=1
	lh	a2, 0(s2)
	mv	a0, s1
	mv	a1, s0
	mv	a3, s0
	mv	a4, a2
	call	printf
	addi	s0, s0, 1
	addi	s2, s2, 2
	bne	s0, s3, .LBB0_1
# %bb.2:
	li	a0, 0
	lw	ra, 28(sp)                      # 4-byte Folded Reload
	lw	s0, 24(sp)                      # 4-byte Folded Reload
	lw	s1, 20(sp)                      # 4-byte Folded Reload
	lw	s2, 16(sp)                      # 4-byte Folded Reload
	lw	s3, 12(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 32
	ret
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.type	.L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"a = %d, b = %d\n"
	.size	.L.str, 16

	.type	.L.str.1,@object                # @.str.1
.L.str.1:
	.asciz	"*p = %d, *q = %d\n"
	.size	.L.str.1, 18

	.type	.L.str.2,@object                # @.str.2
.L.str.2:
	.asciz	"After modification:\n"
	.size	.L.str.2, 21

	.type	.L__const.main.arr,@object      # @__const.main.arr
	.section	.rodata,"a",@progbits
	.p2align	1, 0x0
.L__const.main.arr:
	.half	1                               # 0x1
	.half	2                               # 0x2
	.half	3                               # 0x3
	.half	4                               # 0x4
	.half	5                               # 0x5
	.size	.L__const.main.arr, 10

	.type	.L.str.3,@object                # @.str.3
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str.3:
	.asciz	"Array elements using pointer:\n"
	.size	.L.str.3, 31

	.type	.L.str.4,@object                # @.str.4
.L.str.4:
	.asciz	"arr[%d] = %d, *(r+%d) = %d\n"
	.size	.L.str.4, 28

	.ident	"Homebrew clang version 20.1.8"
	.section	".note.GNU-stack","",@progbits
	.addrsig
