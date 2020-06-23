include Irvine32.inc
include hcarray.inc

.code

; //============================================================================
ReadText PROC,
  Name:     PTR BYTE,      ; // Pointer to File Name
  Content:  PTR BYTE,      ; // Pointer to File Content
  Len:      DWORD           ; // Number of characters read from a file
; //============================================================================
LOCAL FileHandle: DWORD

  push edx
  push ecx
  push eax

  mov   edx, OFFSET Name
  call  OpenInputFile
  .IF eax == INVALID_HANDLE_VALUE
    mov   edx, "Error occurred while opening file."
    call  WriteString
    jmp   end
  .ELSE
    mov   FileHandle, eax ; // File handle is stored in eax after calling OpenInputFile
    mov   edx, OFFSET Content
    mov   ecx, BUFFER_SIZE
    mov   eax, FileHandle
    call  ReadFromFile
    jc    reading_error ; // Carry Flag is set if an error occurred while reading_error
    mov   Len, eax
    ; // Terminating string with "\0"
    add   edx, Len
    mov   BYTE PTR [edx], 0
    ; // Closing the file
    mov   eax, FileHandle
    call  CloseFile
    ; // Checking if reading was successful
    mov edx, OFFSET Content
    call WriteString
  .ENDIF
  reading_error:
  mov   edx, OFFSET "Error occurred while reading file."
  call  WriteString
  end:
  pop eax
  pop ecx
  pop edx

  ret
ReadText ENDP

Count PROC,
  Content:  PTR BYTE,      ; // Pointer to String
  Freq:     PTR BYTE,      ; // Pointer to array containing frequency of each character
  Len:      DWORD,         ; // Length of Content string

  push ecx
  push esi
  push edi

  mov esi, Content
  mov edi, Freq
  mov ecx, Len

  l1:
  ; // Proveriti adresiranje edi[esi]
    inc edi[esi]
    inc edi
    inc esi
  loop l1
  mov Num, eax

  pop edi
  pop esi
  pop ecx

  ret
Count ENDP

END
