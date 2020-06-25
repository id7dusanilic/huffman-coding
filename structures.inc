; // Holds a symbol (character) and its frequency
Data_S STRUCT
  sym  BYTE ?
  num  BYTE ?
Data_S ENDS

; // Huffman tree node
Node_S STRUCT
  info 	Data_S ?
  left 	BYTE 0
  right BYTE 0
Node_S ENDS	
