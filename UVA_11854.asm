;UVA 11854 
;Egypt
.MODEL SMALL
.STACK 100H
.DATA 
     A DW ?
     B DW ?
     C DW ?
     M DW ?
     N DW ?
     ANS DW ? 
     S1 DW ? 
     S2 DW ?
     S3 DW ? 
     INPUT DB 'INPUT : $'
     OUTPUT DB 'OUTPUT : $' 
     SUM DB 'SUM : $'  
     TEMP DB ? 
     INVALID DB 'INVALID $'
     EQUILATERAL DB 'EQUILATERAL $'
     RIGHT DB 'right $'
     WRONG DB 'wrong $'
.CODE
MAIN PROC 
     MOV AX,@DATA
     MOV DS,AX 

     TOP:
     
     CALL DECIMEL_INPUT      ;INPUT A
     MOV A,AX
     CALL NEWLINE 
     
     CALL DECIMEL_INPUT      ;INPUT B
     MOV B,AX
     CALL NEWLINE
     
     CALL DECIMEL_INPUT      ;INPUT C
     MOV C,AX
     CALL NEWLINE
     
     MOV AX,A   ;AX=A
     MOV BX,B   ;BX=B
     MOV CX,C   ;CX=C
     
     CMP AX,BX
     JE IF_ONE  
     JMP ELSE_IF_ONE
   
  ;IF BLOCK STARTS   ;if(A>B && A>C && (A*A==B*B+C*C)
     IF_ONE:
           CMP AX,CX
           JG CHECK_ONE
           JMP ELSE_IF_ONE
     CHECK_ONE:
              XOR DX,DX
              MOV AX,A
              MOV BX,AX
              MUL BX     ;A*A
              
              MOV S1,AX  ;S1=(AX*AX)
              
              XOR DX,DX
              MOV AX,B   ;B*B
              MOV BX,AX
              MUL BX
              
              MOV S2,AX  ;S2=(B*B)
              
              XOR DX,DX
              MOV AX,C   ;C*C
              MOV BX,AX
              MUL BX
              
              MOV S3,AX  ;S3=(C*C)
              
              MOV DX,S2
              ADD DX,S3  ;(B*B)+(C*C)
              
              MOV AX,A   ;RESET AX,BX,CX
              MOV BX,B
              MOV CX,C
              
              CMP S1,DX  ;if(A*A)=(B*B)+(C*C)
              JE PRINT_RIGHT
              JMP ELSE_IF_ONE
              
     PRINT_RIGHT:
                LEA DX,RIGHT
                MOV AH,9
                INT 21H
                JMP END_WORK   
  ;END IF BLOCK  
     
  ;ELSE IF ONE STARTS   ;if( B>A && B>C && (B*B=A*A+C*C) )           
     ELSE_IF_ONE:
                CMP BX,AX
                JG IF_TWO
                JMP ELSE_IF_TWO
                
     IF_TWO:
           CMP BX,CX
           JG CHECK_TWO
           JMP ELSE_IF_TWO
           
     CHECK_TWO:
              MOV S1,0
              MOV S2,0
              MOV S3,0
              
              XOR DX,DX
              MOV AX,B 
              MOV BX,AX
              MUL BX
              
              MOV S1,AX 
              
              XOR DX,DX
              MOV AX,A
              MOV BX,AX
              MUL BX
              
              MOV S2,AX
              
              XOR DX,DX
              MOV AX,C
              MOV BX,AX
              MUL BX
              
              MOV S3,AX 
              
              MOV DX,S2
              ADD DX,S3
              
              CMP DX,S1
              JE PRINT_RIGHT
              JMP ELSE_IF_TWO 
              
  ;ELSE IF ONE END 
   
  ;ELSE IF TWO STARTS            
     ELSE_IF_TWO:
                CMP CX,AX
                JG IF_THREE
                JMP ELSE_IF_THREE
                
     IF_THREE:
             CMP CX,BX
             JG CHECK_THREE
             JMP ELSE_IF_THREE
             
     CHECK_THREE:
                MOV S1,0
                MOV S2,0
                MOV S3,0
                
                XOR DX,DX
                MOV AX,C 
                MOV BX,AX
                MUL BX
                
                MOV S1,AX
                
                XOR DX,DX
                MOV AX,A
                MOV BX,AX
                MUL BX
                
                MOV S2,AX
                
                XOR DX,DX
                MOV AX,B
                MOV BX,AX
                MUL BX
                
                MOV S3,AX
                
                MOV DX,S2
                ADD DX,S3
                
                CMP DX,S1
                JE PRINT_RIGHT
                JMP ELSE_IF_THREE 
  ;ELSE IF TWO END              
                
  ;ELSE IF THREE STARTS              
      ELSE_IF_THREE:
                   CMP AX,0
                   JE CHECKING_ONE
                   JMP PRINT_WRONG
                   
      CHECKING_ONE:
                  CMP BX,0
                  JE CHECKING_TWO
                  JMP PRINT_WRONG
                  
      CHECKING_TWO:
                  CMP CX,0
                  JE EXIT
                  JMP PRINT_WRONG  
                  
  ;ELSE IF THREE END                                                                          
      PRINT_WRONG:
                LEA DX,WRONG
                MOV AH,9
                INT 21H  
                
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