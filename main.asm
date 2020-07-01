.386
.model flat, stdcall
.stack 4096
ExitProcess proto, dwExitCode:dword

include Irvine32.inc
include file_process.inc
include huffman_tree.inc
include configuration.inc

.data?
FileHandle			DWORD		?	; // Handle to input file
CharactersRead		DWORD		?	; // Number of characters read from the input file
DiffCharacters		DWORD		?	; // Number of different characters read from the input file
FileName			BYTE		MAX_LEN			DUP(?)	; // Holds the name of the file
FileContent			BYTE		BUFFER_SIZE 	DUP(?)	; // Holds the content of the file
ProcessedInput		Data_S		MAX_LEN			DUP(<>)	; // Array that holds a character and its frequency
Array				BYTE		MAX_DEPTH		DUP(?)	; // Auxiliary array (used to temporarily store a code)
RootIndex			DWORD		?	; // Index of root node in the Huffman tree (stored in array)

.data
InputMsg			BYTE		"Please enter the file name: ", 0
ExitMsg				BYTE		10, "Press ENTER to exit ...", 0
TitleBar			BYTE		"Symbol", 9, "Frequency", 9, "Code", 0
Freq				BYTE		MAX_LEN			DUP(0)	; // Holds frequency of each character
HuffmanTree			Node_S		MAX_LEN			DUP(<>)	

.code

main PROC

; // Printing input message
mov		edx, OFFSET InputMsg
call	WriteString

; // Reading file name
mov 	ecx, BUFFER_SIZE-1
mov 	edx, OFFSET FileName
call	ReadString

; // Reading the file, file content is stored in FileContent. Length of content
; // is stored in eax register
INVOKE 	ReadText, OFFSET FileName, OFFSET FileContent
mov 	CharactersRead, eax

; // Counting how many times each character from ASCII table appeared in content
; // The number is stored in Freq, where index in the array corresponds to ASCII
; // code of each character
INVOKE 	Count, OFFSET FileContent, OFFSET Freq, CharactersRead

; // Removing characters that didn't appear in the content, and making a new
; // array, where a character and is frequency is stored (Data_S struct).
; // Number of different characters that appear at least once is stored in eax.
INVOKE 	Trim, OFFSET Freq, OFFSET ProcessedInput
mov 	DiffCharacters, eax

; // Sorting the array in ascending order by the frequency of characters
INVOKE 	Sort, OFFSET ProcessedInput, DiffCharacters

; // Prints the resulting array in format <char - frequency>
; INVOKE 	PrintResults, OFFSET ProcessedInput, DiffCharacters

; // Forming the Huffman tree. Number of nodes in Huffman tree is stored in eax
INVOKE	FormTree, OFFSET ProcessedInput, BYTE PTR DiffCharacters, OFFSET HuffmanTree
mov		RootIndex, eax

; // Printing the title
mov		al, 10
call	WriteChar
mov		edx, OFFSET TitleBar
call	WriteString
mov		al, 10
call	WriteChar

; // Printing results
INVOKE	PrintCodes, OFFSET HuffmanTree, RootIndex, OFFSET Array, 0


mov		edx, OFFSET ExitMsg
call	WriteString

mov 	ecx, 1
mov 	edx, OFFSET FileName
call	ReadString

INVOKE ExitProcess, 0
main ENDP

END main
