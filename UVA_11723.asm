;UVA 11723
;Numbering Roads!
.MODEL SMALL
.STACK 100H
.DATA 
     R DW ?
     N DW ?   
     R1 DW ?  
     I DW ?   
     INPUT DB 'INPUT : $'
     OUTPUT DB 'OUTPUT : $'
     IMPOS DB 'impossible $'
     CASE DB 'Case $'
     COLON DB ': $' 
.CODE
MAIN PROC 
     MOV AX,@DATA
     MOV DS,AX  
     
     MOV I,0
     
     TOP:
                          
     LEA DX,INPUT
     MOV AH,9
     INT 21H  
     CALL NEWLINE
     
     CALL DECIMEL_INPUT    ;input R
     MOV R,AX
     CALL NEWLINE
     
     CALL DECIMEL_INPUT    ;input N
     MOV N,AX
     CALL NEWLINE 
     
     CMP R,0       ;if(R==0 !! N==0)
     JE EXIT       ; then exit
     
     CMP N,0
     JE EXIT
     
     DEC R         ;R=R-1
                   
     XOR DX,DX     ;R1=R/N
     MOV AX,R
     MOV BX,N
     DIV BX
     
     MOV R1,AX
     CMP AX,26     ;if(R1>26)
     JG IMPOSSIBLE ; then print impossible in desired format 
     
  ;ELSE STARTS   
     LEA DX,CASE   ;else print R1 as output in desired format
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
     
     MOV AX,R1
     PUSH AX
     POP AX
     CALL DECIMEL_OUTPUT 
     DEC I
     JMP END_WORK  
  ;END OF ELSE        
     
     IMPOSSIBLE: 
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
              
              LEA DX,IMPOS
              MOV AH,9
              INT 21H  
              
              DEC I
              JMP END_WORK
              
     END_WORK: 
            INC I          ;continue the loop again
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