INCLUDE "EMU8086.INC"
.MODEL SMALL
.STACK 100H
.DATA 
    A DW 5 DUP (?)
    B DW ?
    AREA DW ?

.CODE
MAIN PROC 
     MOV AX,@DATA
     MOV DS,AX
     
     XOR BX,BX ;array index
     MOV CX,5  ;Loop counter  
     PRINT "ENTER 5 DECIMEL INPUTS : "  
     PRINTN
     
     INPUT_FOR:
              CALL DECIMEL_INPUT  
              MOV A[BX],AX
              ADD BX,2 
              PRINTN
              LOOP INPUT_FOR   
              
          
     XOR BX,BX ;array index
     MOV CX,5  ;Loop counter  
     PRINT "THE OUTPUT 5 ELEMENTS STORED IN THE ARRAY : "
      
     OUTPUT_FOR:
              MOV AX,A[BX]
              PUSH AX
              PRINTN
              POP AX
              CALL DECIMEL_OUTPUT
              ADD BX,2
              LOOP OUTPUT_FOR         
 
     
     ;PUSH AX
     ;PRINTN
     ;PRINT "OUTPUT : "
     ;POP AX 
     ;CALL DECIMEL_OUTPUT

     
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