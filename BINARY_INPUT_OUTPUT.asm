.MODEL SMALL
.STACK 100H
.DATA
    

.CODE
MAIN PROC  
    
    CALL BINARY_INPUT 
    CALL NEWLINE
    CALL BINARY_OUTPUT
    
    MOV AH,4CH
    INT 21H
MAIN ENDP    
     
BINARY_INPUT PROC
     
     XOR BX,BX
     MOV AH,1
     INT 21H
     
     WHILE:
          CMP AL,13
          JE END_WHILE
          AND AL,0FH
          SHL BX,1
          OR BL,AL
          INT 21H
          JMP WHILE
    
    
     END_WHILE:
        RET
BINARY_INPUT ENDP 

BINARY_OUTPUT PROC
       PUSH AX
       PUSH BX
       PUSH CX
       PUSH DX
       
       MOV CX,16
       FOR:
          ROL BX,1
          JC OUTPUT_ONE
          MOV AH,2
          MOV DL,'0'
          INT 21H 
          L:
       LOOP FOR
       
       CMP CX,0
       JE END_FOR
       
       OUTPUT_ONE:
                MOV AH,2
                MOV DL,'1'
                INT 21H
                JMP L   
       
       END_FOR:
    
       RET
BINARY_OUTPUT ENDP    

NEWLINE PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    MOV AH,2
    MOV DL,10
    INT 21H
    MOV DL,13
    INT 21H
    
    POP DX
    POP CX
    POP BX
    POP AX
            
    RET        
NEWLINE ENDP    
    
    
END MAIN