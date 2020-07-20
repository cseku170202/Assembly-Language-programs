INCLUDE "EMU8086.INC"
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
 

.CODE
MAIN PROC 
     MOV AX,@DATA
     MOV DS,AX 
    
    ; PRINT "INPUT : " 
     CALL DECIMEL_INPUT 
     
     MOV NUM,AX           ;SAVE THE INPUT IN NUM,NUMBER & ACTUAL_NUMBER
     MOV NUMBER,AX 
     MOV ACTUAL_NUMBER,AX
     
     CMP AX,0
     JE INPUT_ZERO 
      
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
               
     CMP NUMBER,0
     JE INPUT_ZERO 
     
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
          MOV AX,SUM
          CMP AX,ACTUAL_NUMBER
          JE ARMSTRONG  
          
          PRINTN
          PRINT "NOT ARMSTRONG NUMBER"
          JMP EXIT
          
     ARMSTRONG:
              PRINTN
              PRINT "ARMSTRONG NUMBER" 
              JMP EXIT 
              
              
     INPUT_ZERO:
               PRINTN
               PRINT "THIS IS AN INVALID INPUT."
               JMP EXIT        
      
      
      

     EXIT:
     MOV AH,4CH
     INT 21H
MAIN ENDP 
     
         
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

END MAIN