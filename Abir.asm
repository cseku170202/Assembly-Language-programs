
.MODEL SMALL
.STACK 100H
.DATA
     X DW ?
     Y DB 0
     
     
.CODE  
MAIN PROC 
    MOV AX,@DATA
    MOV DS,AX 
    
    CALL INPUT_TAKEN
    CALL OUTPUT_SHOW  
    
    MOV AH,4CH
    INT 21H
MAIN ENDP    
 
    
   
INPUT_TAKEN PROC  
      MOV BX,0 
   
      INPUT:
           MOV AH,1
           INT 21H
           CMP AL,13
           JNE NUMBER 
           MOV AX,BX
           JMP END_TAKEN_INPUT

   
      NUMBER:
            SUB AL,48
            MOV AH,0
            MOV X,AX  ;inserted digit
            MOV AX,BX
            MOV CL,10
            MOV CH,0
            MUL CX 
    
            MOV DH,0   
            ADD AX,X   ;adding with prev
            MOV BX,AX
            JMP INPUT 
     
              
      END_TAKEN_INPUT: 
                    RET  
                    
                       
INPUT_TAKEN ENDP
                
                
  
 
OUTPUT_SHOW PROC
 
   LABEL1:
         AND DX,0
         MOV CX,10
         DIV CX
         PUSH DX
         INC Y
         CMP AX,0
         JE NEWLINE
   
         JMP LABEL1
      
         NEWLINE:
         MOV AH,2
         MOV DL,0AH
         INT 21H
         MOV DL,0DH 
         INT 21H
         MOV CL,Y
         JMP PRINT
   
   
   
   PRINT:
   
        MOV AH,2
        POP DX
        ADD DL,48
        INT 21H
        LOOP PRINT 
      RET
OUTPUT_SHOW ENDP
   
   
END MAIN          
       
       
