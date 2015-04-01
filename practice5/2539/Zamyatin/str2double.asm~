global 		str2double

str2double:
	mov 	rsi, 0
	cmp 	byte [rdi], '-'
	jnz 	.pos
	mov 	rsi, 1
	shl 	rsi, 63
	inc 	rdi

.pos:

	finit
	fld 	qword [ten]
	fldz
	mov 	rax, 0

.loop1:
	mov 	al, byte [rdi]
	cmp 	rax, '.'
	jz 		.finish1
	sub 	rax, '0'
	mov 	[tmp], rax
	fmul 	st1
	fild 	qword [tmp]
	faddp 	st1
	inc 	rdi
	jmp 	.loop1
.finish1:
	fstp 	qword [a]
	inc 	rdi
	fldz

.loop3:
	cmp 	byte [rdi], 0
	jz 		.finish3
	inc 	rdi
	jmp 	.loop3
.finish3:
	dec 	rdi 

.loop2:
	cmp 	byte [rdi], '.'
	jz 		.finish2
	mov 	al, [rdi]
	sub 	rax, '0'
	mov 	[tmp], rax
	fdiv 	st1
	fild 	qword [tmp]
	faddp 	st1
	dec 	rdi
	jmp 	.loop2
.finish2:

	fdiv 	st1
	fld 	qword [a]
	faddp
	fstp 	qword [tmp]
	fwait
	or 	  [tmp], rsi
	movlps	xmm0, [tmp]
	ret

section 	.data
ten: 	dq 	10.0

section 	.bss
tmp: 		resd 	1
a: 		resd 	1
b: 		resd 	1
