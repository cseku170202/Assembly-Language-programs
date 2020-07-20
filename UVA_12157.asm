;UVA 12157
;Tariff Plan 
.MODEL SMALL
.STACK 100H
.DATA 
     A DW 5000 DUP (?)
     T DW ?
     I DW ?
     N DW ?
     J DW ?
     MILE DW 0
     S DW 0
     K DW ?
     C DW 0
     P DW 0
     JUICE  DW 0
     A1 DW 0
     B DW 0
    
     INPUT DB 'INPUT : $'
     OUTPUT DB 'OUTPUT : $' 
     CASE DB 'Case $'
     COLON DB ': $'
     PRINT_MILE1 DB 'Mile $'
     PRINT_JUICE1 DB 'Juice $'
     PRINT_BOTH1 DB 'Mile Juice $'
.CODE
MAIN PROC 
     MOV AX,@DATA
     MOV DS,AX 
     
     CALL DECIMEL_INPUT   ;input test case T
     MOV T,AX
     CALL NEWLINE
     
     MOV I,0       ;for(i=0;i<T;i++)
     MOV AX,I
     CMP AX,T
     JL TOP  
     JMP EXIT
     
     TOP:
                     
     LEA DX,INPUT
     MOV AH,9
     INT 21H 
     CALL NEWLINE
     
     CALL DECIMEL_INPUT  ;take the total array element N
     MOV N,AX
     CALL NEWLINE 
     
     MOV J,0             ;for(j=0;j<N;j++)
     XOR SI,SI           ;{
     MOV AX,J            ;   cin>>A[j]
     CMP AX,N            ;}
     JL INPUT_FOR
     JMP FOR
     
     INPUT_FOR:
              CALL DECIMEL_INPUT
              MOV A[SI],AX
              ADD SI,2
              INC J
              
              CALL NEWLINE
              MOV AX,J
              CMP AX,N
              JL INPUT_FOR
              
     FOR:                 ;for(j=0;j<N;j++)
        MOV J,0
        XOR SI,SI
        MOV AX,J
        CMP AX,N
        JL FOR1
        JMP FOR1_NEXT
        
        FOR1:
            MOV AX,A[SI]     ;s=A[j]
            MOV S,AX 
            
            CMP S,29            ;if(s<=29)
            JLE IF_MILE         ;{
            JMP IF_MILE_NEXT
            
            IF_MILE:            
                   MOV AX,MILE  ;   mile=mile+10
                   ADD AX,10    ;} 
                   MOV MILE,AX
                   
                      
        ;IF1 STARTS    
            IF_MILE_NEXT:       ;if(s>=30)
                   CMP S,30     ; then execute TWO_LOOPS
                   JGE TWO_LOOPS
                   JMP ANOTHER_IF ;if(s<=59)->ANOTHER_IF 
                   
                TWO_LOOPS:               ;for(k=29;k<s;k=k+30)
                         MOV K,29        ;{
                         MOV AX,K        ;   continue
                         CMP AX,S        ;} 
                         JL CONTINUE
                         JMP CONTINUE_NEXT
                         
                      CONTINUE:
                              MOV AX,K     ; k=k+30
                              ADD AX,30
                              MOV K,AX
                              
                              MOV AX,K
                              CMP AX,S
                              JL CONTINUE
                              
                      CONTINUE_NEXT:
                              MOV AX,K    ;a=k
                              MOV A1,AX  
                              
                        MOV K,29          ;for(k=29;k<=a;k=k+30)
                        MOV AX,K          ;{
                        CMP AX,A1         ;   mile=mile+10   
                        JLE SECEND_LOOP   ;}
                        JMP SECEND_LOOP_NEXT
                        
                        SECEND_LOOP:
                                MOV AX,MILE  ;mile=mile+10
                                ADD AX,10
                                MOV MILE,AX              
                                    
                                MOV AX,K
                                ADD AX,30
                                MOV K,AX
                                
                                CMP AX,A1
                                JLE SECEND_LOOP
                                   
       ;END OF IF1                         
                                 
                                
            SECEND_LOOP_NEXT:                                        
                 
            ANOTHER_IF:          ;if(s<=59)
            CMP S,59             ;{
            JLE IF_JUICE         ;   juice=juice+15
            JMP IF_JUICE_NEXT    ;}
            
            IF_JUICE:
                   MOV AX,JUICE  ;juice=juice+15
                   ADD AX,15
                   MOV JUICE,AX
                   
                     
                   
            IF_JUICE_NEXT:       ;if(s>=60)
                   CMP S,60      ; then execute TWICE_LOOPS
                   JGE TWICE_LOOPS
                   JMP SECEND_LOOP1_NEXT        
                   
               TWICE_LOOPS:
                         MOV P,59          ;for(p=59;p<s;p=p+60)
                         MOV AX,P          ;{
                         CMP AX,S          ;   continue
                         JL CONTINUE1      ;}
                         JMP CONTINUE1_NEXT
                         
                      CONTINUE1:
                              MOV AX,P       ;p=p+60
                              ADD AX,60
                              MOV P,AX
                              
                              MOV AX,P
                              CMP AX,S
                              JL CONTINUE1  
                              
                      CONTINUE1_NEXT:
                              MOV AX,P      ;b=p
                              MOV B,AX   
                              
                        MOV P,59            ;for(p=59;p<=b;p=p+60)
                        MOV AX,P            ;{
                        CMP AX,B            ;  juice=juice+15
                        JLE SECEND_LOOP1    ;}
                        JMP SECEND_LOOP1_NEXT
                        
                        SECEND_LOOP1:
                                MOV AX,JUICE  ;mile=mile+10
                                ADD AX,15
                                MOV JUICE,AX              
                                    
                                MOV AX,P
                                ADD AX,60
                                MOV P,AX
                                
                                CMP AX,B
                                JLE SECEND_LOOP1    
                                      
                                                   
           SECEND_LOOP1_NEXT:
                        MOV A,0       ;continue the FOR1 loop
                        MOV B,0  
                        
                        ADD SI,2
                        INC J
                        MOV AX,J
                        CMP AX,N
                        JL FOR1
                        
          FOR1_NEXT:
                   MOV AX,MILE    ;if(mile>juice)
                   MOV BX,JUICE   ; then print MILE
                   
                   CMP AX,BX
                   JL PRINT_MILE
                   
                   CMP AX,BX       ;if(juice<mile)
                   JG PRINT_JUICE  ; then print JUICE
                   
                   CMP AX,BX       ;if(mile==juice)
                   JE PRINT_BOTH   ; then print BOTH
                   
          PRINT_MILE:              ;print output in desired format
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
                   
                   LEA DX,PRINT_MILE1
                   MOV AH,9
                   INT 21H
                   
                   MOV AX,MILE
                   PUSH AX
                   POP AX
                   CALL DECIMEL_OUTPUT 
                   DEC I
                   JMP END_WORK 
                   
          PRINT_JUICE:
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
                   
                   LEA DX,PRINT_JUICE1
                   MOV AH,9
                   INT 21H
                   
                   MOV AX,JUICE
                   PUSH AX
                   POP AX
                   CALL DECIMEL_OUTPUT  
                   DEC I
                   JMP END_WORK 
                   
          PRINT_BOTH:
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
                   
                   LEA DX,PRINT_BOTH1
                   MOV AH,9
                   INT 21H
                   
                   MOV AX,MILE
                   PUSH AX
                   POP AX
                   CALL DECIMEL_OUTPUT
                   DEC I         
                   
        END_WORK: 
               MOV MILE,0     ;continue the outer while loop
               MOV JUICE,0
               CALL NEWLINE
               
               INC I
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