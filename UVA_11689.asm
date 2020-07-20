;UVA 11689
;Soda Surpler 
.MODEL SMALL
.STACK 100H
.DATA 
     T DW ?
     E DW ?
     F DW ?
     C DW ? 
     I DW ?
     ANS DW ?  
     R DW ?
     REMAINDER DW ?
     INPUT DB 'INPUT : $'
.CODE
MAIN PROC 
     MOV AX,@DATA
     MOV DS,AX 
     
     CALL DECIMEL_INPUT    ;input test case T
     MOV T,AX
     CALL NEWLINE
     
     MOV I,0    ;for(i=0;i<T;i++)
     MOV AX,I
     CMP AX,T
     JL TOP
     JMP EXIT
     
     TOP:
                     
     LEA DX,INPUT
     MOV AH,9
     INT 21H  
     CALL NEWLINE
     
     CALL DECIMEL_INPUT   ;input E
     MOV E,AX
     CALL NEWLINE 
     
     CALL DECIMEL_INPUT   ;input F
     MOV F,AX
     CALL NEWLINE
     
     CALL DECIMEL_INPUT   ;input C
     MOV C,AX
     CALL NEWLINE
     
     MOV AX,E
     ADD AX,F  ;e=e+f 
     MOV E,AX
     MOV ANS,0 ;ans=0
     
     MOV AX,E
     CMP AX,C
     JGE WHILE
     JMP PRINT
     
     WHILE:                 ;while(e>=c)
          XOR DX,DX
          MOV AX,E
          MOV BX,C
          DIV BX  
          
          MOV REMAINDER,DX  ;remainder=e/c
          MOV R,AX          ;r=e%c
          
          ADD AX,ANS        ;ans=ans+e/c
          MOV ANS,AX   
          
          MOV AX,R          ;e=e%c+e/c
          ADD AX,REMAINDER
          MOV E,AX
          
          CMP AX,C
          JGE WHILE   
          
     PRINT:                ;print ans
          MOV AX,ANS
          PUSH AX
          POP AX
          CALL DECIMEL_OUTPUT
          
     END_WORK:              ;continue the outer for loop
             CALL NEWLINE
             MOV ANS,0
             INC I
             MOV AX,I
             CMP AX,T
             JL TOP                 
    
     EXIT:
     MOV AH,4CH
     INT 21H
MAIN ENDP 
     
         
         
DECIMEL_INPUT PROC
        
            PUSH BX    ;SAVE THE REGISTERS
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
              MOV CX,1  ;NEGATIVE = TRUE
              
        @PLUS:
             INT 21H
             
        @REPEAT2:
                CMP AL,'0'
                JNGE @NOT_DIGIT ;if(AL>=0 && AL<=0)
                
                CMP AL,'9'
                JNLE @NOT_DIGIT  
                
                AND AX,000FH ; CONVERT TO DIGIT
                PUSH AX      ;EKTA DIGIT STACK EE SAVE KORE RAKHTESI AX DIA , ABAR PORE SETA RETRIEVE KORTESI BX DIA
                
                ;BX HOLDS THE PREVIOUS VALUE 
                ;AX HOLDS THE CURRENT VALUE
                ;AT LAST THE SUM IS IN BX
                
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
              JE @EXIT  ;POSITIVE ER JONNO EXIT EE JABE
                                   
              NEG AX    ;NEGATIVE KORE DIBE TOTAL NUMBER K JOKHON (JE) FALSE HOBE
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
                
                OR AX,AX     ;MOV AX,0
                JNE @REPEAT1 ;JNE @REPEAT1 
                
         ;convert digits to character and print
                 
                   MOV AH,2
         @PRINT_LOOP:
                    POP DX     ;LAST ER TAA AGEI PRINT HOBE. STACK ER SYSTEM ANUJAYI
                    OR DL,30H  ;ADD DL,48
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
NEWLINE ENDP 
END MAIN