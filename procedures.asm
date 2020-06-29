include Irvine32.inc
include prototypes.inc

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

END