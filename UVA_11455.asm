;UVA 11455
;Behold My Quadrangle
.MODEL SMALL
.STACK 100H
.DATA 
     A DW 5000 DUP (?)
     SINDEX DW ?
     TEMP_A DW ?
     TEMP_B DW ?  
     K DW ?  
     I DW ?
     J DW ?  
     N DW ? 
     TEMP DW ?    
     T DW ?
     I1 DW ?
     A1 DW ?
     B DW ?
     C DW ?
     D DW ?
     INPUT DB 'INPUT : $'
     OUTPUT DB 'OUTPUT : $' 
     SQUARE DB 'square $'
     RECTANGLE DB 'rectangle $' 
     QUADRANGLE DB 'quadrangle $'
     BANANA DB 'banana $'
.CODE
MAIN PROC 
     MOV AX,@DATA
     MOV DS,AX 
     
     CALL DECIMEL_INPUT       ;input test case T
     MOV T,AX
     CALL NEWLINE
     
     MOV I1,0                 ;for(i=0;i<T;i++)
     MOV AX,I1
     CMP AX,T
     JL TOP 
     JMP EXIT
     
     TOP:
                     
     LEA DX,INPUT
     MOV AH,9
     INT 21H 
     CALL NEWLINE
     
     CALL DECIMEL_INPUT        ;input A1
     MOV A1,AX
     CALL NEWLINE 
     
     CALL DECIMEL_INPUT        ;input B
     MOV B,AX
     CALL NEWLINE
     
     CALL DECIMEL_INPUT        ;input C
     MOV C,AX
     CALL NEWLINE
     
     CALL DECIMEL_INPUT        ;input D
     MOV D,AX
     CALL NEWLINE
     
     MOV AX,A1                 ;AX=A1
     MOV BX,B                  ;BX=B
     MOV CX,C                  ;CX=C
     MOV DX,D                  ;DX=D
     
     CMP AX,BX                 ;if(A==B && B==C && C==D)
     JE AGAIN1                 ; then print SQUARE
     JMP ELSE_IF_ONE
     
        AGAIN1:
              CMP BX,CX
              JE AGAIN2
              JMP ELSE_IF_ONE
              
        AGAIN2:
              CMP CX,DX
              JE PRINT_SQUARE
              
     ELSE_IF_ONE:             ;else if((A==C && B==D)!!
               CMP AX,CX      ;        (A==B && C==D)!!
               JE CHECK1      ;        (A==D && B==C)) 
               JMP ANOTHER    
                              ;   then print RECTANGLE
        CHECK1:
              CMP BX,DX
              JE PRINT_RECTANGLE  
              
        ANOTHER:
              CMP AX,BX
              JE CHECK2
              JMP ANOTHER1
              
        CHECK2:
              CMP CX,DX
              JE PRINT_RECTANGLE 
              
        ANOTHER1:
               CMP AX,DX
               JE MEASURE
               JMP ELSE_IF_TWO
               
        MEASURE:
               CMP BX,CX
               JE PRINT_RECTANGLE 
               
      ELSE_IF_TWO:             ;else
                MOV SI,0       ;
                MOV A[SI],AX   ; A[0]=A1
                               ; A[1]=B
                ADD SI,2       ; A[2]=C
                MOV A[SI],BX   ; A[3]=D
                             
                ADD SI,2
                MOV A[SI],CX
                
                ADD SI,2
                MOV A[SI],DX
                
                MOV K,4        ;number of term to sort
                
                CALL SORTING   ;sorting
                
                MOV SI,0
                MOV AX,A[SI]   ;After sorting
                               ; AX=A[0]
                ADD SI,2       ; BX=A[1]
                MOV BX,A[SI]   ; CX=A[2]
                               ; DX=A[3]
                ADD SI,2
                MOV CX,A[SI]
                
                ADD SI,2
                MOV DX,A[SI]
                
                ADD AX,BX      ;if(A[0]+A[1]+A[2]>=A[3])
                ADD AX,CX      ; then print QUADRANGLE
                
                CMP AX,DX      ;else print BANANA
                JGE PRINT_QUADRANGLE
                
                ELSE:
                    JMP PRINT_BANANA
                    
         PRINT_SQUARE:
                    LEA DX,SQUARE
                    MOV AH,9
                    INT 21H
                    JMP END_WORK
                    
         PRINT_RECTANGLE:
                    LEA DX,RECTANGLE
                    MOV AH,9
                    INT 21H
                    JMP END_WORK
                    
         PRINT_QUADRANGLE:
                    LEA DX,QUADRANGLE
                    MOV AH,9
                    INT 21H
                    JMP END_WORK
                    
         PRINT_BANANA:
                    LEA DX,BANANA
                    MOV AH,9
                    INT 21H
                    JMP END_WORK
                    
       END_WORK:                                                                                         
               CALL NEWLINE      ;continue outer while loop
               INC I1
               MOV AX,I1
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


SORTING PROC 
     PUSH K
     PUSH AX
     PUSH BX
     PUSH CX
     PUSH DX
     
  ;SORTING START 
     XOR BX,BX  ;ARRAY INDEX IN BX       
     MOV CX,K   ;LOOP COUNTER
     
     OUTER_LOOP: 
              MOV SINDEX,BX 
              MOV I,BX      ;OUTER LOOP CURRENT INDEX = I
              MOV N,CX      ;OUTER LOOP COUNTER ,N=CX
              
              
              ADD BX,2      ;THE NEXT INDEX OF CURRENT INDEX I, THAT IS J=I+1
              MOV J,BX
              SUB CX,1      ;INNER LOOP EKBAR KOM COLBE
              CMP CX,0      ;INNER LOOP JOKHON R CHECK KORTE HOBE NAA TOKHON OUTPUT PRINT KORTE COLE JABE
              JE L4
 
              INNER_LOOP:
                       MOV AX,A[BX]  ;AX=A[J] & BX=J  
                       MOV TEMP,BX   ;BX K TEMP E DHORE RAKHLAM
                          
                       MOV BX,SINDEX ;SINDEX=PREVIOUS INDEX
                       MOV DX,A[BX]  ;DX=A[SINDEX]  
                       
                       MOV BX,TEMP  ;DHORE RAKHA TEMP K AGAIN BX E RAKHLAM
                       
                       CMP AX,DX
                       JL LESS_THAN  ;SMALL INDEX J=SINDEX KORTE HOBE
                       L2:
                       ADD BX,2
              LOOP INNER_LOOP 
                  
                  
            ;INTERCHANGE A[I] & A[SINDEX]      
              L1:
                MOV BX,I 
                MOV DX,A[BX]   
                MOV TEMP_A,DX
                
                MOV BX,SINDEX 
                MOV DX,A[BX]  
                MOV TEMP_B,DX 
                
                MOV BX,I
                MOV DX,TEMP_B       
                MOV A[BX],DX
                
                MOV BX,SINDEX
                MOV DX,TEMP_A  
                MOV A[BX],DX  
             ;FINISH INTERCHANGE LABEL
                
                
                
                MOV BX,I 
                MOV CX,N
                ADD BX,2
              
           
     LOOP OUTER_LOOP
  ;SORTING END
  
     L4:  
     POP DX
     POP CX
     POP BX
     POP AX 
     POP K
     
     RET
    
     LESS_THAN:
              MOV AX,TEMP
              MOV SINDEX,AX 
              JMP L2 
  
SORTING ENDP   
 
   

END MAIN