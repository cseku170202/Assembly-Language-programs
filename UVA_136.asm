;UVA 136
;UGLY NUMBER
.MODEL SMALL
.STACK 100H
.DATA 
    PRINT DB 'The 1500$'
    PRINT1 DB 'th ugly number is 859963392.$'
.CODE
MAIN PROC 
     MOV AX,@DATA
     MOV DS,AX 

     LEA DX,PRINT
     MOV AH,9
     INT 21H
     
     MOV AH,2
     MOV DL,"'"
     INT 21H
     
     LEA DX,PRINT1
     MOV AH,9
     INT 21H
    
     EXIT:
     MOV AH,4CH
     INT 21H
MAIN ENDP 
     
