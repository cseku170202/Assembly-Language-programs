;UVA 13025 
;Back to the Past
.MODEL SMALL
.STACK 100H
.DATA 
     PRINT DB 'October 30, 2015 Friday $'
.CODE
MAIN PROC 
     MOV AX,@DATA
     MOV DS,AX 
     
     LEA DX,PRINT
     MOV AH,9
     INT 21H
 
     EXIT:
     MOV AH,4CH
     INT 21H
MAIN ENDP 
END MAIN