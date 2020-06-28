include structures.inc

.code

MAX_DEPTH	= 8		; // Represents maximum number of levels in Huffman Tree
NUL			= 255	; // Not a leaf

; // Goes through Huffman Tree and prints out codes for each leaf in the Tree
; // FirstNode is pointer to the first element of the array which stores
; // the Tree. Code is an array used to store the code of current leaf. 
; // Index is the current length of the code.
PrintCodes		PROTO,\
	FirstNode:	PTR Node_S,\	; // First node pointer 
	Dist:		DWORD,\			; // Distance from first element in Nodes array
	Code:		PTR BYTE,\		; // Array containing code for a leaf
	Index:		DWORD			; // Current index in Code array 
