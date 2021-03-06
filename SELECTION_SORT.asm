.MODEL SMALL
.STACK 100H
.DATA 

     A DW 5000 DUP (?) 
     I DW ?
     J DW ? 
     K DW ?
     SINDEX DW ?
     N DW ?  
     TEMP DW ? 
     TEMP_A DW ? 
     TEMP_B DW ? 
     OUTPUT DB 'SORTED LIST : $'
.CODE
MAIN PROC 
     MOV AX,@DATA
     MOV DS,AX 
    
     CALL DECIMEL_INPUT
     MOV CX,AX
     MOV K,CX
     CALL NEWLINE
              
     XOR BX,BX  ;ARRAY INDEX IN BX       
     INPUT_FOR: 
              CALL DECIMEL_INPUT 
              MOV A[BX],AX
              ADD BX,2
              CALL NEWLINE
     LOOP INPUT_FOR  
                   
     ;SORTING proc sorts the array A[] containing K elements              
                   
     CALL SORTING
     
     CALL NEWLINE         
             
     LEA DX,OUTPUT
     MOV AH,9
     INT 21H        
    
     CALL NEWLINE       
     XOR BX,BX
     MOV CX,K
     JMP OUTPUT_PRINT 
    
     OUTPUT_PRINT:
                 MOV AX,A[BX]
                 PUSH AX
                 POP AX
                 
                 CALL DECIMEL_OUTPUT
                 
                 ADD BX,2
                 CALL NEWLINE 
                 
     LOOP OUTPUT_PRINT            

     EXIT:
     MOV AH,4CH
     INT 21H
MAIN ENDP 
       
     
 SORTING PROC 
     PUSH K
     PUSH AX
     PUSH BX
     PUSH CX
     PUSH DX
     
  ;SORTING START 
     XOR BX,BX  ;ARRAY INDEX IN BX       
     MOV CX,K   ;LOOP COUNTER
     
     OUTER_LOOP: 
              MOV SINDEX,BX 
              MOV I,BX      ;OUTER LOOP CURRENT INDEX = I
              MOV N,CX      ;OUTER LOOP COUNTER ,N=CX
              
              
              ADD BX,2      ;THE NEXT INDEX OF CURRENT INDEX I, THAT IS J=I+1
              MOV J,BX
              SUB CX,1      ;INNER LOOP EKBAR KOM COLBE
              CMP CX,0      ;INNER LOOP JOKHON R CHECK KORTE HOBE NAA TOKHON OUTPUT PRINT KORTE COLE JABE
              JE L44
 
              INNER_LOOP:
                       MOV AX,A[BX]  ;AX=A[J] & BX=J  
                       MOV TEMP,BX   ;BX K TEMP E DHORE RAKHLAM
                          
                       MOV BX,SINDEX ;SINDEX=PREVIOUS INDEX
                       MOV DX,A[BX]  ;DX=A[SINDEX]  
                       
                       MOV BX,TEMP  ;DHORE RAKHA TEMP K AGAIN BX E RAKHLAM
                       
                       CMP AX,DX
                       JL LESS_THAN  ;SMALL INDEX J=SINDEX KORTE HOBE
                       L2:
                       ADD BX,2
              LOOP INNER_LOOP 
                  
                  
            ;INTERCHANGE A[I] & A[SINDEX]      
              L1:
                MOV BX,I 
                MOV DX,A[BX]   
                MOV TEMP_A,DX
                
                MOV BX,SINDEX 
                MOV DX,A[BX]  
                MOV TEMP_B,DX 
                
                MOV BX,I
                MOV DX,TEMP_B       
                MOV A[BX],DX
                
                MOV BX,SINDEX
                MOV DX,TEMP_A  
                MOV A[BX],DX  
             ;FINISH INTERCHANGE LABEL
                
                
                
                MOV BX,I 
                MOV CX,N
                ADD BX,2
              
           
     LOOP OUTER_LOOP
  ;SORTING END  
     L44:
     POP DX
     POP CX
     POP BX
     POP AX 
     POP K
     
     RET
    
     LESS_THAN:
              MOV AX,TEMP
              MOV SINDEX,AX 
              JMP L2 
  
SORTING ENDP   
     
         
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