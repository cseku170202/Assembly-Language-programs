;UVA 11777
;Automate the Grades
.MODEL SMALL
.STACK 100H
.DATA 
     TC DW ? 
     P DW ?
     TERM1 DW ?
     TERM2 DW ?
     FINALL DW ?
     ATTENDANCE DW ?
     CT1 DW ?
     CT2 DW ?
     CT3 DW ?
     AVG DW ?
     T DW ?
     I DW ?
     TOTAL DW 0       
     CASE DB 'Case $'
     COLON DB ': $'
     INPUT DB 'INPUT : $'
     OUTPUT DB 'OUTPUT : $' 
     SUM DB 'SUM : $'    
.CODE
MAIN PROC 
     MOV AX,@DATA
     MOV DS,AX 
     
     CALL DECIMEL_INPUT  ;INPUT TEST CASE TC
     MOV TC,AX
     CALL NEWLINE  
     
     MOV P,0     ;outer loop->test case loop
     MOV AX,P    ;for(p=0;p<tc;p++)
     CMP AX,TC
     JL TOP
     JMP EXIT
     
     TOP:
                     
     LEA DX,INPUT
     MOV AH,9
     INT 21H 
     CALL NEWLINE
     
     CALL DECIMEL_INPUT   ;input term1
     MOV TERM1,AX
     CALL NEWLINE
     
     CALL DECIMEL_INPUT   ;input term2
     MOV TERM2,AX
     CALL NEWLINE
     
     CALL DECIMEL_INPUT   ;input finall
     MOV FINALL,AX
     CALL NEWLINE
     
     CALL DECIMEL_INPUT   ;input attendance
     MOV ATTENDANCE,AX
     CALL NEWLINE
     
     CALL DECIMEL_INPUT   ;input CT1 mark
     MOV CT1,AX
     CALL NEWLINE
     
     CALL DECIMEL_INPUT   ;input CT2 mark
     MOV CT2,AX
     CALL NEWLINE
     
     CALL DECIMEL_INPUT   ;input CT3 mark
     MOV CT3,AX
     CALL NEWLINE
     
     ;AVERAGE CALCULATION
     MOV AX,CT1
     MOV BX,CT2
     MOV CX,CT3   
     
     CMP AX,BX          ;if(a>=b && b>=c)
     JGE IF             ; then avg of a && b
     JMP ELSE_IF_ONE
     
     IF:
       CMP BX,CX
       JGE AVG_AB
                  
     ELSE_IF_ONE:        ;else if(b>=c && c>=a)
                CMP BX,CX   ;   then avg of b && c
                JGE ANOTHER_ONE
                JMP ELSE_IF_TWO
                
            ANOTHER_ONE:
                       CMP CX,BX
                       JGE AVG_BC
                       
     ELSE_IF_TWO:                ;else if(a>=c && c>=b)
                CMP AX,CX        ; then avg of a && c
                JGE ANOTHER_TWO
              
                
            ANOTHER_TWO:
                       CMP CX,BX
                       JGE AVG_AC
  
      
     AVG_AB:
            XOR DX,DX
            ADD AX,BX
            MOV BX,2
            DIV BX
            
            MOV AVG,AX 
            JMP L
            
     AVG_BC:
           XOR DX,DX
           ADD BX,CX
           MOV AX,BX
           MOV BX,2
           DIV BX
           
           MOV AVG,AX
           JMP L
     AVG_AC:
           XOR DX,DX
           ADD AX,CX
           MOV BX,2
           DIV BX
           
           MOV AVG,AX
           JMP L  
           
   ;FINISH AVERAGE CT MARK CALCULATION  
                                                                            
     L:
      MOV AX,TERM1    ;AX=term1+term2
      MOV BX,TERM2
      ADD AX,BX
      
      MOV BX,FINALL   ;AX=term1+term2+finall
      ADD AX,BX
      
      MOV BX,ATTENDANCE
      ADD AX,BX       ;AX=term1+term2+finall+attendance
      
      MOV BX,AVG      
      ADD AX,BX       ;AX=term1+term2+finall+attendance+avg
      
      MOV TOTAL,AX    ;total=AX
      
      
     CMP TOTAL,90 ;if(total>=90)
     JGE PRINT_A  ; then print A
     
     ELSE_IF_FIRST:             ;else if(total>=80 && total!=90) 
                  CMP TOTAL,80  ; then print B
                  JGE AGAIN_FIRST
                  JMP ELSE_IF_2ND
                  
              AGAIN_FIRST:
                         CMP TOTAL,90
                         JNE PRINT_B
                         
     ELSE_IF_2ND:               ;else if(total>=70 && total!=80)
                CMP TOTAL,70    ; then print C
                JGE AGAIN_2ND
                JMP ELSE_IF_3RD
                
              AGAIN_2ND:
                       CMP TOTAL,80
                       JNE PRINT_C
                       
     ELSE_IF_3RD:                ;else if(total>=60 && total!=70)
                CMP TOTAL,60     ; then print D
                JGE AGAIN_3RD
                JMP ELSE_IF_4TH
                
              AGAIN_3RD:
                       CMP TOTAL,70
                       JNE PRINT_D
                       
     ELSE_IF_4TH:                ;else if(total<60)
                CMP TOTAL,60     ; then print F
                JL PRINT_F
   
   
   ;print the result in desired format             
     PRINT_A:               
            LEA DX,CASE
            MOV AH,9
            INT 21H
            
            INC P
            MOV AX,P
            PUSH AX
            POP AX
            CALL DECIMEL_OUTPUT
            
            LEA DX,COLON
            MOV AH,9
            INT 21H
            
            MOV AH,2
            MOV DL,'A'
            INT 21H
            CALL NEWLINE
            DEC P  
            JMP END_WORK
            
     PRINT_B: 
            LEA DX,CASE
            MOV AH,9
            INT 21H
            
            INC P
            MOV AX,P
            PUSH AX
            POP AX
            CALL DECIMEL_OUTPUT
            
            LEA DX,COLON
            MOV AH,9
            INT 21H
            
            MOV AH,2
            MOV DL,'B'
            INT 21H
            CALL NEWLINE 
            DEC P 
            JMP END_WORK
            
     PRINT_C:  
            LEA DX,CASE
            MOV AH,9
            INT 21H
            
            INC P
            MOV AX,P
            PUSH AX
            POP AX
            CALL DECIMEL_OUTPUT
            
            LEA DX,COLON
            MOV AH,9
            INT 21H
            
            MOV AH,2
            MOV DL,'C'
            INT 21H
            CALL NEWLINE
            DEC P
            JMP END_WORK
            
     PRINT_D: 
            LEA DX,CASE
            MOV AH,9
            INT 21H
            
            INC P
            MOV AX,P
            PUSH AX
            POP AX
            CALL DECIMEL_OUTPUT
            
            LEA DX,COLON
            MOV AH,9
            INT 21H
            
            MOV AH,2
            MOV DL,'D'
            INT 21H
            CALL NEWLINE
            DEC P  
            JMP END_WORK
            
     PRINT_F: 
            LEA DX,CASE
            MOV AH,9
            INT 21H
            
            INC P
            MOV AX,P
            PUSH AX
            POP AX
            CALL DECIMEL_OUTPUT
            
            LEA DX,COLON
            MOV AH,9
            INT 21H
            
            MOV AH,2
            MOV DL,'F'
            INT 21H
            CALL NEWLINE 
            DEC P
                                                                                                                   
     END_WORK:
             INC P 
             MOV AX,P
             CMP AX,TC
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