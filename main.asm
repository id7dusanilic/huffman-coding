.386
.model flat, stdcall
.stack 4096
ExitProcess proto, dwExitCode:dword

include Irvine32.inc
include hcarray.inc
include prototypes.inc
include configuration.inc

.data?
FileHandle			DWORD		?	; // Handle to input file
CharactersRead		DWORD		?	; // Number of characters read from the input file
DiffCharacters		DWORD		?	; // Number of different characters read from the input file
FileName			BYTE		MAX_LEN			DUP(?)	; // Holds the name of the file
FileContent			BYTE		BUFFER_SIZE 	DUP(?)	; // Holds the content of the file
Freq				BYTE		MAX_LEN			DUP(0)	; // Holds frequency of each character
ProcessedInput		Data_S		MAX_LEN			DUP(<>)	; // Array that holds a character and its frequency
Array				BYTE		MAX_DEPTH		DUP(?)	; // Auxiliary array (used to temporarily store a code)
RootIndex			DWORD		?	; // Index of root node in the Huffman tree (stored in array)

.data
InputMsg			BYTE		"Please enter the file name: ",0
len					BYTE		8
input				Data_S		<'z', 2>, <'k', 7>, <'m', 24>, <'c', 32>, <'u', 37>, <'d', 42>, <'l', 42>, <'e', 120>
HuffmanTree			Node_S		255				DUP(<>)	

.code

main PROC

; // Printing input message
mov		edx, OFFSET InputMsg
call	WriteString

; // Reading file name
mov 	ecx, BUFFER_SIZE;-1
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
INVOKE 	PrintResults, OFFSET ProcessedInput, DiffCharacters

; // Forming the Huffman tree. Number of nodes in Huffman tree is stored in eax
INVOKE	FormTree, OFFSET ProcessedInput, BYTE PTR DiffCharacters, OFFSET HuffmanTree
; INVOKE	FormTree, OFFSET input, len, OFFSET HuffmanTree
mov		RootIndex, eax

; // Printing results
INVOKE	PrintCodes, OFFSET HuffmanTree, eax, OFFSET Array, 0

INVOKE ExitProcess, 0
main ENDP

END main
