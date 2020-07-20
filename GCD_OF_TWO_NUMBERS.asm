.MODEL SMALL
.STACK 100H
.DATA 
    A DW ?
    B DW ?
    X DW ?

.CODE
MAIN PROC 
     MOV AX,@DATA
     MOV DS,AX 
     
     ;TAKE TWO NUMBER A && B TO FIND THE GCD
     ;AT LAST THE RESULT IS IN AX REGISTER
   
     CALL DECIMEL_INPUT 
     MOV A,AX
     CALL NEWLINE
     
     CALL DECIMEL_INPUT
     MOV B,AX
     CALL NEWLINE  
     
     CALL GCD
                      
     PUSH AX
     POP AX
     CALL DECIMEL_OUTPUT
     
     
     EXIT:
     MOV AH,4CH
     INT 21H
MAIN ENDP 
     
  GCD PROC 
    
     PUSH A
     PUSH B
     PUSH BX
     PUSH CX
     PUSH DX
           
     CMP A,AX
     JL A_SMALL
     
     MOV X,AX ; AX=B ekhane
  ;if condition   
     AGAIN: 
          XOR DX,DX
          MOV AX,A
          MOV BX,X
          DIV BX   ; DX:AX=AX/BX, DX=remainder , AX=integer part
          
          CMP DX,0
          JE B_TEST_REMAINDER  
          JNE ELSE
          
          
     B_TEST_REMAINDER:
                     MOV AX,B     
                     MOV BX,X
                     DIV BX
                           
                     CMP DX,0
                     JE PRINT_RESULT 
                     JNE ELSE
                     
     PRINT_RESULT:                      
                 MOV AX,X ;AX CONTAINS THE GCD OF A && B
                 JMP FINISH  
                 
   ;end if                     
     A_SMALL: 
            MOV AX,A
            MOV X,AX
            JMP AGAIN   
            
   ;else         
     ELSE:
         XOR DX,DX
         DEC X
         JMP AGAIN  
   ;end else 
   
     FINISH: 
      POP DX
      POP CX
      POP BX
      POP B
      POP A  
                
     RET       
   
GCD ENDP                          
     
         
     DECIMEL_INPUT PROC
        
            PUSH BX
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
              MOV CX,1
              
        @PLUS:
             INT 21H
             
        @REPEAT2:
                CMP AL,'0'
                JNGE @NOT_DIGIT ;if(AL>=0 && AL<=0)
                
                CMP AL,'9'
                JNLE @NOT_DIGIT  
                
                AND AX,000FH ; CONVERT TO DIGIT
                PUSH AX
                
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
              JE @EXIT  
                                   
              NEG AX
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
                
                OR AX,AX
                JNE @REPEAT1 
                
         ;convert digits to character and print
                 
                   MOV AH,2
         @PRINT_LOOP:
                    POP DX
                    OR DL,30H
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