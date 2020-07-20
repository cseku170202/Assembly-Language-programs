;UVA 11942
;Lumberjack Sequencing 
.MODEL SMALL
.STACK 100H
.DATA 
     A DW 10 DUP (?)
     K DW ?
     TEMP DW ?
     TEMP_A DW ?
     TEMP_B DW ? 
     I DW ?
     J DW ?
     SINDEX DW ?  
     N DW ? 
     B DW 10 DUP (0)
     T DW ?
     I1 DW ?
     J1 DW ?
     K1 DW ?
     C DW 0
     INPUT DB 'INPUT : $'
     OUTPUT DB 'OUTPUT : $'
     LUM DB 'Lumberjacks: $'
     ORDERED DB 'Ordered $'
     UNORDERED DB 'Unordered $' 
.CODE
MAIN PROC 
     MOV AX,@DATA
     MOV DS,AX 
     
     CALL DECIMEL_INPUT       ;input test case T
     MOV T,AX
     CALL NEWLINE
     
     MOV I1,0       ;for(i=0;i<T:i++)
     MOV AX,I1
     CMP AX,T
     JL TOP
     JMP EXIT
     
     TOP:
                     
     LEA DX,INPUT
     MOV AH,9
     INT 21H 
     CALL NEWLINE
     
     XOR SI,SI      ;for(j=0;j<10;j++)
     MOV J1,0
     MOV AX,J1
     CMP AX,10      
     JL INPUT_FOR
     JMP INPUT_FOR_NEXT
     
     INPUT_FOR:
              CALL DECIMEL_INPUT ;cin>>A[j]
              MOV A[SI],AX       ;B[j]=A[j]
              MOV B[SI],AX       ;copy the A[] to B[] array
              
              ADD SI,2 
              
              CALL NEWLINE
              INC J1
              MOV AX,J1
              CMP AX,10   
              JL INPUT_FOR
              
     INPUT_FOR_NEXT:
           XOR SI,SI
           MOV AX,A[SI] ;AX contains A[0]
           ADD SI,2
           MOV BX,A[SI] ;BX contains A[1]
           
           CMP AX,BX          ;if(A[0]<A[1])
           JL SORT_ASCENDING  ; then ascending sort
           
           CMP AX,BX          ;if(A[0]>A[1])
           JG SORT_DECENDING  ; then decending sort
           
           SORT_ASCENDING:
                        MOV K,10     
                        CALL SORTING  
                        XOR SI,SI
                        JMP NEXT
                        
           SORT_DECENDING:
                        MOV K,10   
                        CALL SORTING_DECENDING 
                        XOR SI,SI
                                
           NEXT:
               MOV K1,0             ;for(k=0;k<10;k++)
               MOV AX,K1
               CMP AX,10  
               JL EQUAL_CHECK
               JMP END_FOR
               
               EQUAL_CHECK:
                          MOV AX,A[SI]  ;if(A[K]==B[K])
                          MOV BX,B[SI]  ;{
                          CMP AX,BX
                          JE FOR_AGAIN  ;   continue
                                        ;}
                          ;else
                          INC C
                          JMP END_FOR   ; break
                          
                          FOR_AGAIN:    ;continue the loop again
                          ADD SI,2
                          INC K1
                          MOV AX,K1
                          CMP AX,10  
                          JL EQUAL_CHECK
                          
         END_FOR:                    ;if(i==0)
                CMP I1,0             ; then print Lumberjacks
                JE PRINT_LUMBERJACKS
                
                CMP C,0              ;if(c==0)
                JE PRINT_ORDERED     ; then print Ordered
                
                ;else
                JMP PRINT_UNORDERED  ;else
                                     ; print Unordered
         PRINT_LUMBERJACKS:
                        LEA DX,LUM
                        MOV AH,9
                        INT 21H 
                        CMP C,0
                        JG PRINT_UNORDERED
                        
         PRINT_ORDERED: 
                     CALL NEWLINE
                     LEA DX,ORDERED
                     MOV AH,9
                     INT 21H 
                     JMP END_WORK
                     
         PRINT_UNORDERED: 
                     CALL NEWLINE
                     LEA DX,UNORDERED
                     MOV AH,9
                     INT 21H                                                     
               
         END_WORK: 
                 MOV C,0            ;continue outer while loop
                 CALL NEWLINE      
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


   
SORTING_DECENDING PROC    
     PUSH K
     PUSH AX
     PUSH BX
     PUSH CX
     PUSH DX
     
  ;SORTING START 
     XOR BX,BX  ;ARRAY INDEX IN BX       
     MOV CX,K   ;LOOP COUNTER    
     OUTER_LOOP1: 
              MOV SINDEX,BX 
              MOV I,BX      ;OUTER LOOP CURRENT INDEX = I
              MOV N,CX      ;OUTER LOOP COUNTER ,N=CX
              
              
              ADD BX,2      ;THE NEXT INDEX OF CURRENT INDEX I, THAT IS J=I+1
              MOV J,BX
              SUB CX,1      ;INNER LOOP EKBAR KOM COLBE
              CMP CX,0      ;INNER LOOP JOKHON R CHECK KORTE HOBE NAA TOKHON OUTPUT PRINT KORTE COLE JABE
              JE L44
              
              INNER_LOOP1:
                       MOV AX,A[BX]  ;AX=A[J] & BX=J  
                       MOV TEMP,BX   ;BX K TEMP E DHORE RAKHLAM
                          
                       MOV BX,SINDEX ;SINDEX=PREVIOUS INDEX
                       MOV DX,A[BX]  ;DX=A[SINDEX]  
                       
                       MOV BX,TEMP  ;DHORE RAKHA TEMP K AGAIN BX E RAKHLAM
                       
                       CMP AX,DX
                       JG GREATER_THAN  ;SMALL INDEX J=SINDEX KORTE HOBE
                       L22:
                       ADD BX,2
              LOOP INNER_LOOP1 
                                
            ;INTERCHANGE A[I] & A[SINDEX]      
              L11:
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
     LOOP OUTER_LOOP1
  ;SORTING END  
     L44:
     POP DX
     POP CX
     POP BX
     POP AX 
     POP K     
     RET
    
     GREATER_THAN:
              MOV AX,TEMP
              MOV SINDEX,AX 
              JMP L22 
  
SORTING_DECENDING ENDP   
END MAIN