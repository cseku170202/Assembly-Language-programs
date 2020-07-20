;UVA 10038
;Jolly Jumper
.MODEL SMALL
.STACK 100H
.DATA 
     A DW 5000 DUP (0)  
     K DW ? 
     B DW 5000 DUP (0)
            
     SINDEX DW ?
     TEMP DW ?  
     TEMP_A DW ? 
     TEMP_B DW ?   
     N DW ? 
     N1 DW ?
     I DW ?
     S DW 0
     J DW ?
     C DW 0
     K1 DW 0
     P DW ?
     X DW 0 
     X1 DW 0 
     NUM DW ?   
     R1 DW ?
     R2 DW ?  
     INDEX DW ? 
     INDEX1 DW ?
     
     INPUT DB 'INPUT : $'
     OUTPUT DB 'OUTPUT : $' 
     SUM DB 'SUM : $'  
     JOLLY DB 'Jolly $' 
     NOT_JOLLY DB 'Not Jolly $'

.CODE
MAIN PROC 
     MOV AX,@DATA
     MOV DS,AX 
     
     TOP:   ; while( cin >> n )
                     
     LEA DX,INPUT
     MOV AH,9
     INT 21H 
     CALL NEWLINE
     
     
     CALL DECIMEL_INPUT     ;INPUT N
     MOV N,AX
     MOV N1,AX
     CALL NEWLINE 
     
     CMP N,0    ;if(N==0)
     JE EXIT    ; break
     
     DEC N1     ;P=N-1
     MOV AX,N1
     MOV P,AX  
     
     XOR BX,BX   ;for(i=0;i<n;i++)
     MOV I,BX    ;{
     CMP BX,N    ;   cin >> A[i]
     JL TAKE_INPUT ;}
     JMP IF
     
     TAKE_INPUT:
               CALL DECIMEL_INPUT
               MOV A[BX],AX
               ADD BX,2
               CALL NEWLINE  
               
               INC I
               MOV AX,I
               CMP AX,N
               JL TAKE_INPUT   
               
     IF:              ;if(N==1)
       CMP N,1        ; then print Jolly
       JE PRINT_JOLLY
       JMP IF_NEXT
       
     PRINT_JOLLY:
                LEA DX,JOLLY
                MOV AH,9
                INT 21H
                
                CALL NEWLINE
                JMP END_WORK  ;continue
                
     IF_NEXT:
            XOR BX,BX
            MOV J,0 
            MOV AX,N
            MOV NUM,AX
            DEC NUM      ;NUM contains N-1
            
            MOV AX,J     ;if(j=0;j<n-1;j++)
            CMP AX,NUM
            JL FOR  
            JMP FOR_NEXT
            
            FOR:
               MOV AX,A[BX]  ;AX contains A[j]
               ADD BX,2
               MOV CX,A[BX]  ;CX contains A[j+1]
               SUB CX,AX     ;CX = A[j+1]-A[j]
               MOV S,CX      ;S=CX
               
               CMP S,0       ;if(s<0)
               JL NEGATE     ; then s=s*(-1)
               JMP NEGATE_NEXT
               
               NEGATE:
                     NEG S
               
               NEGATE_NEXT:
                         MOV SI,K
                         MOV AX,S
                         MOV B[SI],AX       ;B[k]=S
                         
                         ADD K,2            ;k++
                         
                         MOV AX,S           ;if(s>=n !! s==0)
                         CMP AX,N           ; then execute INCREMENT
                         JGE INCREMENT
                         
                         CMP S,0
                         JE INCREMENT 
                         JMP L6             ;else continue FOR
                         
                         INCREMENT:
                                 INC C
                                 JMP FOR_NEXT  ;break 
               L6:      ;continue FOR            
               INC J
               MOV AX,J
               CMP AX,NUM
               JL FOR
               
            FOR_NEXT: 
                   MOV INDEX,0     ;copy the array A[] to B[]
                   MOV INDEX1,0    
                   MOV AX,INDEX
                   CMP AX,P
                   JL COPY
                   JMP COPY_NEXT
                   
                   COPY:
                       MOV BX,INDEX
                       MOV AX,B[BX]
                       MOV A[BX],AX ;A[i]=B[i]
                       
                       ADD INDEX,2  ;INDEX contains i
                       
                       INC INDEX1   ;INDEX1 contains loop counter
                       MOV AX,INDEX1
                       CMP AX,P
                       JL COPY
                       
                   COPY_NEXT: ;sorting start-> A[] holds the values to sort 
                           MOV AX,P
                           MOV K,AX  ;K contains the number of elements to sort  
                           
                           CALL SORTING
                     
             DEC P    ;for(x=0;x<p-1;x++)          
             MOV X,0
             MOV X1,0
             MOV AX,X
             CMP AX,P
             JL LAST_FOR
             JMP LAST_FOR_NEXT
             
             LAST_FOR:
                     MOV BX,X 
                     MOV AX,A[BX]  ;AX contains A[x]
                     ADD BX,2
                     MOV CX,A[BX]  ;CX contains A[x+1]
                     
                     CMP AX,CX
                     JE INCREM
                     
                     L5:
                     ADD X,2
                     
                     INC X1
                     MOV AX,X1
                     CMP AX,P
                     JL LAST_FOR 
                     
             JMP LAST_FOR_NEXT        
                     
                INCREM:      ;if(B[x+1]==B[x])
                     INC C   ; c++   
                     JMP L5  ; back into the loop again (L5)
                     
             LAST_FOR_NEXT:       ;if(c>0)
                         CMP C,0  ; then print Not Jolly
                         JG PRINT_NOT_JOLLY
                         
                         CMP C,0        ;if(c==0)
                         JE JOLLY_PRINT ; then print Jolly
                         
             PRINT_NOT_JOLLY:
                            LEA DX,NOT_JOLLY
                            MOV AH,9
                            INT 21H 
                            CALL NEWLINE  
                            JMP END_WORK
                            
             JOLLY_PRINT:
                        LEA DX,JOLLY
                        MOV AH,9
                        INT 21H
                        CALL NEWLINE
                        JMP END_WORK                                     
                                     
     END_WORK:
            MOV C,0     ;continue the outer while loop
            MOV S,0
            MOV K,0 
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