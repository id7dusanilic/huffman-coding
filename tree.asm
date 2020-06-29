.model flat, stdcall

include prototypes.inc
.code

FormTree PROC,	input: 	PTR Data_S, \
		len: 	BYTE, \
		output: PTR Node_S

	push ebx
	push ecx
	push edx
	push esi
	push edi

	; // cx used as temporary register, eax as count sum (mostly)
	; // dh - input index, dl - stack size

	; // esi incremented after every read,
	; // edi constant with offset set in ebx (which is incremented)
	mov esi, input
	mov edi, output
	xor ebx, ebx ; // counter in output array, set to 0
	mov edx, ebx

	movzx ecx, Data_S PTR [esi]
	mov (Node_S PTR [edi + ebx * TYPE Node_S]), 0
	mov (Node_S PTR [edi + ebx * TYPE Node_S]).info, cx
	mov (Node_S PTR [edi + ebx * TYPE Node_S]).left, NUL
	mov (Node_S PTR [edi + ebx * TYPE Node_S]).right, NUL
	movzx eax, (Data_S PTR[esi]).num
	add esi, TYPE Data_S
	inc dh
	inc ebx
	
	mov cx, Data_S PTR [esi]
	mov (Node_S PTR [edi + ebx * TYPE Node_S]), 0
	mov (Node_S PTR [edi + ebx * TYPE Node_S]).info, cx
	mov (Node_S PTR [edi + ebx * TYPE Node_S]).left, NUL
	mov (Node_S PTR [edi + ebx * TYPE Node_S]).right, NUL
	add al, (Data_S PTR[esi]).num
	add esi, TYPE Data_S
	inc dh
	inc ebx

	mov (Node_S PTR [edi + ebx * TYPE Node_S]), 0
	mov (Node_S PTR [edi + ebx * TYPE Node_S]).info.num, al
	mov (Node_S PTR [edi + ebx * TYPE Node_S]).left, 0
	mov (Node_S PTR [edi + ebx * TYPE Node_S]).right, 1

	push bx
	inc ebx
	inc dl
	
	mov dh, 2

outerloop:
	cmp dl, 2
	jnz elif
		; // 2 elements on stack
		mov cx, [esp]
		mov ah, (Node_S PTR[edi + ecx * TYPE Node_S]).info.num
		mov cx, [esp + TYPE cx]
		cmp (Node_S PTR[esi]).info.num, ah
		jns noswap
		cmp (Node_S PTR[edi + ecx * TYPE Node_S]).info.num, ah
		jns noswap

		movzx ecx, Data_S PTR [esi]
		mov (Node_S PTR [edi + ebx * TYPE Node_S]), 0
		mov (Node_S PTR [edi + ebx * TYPE Node_S]).info, cx
		mov (Node_S PTR [edi + ebx * TYPE Node_S]).left, NUL
		mov (Node_S PTR [edi + ebx * TYPE Node_S]).right, NUL
		add esi, TYPE Data_S
		inc dh

		pop cx
		dec dl
		xchg [esp], cx
		push bx
		inc dl
		inc ebx
		jmp swap

	noswap:
		pop cx
		dec dl
	swap:
		movzx ax, (Node_S PTR [edi + ecx * TYPE Node_S]).info.num
		mov (Node_S PTR [edi + ebx * TYPE Node_S]).left, cl
		pop cx
		dec dl
		add al, (Node_S PTR [edi + ecx * TYPE Node_S]).info.num
		mov (Node_S PTR [edi + ebx * TYPE Node_S]).info.num, al
		mov (Node_S PTR [edi + ebx * TYPE Node_S]).right, cl
		push bx
		inc dl
		inc ebx
		jmp bottom
	elif:
	inc dh
	cmp dh, len
	jz els
		dec dh
		mov cx, [esp]
		movzx eax, (Node_S PTR[edi + ecx * TYPE Node_S]).info.num
		cmp (Data_S PTR[esi + TYPE Data_S]).num, al
		js lesser ; // a[i+1] < stack.top()
			mov cx, Data_S PTR [esi]
			mov (Node_S PTR [edi + ebx * TYPE Node_S]).info, cx	
			mov (Node_S PTR [edi + ebx * TYPE Node_S]).left, NUL
			mov (Node_S PTR [edi + ebx * TYPE Node_S]).right, NUL
			movzx eax, (Data_S PTR[esi]).num
			add esi, TYPE Data_S
			inc dh
			inc ebx

			mov cl, bl
			dec cl
			mov (Node_S PTR [edi + ebx * TYPE Node_S]), 0
			mov (Node_S PTR [edi + ebx * TYPE Node_S]).left, cl

			pop cx
			dec dl
			add al, (Node_S PTR [edi + ecx * TYPE Node_S]).info.num
			mov (Node_S PTR [edi + ebx * TYPE Node_S]).info.num, al
			mov (Node_S PTR [edi + ebx * TYPE Node_S]).right, cl
			push bx
			inc dl
			inc ebx
		jmp bottom
		lesser:
			movzx ecx, Data_S PTR [esi]
			mov (Node_S PTR [edi + ebx * TYPE Node_S]), 0
			mov (Node_S PTR [edi + ebx * TYPE Node_S]).info, cx
			mov (Node_S PTR [edi + ebx * TYPE Node_S]).left, NUL
			mov (Node_S PTR [edi + ebx * TYPE Node_S]).right, NUL
			movzx eax, (Data_S PTR[esi]).num
			add esi, TYPE Data_S
			inc dh
			inc ebx
			
			mov cx, Data_S PTR [esi]
			mov (Node_S PTR [edi + ebx * TYPE Node_S]), 0
			mov (Node_S PTR [edi + ebx * TYPE Node_S]).info, cx
			mov (Node_S PTR [edi + ebx * TYPE Node_S]).left, NUL
			mov (Node_S PTR [edi + ebx * TYPE Node_S]).right, NUL
			add al, (Data_S PTR[esi]).num
			add esi, TYPE Data_S
			inc dh
			inc ebx

			mov (Node_S PTR [edi + ebx * TYPE Node_S]), 0
			mov (Node_S PTR [edi + ebx * TYPE Node_S]).info.num, al
			mov al, bl
			dec al
			mov (Node_S PTR [edi + ebx * TYPE Node_S]).right, al
			dec al
			mov (Node_S PTR [edi + ebx * TYPE Node_S]).left, al

			push bx
			inc ebx
			inc dl
		jmp bottom
	els:
		dec dh
		movzx ecx, Data_S PTR [esi]
		mov (Node_S PTR [edi + ebx * TYPE Node_S]), 0
		mov (Node_S PTR [edi + ebx * TYPE Node_S]).info, cx
		mov (Node_S PTR [edi + ebx * TYPE Node_S]).left, NUL
		mov (Node_S PTR [edi + ebx * TYPE Node_S]).right, NUL
		movzx eax, (Data_S PTR[esi]).num
		add esi, TYPE Data_S
		inc dh
		inc ebx

		pop cx
		dec dl
		mov (Node_S PTR [edi + ebx * TYPE Node_S]), 0
		add al, (Node_S PTR [edi + ecx * TYPE Node_S]).info.num
		mov (Node_S PTR [edi + ebx * TYPE Node_S]).info.num, al
		mov eax, ebx
		dec eax
		mov (Node_S PTR [edi + ebx * TYPE Node_S]).right, al
		mov (Node_S PTR [edi + ebx * TYPE Node_S]).left, cl
		inc dh
	bottom:
	cmp dh, len
	js outerloop
	
	mov eax, len
	mul eax, 2
	dec eax

	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
ret
FormTree ENDP
END
