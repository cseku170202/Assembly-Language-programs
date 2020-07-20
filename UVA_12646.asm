;UVA 12646
;Zero or One
.MODEL SMALL
.STACK 100H
.DATA 
     A DW ?
     B DW ?
     C DW ?  
     INPUT DB 'INPUT : $'
     OUTPUT DB 'OUTPUT : $' 
     SUM DB 'SUM : $'  
     TEMP DB ?  
     PRINT1 DB 'A $'
     PRINT2 DB 'B $'
     PRINT3 DB 'C $'
     PRINT4 DB '* $'
.CODE
MAIN PROC 
     MOV AX,@DATA
     MOV DS,AX  
     
     TOP:
     
     LEA DX,INPUT
     MOV AH,9
     INT 21H  
     CALL NEWLINE
      
     CALL DECIMEL_INPUT    ;input A
     MOV A,AX
     CALL NEWLINE
     
     CALL DECIMEL_INPUT    ;input B
     MOV B,AX
     CALL NEWLINE
     
     CALL DECIMEL_INPUT    ;input C
     MOV C,AX
     CALL NEWLINE
     
     MOV AX,A     ;AX=A
     MOV BX,B     ;BX=B
     MOV CX,C     ;CX=C 
     
  ;IF BLOCK            if(A==B && C!=A && C!=B)
     CMP AX,BX         ; then print C
     JE CHECK1
     JMP ELSE_IF_ONE
     
        CHECK1:
              CMP CX,AX
              JNE CHECK11
              JMP ELSE_IF_ONE
              
        CHECK11:
              CMP CX,BX
              JNE PRINT_C
              JMP ELSE_IF_ONE
              
        PRINT_C:
              LEA DX,PRINT3
              MOV AH,9
              INT 21H
              JMP END_WORK  
  ;END OF IF    
          
  ;ELSE IF ONE STARTS    ;else if(B==C && A!=B && A!=C)         
     ELSE_IF_ONE:        ; then print A
     CMP BX,CX
     JE CHECK2
     JMP ELSE_IF_TWO
     
        CHECK2:
              CMP AX,BX
              JNE CHECK22
              JMP ELSE_IF_TWO
              
        CHECK22:
              CMP AX,CX
              JNE PRINT_A
              JMP ELSE_IF_TWO
              
        PRINT_A:
              LEA DX,PRINT1
              MOV AH,9
              INT 21H
              JMP END_WORK 
   ;END OF ELSE IF ONE           
              
   ;ELSE IF TWO STARTS     ;else if(C==A && B!=C && B!=A)      
     ELSE_IF_TWO:          ; then print B
     CMP CX,AX
     JE CHECK3
     JMP ELSE
     
        CHECK3:
              CMP BX,CX
              JNE CHECK33
              JMP ELSE
              
        CHECK33:
              CMP BX,AX
              JNE PRINT_B
              JMP ELSE
              
        PRINT_B:
              LEA DX,PRINT2
              MOV AH,9
              INT 21H
              JMP END_WORK 
  ;END OF ELSE IF TWO            
                     
  ;ELSE STARS            ;else        
      ELSE:              ; print *
          LEA DX,PRINT4
          MOV AH,9
          INT 21H
          JMP END_WORK 
  ;END OF ELSE        
          
      END_WORK:
              CALL NEWLINE  
              JMP TOP            
                                                    
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