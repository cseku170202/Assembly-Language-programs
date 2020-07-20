;UVA 12478
;Hardest Problem Ever (Easy)
.MODEL SMALL
.STACK 100H
.DATA 
    PRINT DB 'KABIR $'
.CODE
MAIN PROC 
     MOV AX,@DATA
     MOV DS,AX 
     
     LEA DX,PRINT
     MOV AH,9
     INT 21H  
     
     MOV AH,2
     MOV DL,10
     INT 21H
     MOV DL,13
     INT 21H

     EXIT:
     MOV AH,4CH
     INT 21H
MAIN ENDP 
END MAIN