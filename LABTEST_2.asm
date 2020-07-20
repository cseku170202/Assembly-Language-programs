
.MODEL SMALL
.STACK 100H
.DATA 
    A DW 5 DUP (?) 
    NUM DW ?
    NUMBER DW ? 
    C DW ? 
    J DW 0 
    S DW 0 
    B DW ? 
    Y DW ? 
    TEMP DW ?  
    SUM DW 0
    AX_TEMP DW ?
    ACTUAL_NUMBER DW ?  
    
    NUM1 DW ?
    N1 DW ?
    REMAINDER1 DW ?
    QUOTIENT1 DW ? 
    A1 DW ? 
    REVERSE_NUM DW ? 
    INPUT DB 'TAKE AN INPUT : $'
    PRINT1 DB 'POWER SUM = $'
    PRINT2 DB 'REVERSE NUM = $' 
    SUCCESSFUL DB 'SUCCESSFUL $'
    UNSUCCESSFUL DB 'UNSUCCESSFUL $'
.CODE
MAIN PROC 
     MOV AX,@DATA
     MOV DS,AX 
    
     LEA DX,INPUT
     MOV AH,9
     INT 21H 
     
     CALL DECIMEL_INPUT 
     
     MOV NUM,AX           ;SAVE THE INPUT IN NUM,NUMBER & ACTUAL_NUMBER
     MOV NUMBER,AX 
     MOV ACTUAL_NUMBER,AX
      
  ;1ST WHILE LOOP   
     TOTAL_DIGIT_COUNT:  
                      XOR DX,DX       ;CLEAR THE DX REGISTER
                      MOV BX,10
                      DIV BX          ;DX:AX=AX/BX  AX=integer part & DX=remainder
                                      
                      INC J          ;J IS THE COUNTER OF THE TOTAL DIGIT OF THE TAKEN INPUT
                      
                      MOV NUM,AX     ;integer part kome AX re vitor thakbe.
                      CMP NUM,0
                      JE LOOP_BREAK_EXECUTE_NEXT_LINE
                      
                      JMP TOTAL_DIGIT_COUNT
  ;1ST WHILE LOOP END                    
     LOOP_BREAK_EXECUTE_NEXT_LINE: 
                                 MOV BX,J
                                 MOV S,BX   ;S=J
                                 
     MOV AX,NUMBER                                         
              
  ;2ND WHILE LOOP   
     CALCULATE_SUM: 
                  
                  XOR DX,DX
                  MOV BX,10
                  DIV BX
                  
                  MOV B,DX       ;B=DX 
                  MOV AX_TEMP,AX ;AX_TEMP=AX
                            
                           
                  JMP POWER_SUM
                  L1:
                    ADD SUM,BX    ;result(x to the power n) keno BX ee thaklo bujhlam naa. SUM = SUM + BX 
                    
                  CMP AX_TEMP,0
                  JE BREAK  
                  
                  MOV AX,AX_TEMP ;AX er value RESET kore dilam
                  
      JMP CALCULATE_SUM
    ;2ND WHILE LOOP END              
                               
   ;x to the power n               
     POWER_SUM:
              MOV Y,1
              MOV AX,DX ;DX=x 
              MOV TEMP,AX      ;value save kore rakhlam loop er vitor use korar jonno.TEMP=AX
              MOV BX,Y  ;y=1
              MOV CX,S  ;CX=n
              
              POWER:
                   MUL BX  
                   
                   MOV BX,AX
                   MOV AX,TEMP
              LOOP POWER 
                                           
     JMP L1 
   ;x to the power n end  
     
    BREAK:
     
     MOV AX,ACTUAL_NUMBER
     CALL REVERSE_NUMBER  
                        
     CALL NEWLINE                   
     LEA DX,PRINT1
     MOV AH,9
     INT 21H
                                           
     MOV AX,SUM
     PUSH AX
     POP AX
     CALL DECIMEL_OUTPUT   
     
     CALL NEWLINE 
     LEA DX,PRINT2
     MOV AH,9
     INT 21H
     
     MOV AX,A1
     PUSH AX
     POP AX
     CALL DECIMEL_OUTPUT  
     
     CALL NEWLINE
     MOV AX,SUM
     CMP AX,A1
     JE PRINT_SUCCESSFUL
                         
     CALL NEWLINE                    
     LEA DX,UNSUCCESSFUL
     MOV AH,9
     INT 21H
     
     JMP EXIT         
                      
     PRINT_SUCCESSFUL: 
     CALL NEWLINE               
     LEA DX,SUCCESSFUL
     MOV AH,9
     INT 21H  
                         
     EXIT:
     MOV AH,4CH
     INT 21H
MAIN ENDP  

      REVERSE_NUMBER PROC
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX

        MOV NUM1,AX        
        MOV N1,AX
     
        CMP N1,0
        JE NUMBER_ZERO 
     
        PALINDROME_LOOP:
                    XOR DX,DX
                    MOV AX,N1
                    MOV BX,10
                    DIV BX     ;DX:AX=AX/BX, QUOTIENT=AX,REMAINDER=DX
                    
                    MOV REMAINDER1,DX ;VALUE SAVE KORE RAKHLAM REMAINDER & QUOTIENT EE
                    MOV QUOTIENT1,AX
                    
                    MOV AX,A1    
                    MOV BX,10
                    MUL BX      ;DX:AX=AX*BX
                    
                    ADD AX,REMAINDER1
                    MOV A1,AX
                    
                    ;SET A1 AND N1 AGAIN
                    ;QUOTIENT1 WILL BE THE NEXT N1
                    ;A1 WILL BE THE NEXT MULTIPLICANT AND IT IS SET AUTOMATICALLY.NOTHING TO BE DONE FOR A1 AGAIN 
                    
                    MOV AX,QUOTIENT1
                    MOV N1,AX
                    
                    CMP QUOTIENT1,0
                    JNE PALINDROME_LOOP 
          NUMBER_ZERO:          
                    
          POP DX
          POP CX
          POP BX
          POP AX
          RET 
          
     REVERSE_NUMBER ENDP  
     
         
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