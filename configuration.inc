ifndef _CONF_INC_
_CONF_INC_ = 0

.model flat, stdcall

.code

BUFFER_SIZE = 255	; // Maximum number of characters that can be read
MAX_LEN     = 256	; // Maximum length of freq array
MAX_DEPTH	= 8		; // Represents maximum number of levels in Huffman Tree
NUL			= 255	; // Not a leaf

endif