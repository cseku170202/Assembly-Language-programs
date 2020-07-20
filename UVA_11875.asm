;UVA 11875
;Brick Game 
.MODEL SMALL
.STACK 100H
.DATA      
     A DW 5000 DUP (?)
     T DW ?
     I DW ?
     N DW ?
     J DW ?
     K DW ?
     P DW ?
     A_TEMP DW ?
     B DW ?
     C DW 0
     D DW 0  
     X DW ?
     Y DW ? 
     P1 DW ? 
     P_TEMP DW ?
     INPUT DB 'INPUT : $'
     OUTPUT DB 'OUTPUT : $' 
     CASE DB 'Case $'
     COLON DB ': $'
.CODE
MAIN PROC 
     MOV AX,@DATA
     MOV DS,AX  
     
     CALL DECIMEL_INPUT     ;INPUT test case T
     MOV T,AX
     CALL NEWLINE
     
     MOV I,0     ;for(i=0;i<T;i++)
     MOV AX,I
     CMP AX,T
     JL TOP 
     JMP EXIT
     
     TOP:
                     
     LEA DX,INPUT
     MOV AH,9
     INT 21H 
     CALL NEWLINE
     
     CALL DECIMEL_INPUT    ;Take the total number of input for the ith term
     MOV N,AX
     CALL NEWLINE 
     
     XOR BX,BX
     MOV CX,N
     
     INPUT_FOR:            ;Take N inputs
              CALL DECIMEL_INPUT
              MOV A[BX],AX
              ADD BX,2
              CALL NEWLINE
              LOOP INPUT_FOR 
              
     MOV AX,A[0]   ;AX=A[0]
     MOV BX,A[2]   ;BX=A[1]
     
     CMP AX,BX     ;if(A[0]>A[1] !! A[0]<A[1] )
     JG IF_BODY    ; then execute IF_BODY
     
     CMP AX,BX
     JL IF_BODY
     
     IF_BODY:
            XOR DX,DX   ;P=N/2
            MOV AX,N 
            MOV BX,2
            DIV BX 
            
            MOV P,AX       ;save the value of P 
            MOV P_TEMP,AX 
            MOV P1,AX
            
            INC P          ;for(a=p+1;a<N;a++)
            MOV AX,P       ;{
            MOV A,AX       ;   c++
            CMP AX,N       ;}
            JL FOR1
            JMP NEXT_FOR1
            
            FOR1:
                INC C
                
                INC A
                MOV AX,A
                CMP AX,N
                JL FOR1
                
            NEXT_FOR1: 
            DEC P_TEMP     ;for(b=P-1;b>=0;b--)
            MOV BX,P_TEMP  ;{
            MOV B,BX       ;  d++
            CMP BX,0       ;}
            JGE FOR2
            JMP NEXT_FOR2
            
            FOR2:
                INC D
                
                DEC B
                MOV BX,B
                CMP BX,0
                JGE FOR2
                
            NEXT_FOR2:
            MOV AX,C       ;if(c==d)
            CMP AX,D       ; then execute PRINT
            JE PRINT
            JMP END_WORK
            
          PRINT:           ;print the output in desired format
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
               
               XOR DX,DX
               MOV AX,P1
               MOV BX,2
               MUL BX
               
               MOV BX,AX
               MOV AX,A[BX]
               PUSH AX
               POP AX
               CALL DECIMEL_OUTPUT 
               DEC I
               
       END_WORK:
               CALL NEWLINE
               MOV C,0       ;reset the values of c && d
               MOV D,0 
               
               INC I         ;continue the loop until i<t
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