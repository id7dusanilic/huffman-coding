include structures.inc

.code

BUFFER_SIZE = 256 ; // Maximum number of characters that can be read
MAX_LEN     = 256 ; // Maximum length of freq array

ReadText PROTO,
  Name:     PTR BYTE,      ; // Pointer to File Name
  Content:  PTR BYTE,      ; // Pointer to File Content
  Len:      DWORD           ; // Number of characters read from a file

Count PROTO,
  Content:  PTR BYTE,      ; // Pointer to String
  Freq:     PTR BYTE,      ; // Pointer to array containing frequency of each character
  Len:      DWORD           ; // Number of different characters in Contents String

Sort PROTO,
  Array:    PTR Data_S,    ; // Pointer to array to be sorted
  Len:      BYTE           ; // Length of array to be sorted


MakeArray PROTO,
  Freq:     PTR BYTE,      ; // Pointer to array containing frequency of each character
  Result:   PTR Data_S,    ; // Pointer to resulting array
  Len:      BYTE           ; // Length of freq array
