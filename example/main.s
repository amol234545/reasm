	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_zmmul1p0"
	.file	"main.c"
	.text
	.globl	fib                             # -- Begin function fib
	.p2align	2
	.type	fib,@function
fib:                                    # @fib
# %bb.0:
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	sw	s0, 8(sp)                       # 4-byte Folded Spill
	sw	s1, 4(sp)                       # 4-byte Folded Spill
	sw	s2, 0(sp)                       # 4-byte Folded Spill
	mv	s0, a0
	li	s1, 0
	li	s2, 2
	blt	s0, s2, .LBB0_2
.LBB0_1:                                # =>This Inner Loop Header: Depth=1
	addi	a0, s0, -1
	call	fib
	add	s1, s1, a0
	addi	s0, s0, -2
	bge	s0, s2, .LBB0_1
.LBB0_2:
	add	a0, s0, s1
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	lw	s0, 8(sp)                       # 4-byte Folded Reload
	lw	s1, 4(sp)                       # 4-byte Folded Reload
	lw	s2, 0(sp)                       # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
.Lfunc_end0:
	.size	fib, .Lfunc_end0-fib
                                        # -- End function
	.globl	printFib                        # -- Begin function printFib
	.p2align	2
	.type	printFib,@function
printFib:                               # @printFib
# %bb.0:
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	sw	s0, 8(sp)                       # 4-byte Folded Spill
	sw	s1, 4(sp)                       # 4-byte Folded Spill
	sw	s2, 0(sp)                       # 4-byte Folded Spill
	mv	s0, a1
	mv	s1, a0
	lui	s2, %hi(.L.str)
	addi	s2, s2, %lo(.L.str)
	bge	s0, s1, .LBB1_2
.LBB1_1:                                # =>This Inner Loop Header: Depth=1
	mv	a0, s0
	call	fib
	mv	a1, a0
	mv	a0, s2
	call	printf
	addi	s0, s0, 1
	blt	s0, s1, .LBB1_1
.LBB1_2:
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	lw	s0, 8(sp)                       # 4-byte Folded Reload
	lw	s1, 4(sp)                       # 4-byte Folded Reload
	lw	s2, 0(sp)                       # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
.Lfunc_end1:
	.size	printFib, .Lfunc_end1-printFib
                                        # -- End function
	.globl	main                            # -- Begin function main
	.p2align	2
	.type	main,@function
main:                                   # @main
# %bb.0:
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	li	a0, 10
	li	a1, 0
	call	printFib
	li	a0, 0
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.type	.L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"%d "
	.size	.L.str, 4

	.ident	"Homebrew clang version 20.1.8"
	.section	".note.GNU-stack","",@progbits
	.addrsig
