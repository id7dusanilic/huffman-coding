.386
.model flat, stdcall
.stack 4096
ExitProcess proto, dwExitCode:dword

include Irvine32.inc
include prototypes.inc

.data
len		BYTE	8
input	Data_S <'z', 2>, <'k', 7>, <'m', 24>, <'c', 32>, <'u', 37>, <'d', 42>, <'l', 42>, <'e', 120>
nodes Node_S 15 DUP(<>)

.data?
Array	BYTE	MAX_DEPTH DUP(?)

.code
    main PROC

	INVOKE FormTree, OFFSET input, len, OFFSET nodes
	INVOKE PrintCodes, OFFSET nodes, 14, OFFSET Array, 0

    INVOKE ExitProcess, 0
    main ENDP
end main
