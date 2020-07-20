INCLUDE "EMU8086.INC"
.MODEL SMALL
.STACK 100H
.DATA 
    A DW 0
    B DW 1
    C DW 0  
    SUM DW 1 
    
    INPUT DB 'INPUT : $'
    PRINT1 DB '0 1$' 
    SUMMATION DB 'SUMMATION : $' 
    SPACE DB ' $'  
    FIBONACCI DB 'FIBONACCI SERIES : $'
    
    

.CODE
MAIN PROC  
     MOV AX,@DATA
     MOV DS,AX
    
     LEA DX,INPUT   
     MOV AH,9
     INT 21H
      
     CALL DECIMEL_INPUT
     MOV CX,AX
     SUB CX,2
      
     CALL NEWLINE 
     CALL NEWLINE
     
     LEA DX,FIBONACCI
     MOV AH,9
     INT 21H
     
     CALL NEWLINE
  
     LEA DX,PRINT1  ;initially print kore dilam 0 1
     MOV AH,9
     INT 21H    
     
     MOV AX,A        ;AX=A=0 initially
     
     LEA DX,SPACE
     MOV AH,9
     INT 21H
     
     FIBONACCI_FOR:
                  MOV AX,C   ;RESET AX IN EVERY TIME LOOPING
                  
                  ADD AX,B   ;AX = AX + B
                  MOV DX,AX  ;DX = AX (SUM OF 2 PREVIOUS DIGITS)  
                  ADD SUM,DX
                  
      
                  MOV AX,B   ;fixt new AX & B --> AX=B
                  MOV B,DX                       ;B=DX
                  
                  MOV C,AX   ;AX change naa hoi sei jonnno C tee dhore rakhlam
                  
                  MOV AX,DX   ;SUM taa print korlam
                  PUSH AX
                  POP AX 
                  CALL DECIMEL_OUTPUT
                  
                  LEA DX,SPACE
                  MOV AH,9
                  INT 21H 
                  
                  CMP CX,1
                  JE SUM_PRINT
                  LOOP FIBONACCI_FOR 
                  
     SUM_PRINT:
             CALL NEWLINE
             CALL NEWLINE 
             
             LEA DX,SUMMATION
             MOV AH,9
             INT 21H
             
             MOV AX,SUM
             PUSH AX
             POP AX
             CALL DECIMEL_OUTPUT             
 
     

     EXIT:
     MOV AH,4CH
     INT 21H
MAIN ENDP 
     
         
     DECIMEL_INPUT PROC
        
            PUSH BX
            PUSH CX
            PUSH DX
        
        @BEGIN:
              XOR BX,BX ;BX=TOTAL
              XOR CX,CX ;CX HOLDS SIGN
              
              MOV AH,1 ;READ A CHARACTER
              INT 21H  ;CHARACTER IN AL
              
              CMP AL,'-'
              JE @MINUS
              
              CMP AL,'+'
              JE @PLUS
              JMP @REPEAT2
              
        @MINUS:
              MOV CX,1
              
        @PLUS:
             INT 21H
             
        @REPEAT2:
                CMP AL,'0'
                JNGE @NOT_DIGIT ;if(AL>=0 && AL<=0)
                
                CMP AL,'9'
                JNLE @NOT_DIGIT  
                
                AND AX,000FH ; CONVERT TO DIGIT
                PUSH AX
                
                MOV AX,10  ;GET 10
                MUL BX     ;TOTAL = TOTAL * 10
                POP BX     ;RETRIEVE DIGIT
                ADD BX,AX  ;TOTAL = TOTAL * 10 + DIGIT
                
                MOV AH,1
                INT 21H
                CMP AL,0DH ;CARRIAGE RETURN
                JNE @REPEAT2
                
                
              MOV AX,BX ;STORE NUM IN AX
              
              ;if(cx is negative)
              OR CX,CX 
              JE @EXIT  
                                   
              NEG AX
              ;end if  
              
         @EXIT:
              POP DX
              POP CX
              POP BX
              RET
              
         @NOT_DIGIT:
                   MOV AH,2    ;NEW LINE
                   MOV DL,13
                   INT 21H
                   MOV DL,10
                   INT 21H
                   JMP @BEGIN 
                  
     DECIMEL_INPUT ENDP
     
     


     DECIMEL_OUTPUT PROC
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        
     ;if AX<0
        OR AX,AX     ;AX < 0
        JGE @END_IF1 ;NO , > 0
     ;Then
        PUSH AX   ;SAVE NUMBER
        MOV DL,'-'
        MOV AH,2
        INT 21H
        POP AX
        NEG AX                
        
        @END_IF1:
                XOR CX,CX ;CX Counts digits
                MOV BX,10D ;BX has dividor
                
        @REPEAT1:
                XOR DX,DX
                DIV BX    ;AX=quotient , DX = Remainder
                PUSH DX   ;Save remainder on stack
                INC CX
                
                OR AX,AX
                JNE @REPEAT1 
                
         ;convert digits to character and print
                 
                   MOV AH,2
         @PRINT_LOOP:
                    POP DX
                    OR DL,30H
                    INT 21H
                    LOOP @PRINT_LOOP  
                    
                    POP DX
                    POP CX
                    POP BX
                    POP AX 
                    
                    
                    RET
                    
     DECIMEL_OUTPUT ENDP 
     
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

END MAIN