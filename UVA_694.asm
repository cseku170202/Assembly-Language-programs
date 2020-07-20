;UVA 694
;The Collatz Sequence 
.MODEL SMALL
.STACK 100H
.DATA 
     A DW ?
     L DW ?
     TERM DW 0
     I DW 0
     P DW ?    
     INPUT DB 'INPUT : $'
     SUM DB 'SUM : $'  
     TEMP DB ? 
     CASE DB 'Case $'
     COLON DB ':$ ' 
     PRINT_T DB 'A = $' 
     LIMIT DB ' limit = $' 
     NO_TERMS DB ' number of terms = $'
.CODE
MAIN PROC 
     MOV AX,@DATA
     MOV DS,AX       
     TOP:                     
     LEA DX,INPUT
     MOV AH,9
     INT 21H   
     CALL NEWLINE
     
     CALL DECIMEL_INPUT    ;TAKE AN INPUT A
     MOV A,AX
     CALL NEWLINE  
     
     CALL DECIMEL_INPUT    ;TAKE ANOTHER INPUT L
     MOV L,AX
     CALL NEWLINE
     
     MOV AX,A  ;P=A
     MOV P,AX
     MOV TERM,0 ;TERM=0
     
     CMP AX,L    ;while( A<=L )
     JLE WHILE   ; then execute WHILE label
     JMP NEXT_WHILE
          
  ;WHILE STARTS   
     WHILE:
          CMP A,0                  ;if( A<0 && L<0 )
          JL ANOTHER_CHECK         ; then break
          JMP ELSE_IF_ONE          ;break means jmp to NEXT_WHILE
          
          ANOTHER_CHECK:
                       CMP L,0
                       JL NEXT_WHILE 
                       
          ELSE_IF_ONE:             ;else if(A==1)
                     CMP A,1       ; then term++
                     JE BODY_ONE   ;      break
                     JMP ELSE_IF_TWO
                     
          BODY_ONE:
                  INC TERM
                  JMP NEXT_WHILE 
                  
          ELSE_IF_TWO:             ;else if(A%2==0)
                     XOR DX,DX     ; then A=A/2  ;IN BODY_TWO
                     MOV AX,A      ;      term++ ;IN BODY_TWO
                     MOV BX,2
                     DIV BX
                     
                     CMP DX,0
                     JE BODY_TWO 
                     JMP ELSE_IF_THREE
                     
          BODY_TWO:
                  MOV A,AX
                  INC TERM
                  JMP END_WORK 
                  
          ELSE_IF_THREE:           ;else if(A%2!=0)
                       XOR DX,DX   ; then A=A*3+1  ;IN BODY_THREE
                       MOV AX,A    ;      term++   ;IN BODT_THREE
                       MOV BX,2
                       DIV BX
                       
                       CMP DX,0
                       JNE BODY_THREE 
                       JMP END_WORK
                       
          BODY_THREE:
                    XOR DX,DX
                    MOV AX,A
                    MOV BX,3
                    MUL BX
                    
                    INC AX
                    MOV A,AX
                    INC TERM
                    
                    
          END_WORK:
                  MOV CX,A      ;while(A<=L)
                  CMP AX,L      ; if true then execute again
                  JLE WHILE 
                  
  ;END WHILE                
                  
     NEXT_WHILE:
     INC I
     
     CMP TERM,0
     JNE PRINT_OUTPUT 
     JMP EXIT
     
     PRINT_OUTPUT:              ;print output in desired format
                 LEA DX,CASE
                 MOV AH,9
                 INT 21H        
                 
                 MOV AX,I       ;ith case number print
                 PUSH AX
                 POP AX
                 CALL DECIMEL_OUTPUT
                 
                 LEA DX,COLON   ;colon print
                 MOV AH,9
                 INT 21H
                 
                 LEA DX,PRINT_T ; A = print
                 MOV AH,9
                 INT 21H
                 
                 MOV AX,P
                 PUSH AX
                 POP AX
                 CALL DECIMEL_OUTPUT 
                 
                 MOV AH,2       ;comma print
                 MOV DL,','
                 INT 21H  
                 
                 LEA DX,LIMIT   ; limit = print
                 MOV AH,9
                 INT 21H
                 
                 MOV AX,L
                 PUSH AX
                 POP AX
                 CALL DECIMEL_OUTPUT 
                 
                 MOV AH,2       ;comma print
                 MOV DL,','
                 INT 21H  
                 
                 LEA DX,NO_TERMS
                 MOV AH,9
                 INT 21H
                 
                 MOV AX,TERM
                 PUSH AX
                 POP AX
                 CALL DECIMEL_OUTPUT                                   
     RETURN_AGAIN:
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