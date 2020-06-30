ifndef _FILE_PROCESS_INC_
_FILE_PROCESS_INC_ = 0

.model flat, stdcall

include structures.inc
include configuration.inc

.code

; // Reads file with FileName and stores its content in Content
ReadText PROTO,\
  FileName: PTR BYTE,\    ; // Pointer to File Name
  Content:	PTR BYTE      ; // Pointer to File Content

; // Counts the number of times each ASCII table appears in Content
Count PROTO,\
  Content:  PTR BYTE,\    ; // Pointer to String
  Freq:     PTR BYTE,\    ; // Pointer to array containing frequency of each character
  Len:      DWORD         ; // Length of Content string

; // Removes chars that don't appear at least once in the content, and forms a
; // new array containing each of the remaining character's frequency
Trim PROTO,\
  Freq:     PTR BYTE,\    ; // Pointer to array containing frequency of each char
  Chars:    PTR Data_S		; // Pointer to array of chars that appear at least once

; // Sorts the array in ascending order by frequency of characters
Sort PROTO,\
  Array:    PTR Data_S,\	; // Pointer to array to be sorted
  Len:      DWORD			    ; // Length of array to be sorted

; // Prints the resulting array in format <char - frequency>
PrintResults PROTO,\
  Result:   PTR Data_S,\	; // Pointer to resulting array
  Len:      DWORD			    ; // Length of resulting array

  endif