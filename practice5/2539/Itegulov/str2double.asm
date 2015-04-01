global str2double

default rel

str2double:
	mov rsi, rdi
	xor eax, eax
	xor edx, edx
	cld
	movsd xmm2, qword [one] ; xmm2 contains 10^-i for frac_part
	cmp [rsi], byte '-'
	jne .plus
	inc rsi
	mov dl, 1 ; dl contains minus flag
.plus
	xorps xmm0, xmm0
.int_part
	lodsb
	cmp al, '.'
	jz .frac_part

	sub al, '0'
	mulsd xmm0, qword [ten]
	cvtsi2sd xmm1, eax
	addsd xmm0, xmm1
	jmp .int_part
.frac_part
	divsd xmm2, qword [ten]
	lodsb
	test al, al
	jz .finish
	sub al, '0'
	cvtsi2sd xmm1, eax
	mulsd xmm1, xmm2
	addsd xmm0, xmm1
	jmp .frac_part
.finish
	test dl, 1
	jz .return
	mulsd xmm0, qword [minusOne]
.return
	ret

section .rodata
one: dq 1.0
ten: dq 10.0
minusOne: dq -1.0
