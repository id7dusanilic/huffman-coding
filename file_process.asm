include Irvine32.inc
include file_process.inc

.data
FileOpenErrMsg		BYTE  "Error occurred while opening file.", 0
FileReadErrMsg		BYTE  "Error occurred while reading file.", 0
Separator			BYTE  " - ", 0

.code

; //============================================================================

ReadText PROC,\
FileName:	PTR BYTE,\		; // Pointer to File Name
Content:	PTR BYTE		; // Pointer to File Content

; //============================================================================
LOCAL FileHandle: DWORD, Len: DWORD

; // Saving used registers
push	edx
push	ecx

mov		edx,  FileName
call	OpenInputFile
.IF (eax == INVALID_HANDLE_VALUE)
	mov		edx, OFFSET FileOpenErrMsg
	call	WriteString
	jmp		end_label
.ELSE
; // File handle is stored in eax after calling OpenInputFile
	mov		FileHandle, eax
	mov		edx, Content
	mov		ecx, BUFFER_SIZE
	mov		eax, FileHandle
	call	ReadFromFile
; // Carry Flag is set if an error occurred while reading_error
	jc		reading_error
	mov		Len, eax
; // Terminating string with "\0"
	add		edx, Len
	mov		BYTE PTR[edx], 0
; // Closing the file
	mov		eax, FileHandle
	call	CloseFile
.ENDIF
; // Storing Length to eax register
mov		eax, Len

; // Restoring used registers
pop		ecx
pop		edx
jmp		return_label

reading_error :
mov		edx, OFFSET FileReadErrMsg
call	WriteString
end_label:
INVOKE ExitProcess, -1

return_label:
ret
ReadText ENDP

; //============================================================================

Count PROC,\
  Content:  PTR BYTE,\		; // Pointer to String
  Freq:     PTR BYTE,\		; // Pointer to array containing freq of each char
  Len:      DWORD		    ; // Length of Content string

; //============================================================================

; // Saving used registers
push	ecx
push	esi
push	edi
push	edx
push	eax

; // Initializing registers
mov		esi, Content
mov		edi, Freq
mov		ecx, Len

l1:
; // Getting the char - index
movzx	eax, BYTE PTR [esi]
; // Adding starting adress
add		eax, edi
; // Incrementing the count for current char
mov		edx, [eax]
inc		edx
mov		[eax], edx
; // Moving to next char
inc		esi
loop	l1

; // Restoring used registers
pop		eax
pop		edx
pop		edi
pop		esi
pop		ecx

ret
Count ENDP

; //============================================================================

Trim PROC,\
Freq:     PTR BYTE,\		; // Pointer to array containing freq of each character
Chars:    PTR Data_S		; // Pointer to array of chars that appear at least once

; //============================================================================

; // Saving used registers
push	edx
push	edi
push	esi
push	ecx

; // Initializing registers
mov		edi, Chars
mov		esi, Freq
mov		ecx, 0
mov		edx, 0

l2:
; // Getting frequency of current char
movzx	eax, BYTE PTR[esi]
.IF(eax != 0)
; // If char appears at least once, save it and its frequency to array
	mov		eax, ecx
	mov		(Data_S PTR[edi]).sym, al
	mov		al, BYTE PTR[esi]
	mov		(Data_S PTR[edi]).num, al
	add		edi, TYPE Data_S
	inc		edx
.ENDIF
inc		esi
inc		ecx
cmp		ecx, MAX_LEN
jne		l2

; // Saves number of different characters
mov		eax, edx

; // Restoring used registers
pop		ecx
pop		esi
pop		edi
pop		edx

ret
Trim ENDP

; //============================================================================

Sort PROC, \
Array:    PTR Data_S,\  ; // Pointer to array to be sorted
Len:      DWORD         ; // Length of array to be sorted

; //============================================================================

LOCAL n: DWORD

; // Saving used registers
push	eax
push	ebx
push	ecx
push	edx
push	esi
push	edi

; // Initializing registers
mov		eax, Len
dec		eax
mov		n, eax
mov     eax, 0
mov		ebx, 0
mov		ecx, 0
mov		esi, Array

outloop:
mov		eax, 0
mov		edi, esi
mov		edx, ecx
mov		al, (Data_S PTR [esi]).num
	inloop:
	mov		ebx, 0
	add		edi, TYPE Data_S
	mov		bl, (Data_S PTR [edi]).num
	.IF(eax > ebx)
		mov		bx, (Data_S PTR[esi])
		xchg	bx, (Data_S PTR[edi])
		xchg	bx, (Data_S PTR[esi])
		mov		al, (Data_S PTR[esi]).num
	.ENDIF
	inc		edx
	cmp		edx, n
	jne		inloop
add		esi, TYPE Data_S
inc		ecx
cmp		ecx, n
jne		outloop

; // Restoring used registers
pop		edi
pop		esi
pop		edx
pop		ecx
pop		ebx
pop		eax

ret
Sort ENDP


; //============================================================================

PrintResults PROC,\
Result:		PTR Data_S,\      ; // Pointer to resulting array
Len:		DWORD             ; // Length of resulting array

; //============================================================================

; // Initializing registers
mov		ecx, Len
mov		edi, Result
print_loop :
	mov		al, (Data_S PTR[edi]).sym
	call	WriteChar
	mov		edx, OFFSET Separator
	call	WriteString
	mov		al, (Data_S PTR[edi]).num
	call	WriteDec
	mov		al, 10
	call	WriteChar
	add		edi, TYPE Data_S
	loop	print_loop

ret
PrintResults ENDP

END
