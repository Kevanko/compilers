	.file	"array.mod"
	.text
	.globl	_t10ExampleMod4Main
	.p2align	4
	.type	_t10ExampleMod4Main,@function
_t10ExampleMod4Main:
	.cfi_startproc
	movq	$100, .L_t10ExampleMod1v+16(%rip)
	retq
.Lfunc_end0:
	.size	_t10ExampleMod4Main, .Lfunc_end0-_t10ExampleMod4Main
	.cfi_endproc

	.section	".note.GNU-stack","",@progbits
