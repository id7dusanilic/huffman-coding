.386
.model flat, stdcall
.stack 4096
ExitProcess proto, dwExitCode:dword

include structures.inc

FormTree PROTO,	input: 	PTR Data_S, \
		len: 	BYTE, \
		output: PTR Node_S

.data
len		BYTE	8
input	Data_S <'z', 2>, <'k', 7>, <'m', 24>, <'c', 32>, <'u', 37>, <'d', 42>, <'l', 42>, <'e', 120>
output Node_S 15 DUP(<>)

.code
    main PROC

	INVOKE FormTree, OFFSET input, len, OFFSET output

    INVOKE ExitProcess, 0
    main ENDP
end main
