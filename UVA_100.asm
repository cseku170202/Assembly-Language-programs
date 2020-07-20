;UVA 100
;The 3n + 1 problem
.MODEL SMALL
.STACK 100H
.DATA 
     A DW ?
     B DW ?
     P DW ?
     BIG DW 0
     I DW ?
     J DW ?
     N DW ?
     Q DW ?  
     Q_TEMP DW ?  
     Q1 DW ?
     Q2 DW ?
     C DW ?
     INPUT DB 'INPUT : $'
     OUTPUT DB 'OUTPUT : $' 
     SUM DB 'SUM : $'  
     TEMP DB ? 
     SPACE DB ' $'
.CODE
MAIN PROC 
     MOV AX,@DATA
     MOV DS,AX  
     
     TOP:
                     
     LEA DX,INPUT 
     MOV AH,9
     INT 21H      
     CALL NEWLINE
     
     
     CALL DECIMEL_INPUT   ;input A
     MOV A,AX
     CALL NEWLINE 

     CALL DECIMEL_INPUT   ;input B
     MOV B,AX
     CALL NEWLINE
     
     MOV BIG,0        ;big=0
     MOV AX,A
     MOV I,AX         ;i=a
     MOV BX,B
     MOV J,BX         ;j=b  
     
     MOV AX,I
     MOV BX,J
     
     CMP AX,BX        ;if(i>j)
     JG IF            ; then execute IF
     JMP IF_NEXT      ;else execute IF_NEXT
     
     IF:
       MOV CX,I
       MOV C,CX     ;c=i
       
       MOV CX,J
       MOV I,CX     ;i=j
       
       MOV CX,C  
       MOV J,CX     ;j=c
       
     IF_NEXT:
            MOV CX,I  ;n=i
            MOV N,CX
            
     MOV AX,N
     MOV BX,J
     CMP AX,BX
     JLE WHILE        ;while(n<=j)
     JMP PRINT_OUTPUT
     
     WHILE:
          MOV P,1         ;P=1
          MOV AX,N
          MOV Q,AX        ;Q=N 
          MOV Q_TEMP,AX  
          MOV Q1,AX
          MOV Q2,AX
          
          CMP Q,1
          JNE WHILE1      ;while(q!=1)
          JMP IF1
          
          WHILE1:
                XOR DX,DX
                MOV AX,Q  
                MOV BX,2
                DIV BX
                
                CMP DX,0
                JNE IF_WHILE1
                JMP ELSE_WHILE1
                
                IF_WHILE1:        ;if(q%2!=0)
                         XOR DX,DX ;(3*q)
                         MOV AX,Q
                         MOV BX,3
                         MUL BX
                         
                         INC AX    ;(3*q)+1
                         
                         MOV Q,AX  ;q=(3*q)+1
                         JMP L
                         
                ELSE_WHILE1:       ;else
                          XOR DX,DX ;q/2
                          MOV AX,Q
                          MOV BX,2
                          DIV BX
                          
                          MOV Q,AX  ;q=q/2  
                          
          L:                
          INC P       ;P++
          CMP Q,1
          JNE WHILE1  
               
          IF1:        ;if(big<p)
          MOV DX,BIG  ; then execute ASSIGN
          CMP DX,P    ;else execute ASSIGN_NEXT
          JL ASSIGN  
          JMP ASSIGN_NEXT
          
          ASSIGN:
                MOV DX,P   ;big=p
                MOV BIG,DX        
          ASSIGN_NEXT:
                    INC N      ;N++
                    MOV AX,N   
                    MOV BX,J
                    CMP AX,BX
                    JLE WHILE           
          PRINT_OUTPUT:       ;print the output in desired format
                     MOV AX,A
                     PUSH AX
                     POP AX
                     CALL DECIMEL_OUTPUT
                     
                     LEA DX,SPACE
                     MOV AH,9
                     INT 21H
                     
                     MOV AX,B
                     PUSH AX
                     POP AX
                     CALL DECIMEL_OUTPUT
                     
                     LEA DX,SPACE
                     MOV AH,9
                     INT 21H
                     
                     MOV AX,BIG
                     PUSH AX
                     POP AX
                     CALL DECIMEL_OUTPUT  
                     
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