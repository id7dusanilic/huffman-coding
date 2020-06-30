include Irvine32.inc
include prototypes.inc
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


FormTree PROC, input: 	PTR Data_S, \
len : BYTE, \
	output : PTR Node_S

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
xor ebx, ebx; // counter in output array, set to 0
mov edx, ebx

movzx ecx, Data_S PTR[esi]
mov(Node_S PTR[edi + ebx * TYPE Node_S]), 0
mov(Node_S PTR[edi + ebx * TYPE Node_S]).info, cx
mov(Node_S PTR[edi + ebx * TYPE Node_S]).left, NUL
mov(Node_S PTR[edi + ebx * TYPE Node_S]).right, NUL
movzx eax, (Data_S PTR[esi]).num
add esi, TYPE Data_S
inc dh
inc ebx

mov cx, Data_S PTR[esi]
mov(Node_S PTR[edi + ebx * TYPE Node_S]), 0
mov(Node_S PTR[edi + ebx * TYPE Node_S]).info, cx
mov(Node_S PTR[edi + ebx * TYPE Node_S]).left, NUL
mov(Node_S PTR[edi + ebx * TYPE Node_S]).right, NUL
add al, (Data_S PTR[esi]).num
add esi, TYPE Data_S
inc dh
inc ebx

mov(Node_S PTR[edi + ebx * TYPE Node_S]), 0
mov(Node_S PTR[edi + ebx * TYPE Node_S]).info.num, al
mov(Node_S PTR[edi + ebx * TYPE Node_S]).left, 0
mov(Node_S PTR[edi + ebx * TYPE Node_S]).right, 1

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
cmp(Node_S PTR[esi]).info.num, ah
jns noswap
cmp(Node_S PTR[edi + ecx * TYPE Node_S]).info.num, ah
jns noswap

movzx ecx, Data_S PTR[esi]
mov(Node_S PTR[edi + ebx * TYPE Node_S]), 0
mov(Node_S PTR[edi + ebx * TYPE Node_S]).info, cx
mov(Node_S PTR[edi + ebx * TYPE Node_S]).left, NUL
mov(Node_S PTR[edi + ebx * TYPE Node_S]).right, NUL
add esi, TYPE Data_S
inc dh

pop cx
dec dl
xchg[esp], cx
push bx
inc dl
inc ebx
jmp swap

noswap :
pop cx
dec dl
swap :
movzx ax, (Node_S PTR[edi + ecx * TYPE Node_S]).info.num
mov(Node_S PTR[edi + ebx * TYPE Node_S]).left, cl
pop cx
dec dl
add al, (Node_S PTR[edi + ecx * TYPE Node_S]).info.num
mov(Node_S PTR[edi + ebx * TYPE Node_S]).info.num, al
mov(Node_S PTR[edi + ebx * TYPE Node_S]).right, cl
push bx
inc dl
inc ebx
jmp bottom
elif :
inc dh
cmp dh, len
jz els
dec dh
mov cx, [esp]
movzx eax, (Node_S PTR[edi + ecx * TYPE Node_S]).info.num
cmp(Data_S PTR[esi + TYPE Data_S]).num, al
js lesser; // a[i+1] < stack.top()
mov cx, Data_S PTR[esi]
mov(Node_S PTR[edi + ebx * TYPE Node_S]).info, cx
mov(Node_S PTR[edi + ebx * TYPE Node_S]).left, NUL
mov(Node_S PTR[edi + ebx * TYPE Node_S]).right, NUL
movzx eax, (Data_S PTR[esi]).num
add esi, TYPE Data_S
inc dh
inc ebx

mov cl, bl
dec cl
mov(Node_S PTR[edi + ebx * TYPE Node_S]), 0
mov(Node_S PTR[edi + ebx * TYPE Node_S]).left, cl

pop cx
dec dl
add al, (Node_S PTR[edi + ecx * TYPE Node_S]).info.num
mov(Node_S PTR[edi + ebx * TYPE Node_S]).info.num, al
mov(Node_S PTR[edi + ebx * TYPE Node_S]).right, cl
push bx
inc dl
inc ebx
jmp bottom
lesser :
movzx ecx, Data_S PTR[esi]
mov(Node_S PTR[edi + ebx * TYPE Node_S]), 0
mov(Node_S PTR[edi + ebx * TYPE Node_S]).info, cx
mov(Node_S PTR[edi + ebx * TYPE Node_S]).left, NUL
mov(Node_S PTR[edi + ebx * TYPE Node_S]).right, NUL
movzx eax, (Data_S PTR[esi]).num
add esi, TYPE Data_S
inc dh
inc ebx

mov cx, Data_S PTR[esi]
mov(Node_S PTR[edi + ebx * TYPE Node_S]), 0
mov(Node_S PTR[edi + ebx * TYPE Node_S]).info, cx
mov(Node_S PTR[edi + ebx * TYPE Node_S]).left, NUL
mov(Node_S PTR[edi + ebx * TYPE Node_S]).right, NUL
add al, (Data_S PTR[esi]).num
add esi, TYPE Data_S
inc dh
inc ebx

mov(Node_S PTR[edi + ebx * TYPE Node_S]), 0
mov(Node_S PTR[edi + ebx * TYPE Node_S]).info.num, al
mov al, bl
dec al
mov(Node_S PTR[edi + ebx * TYPE Node_S]).right, al
dec al
mov(Node_S PTR[edi + ebx * TYPE Node_S]).left, al

push bx
inc ebx
inc dl
jmp bottom
els :
dec dh
movzx ecx, Data_S PTR[esi]
mov(Node_S PTR[edi + ebx * TYPE Node_S]), 0
mov(Node_S PTR[edi + ebx * TYPE Node_S]).info, cx
mov(Node_S PTR[edi + ebx * TYPE Node_S]).left, NUL
mov(Node_S PTR[edi + ebx * TYPE Node_S]).right, NUL
movzx eax, (Data_S PTR[esi]).num
add esi, TYPE Data_S
inc dh
inc ebx

pop cx
dec dl
mov(Node_S PTR[edi + ebx * TYPE Node_S]), 0
add al, (Node_S PTR[edi + ecx * TYPE Node_S]).info.num
mov(Node_S PTR[edi + ebx * TYPE Node_S]).info.num, al
mov eax, ebx
dec eax
mov(Node_S PTR[edi + ebx * TYPE Node_S]).right, al
mov(Node_S PTR[edi + ebx * TYPE Node_S]).left, cl
inc dh
bottom :
cmp dh, len
js outerloop

mov eax, ebx

pop edi
pop esi
pop edx
pop ecx
pop ebx
ret
FormTree ENDP


END