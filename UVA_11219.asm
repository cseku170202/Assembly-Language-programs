;UVA 11219
;How old are you?
.MODEL SMALL
.STACK 100H
.DATA 
     A DW ?
     B DW ?
     C DW ?
     E DW ?
     G DW ?
     F DW ?
     K DW ?
     I DW ?
     J DW ?
     T DW ? 
     PRIN DB '/$'
     INPUT DB 'INPUT : $'
     CASE DB 'Case #$'
     COLON DB ': $'
     INVALID DB 'Invalid birth date$'
     CHECK_BIRTH DB 'Check birth date$' 
.CODE
MAIN PROC 
     MOV AX,@DATA
     MOV DS,AX    
     
     CALL DECIMEL_INPUT    ;input test case T
     MOV T,AX
     CALL NEWLINE
     
     MOV I,0         ;for(i=0;i<T;i++)
     MOV AX,I
     CMP AX,T
     JL TOP
     JMP EXIT
     
     TOP:
                    
     LEA DX,INPUT
     MOV AH,9
     INT 21H  
     CALL NEWLINE  
     
     CALL DECIMEL_INPUT   ;input A
     MOV A,AX
     CALL NEWLINE  
     
     LEA DX,PRIN
     MOV AH,9
     INT 21H
     
     CALL DECIMEL_INPUT   ;input B
     MOV B,AX
     CALL NEWLINE
     
     LEA DX,PRIN
     MOV AH,9
     INT 21H
     
     CALL DECIMEL_INPUT   ;input C
     MOV C,AX
     CALL NEWLINE
     
     CALL DECIMEL_INPUT   ;input E
     MOV E,AX
     CALL NEWLINE
     
     LEA DX,PRIN
     MOV AH,9
     INT 21H
     
     CALL DECIMEL_INPUT   ;input F
     MOV F,AX
     CALL NEWLINE
     
     LEA DX,PRIN
     MOV AH,9
     INT 21H
     
     CALL DECIMEL_INPUT   ;input G
     MOV G,AX
     CALL NEWLINE
     
     MOV AX,C    ;k=c-g
     SUB AX,G
     MOV K,AX  
     
     MOV AX,B     ;if(b<f)
     CMP AX,F     ; then k--
     JL IF        ;else if(b==f)
     CMP AX,F     ;{
     JNL ELSE_IF  ;  if(a<e)
     JMP NEXT_IF  ;     K--     
                  ;}
     IF:
       DEC K
       JMP NEXT_IF
       
     ELSE_IF:
           MOV AX,B
           CMP AX,F
           JE CHECK
           JMP NEXT_IF
           
        CHECK:
             MOV AX,A
             CMP AX,E
             JL DECREMENT
             JMP NEXT_IF
             
        DECREMENT:
             DEC K
             
     NEXT_IF:                    ;if(k<0)
            CMP K,0              ; then print INVAID in desired format
            JL PRINT_INVALID
            
            CMP K,130            ;else if(k>130)
            JG PRINT_CHECK       ; then print CHECK BIRTH DATE in desired format
            
            LEA DX,CASE          ;else
            MOV AH,9             ; print output k in desired format
            INT 21H
            
            INC I
            MOV AX,I
            PUSH AX
            POP AX
            CALL DECIMEL_OUTPUT
            
            LEA DX,COLON
            MOV AH,9
            INT 21H
            
            MOV AX,K
            PUSH AX
            POP AX
            CALL DECIMEL_OUTPUT
            DEC I
            JMP END_WORK
            
     PRINT_INVALID:
                 LEA DX,CASE
                 MOV AH,9
                 INT 21H
                 
                 INC I
                 MOV AX,I
                 PUSH AX
                 POP AX
                 CALL DECIMEL_OUTPUT
                 
                 LEA DX,COLON
                 MOV AH,9
                 INT 21H
                 
                 LEA DX,INVALID
                 MOV AH,9
                 INT 21H
                 DEC I
                 JMP END_WORK
                 
     PRINT_CHECK:
                LEA DX,CASE
                MOV AH,9
                INT 21H
                
                INC I
                MOV AX,I
                PUSH AX
                POP AX
                CALL DECIMEL_OUTPUT
                
                LEA DX,COLON
                MOV AH,9
                INT 21H
                
                LEA DX,CHECK_BIRTH
                MOV AH,9
                INT 21H
                DEC I
                JMP END_WORK
                
     END_WORK:                ;continue the outer for loop
             CALL NEWLINE
             MOV K,0
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