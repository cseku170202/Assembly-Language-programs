;UVA 11461
;SQUARE NUMBERS
.MODEL SMALL
.STACK 100H
.DATA 
     A DW ?
     B DW ?
     BIG DW ?
     I DW ?
     M DW ?
     C DW 0
     SMALL DW ?  
     INPUT DB 'INPUT : $'
     OUTPUT DB 'OUTPUT : $' 
     SUM DB 'SUM : $'  
.CODE
MAIN PROC 
     MOV AX,@DATA
     MOV DS,AX 
      
     TOP: 
                     
     LEA DX,INPUT
     MOV AH,9
     INT 21H   
     CALL NEWLINE
     
     CALL DECIMEL_INPUT    ;TAKE AN INPUT
     MOV A,AX
     CALL NEWLINE
     
     CALL DECIMEL_INPUT    ;TAKE ANOTHER INPUT
     MOV B,AX
     CALL NEWLINE
     
     MOV AX,A
     MOV BX,B
                         ;if(A>B)
     CMP AX,BX           ; then execute A-GREATER
     JG A_GREATER
     
     ;else               ;else (A<B)
     MOV BIG,BX          ;   big=b
     MOV SMALL,AX        ;   small=a
     JMP F
     
     A_GREATER:          ;if body portion
              MOV BIG,AX ;  big=a
              MOV SMALL,BX; small=b  
              
     F:          ;for(i=1;i<=big;i++)
     MOV I,1
     MOV CX,I
     CMP CX,BIG
     JLE FOR
     JMP NEXT_FOR         
     FOR:          ;for body starts
        XOR DX,DX  ;  M=i*i
        MOV AX,I
        MOV BX,I
        MUL BX    
        
        MOV M,AX
        
        MOV DX,M       ;if(M>=small)
        CMP DX,SMALL   ; then execute ANOTHER_TEST
        JGE ANOTHER_TEST 
                      
        INSIDE_FOR:              
        INC I
        MOV CX,I
        CMP CX,BIG
        JLE FOR
     
     JMP NEXT_FOR  ;After completing the loop jmp to NEXT_FOR    
        
     ANOTHER_TEST:     ; && if(M<=big)
               CMP DX,BIG  ;  then execute INCREMENT
               JLE INCREMENT
               JMP INSIDE_FOR
               
     INCREMENT:
            INC C         ;C++
            JMP INSIDE_FOR
            
     NEXT_FOR:             ;if(a==0 && b==0)
            CMP A,0        ; then break
            JE AGAIN_TEST
     AGAIN_TEST:
               CMP B,0
               JE EXIT
               
     FINAL_PRINT:          ;else print the result that is in c
                LEA DX,OUTPUT
                MOV AH,9
                INT 21H
                
                MOV AX,C
                PUSH AX
                POP AX
                CALL DECIMEL_OUTPUT 
                
     END_WORK:          ;continue the most outer loop
             MOV C,0
             CALL NEWLINE 
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