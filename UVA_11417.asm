;UVA 11417
;GCD
.MODEL SMALL
.STACK 100H
.DATA 
    A DW ?
    B DW ?
    X DW ?    
    N DW ?
    I DW ?
    J DW ?
    G DW ?  
    INPUT DB 'INPUT :$'
    OUTPUT DB 'OUTPUT :$'
.CODE
MAIN PROC 
     MOV AX,@DATA
     MOV DS,AX  
     
     TOP: 
     
     LEA DX,INPUT
     MOV AH,9
     INT 21H
     CALL NEWLINE
     
     CALL DECIMEL_INPUT      ;take input N
     MOV N,AX
     CALL NEWLINE
     
     CMP N,0     ;if(N==O)
     JE EXIT     ; then break
     
     MOV G,0     ;G=0
     
     MOV I,1
     MOV AX,I
     CMP AX,N
     JL FOR
     JMP PRINT
     
     FOR:         ;for(i=1;i<N;i++)
        INC I     ;{
        MOV AX,I  ;   for(j=j+1;j<=N;j++)
        MOV J,AX  ;   {
        DEC I     ;     G=G+GCD(i,j)
        CMP AX,N  ;   } 
        JLE FOR1  ;}
        JMP FOR_AGAIN
        
          FOR1:
              MOV AX,I
              MOV A,AX
            
              MOV AX,J
              MOV B,AX
            
              CALL GCD
            
              ADD AX,G
              MOV G,AX  ;G=G+GCD(I,J)
            
              INC J
              MOV AX,J
              CMP AX,N
              JLE FOR1
            
      FOR_AGAIN:
              INC I
              MOV AX,I
              CMP AX,N
              JL FOR
              
     PRINT:           ;print the result
          MOV AX,G
          PUSH AX
          POP AX
          CALL DECIMEL_OUTPUT
          JMP END_WORK
          
     END_WORK: 
            CALL NEWLINE
            JMP TOP                    
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