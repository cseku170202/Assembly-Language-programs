;UVA 11466
;Largest Prime Divisor 
.MODEL SMALL
.STACK 100H
.DATA
     N DW ?
     I DW ?
     M DW ?
     NUM DW ?
     C DW ?
     I1 DW ?   
     INPUT DB 'INPUT : $'
     OUTPUT DB 'OUTPUT : $'
     PRINT1 DB '-1 $' 
.CODE
MAIN PROC 
     MOV AX,@DATA
     MOV DS,AX   
     TOP:      
     LEA DX,INPUT
     MOV AH,9
     INT 21H 
     CALL NEWLINE
     
     CALL DECIMEL_INPUT    ;take input N
     MOV N,AX
     CALL NEWLINE 
     
     CMP N,0     ; if(N!=0)
     JNE START   ;  then execute START
     JMP EXIT    ; else 
                 ;  jmp to EXIT
     START:
          MOV M,0     ;m=0
          MOV C,0     ;c=0
          CMP N,0      
          JL NEGATE
          JMP NEGATE_NEXT
          
          NEGATE:        ;num=fabs(n)
                NEG N
                MOV AX,N
                MOV NUM,AX
                
          NEGATE_NEXT:
                     MOV AX,N
                     MOV NUM,AX  
      ;FOR STARTS               
          MOV I,2     ;for(i=2;i*i<=num;i++)
          XOR DX,DX
          MOV AX,I
          MOV BX,I
          MUL BX
          
          MOV I1,AX      ;I1=i*i
          CMP AX,NUM
          JLE FOR
          JMP FOR_NEXT
          
          
         ;WHILE STARTS    
          FOR:
             XOR DX,DX     ;while(n%i==0)
             MOV AX,N
             MOV BX,I
             DIV BX
             
             CMP DX,0
             JE WHILE
             JMP WHILE_NEXT
             
             WHILE:         ; if(m!=i)
                  MOV AX,M  ;   then c++
                  MOV BX,I
                  CMP AX,BX
                  JNE IF
                  JMP IF_NEXT
                  
                  IF:
                    INC C
                    
                  IF_NEXT:    ;m=i
                    MOV AX,I
                    MOV M,AX
                    
                    XOR DX,DX ;n=n/i
                    MOV AX,N
                    MOV BX,I
                    DIV BX
                    
                    MOV N,AX
                    
                  L:
                  XOR DX,DX   ;if condition satisfied then continue while loop again
                  MOV AX,N
                  MOV BX,I
                  DIV BX
                  
                  CMP DX,0
                  JE WHILE
          ;END OF WHILE LOOP
          
                    
            WHILE_NEXT:       ;continue the for loop again if condition satisfied
            INC I 
            MOV AX,I
            MOV I1,AX
            
            XOR DX,DX
            MOV AX,I1
            MOV BX,I1
            MUL BX
            
            CMP AX,NUM
            JLE FOR
   ;END OF FOR      
               
   ;IF STARTS            
         FOR_NEXT:         ;if(n!=1 && n!=-1 && n!=num)
            CMP N,1        ; {
            JNE CHECK1     ;    m=fabs(n)
            JMP PRINT_IF   ;    c++
                           ; }
           CHECK1: 
                MOV AX,1
                NEG AX
                CMP N,AX
                JNE CHECK2
                JMP PRINT_IF
                
           CHECK2:
                MOV AX,N
                CMP AX,NUM
                JNE EXECUTE_BODY 
                JMP PRINT_IF
                
           EXECUTE_BODY:
                  CMP N,0
                  JL NEGATE1
                  JMP NEGATE1_NEXT
                  
               NEGATE1:
                     NEG N
                     MOV AX,N
                     MOV M,AX
                     INC C
                     JMP PRINT_IF
                     
               NEGATE1_NEXT:
                     MOV AX,N
                     MOV M,AX
                     INC C    
     ;END OF IF                
           PRINT_IF:             ;if(c>1)
                  CMP C,1        ; then print M
                  JG PRINT_M     ;else
                  JMP PRINT_ELSE ; print -1
               PRINT_M:
                     MOV AX,M
                     PUSH AX
                     POP AX
                     CALL DECIMEL_OUTPUT 
                     JMP END_WORK
                     
           PRINT_ELSE:    
                    LEA DX,PRINT1
                    MOV AH,9
                    INT 21H
                                                               
                    JMP END_WORK     
      END_WORK:
              CALL NEWLINE  
              MOV C,0
              CMP N,0
              JNE TOP             
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