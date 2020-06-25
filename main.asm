.386
.model flat, stdcall
.stack 4096
ExitProcess proto, dwExitCode:dword

include Irvine32.inc
include prototypes.inc



.data?
Array	BYTE	MAX_DEPTH DUP(?)

.data
Nodes	Node_S	<< 'a', 5 > , NUL, NUL > , << 'b', 9 > , NUL, NUL > , <<  0 , 14 > , 0, 1 > , << 'c', 12 > , NUL, NUL > ,\
				<< 'd', 13 > , NUL, NUL > , << 0, 25 > , 3, 4 > , << 'e', 16 > , NUL, NUL > , << 0, 30 > , 2, 6 > ,\
				<< 0, 55 > , 5, 7 > , << 'f', 45 > , NUL, NUL >, << 0, 100 > , 9, 8 >

.code
    main PROC


	INVOKE PrintCodes, OFFSET Nodes, 10, OFFSET Array, 0


    INVOKE ExitProcess, 0
    main ENDP
end main
