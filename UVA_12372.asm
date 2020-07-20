;UVA 12372
;Packing for Holiday 
.MODEL SMALL
.STACK 100H
.DATA 
     T DW ?
     I DW ?
     L DW ?
     W DW ?
     H DW ? 
     INDEX DW 1
     TESTCASE DW ?
    
     INPUT DB 'INPUT : $'
     OUTPUT DB 'OUTPUT : $' 
     SUM DB 'SUM : $'  
     TEMP DB ? 
     CASE DB 'Case $'
     SPACE DB ' $'
     
     BAD DB ' Bad $'
     GOOD DB ' Good $'
     TE DW ? 
     PRINT DB ':$'
.CODE
MAIN PROC 
     MOV AX,@DATA     ;initialize data
     MOV DS,AX   
     
     CALL DECIMEL_INPUT   ;enter the test case
     MOV TESTCASE,AX
     CALL NEWLINE
     
     FOR:
     
     CALL DECIMEL_INPUT  ;input L
     MOV L,AX
     CALL NEWLINE
     
     CALL DECIMEL_INPUT  ;input W
     MOV W,AX
     CALL NEWLINE
     
     CALL DECIMEL_INPUT  ;input H
     MOV H,AX
     CALL NEWLINE
     
     MOV BX,20D          ;SET BX=20
     CMP L,BX            ;if(L>20)
     JG ELSE             ;   then execute else
     
     CMP W,BX            ;if(W>20)
     JG ELSE             ;   then execute else
     
     CMP H,BX            ;if(H>20)
     JG ELSE             ;   then execute else
     
     LEA DX,CASE         ; PRINT Case
     MOV AH,9
     INT 21H 
     
     MOV AX,INDEX        ;PRINT ith index
     PUSH AX
     POP AX
     CALL DECIMEL_OUTPUT
     
     LEA DX,PRINT        ;PRINT colon
     MOV AH,9
     INT 21H
     
     LEA DX,GOOD         ;PRINT Good
     MOV AH,9
     INT 21H 
     INC INDEX 
     JMP END_WORK
     
     ELSE: 
         LEA DX,CASE       ;PRINT Case
         MOV AH,9
         INT 21H
         
         MOV AX,INDEX      ;PRINT ith index
         PUSH AX
         POP AX
         CALL DECIMEL_OUTPUT
         
         LEA DX,PRINT      ;PRINT colon
         MOV AH,9
         INT 21H
         
         LEA DX,BAD        ;PRINT Bad
         MOV AH,9
         INT 21H 
         INC INDEX 
             
     END_WORK:
             DEC TESTCASE
             CMP TESTCASE,1 
             CALL NEWLINE
             JGE FOR        
         
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