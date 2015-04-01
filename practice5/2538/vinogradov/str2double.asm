default rel
global str2double

section .data
const_10:	dq 10.
const_1:	dq 1.
const_m1:	dq -1.

section .text
str2double:	
	xor rax, rax
	xorpd xmm0, xmm0
	mov rsi, rdi

.read_sign:
	xor rdi, rdi
	cmp [rsi], byte '-'
	jne .not_negative
.negative:
	mov rdi, 1
	add rsi, 1
.not_negative:

.read_integral:
	lodsb
	cmp al, '0'
	jnae .integral_end
	cmp al, '9'
	jnbe .integral_end
	sub al, '0'

	mulsd xmm0, [const_10]

	cvtsi2sd xmm1, rax
	addsd xmm0, xmm1

	;; add xmm0, al
	jmp .read_integral
.integral_end:
	sub rsi, 1

.read_point:
	cmp [esi], byte '.'
	jne .end
.point:
	add rsi, 1

	movsd xmm2, [const_1]
.read_fractional:
	lodsb
	cmp al, '0'
	jnae .fractional_end
	cmp al, '9'
	jnbe .fractional_end
	sub al, '0'

	mulsd xmm0, [const_10]
	cvtsi2sd xmm1, rax
	addsd xmm0, xmm1

	mulsd xmm2, [const_10]

	jmp .read_fractional
.fractional_end:
	divsd xmm0, xmm2

.end:
	test rdi, rdi
	jz .return
.negate:	
	mulsd xmm0, [const_m1]
.return:
	ret
