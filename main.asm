.386
.model flat, stdcall
.stack 4096
ExitProcess proto, dwExitCode:dword

include Irvine32.inc
include hcarray.inc

.data?
FileHandle        DWORD		?
CharactersRead    DWORD		?
DiffCharacters		DWORD		?
FileName					BYTE		MAX_LEN				DUP(?)
FileContent       BYTE		BUFFER_SIZE 	DUP(?)
Freq							BYTE		MAX_LEN				DUP(0)
Result						Data_S	MAX_LEN				DUP(<>)

.data
;FileName					 BYTE  "example.txt", 0
InputMsg					BYTE  "Please enter the file name: ",0

.code

main PROC

; // Printing input message
mov			edx, OFFSET InputMsg
call		WriteString

; // Reading file name
mov 		ecx, BUFFER_SIZE-1
mov 		edx, OFFSET FileName
call		ReadString

; // Reading the file, file content is stored in FileContent. Length of content
; // is stored in eax register
INVOKE 	ReadText, OFFSET FileName, OFFSET FileContent
mov 		CharactersRead, eax

; // Counting how many times each character from ASCII table appeared in content
; // The number is stored in Freq, where index in the array corresponds to ASCII
; // code of each character
INVOKE 	Count, OFFSET FileContent, OFFSET Freq, CharactersRead

; // Removing characters that didn't appear in the content, and making a new
; // array, where a character and is frequency is stored (Data_S struct).
; // Number of different characters that appear at least once is stored in eax.
INVOKE 	Trim, OFFSET Freq, OFFSET Result
mov 		DiffCharacters, eax

; // Sorting the array in ascending order by the frequency of characters
INVOKE 	Sort, OFFSET Result, DiffCharacters

; // Prints the resulting array in format <char - frequency>
INVOKE 	PrintResults, OFFSET Result, DiffCharacters

main ENDP

INVOKE ExitProcess, 0
END main
