;UVA 11727
;Cost Cutting 
.MODEL SMALL
.STACK 100H
.DATA 
     INPUT DB 'INPUT : $'
     OUTPUT DB 'OUTPUT : $' 
     MEDIAN DB 'MEDIAN : $'
     A DW ?
     B DW ?
     C DW ? 
     D DW ?
     TEMP DW ?
.CODE
MAIN PROC 
     MOV AX,@DATA
     MOV DS,AX
     
     CALL DECIMEL_INPUT
     MOV DX,AX
     MOV D,DX
     CALL NEWLINE 
     
     START:

     LEA DX,INPUT
     MOV AH,9
     INT 21H 
     CALL NEWLINE
      
     CALL DECIMEL_INPUT  ;INPUT A
     MOV A,AX
     CALL NEWLINE
     
     CALL DECIMEL_INPUT  ;INPUT B
     MOV B,AX
     CALL NEWLINE  
     
     CALL DECIMEL_INPUT  ;INPUT C
     MOV C,AX
     CALL NEWLINE     
     
     MOV AX,A     ;AX=A
     MOV BX,B     ;BX=B
     MOV CX,C     ;CX=C
     
     CMP AX,BX
     JG A_GREATER_THAN_B   ;if(A>B)
     
     CMP BX,CX
     JG B_GREATER_THAN_C   ;if(A<B && B>C)
     
     MOV AX,BX             ;if(A<B && B<C)
     PUSH AX               ;than B is the result
     POP AX 
     MOV TEMP,AX  
     
     CALL NEWLINE
     
     LEA DX,MEDIAN
     MOV AH,9
     INT 21H  
     
     MOV AX,TEMP
     CALL DECIMEL_OUTPUT 
     JMP FINISH
      
     A_GREATER_THAN_B:
                     CMP AX,CX
                     JG A_GREATER_THAN_C1 ;if(A>B && A>C)
                     
                     PUSH AX              ;if(A>B && A<C)
                     POP AX  
                     MOV TEMP,AX             ;then A is the result
                     CALL NEWLINE
                          
                     LEA DX,MEDIAN
                     MOV AH,9
                     INT 21H 
                     
                     MOV AX,TEMP
                     CALL DECIMEL_OUTPUT 
                     JMP FINISH
                     
     B_GREATER_THAN_C:
                     CMP AX,CX             ;if(B>C && A>C)
                     JG A_GREATER_THAN_C2
                     
                     MOV AX,CX             ;if(B>C && A<C)
                     PUSH AX               ;then C is the result
                     POP AX  
                     MOV TEMP,AX
                     
                     CALL NEWLINE
                     
                     LEA DX,MEDIAN
                     MOV AH,9
                     INT 21H  
                     
                     MOV AX,TEMP
                     CALL DECIMEL_OUTPUT 
                     JMP FINISH
                     
     A_GREATER_THAN_C1:
                      CMP BX,CX
                      JG B_GREATER_THAN_C1 ;if(A>B && A>C && B>C)
                      
                      MOV AX,CX            ;if(A>B && A>C && B<C)
                      PUSH AX              ;then C is the result
                      POP AX 
                      MOV TEMP,AX
                      CALL NEWLINE
                      
                      LEA DX,MEDIAN
                      MOV AH,9
                      INT 21H 
                      
                      MOV AX,TEMP
                      CALL DECIMEL_OUTPUT
                      JMP FINISH
                      
     A_GREATER_THAN_C2:
                      PUSH AX              ;if(B>C && A<C)
                      POP AX 
                      MOV TEMP,AX              ;then A is the result
                      CALL NEWLINE
                      
                      LEA DX,MEDIAN
                      MOV AH,9
                      INT 21H 
                      
                      MOV AX,TEMP
                      CALL DECIMEL_OUTPUT
                      JMP FINISH
                      
     B_GREATER_THAN_C1:
                      MOV AX,BX           ;if(A>B && A>C && B>C)
                      PUSH AX             ;then A is the result
                      POP AX  
                      MOV TEMP,AX
                      CALL NEWLINE
                      
                      LEA DX,MEDIAN
                      MOV AH,9
                      INT 21H
                       
                      MOV AX,TEMP
                      CALL DECIMEL_OUTPUT
                      JMP FINISH 
                      
     FINISH:                                                  
           DEC D
           MOV DX,D
           CMP DX,0 
           CALL NEWLINE
           CALL NEWLINE
     JG START                 
 
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