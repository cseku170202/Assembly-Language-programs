;UVA 11636
;Hello World! 
.MODEL SMALL
.STACK 100H
.DATA 
     N DW ?
     I DW 0
     P DW 0
     C DW 0
     J DW 0
     K DW ?
     M DW 0      
     CASE DB 'Case $'
     INPUT DB 'INPUT : $'
     OUTPUT DB 'OUTPUT : $' 
     SUM DB 'SUM : $' 
     COLON DB ': $' 
     TEMP DB ?
.CODE
MAIN PROC 
     MOV AX,@DATA
     MOV DS,AX   
     
     TOTAL:
   
     CALL DECIMEL_INPUT    ;TAKE AN INPUT
     MOV N,AX 
     
     CMP N,0       ;negative kina check
     JL EXIT       ;negative hole program exit korbe
     
     INC J         ;koto tomo term seta count kora 
     
     CMP N,1       ;N==1 hole onno kisui korar dorkar nai,direct print kore dite hobe.
     JE PRINT_ONE
        
     MOV K,2    
     FOR:           ;for(k=2; ;K=K*2)
        MOV AX,K      ;{
        CMP AX,N      ;   if(K>=N)
        JGE CHECK_ONE ;   {
        MOV BX,2      ;     M=K;
        XOR DX,DX     ;     break;
        MUL BX        ;   }
                      ;}
        MOV K,AX
           
     JMP FOR
     
     CHECK_ONE:
              MOV M,AX  ;M=K
              JMP NEXT
              
     NEXT:
         MOV K,2             ;for(K=2;K<=M;K=K*2)
         FOR2:               ; {
             MOV AX,K        ;    C++;
             INC C           ; }
             CMP AX,M
             JGE EXIT_FOR2  
           
             MOV BX,2
             XOR DX,DX
             MUL BX
             
             MOV K,AX
         JMP FOR2  
         
     EXIT_FOR2:    
              MOV AX,C
              CALL NEWLINE          
                 
     MOV BX,J   
     
     PUSH AX         ;result in AX
     PUSH BX         ;koto tomo term
     
     LEA DX,CASE
     MOV AH,9
     INT 21H  
     
     POP AX
     CALL DECIMEL_OUTPUT 
     
     LEA DX,COLON
     MOV AH,9
     INT 21H
     
     POP AX
     CALL DECIMEL_OUTPUT 
     MOV C,0
     JMP END_PRO 
     
     PRINT_ONE:      
             LEA DX,CASE
             MOV AH,9
             INT 21H
             
             MOV AX,J
             PUSH AX
             POP AX
             CALL DECIMEL_OUTPUT
             
             LEA DX,COLON
             MOV AH,9
             INT 21H
             
             MOV AH,2
             MOV AL,'0'
             INT 21H   
             
     MOV C,0  
     
     END_PRO: 
           CALL NEWLINE
           JMP TOTAL     
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