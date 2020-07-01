include Irvine32.inc
include huffman_tree.inc
include configuration.inc

.data
NodeSize BYTE TYPE Node_S

.code

; // ========================================================================

PrintCodes	PROC,\
FirstNode:	PTR Node_S,\	; // First Node pointer 
Dist:		DWORD,\			; // Distance from first element in Nodes array
Code:		PTR BYTE,\		; // Array containing code for a leaf
Index:		DWORD			; // Current index in Code array 

; // ========================================================================

LOCAL	DistBytes: DWORD	; // Distance from first node in BYTES

; // Saving used registers
push	eax
push	esi
push	edi
push	ecx
push	edx

; // Calculating DistBytes
mov		eax, 0
mov		ax, WORD PTR Dist
mul		NodeSize
mov		DistBytes, eax

; // Initializing registers
; // esi - pointer to current node
; // edi - pointer to char in string that holds the code
mov		esi, DistBytes
add		esi, FirstNode
mov		edi, Code
add		edi, Index

; // Incrementing index
mov		ecx, Index
inc		ecx

mov		eax, 0

; // Checking if left child exists
mov		al, BYTE PTR[esi + 2]
.IF(al != NUL)
mov		BYTE PTR[edi], '0'
INVOKE	PrintCodes, FirstNode, eax, Code, ecx
.ENDIF

; // Checking if right child exists
mov		al, BYTE PTR[esi + 3]
.IF(al != NUL)
mov		BYTE PTR[edi], '1'
INVOKE	PrintCodes, FirstNode, eax, Code, ecx
.ENDIF

; // Ending string with '\0'
mov		BYTE PTR[edi], 0

; // Printing leaves and codes
mov		al, BYTE PTR[esi]
.IF(al != 0)
call	WriteChar
mov		al, 9
call	WriteChar
mov		al, BYTE PTR[esi+1]
call	WriteDec
mov		al, 9
call	WriteChar
mov		al, 9
call	WriteChar
mov		edx, Code
call	WriteString
mov		al, 10
call	WriteChar
.ENDIF

; // Restoring used registers
pop		edx
pop		ecx
pop		edi
pop		esi
pop		eax

ret
PrintCodes ENDP

; // ========================================================================

FormTree PROC,	input: 	PTR Data_S, \
		len: 	BYTE, \
		output: PTR Node_S
		
; // ========================================================================

LOCAL temparray[255] : BYTE
	push ebp ; // pushed again to the stack because it is to be used
	push ebx
	push ecx
	push edx
	push esi
	push edi

	; // cx used as temporary register, eax as count accumulator (mostly)
	; // dh - input index, dl - array length
	; // ebp as temp array

	; // esi incremented after every read,
	; // edi constant with offset set in ebx (which is incremented)
	mov esi, input
	mov edi, output
	movzx eax, len
	dec eax		; // compare with the last possible index instead of the number of elements
	push ax
	lea ebp, temparray
	xor ebx, ebx ; // counter in output array, set to 0
	mov edx, 0

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

	mov [ebp], bl
	inc ebx
	inc dl

outerloop:
;// are there 2 input elements remaining
	cmp dh, [esp]
	je temp	; // 1 input element
	ja tempboth	; // no input elements

	; // 2 or more input elements left
	xor ecx, ecx
	mov cl,  [ebp]
	movzx  eax, (Node_S PTR [edi + ecx * TYPE Node_S]).info.num
	cmp al, (Data_S PTR [esi + TYPE Data_S]).num
	jb temp
	; // n1 + n2, take two input elements

		; // take first input
		movzx ecx, Data_S PTR [esi]
		mov (Node_S PTR [edi + ebx * TYPE Node_S]), 0
		mov (Node_S PTR [edi + ebx * TYPE Node_S]).info, cx
		mov (Node_S PTR [edi + ebx * TYPE Node_S]).left, NUL
		mov (Node_S PTR [edi + ebx * TYPE Node_S]).right, NUL
		movzx eax, (Data_S PTR[esi]).num
		add esi, TYPE Data_S
		inc dh
		inc ebx
		; // take second input
		mov cx, Data_S PTR [esi]
		mov (Node_S PTR [edi + ebx * TYPE Node_S]), 0
		mov (Node_S PTR [edi + ebx * TYPE Node_S]).info, cx
		mov (Node_S PTR [edi + ebx * TYPE Node_S]).left, NUL
		mov (Node_S PTR [edi + ebx * TYPE Node_S]).right, NUL
		add al, (Data_S PTR[esi]).num
		add esi, TYPE Data_S
		inc dh
		inc ebx
		; make a joining node, and push its index
		mov (Node_S PTR [edi + ebx * TYPE Node_S]), 0
		mov (Node_S PTR [edi + ebx * TYPE Node_S]).info.num, al
		mov al, bl
		dec al
		mov (Node_S PTR [edi + ebx * TYPE Node_S]).right, al
		dec al
		mov (Node_S PTR [edi + ebx * TYPE Node_S]).left, al
		
		inc ebp
		mov [ebp], bl
		inc dl
		inc ebx

	jmp bottom
temp:
	cmp dl, 2
	jb arrte ; // if there are less than 2 elements in the temp array, take one input and one temporary -> ARRay + TEmp

	; // 2 or more in temp array, 1 or more input
	dec ebp
	xor ecx, ecx
	mov cl, [ebp]
	inc ebp
	movzx  eax, (Node_S PTR [edi + ecx * TYPE Node_S]).info.num
	cmp al, (Data_S PTR [esi]).num ; // compare second temp element and lowest remaining input
	jae arrte
tempboth:
	cmp dl, 2
	jb arrte
	; // s1 + s2, take two temporary elements

	; // take first
	
	xor ecx, ecx
	mov cl, [ebp]
	dec ebp
	dec dl
	movzx ax, (Node_S PTR [edi + ecx * TYPE Node_S]).info.num
	mov (Node_S PTR [edi + ebx * TYPE Node_S]).left, cl
	; // take second
	xor ecx, ecx
	mov cl, [ebp]
	dec ebp
	dec dl
	add al, (Node_S PTR [edi + ecx * TYPE Node_S]).info.num
	mov (Node_S PTR [edi + ebx * TYPE Node_S]).info.num, al
	mov (Node_S PTR [edi + ebx * TYPE Node_S]).right, cl
	inc ebp
	mov [ebp], bl
	inc dl
	inc ebx

	jmp bottom

arrte:
	cmp dh, [esp]
	ja bottom
	; // n1 + s1, take one temp and one input

	; // take input
	mov cx, Data_S PTR [esi]
	mov (Node_S PTR [edi + ebx * TYPE Node_S]).info, cx	
	mov (Node_S PTR [edi + ebx * TYPE Node_S]).left, NUL
	mov (Node_S PTR [edi + ebx * TYPE Node_S]).right, NUL
	movzx eax, (Data_S PTR[esi]).num
	add esi, TYPE Data_S
	inc dh
	inc ebx
	; // write index of previous node
	mov cl, bl
	dec cl
	mov (Node_S PTR [edi + ebx * TYPE Node_S]), 0
	mov (Node_S PTR [edi + ebx * TYPE Node_S]).left, cl

	; // take temp
	xor ecx, ecx
	mov cl, [ebp]
	dec ebp
	dec dl
	add al, (Node_S PTR [edi + ecx * TYPE Node_S]).info.num
	mov (Node_S PTR [edi + ebx * TYPE Node_S]).info.num, al
	mov (Node_S PTR [edi + ebx * TYPE Node_S]).right, cl
	inc ebp
	mov [ebp], bl
	inc dl
	inc ebx

bottom:
	call TempSort
	cmp dh, [esp]
	jbe outerloop
	cmp dl, 1
	ja outerloop
	
	pop ax ; // len
	movzx eax, bl
	dec eax ; // index of tree root

	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop ebp
ret
FormTree ENDP

TempSort PROC
; // Number of temporary elements is saved in dl
; // address of the last element is in ebp register

; // Saving used registers
push    eax
push    ebx
push    ecx
push    edx
push    esi
push    edi
push	ebp

movzx eax, dl
sub	ebp, eax ; // ebp holds the first
inc ebp
dec dl

; // Initializing registers
mov     eax, 0 ; // i
mov     esi, 1 ; // j
mov		ebx, 0 ; // bh - num_i, bl - num_j

soloop:
	mov esi, eax
	inc esi
  siloop:
	mov ecx, 0
	mov cl, [ebp + eax]
	mov bh, (Node_S PTR [edi + ecx * TYPE Node_S]).info.num ; // num[i]

	mov ecx, 0
	mov cl, [ebp + esi]
	mov bl, (Node_S PTR [edi + ecx * TYPE Node_S]).info.num ; // num[j]

	.IF(bh < bl)
		mov bl, [ebp + esi]
		xchg bl, [ebp + eax]
		mov [ebp + esi], bl
	.ENDIF
	inc    esi
	mov ecx, esi
	cmp    cl, dl
	jbe siloop

inc   eax
cmp   al, dl
jb   soloop

fin:

; // Restoring used registers
pop ebp
pop   edi
pop   esi
pop   edx
pop   ecx
pop   ebx
pop   eax

ret
TempSort ENDP


END
