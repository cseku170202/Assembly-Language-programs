;UVA 11479 
;Is this the easiest problem?
.MODEL SMALL
.STACK 100H
.DATA 
     A DW ?
     B DW ?
     C DW ?
     M DW ?
     N DW ? 
     T DW ?
     I DW 0
     ANS DW ?   
     INPUT DB 'INPUT : $'
     OUTPUT DB 'OUTPUT : $' 
     SUM DB 'SUM : $'  
     TEMP DB ? 
     INVALID DB 'Invalid $'
     EQUILATERAL DB 'Equilateral $'
     ISOSCELES DB 'Isosceles $' 
     SCALENE DB 'Scalene $'
     CASE DB 'Case $'
     COLON DB ': $'
.CODE
MAIN PROC 
     MOV AX,@DATA
     MOV DS,AX 
     
     CALL DECIMEL_INPUT      ;INPUT TEST CASE
     MOV T,AX
     CALL NEWLINE
     
     TOP:
     CALL DECIMEL_INPUT      ;INPUT A
     MOV A,AX
     CALL NEWLINE 
     
     CALL DECIMEL_INPUT      ;INPUT B
     MOV B,AX
     CALL NEWLINE
     
     CALL DECIMEL_INPUT      ;INPUT C
     MOV C,AX
     CALL NEWLINE
     
     MOV AX,A                ;AX=A
     MOV BX,B                ;BX=B
     MOV CX,C                ;CX=C
  ;IF BLOCK         
     XOR DX,DX               ;if(A+B<=C)
     MOV DX,AX
     ADD DX,BX ;ADD AX,BX
     CMP DX,CX
     JLE PRINT_INVALID
                             ;||
     XOR DX,DX               ;if(B+C<=A)
     MOV DX,BX
     ADD DX,CX ;ADD BX,CX
     CMP DX,AX
     JLE PRINT_INVALID
                             ;||
     XOR DX,DX               ;if(A+C<=B)
     MOV DX,AX
     ADD DX,CX ;ADD AX,CX
     CMP DX,BX
     JLE PRINT_INVALID 
  ;END IF
     
  ;ELSE IF->1
     XOR DX,DX       ;if(A+B>C)
     MOV DX,AX
     ADD DX,BX
     CMP DX,CX
     JG ELSE_IF_ONE
                     ;||  
     XOR DX,DX       ;if(B+C>A)
     MOV DX,BX
     ADD DX,CX
     CMP DX,AX
     JG ELSE_IF_ONE
                     ;||
     XOR DX,DX       ;if(A+C>B)
     MOV DX,AX
     ADD DX,CX
     CMP DX,BX
     JG ELSE_IF_ONE   
     
   ;ELSE IF->1 END
     
     
   ;ELSE IF->2 
     ELSE_TWO:
     XOR DX,DX
     MOV DX,AX
     ADD DX,BX
     CMP DX,CX
     JG ELSE_IF_TWO
     
     XOR DX,DX
     MOV DX,BX
     ADD DX,CX
     CMP DX,AX
     JG ELSE_IF_TWO
     
     XOR DX,DX
     MOV DX,AX
     ADD DX,CX
     CMP DX,BX
     JG ELSE_IF_TWO  
   ;ELSE IF-2 END
   
   ;ELSE IF->3
     ELSE_THREE: 
     XOR DX,DX
     MOV DX,AX
     ADD DX,BX
     CMP DX,CX
     JG ELSE_IF_THREE
     
     XOR DX,DX
     MOV DX,BX
     ADD DX,CX
     CMP DX,AX
     JG ELSE_IF_THREE
     
     XOR DX,DX
     MOV DX,AX
     ADD DX,CX
     CMP DX,BX
     JG ELSE_IF_THREE
    ;ELSE IF->3 END 
  
     PRINT_INVALID: 
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
                  
                  LEA DX,INVALID
                  MOV AH,9
                  INT 21H 
                  JMP END_WORK
                  
     ELSE_IF_ONE:
                CMP AX,BX
                JE CHECK_AGAIN 
                JMP ELSE_TWO
                
            CHECK_AGAIN:
                       CMP BX,CX
                       JE PRINT_EQUILATERAL 
                       JMP ELSE_TWO
                
            PRINT_EQUILATERAL: 
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
                       
                       LEA DX,EQUILATERAL
                       MOV AH,9
                       INT 21H
                       JMP END_WORK  
                                                                    
     ELSE_IF_TWO:
                CMP AX,BX
                JE PRINT_ISOSCELES
                JNE ELSE_THREE
                
                CMP BX,CX
                JE PRINT_ISOSCELES 
                JNE ELSE_THREE
                
                CMP AX,CX
                JE PRINT_ISOSCELES 
                JNE ELSE_THREE
                
           PRINT_ISOSCELES: 
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
                          
                          LEA DX,ISOSCELES
                          MOV AH,9
                          INT 21H
                          JMP END_WORK  
                          
     ELSE_IF_THREE:
                  CMP AX,BX
                  JNE LAST_CHECK
                  
              LAST_CHECK:
                        CMP BX,CX
                        JNE FINISHING
                        
              FINISHING:
                       CMP AX,CX
                       JNE PRINT_SCALENE
                       
              PRINT_SCALENE: 
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
                           
                           LEA DX,SCALENE
                           MOV AH,9
                           INT 21H
                           JMP END_WORK
                              
      END_WORK: 
             CALL NEWLINE                    
             DEC T
             CMP T,0
         JG TOP                                                                
         
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