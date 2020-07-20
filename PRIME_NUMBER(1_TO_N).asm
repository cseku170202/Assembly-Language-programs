INCLUDE "EMU8086.INC"
.MODEL SMALL
.STACK 100H
.DATA 
     N DW ?
     I DW ?
     J DW ?
     S DW 1 
     TEMP DW ?

.CODE
MAIN PROC 
     MOV AX,@DATA
     MOV DS,AX 
    
     PRINT "INPUT : " 
     CALL DECIMEL_INPUT  
     MOV N,AX          ;N IS THE HIGHEST NUMBER 
     
     CMP N,2           ;I=2 PRINT HOBE NAA JODI ETA NAA KORI
     JGE PRINT_TWO
     PRINT_TWO:
              PRINTN
              PRINTN  
              
     PRINT "THE PRIME NUMBERS ARE : "
     PRINTN         
     
     MOV I,2
     MOV AX,I       ;AX=I=OUTER LOOP CURRENT CONTENT
      
     MOV J,2        ;BX=J=INNER LOOP CURRENT CONTENT
     MOV BX,J
  ;OUTER LOOP START   
     OUTER_LOOP: 
               MOV CX,J
               CMP CX,I  ;if(j<I) false hoi tokhon I=2 print kore dite hobe
               JNL PRINT ;FOR I=2 PRINT HOBE ER JONNO
           
           
           ;INNER LOOP START    
               INNER_LOOP:
                         XOR DX,DX    ;CLEAR DX REGISTER
                         DIV BX       ;DX:AX=AX/BX , AX=QUOTIENT & DX=REMAINDER
                                 
                         MOV S,DX     ;S=REMAINDER
                                 
                         CMP DX,0     ;DX=S=0 hole r check korar dorkar nai
                         JE BREAK
                         
                         INC J
                         MOV BX,J     ;RESET BX REGISTER
                         
                         MOV AX,I     ;RESET AX REGISTER
                         
                         CMP J,AX      ; j<i porjonto loop colbe
                         JL INNER_LOOP  
          ;INNER LOOP FINISH            
               BREAK:     
                    CMP S,0    ;divisible hole i print kora jabe na.tai NEXT ee jump korbe
                    JE NEXT
                    
               PRINTN
                         
               PRINT:          ;pura inner loop colar pore jodi S!=0 (S=I%J) hoi tokhon setai prime number.So PRINT execute hobe
                    
                    MOV AX,I
                    
                    PUSH AX
                    POP AX 
                    CALL DECIMEL_OUTPUT 
                    PRINTN
                    
               NEXT: 
                   MOV J,2     ;INNER LOOP J START ALWAYS WITH THE VALUE 2
                   MOV BX,J    ;RESET THE BX REGISTER
                   
                   INC I
                   MOV AX,I    ;RESET THE AX REGISTER
                   
      CMP AX,N
      JLE OUTER_LOOP              
                         
   ;OUTER LOOP FINISH                    
                         


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