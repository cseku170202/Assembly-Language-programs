;UVA 10035
;PRIMARY ARITHMATIC
.MODEL SMALL
.STACK 100H
.DATA 
     A DW ?
     B DW ?
     C DW 0
     CI DW 0
     S DW ?
     ANS DW ? 
     R1 DW ?
     R2 DW ?
     A_TEMP DW ?
     B_TEMP DW ?    
     INPUT DB 'INPUT : $'
     OUTPUT DB 'OUTPUT : $' 
     SUM DB 'SUM : $'  
     TEMP DB ? 
     INVALID DB 'INVALID $'
     EQUILATERAL DB 'EQUILATERAL $'    
     NO_CARRY DB 'No carry operation $' 
     ONE_CARRY DB '1 carry operation $' 
     OPERATIONS DB ' carry operations $'
.CODE
MAIN PROC 
     MOV AX,@DATA
     MOV DS,AX       
     TOP:                     
     LEA DX,INPUT
     MOV AH,9
     INT 21H
     CALL NEWLINE
          
     CALL DECIMEL_INPUT      ;TAKE AN INPUT
     MOV A,AX
     CALL NEWLINE  
     
     CALL DECIMEL_INPUT      ;TAKE ANOTHER INPUT
     MOV B,AX
     CALL NEWLINE
                  
     MOV CX,0     ;CX HOLDS THE SUM         
     MOV C,0      ;NUMBER OF CARRY COUNTS
     MOV CI,0    
     
     CMP A,0             ;if(a==0 && B==0)
     JE ANOTHER_CHECK    ;   break
     
     ANOTHER_CHECK:
                  CMP B,0
                  JE EXIT
     
     CMP A,0        ;while(a!=0 !! b!=0)
     JNE WHILE
     
     CMP B,0
     JNE WHILE     
                       
     WHILE:
          XOR DX,DX  ;a%10
          MOV AX,A 
          MOV BX,10
          DIV BX
          
          MOV A,AX   ;A=A/10 ; quotient( next A)
          MOV R1,DX  ;R1=dx=a%10
          
          XOR DX,DX  ;B%10
          MOV AX,B
          MOV BX,10
          DIV BX
          
          MOV B,AX   ;B=B/10 ;quotient (next B)
          MOV R2,DX  ;R2=dx=b%10
          
          MOV CX,R1  ;cx=R1+R2
          ADD CX,R2
          ADD CX,CI  ;cx=R1+R2+CI
          
          MOV S,CX   ;S=cx
          
          CMP S,10   ;if(S>=10)
          JGE COUNT  ; then c++
          
          L:        
          XOR DX,DX  ;ci=s/10      
          MOV AX,S
          MOV BX,10
          DIV BX
          
          MOV CI,AX
          
          CMP A,0    ;if(a!=0 !! B!=0)
          JNE WHILE  ; then execute loop again
          
          CMP B,0
          JNE WHILE
          
     JMP NEXT     ; after finishinf the loop jump to next          
     COUNT:
          INC C
          JMP L                 
     NEXT:     
     CMP C,0
     JE NO
     
     CMP C,1
     JE ONE
     
     CMP C,1
     JG ELSE_PRINT     
     NO:                ;if(c==0)
       LEA DX,NO_CARRY  ;  then .....
       MOV AH,9
       INT 21H  
       CALL NEWLINE
       JMP END_WORK        
     ONE:                ;else if(c==1)
        LEA DX,ONE_CARRY ; then .....
        MOV AH,9
        INT 21H
        CALL NEWLINE
        JMP END_WORK         
     ELSE_PRINT:         ;else 
              MOV AX,C   ; ......
              PUSH AX
              POP AX
              CALL DECIMEL_OUTPUT
              
              LEA DX,OPERATIONS
              MOV AH,9
              INT 21H
              CALL NEWLINE              
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