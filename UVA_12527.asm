;UVA 12527
;Different Digits 
.MODEL SMALL
.STACK 100H
.DATA 
     A1 DW ?
     I DW 0
     J DW ?
     K DW ?
     S DW ?
     A DW 100 DUP (0)
     X DW 0
     H DW 0
     G DW 0
     OUTPUT DW 0
     M DW ?
     N DW ? 
     R1 DW ?
     R2 DW ? 
     K_TEMP DW ?
     I_TEMP DW ?
     INPUT DB 'INPUT : $'
     OUTPUT1 DB 'OUTPUT : $' 
.CODE
MAIN PROC 
     MOV AX,@DATA
     MOV DS,AX 
                     
     LEA DX,INPUT
     MOV AH,9
     INT 21H   
     CALL NEWLINE
     
     CALL DECIMEL_INPUT  
     MOV N,AX
     CALL NEWLINE
     
     CALL DECIMEL_INPUT
     MOV M,AX
     CALL NEWLINE 
     
     MOV AX,N
     MOV A1,AX
     CMP AX,M
     JLE OUTER_BODY 
     JMP END_WORK
     
     OUTER_BODY: 
               MOV AX,A1  ;X=A
               MOV X,AX
               
               CMP A1,0
               JNE WHILE
               JMP AGAIN
               
               WHILE:
                    XOR DX,DX
                    MOV AX,A1
                    MOV BX,10
                    DIV BX
                    
                    MOV S,DX    ;s=a%10
                    
                    MOV BX,I
                    MOV I_TEMP,BX
                    MOV A[BX],DX  ;A[i]=s  
                    MOV A1,AX      ;a=a/10
                    
                    CMP I,1       ;if(i>=1)
                    JGE IF_ONE
                    JMP IF_TWO
                    
                    IF_ONE:
                          DEC I
                          MOV CX,I
                          MOV K,CX 
                          MOV K_TEMP,CX
                          
                          CMP K,0
                          JGE FOR1 
                          JMP IF_TWO
                          
                          FOR1:
                              XOR DX,DX  ;i=i*2 ->index(DW)
                              MOV AX,I
                              MOV BX,2
                              MUL BX
                              
                              MOV I,AX 
                               
                              MOV BX,I
                              MOV CX,A[BX]
                              MOV R1,CX     ;A[i] in R1
                              
                              XOR DX,DX
                              MOV AX,K
                              MOV BX,2
                              MUL BX
                              
                              MOV K,AX
                              
                              MOV BX,K
                              MOV CX,A[BX]
                              MOV R2,CX     ;A[k] in R2
                              
                              CMP CX,R1
                              JE INNER_IF
                              JMP CONTINUE_FOR1
                              
                              INNER_IF:
                                      INC H
                                      JMP AGAIN
                                      
                              CONTINUE_FOR1: 
                                           MOV DX,I_TEMP
                                           MOV I,DX
                                           
                                           MOV DX,K_TEMP
                                           MOV K,DX
                                           
                                           DEC K
                                           CMP K,0
                                           JGE FOR1        
                    
               
                    IF_TWO:
                          CMP A1,0
                          JE AGAIN
                          
                    INC I
                    CMP A1,0
                    JNE WHILE  
                    
               AGAIN:
                    MOV CX,X ;A=X
                    MOV A1,CX 
                    
                    MOV G,0
                    MOV BX,G
                    MOV CX,G
                    CMP BX,I
                    JLE FOR2
                    JMP NEXT_FOR2
                    
                    FOR2:
                        MOV A[BX],0
                        ADD BX,2 
                                 
                        INC CX
                        CMP CX,I
                        JLE FOR2
                        
                    NEXT_FOR2:
                             MOV I,0 
                             
                             INC A1
                             MOV CX,A1
                             CMP CX,M
                             JLE OUTER_BODY                             
                                                              
     END_WORK:
             LEA DX,OUTPUT1
             MOV AH,9
             INT 21H
             
             MOV AX,M
             MOV BX,N
             SUB AX,BX
             INC AX
             
             SUB AX,H
             MOV OUTPUT,AX
             
             MOV AX,OUTPUT
             PUSH AX
             POP AX
             CALL DECIMEL_OUTPUT               
                          
               
              
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