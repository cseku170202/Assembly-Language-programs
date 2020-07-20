;UVA 10591
;Happy Number
.MODEL SMALL
.STACK 100H
.DATA 
     T DW ?
     I DW ?
     A DW ?
     S DW ?
     SUM DW 0
     B DW ?   
     INPUT DB 'INPUT : $'
     OUTPUT DB 'OUTPUT : $'
     CASE DB 'Case #$'
     COLON DB ': $'
     HAPPY DB ' is a Happy number.$'
     UNHAPPY DB ' is an Unhappy number.$'
.CODE
MAIN PROC 
     MOV AX,@DATA
     MOV DS,AX   
     
     CALL DECIMEL_INPUT    ;input test case T
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
          
     MOV SUM,0                ;sum=0
     
     CALL DECIMEL_INPUT       ; take input A
     MOV A,AX
     CALL NEWLINE 
     
     MOV B,AX                 ;b=a
     
     CMP A,10                 ;if(a<10)
     JL IF                    ;{
     JMP IF_NEXT              ;  a=a*a
                              ;}
     IF:
       XOR DX,DX
       MOV AX,A 
       MOV BX,A
       MUL BX
       
       MOV A,AX  ; a=a*a
       
     IF_NEXT:                 ;while(a>=1)
           CMP A,1            ;{  
           JGE WHILE 
           JMP WHILE_NEXT
           
           WHILE:             
                XOR DX,DX
                MOV AX,A
                MOV BX,10
                DIV BX
                                 
                MOV A,AX       ;set A for the next execution               
                MOV S,DX       ;s=a%10 
                
                XOR DX,DX
                MOV AX,S
                MOV BX,S
                MUL BX
                
                MOV S,AX       ;s=s*s
                
                MOV AX,S
                ADD AX,SUM     ;sum=sum+(s*s) 
                MOV SUM,AX
                
                CMP SUM,1      ;if(sum==1 && a==0)
                JE CHECK_AGAIN ; then break
                JMP IF1
                
                    CHECK_AGAIN:
                           CMP A,0
                           JE WHILE_NEXT ; break
                           
                IF1:           ;if(a==0 && ( sum>=1 && sum<=9 ))
                   CMP A,0     ; then break
                   JE CHECK1
                   JMP IF2
                   
                  CHECK1:
                        CMP SUM,1
                        JGE CHECK1_1
                        JMP IF2
                        
                  CHECK1_1:
                          CMP SUM,9
                          JLE WHILE_NEXT  ; break
                          
                IF2:          ;if(a==0)
                   CMP A,0    ; then RESET
                   JE RESET 
                   
                   L:
                   CMP A,1    ;continue while loop
                   JGE WHILE  
                   
             JMP WHILE_NEXT      
                   
             RESET:
                  MOV AX,SUM
                  MOV A,AX   ;a=sum
                  MOV SUM,0  ;sum=0
                  JMP L      ;back into the loop by JMP L
                  
             WHILE_NEXT:
                       CMP SUM,1        ;if(sum==1)
                       JE HAPPY_NUMBER  ; then print Happy number
                       
                       ELSE:            ;else 
                           LEA DX,CASE  ; print Unhappy number 
                           MOV AH,9
                           INT 21H      ;print the output in desired format
                           
                           INC I
                           MOV AX,I
                           PUSH AX
                           POP AX
                           CALL DECIMEL_OUTPUT
                           
                           LEA DX,COLON
                           MOV AH,9
                           INT 21H
                           
                           MOV AX,B
                           PUSH AX
                           POP AX
                           CALL DECIMEL_OUTPUT
                           
                           LEA DX,UNHAPPY
                           MOV AH,9
                           INT 21H
                                  
                           DEC I       
                           JMP END_WORK
                           
                       HAPPY_NUMBER:
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
                           
                           MOV AX,B
                           PUSH AX
                           POP AX
                           CALL DECIMEL_OUTPUT
                           
                           LEA DX,HAPPY
                           MOV AH,9
                           INT 21H 
                           
                           DEC I
                           JMP END_WORK 
                           
         END_WORK:
                 CALL NEWLINE  ;continue the outer while loop               
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