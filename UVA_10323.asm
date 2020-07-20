;UVA 10323
;Factorial! You Must be Kidding!!!
.MODEL SMALL
.STACK 100H
.DATA 
     N DW ?
     P DW ?
     T DW ?
     I DW ?  
     PRINT_UNDER DB 'Underflow!$' 
     OVERFLOW DB 'Overflow!$'  
     ONE DB '40320 $'  
     TWO DB '362880 $'   
     THREE DB '3628800 $' 
     FOUR DB '39916800 $'
     FIVE DB '479001600 $' 
     SIX DB '6227020800 $'    
     INPUT DB 'INPUT : $'
     OUTPUT DB 'OUTPUT : $' 
     SUM DB 'SUM : $'  
.CODE
MAIN PROC 
     MOV AX,@DATA
     MOV DS,AX        
     TOP:       
     CALL DECIMEL_INPUT     ;TAKE INPUT N
     MOV N,AX
     CALL NEWLINE 
     
     CMP N,0                ;if(n>=0 && n<=7)
     JGE IF                 ; then print Underflow
     JMP ELSE_IF_ONE
     
     IF:
       CMP N,7
       JLE PRINT_UNDERFLOW
       JMP ELSE_IF_ONE
       
     PRINT_UNDERFLOW: 
                   LEA DX,PRINT_UNDER
                   MOV AH,9
                   INT 21H  
                   CALL NEWLINE
                   
                   
     ELSE_IF_ONE:              ;else if(n>0 && n%2==0)
                CMP N,0        ; then print Underflow
                JL CHECK1
                JMP ELSE_IF_TWO
                
         CHECK1:
           XOR DX,DX
           MOV AX,N
           MOV BX,2
           DIV BX
           
           CMP DX,0
           JE PRINT1 
           JMP ELSE_IF_TWO
           
         PRINT1:
           LEA DX,PRINT_UNDER
           MOV AH,9
           INT 21H 
           CALL NEWLINE
           
     ELSE_IF_TWO:              ;else if(n<0 && n%2!=0)
                CMP N,0        ; then print Overflow
                JL CHECK2
                JMP ELSE_IF_THREE 
                
         CHECK2:
           XOR DX,DX
           MOV AX,N
           MOV BX,2
           DIV BX
           
           CMP DX,0
           JNE PRINT2
           JMP ELSE_IF_THREE
           
         PRINT2:
           LEA DX,OVERFLOW
           MOV AH,9
           INT 21H
           CALL NEWLINE  
           
     ELSE_IF_THREE:             ;else if(n>13)
                  CMP N,13      ; then print Overflow
                  JG PRINT3
                  JMP ELSE_IF_FOUR
                  
            PRINT3:
              LEA DX,OVERFLOW
              MOV AH,9
              INT 21H
              CALL NEWLINE
              
     ELSE_IF_FOUR:              ;else if(n==8)     
                 CMP N,8        ;then print 40320
                 JE PRINT4
                 JMP ELSE_IF_FIVE
                 
            PRINT4:
              LEA DX,ONE
              MOV AH,9
              INT 21H
              CALL NEWLINE
              
     ELSE_IF_FIVE:              ;else if(n==9)
                 CMP N,9        ; then print 362880
                 JE PRINT5
                 JMP ELSE_IF_SIX
                 
            PRINT5:
               LEA DX,TWO
               MOV AH,9
               INT 21H
               CALL NEWLINE
               
     ELSE_IF_SIX:               ;else if(n==10)
                CMP N,10        ; then print 3628800
                JE PRINT6
                JMP ELSE_IF_SEVEN
                
            PRINT6:
               LEA DX,THREE
               MOV AH,9
               INT 21H
               CALL NEWLINE 
               
     ELSE_IF_SEVEN:             ;else if(n==11)
                  CMP N,11      ; then print 39916800
                  JE PRINT7
                  JMP ELSE_IF_EIGHT
                  
            PRINT7:
               LEA DX,FOUR
               MOV AH,9
               INT 21H
               CALL NEWLINE 
               
     ELSE_IF_EIGHT:             ;else if(n==12)
                  CMP N,12      ; then print 479001600
                  JE PRINT8
                  JMP ELSE_IF_NINE
                  
            PRINT8:
               LEA DX,FIVE
               MOV AH,9
               INT 21H
               CALL NEWLINE  
               
     ELSE_IF_NINE:              ;else if(n==13)
                 CMP N,13       ; then print 6227020800
                 JE PRINT9
                 JMP END_WORK
                 
            PRINT9:
              LEA DX,SIX
              MOV AH,9
              INT 21H
              CALL NEWLINE
              
     END_WORK: 
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