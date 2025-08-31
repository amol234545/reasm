	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_zmmul1p0"
	.file	"main.cpp"
	.text
	.globl	main                            # -- Begin function main
	.p2align	2
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:
	addi	sp, sp, -48
	.cfi_def_cfa_offset 48
	sw	ra, 44(sp)                      # 4-byte Folded Spill
	sw	s0, 40(sp)                      # 4-byte Folded Spill
	.cfi_offset ra, -4
	.cfi_offset s0, -8
	addi	s0, sp, 48
	.cfi_def_cfa s0, 0
	li	a0, 0
	sw	a0, -32(s0)                     # 4-byte Folded Spill
	sw	a0, -12(s0)
	lui	a1, %hi(.L.str)
	addi	a1, a1, %lo(.L.str)
	addi	a0, s0, -20
	sw	a0, -48(s0)                     # 4-byte Folded Spill
	li	a2, 1000
	call	_ZN11BankAccountC2EPKci
	lw	a0, -48(s0)                     # 4-byte Folded Reload
	call	_ZNK11BankAccount11showBalanceEv
	lw	a0, -48(s0)                     # 4-byte Folded Reload
	li	a1, 250
	sw	a1, -44(s0)                     # 4-byte Folded Spill
	call	_ZN11BankAccount7depositEi
	lw	a0, -48(s0)                     # 4-byte Folded Reload
	li	a1, 500
	sw	a1, -40(s0)                     # 4-byte Folded Spill
	call	_ZN11BankAccount8withdrawEi
	lw	a0, -48(s0)                     # 4-byte Folded Reload
	call	_ZNK11BankAccount11showBalanceEv
	lui	a1, %hi(.L.str.1)
	addi	a1, a1, %lo(.L.str.1)
	addi	a0, s0, -28
	sw	a0, -36(s0)                     # 4-byte Folded Spill
	li	a2, 1250
	call	_ZN11BankAccountC2EPKci
	lw	a0, -36(s0)                     # 4-byte Folded Reload
	call	_ZNK11BankAccount11showBalanceEv
	lw	a1, -44(s0)                     # 4-byte Folded Reload
	lw	a0, -36(s0)                     # 4-byte Folded Reload
	call	_ZN11BankAccount7depositEi
	lw	a1, -40(s0)                     # 4-byte Folded Reload
	lw	a0, -36(s0)                     # 4-byte Folded Reload
	call	_ZN11BankAccount8withdrawEi
	lw	a0, -36(s0)                     # 4-byte Folded Reload
	call	_ZNK11BankAccount11showBalanceEv
	lw	a0, -32(s0)                     # 4-byte Folded Reload
	.cfi_def_cfa sp, 48
	lw	ra, 44(sp)                      # 4-byte Folded Reload
	lw	s0, 40(sp)                      # 4-byte Folded Reload
	.cfi_restore ra
	.cfi_restore s0
	addi	sp, sp, 48
	.cfi_def_cfa_offset 0
	ret
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        # -- End function
	.section	.text._ZN11BankAccountC2EPKci,"axG",@progbits,_ZN11BankAccountC2EPKci,comdat
	.weak	_ZN11BankAccountC2EPKci         # -- Begin function _ZN11BankAccountC2EPKci
	.p2align	2
	.type	_ZN11BankAccountC2EPKci,@function
_ZN11BankAccountC2EPKci:                # @_ZN11BankAccountC2EPKci
# %bb.0:
	addi	sp, sp, -32
	sw	ra, 28(sp)                      # 4-byte Folded Spill
	sw	s0, 24(sp)                      # 4-byte Folded Spill
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	lw	a1, -12(s0)
	lw	a0, -16(s0)
	sw	a0, 0(a1)
	lw	a0, -20(s0)
	sw	a0, 4(a1)
	lw	ra, 28(sp)                      # 4-byte Folded Reload
	lw	s0, 24(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 32
	ret
.Lfunc_end1:
	.size	_ZN11BankAccountC2EPKci, .Lfunc_end1-_ZN11BankAccountC2EPKci
                                        # -- End function
	.section	.text._ZNK11BankAccount11showBalanceEv,"axG",@progbits,_ZNK11BankAccount11showBalanceEv,comdat
	.weak	_ZNK11BankAccount11showBalanceEv # -- Begin function _ZNK11BankAccount11showBalanceEv
	.p2align	2
	.type	_ZNK11BankAccount11showBalanceEv,@function
_ZNK11BankAccount11showBalanceEv:       # @_ZNK11BankAccount11showBalanceEv
	.cfi_startproc
# %bb.0:
	addi	sp, sp, -16
	.cfi_def_cfa_offset 16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	sw	s0, 8(sp)                       # 4-byte Folded Spill
	.cfi_offset ra, -4
	.cfi_offset s0, -8
	addi	s0, sp, 16
	.cfi_def_cfa s0, 0
	sw	a0, -12(s0)
	lw	a0, -12(s0)
	lw	a1, 0(a0)
	lw	a2, 4(a0)
	lui	a0, %hi(.L.str.2)
	addi	a0, a0, %lo(.L.str.2)
	call	printf
	.cfi_def_cfa sp, 16
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	lw	s0, 8(sp)                       # 4-byte Folded Reload
	.cfi_restore ra
	.cfi_restore s0
	addi	sp, sp, 16
	.cfi_def_cfa_offset 0
	ret
.Lfunc_end2:
	.size	_ZNK11BankAccount11showBalanceEv, .Lfunc_end2-_ZNK11BankAccount11showBalanceEv
	.cfi_endproc
                                        # -- End function
	.section	.text._ZN11BankAccount7depositEi,"axG",@progbits,_ZN11BankAccount7depositEi,comdat
	.weak	_ZN11BankAccount7depositEi      # -- Begin function _ZN11BankAccount7depositEi
	.p2align	2
	.type	_ZN11BankAccount7depositEi,@function
_ZN11BankAccount7depositEi:             # @_ZN11BankAccount7depositEi
	.cfi_startproc
# %bb.0:
	addi	sp, sp, -32
	.cfi_def_cfa_offset 32
	sw	ra, 28(sp)                      # 4-byte Folded Spill
	sw	s0, 24(sp)                      # 4-byte Folded Spill
	.cfi_offset ra, -4
	.cfi_offset s0, -8
	addi	s0, sp, 32
	.cfi_def_cfa s0, 0
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	lw	a0, -12(s0)
	sw	a0, -20(s0)                     # 4-byte Folded Spill
	lw	a1, -16(s0)
	li	a0, 0
	bge	a0, a1, .LBB3_2
	j	.LBB3_1
.LBB3_1:
	lw	a1, -20(s0)                     # 4-byte Folded Reload
	lw	a2, -16(s0)
	lw	a0, 4(a1)
	add	a0, a0, a2
	sw	a0, 4(a1)
	lw	a1, -16(s0)
	lui	a0, %hi(.L.str.3)
	addi	a0, a0, %lo(.L.str.3)
	call	printf
	j	.LBB3_3
.LBB3_2:
	lui	a0, %hi(.L.str.4)
	addi	a0, a0, %lo(.L.str.4)
	call	printf
	j	.LBB3_3
.LBB3_3:
	.cfi_def_cfa sp, 32
	lw	ra, 28(sp)                      # 4-byte Folded Reload
	lw	s0, 24(sp)                      # 4-byte Folded Reload
	.cfi_restore ra
	.cfi_restore s0
	addi	sp, sp, 32
	.cfi_def_cfa_offset 0
	ret
.Lfunc_end3:
	.size	_ZN11BankAccount7depositEi, .Lfunc_end3-_ZN11BankAccount7depositEi
	.cfi_endproc
                                        # -- End function
	.section	.text._ZN11BankAccount8withdrawEi,"axG",@progbits,_ZN11BankAccount8withdrawEi,comdat
	.weak	_ZN11BankAccount8withdrawEi     # -- Begin function _ZN11BankAccount8withdrawEi
	.p2align	2
	.type	_ZN11BankAccount8withdrawEi,@function
_ZN11BankAccount8withdrawEi:            # @_ZN11BankAccount8withdrawEi
	.cfi_startproc
# %bb.0:
	addi	sp, sp, -32
	.cfi_def_cfa_offset 32
	sw	ra, 28(sp)                      # 4-byte Folded Spill
	sw	s0, 24(sp)                      # 4-byte Folded Spill
	.cfi_offset ra, -4
	.cfi_offset s0, -8
	addi	s0, sp, 32
	.cfi_def_cfa s0, 0
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	lw	a0, -12(s0)
	sw	a0, -20(s0)                     # 4-byte Folded Spill
	lw	a1, -16(s0)
	li	a0, 0
	bge	a0, a1, .LBB4_3
	j	.LBB4_1
.LBB4_1:
	lw	a0, -20(s0)                     # 4-byte Folded Reload
	lw	a1, -16(s0)
	lw	a0, 4(a0)
	blt	a0, a1, .LBB4_3
	j	.LBB4_2
.LBB4_2:
	lw	a1, -20(s0)                     # 4-byte Folded Reload
	lw	a2, -16(s0)
	lw	a0, 4(a1)
	sub	a0, a0, a2
	sw	a0, 4(a1)
	lw	a1, -16(s0)
	lui	a0, %hi(.L.str.5)
	addi	a0, a0, %lo(.L.str.5)
	call	printf
	j	.LBB4_4
.LBB4_3:
	lui	a0, %hi(.L.str.6)
	addi	a0, a0, %lo(.L.str.6)
	call	printf
	j	.LBB4_4
.LBB4_4:
	.cfi_def_cfa sp, 32
	lw	ra, 28(sp)                      # 4-byte Folded Reload
	lw	s0, 24(sp)                      # 4-byte Folded Reload
	.cfi_restore ra
	.cfi_restore s0
	addi	sp, sp, 32
	.cfi_def_cfa_offset 0
	ret
.Lfunc_end4:
	.size	_ZN11BankAccount8withdrawEi, .Lfunc_end4-_ZN11BankAccount8withdrawEi
	.cfi_endproc
                                        # -- End function
	.type	.L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"Alice"
	.size	.L.str, 6

	.type	.L.str.1,@object                # @.str.1
.L.str.1:
	.asciz	"Bob"
	.size	.L.str.1, 4

	.type	.L.str.2,@object                # @.str.2
.L.str.2:
	.asciz	"%s's balance: $%d"
	.size	.L.str.2, 18

	.type	.L.str.3,@object                # @.str.3
.L.str.3:
	.asciz	"Deposited: $%d"
	.size	.L.str.3, 15

	.type	.L.str.4,@object                # @.str.4
.L.str.4:
	.asciz	"Invalid deposit amount."
	.size	.L.str.4, 24

	.type	.L.str.5,@object                # @.str.5
.L.str.5:
	.asciz	"Withdrew: $%d"
	.size	.L.str.5, 14

	.type	.L.str.6,@object                # @.str.6
.L.str.6:
	.asciz	"Insufficient funds or invalid amount."
	.size	.L.str.6, 38

	.ident	"Homebrew clang version 20.1.8"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym _ZNK11BankAccount11showBalanceEv
	.addrsig_sym _ZN11BankAccount7depositEi
	.addrsig_sym _ZN11BankAccount8withdrawEi
	.addrsig_sym printf
