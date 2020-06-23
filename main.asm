.386
.model flat, stdcall
.stack 4096
ExitProcess proto, dwExitCode:dword
include Irvine32.inc
include hcarray.inc

.data?
  FileHandle        DWORD ?
  FileContent       BYTE  BUFFER_SIZE DUP(?)
  CharactersRead    DWORD  ? ; // Number of characters read from a file

.data
  FileName          BYTE  "example.txt",0
  FileOpenErrMsg    BYTE  "Error occurred while opening file.", 0
  FileReadErrMsg    BYTE  "Error occurred while reading file.", 0

.code
  main proc
    mov   edx, OFFSET FileName
    call  OpenInputFile
    .IF eax == INVALID_HANDLE_VALUE
      mov   edx, OFFSET FileOpenErrMsg
      call  WriteString
      jmp   end_label
    .ELSE
      mov   FileHandle, eax ; // File handle is stored in eax after calling OpenInputFile
      mov   edx, OFFSET FileContent
      mov   ecx, BUFFER_SIZE
      mov   eax, FileHandle
      call  ReadFromFile
      jc    reading_error ; // Carry Flag is set if an error occurred while reading_error
      mov   CharactersRead, eax
      ; // Terminating string with "\0"
      add   edx, CharactersRead
      mov   BYTE PTR [edx], 0
      ; // Closing the file
      mov   eax, FileHandle
      call  CloseFile
      ; // Checking if reading was successful
      mov edx, OFFSET FileContent
      call WriteString
    .ENDIF
reading_error:
  mov   edx, OFFSET FileReadErrMsg
  call  WriteString
end_label:

  call ExitProcess
  main endp
END main
