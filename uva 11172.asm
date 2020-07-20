.MODEL SMALL
.STACK 100H
.DATA
MSG1 DB '> $'
MSG2 DB '< $'
MSG3 DB '= $'
.CODE
MAIN PROC
    MOV AX,@DATA
    MOV DS,AX
    
    MOV AH,1
    INT 21H
    MOV BL,AL 
    SUB BL,48
    
    INT 21H
    MOV AL,32
    
    INT 21H
    MOV CL,AL
    SUB CL,48 
     
    CMP BL,CL
    JGE L1 
    
    MOV AH,2
    MOV DL,10
    INT 21H
    MOV DL,13
    INT 21H
    
    LEA DX,MSG2
    MOV AH,9
    INT 21H
    JMP EXIT
    
    L1:
    CMP BL,CL
    JE L2  
    
    MOV AH,2
    MOV DL,10
    INT 21H
    MOV DL,13
    INT 21H
    
    
    LEA DX,MSG1
    MOV AH,9
    INT 21H
    JMP EXIT
    
    L2:
    MOV AH,2
    MOV DL,10
    INT 21H 
    MOV DL,13
    INT 21H
        
    LEA DX,MSG3
    MOV AH,9
    INT 21H
    JMP EXIT
    
    
    EXIT:
    MOV AH,4CH
    INT 21H
MAIN ENDP
END MAIN