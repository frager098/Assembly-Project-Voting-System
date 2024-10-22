PRINT MACRO P1
LEA DX,P1          
MOV AH,9           
INT 21H            
ENDM

DOSSEG
.MODEL SMALL
.STACK 100H

.DATA
INFO DB 10,13,"THIS PROGRAM ACCEPTS 6 UNIQUE VOTERS AND GIVE RESULT ACCORDING TO VOTES$"
CANDIDATE1 DB 10,13,"THE ID OF CANDIDATE 1 IS: 1$"  
CANDIDATE2 DB 10,13,"THE ID OF CANDIDATE 2 IS: 2$"  
CANDIDATE3 DB 10,13,"THE ID OF CANDIDATE 3 IS: 3$"  
MSG DB 10,13,"PLEASE CAST YOUR VOTE AMONG ANYONE OF THEM!: $"  
THANKS DB 10,13,"THANKS FOR VOTING...! $"  
REDO DB 10,13,'PRESS 1,2 OR 3 TO VOTE AGAIN!$'
IV DB 10,13,"INVALID VOTE$"  
M1 DB 10,13,"VOTES GAINED BY CANDIDATE 1: $"  
M2 DB 10,13,"VOTES GAINED BY CANDIDATE 2: $"  
M3 DB 10,13,"VOTES GAINED BY CANDIDATE 3: $"  
VT_C1 DW 0  
VT_C2 DW 0  
VT_C3 DW 0
RANGE DB 0
RESULT DW ?  
W1 DB 10,13,"CANDIDATE 1 WINS $"  
W2 DB 10,13,"CANDIDATE 2 WINS $"   
W3 DB 10,13,"CANDIDATE 3 WINS $"   
DRAW DB 10,13,"THIS IS A TIE ! $"   
.CODE
MAIN PROC

    MOV AX, @DATA
    MOV DS, AX

    PRINT INFO
    
PROMPT:               
    PRINT CANDIDATE1   
    PRINT CANDIDATE2   
    PRINT CANDIDATE3   
    PRINT MSG          


    COMPARISION:
    CMP RANGE,20        
    JE ENDD            

    CALL INP_VOTE      
    
    ; Comparing input vote with candidate IDs
    CMP AL,'1'    
    JE C1             ; If vote is for candidate 1
    CMP AL,'2'
    JE C2             ; If vote is for candidate 2
    CMP AL,'3'
    JE C3            ; If vote is for candidate 3
    JMP INVALID       ; If invalid vote, jump to INVALID

C1:
    INC VT_C1          
    PRINT THANKS 
    PRINT REDO
   
    JMP COMPARISION   
                  

C2:
    INC VT_C2          
    PRINT THANKS
    PRINT REDO
 
    JMP COMPARISION


C3:
    INC VT_C3        
    PRINT THANKS
    PRINT REDO
   
    JMP COMPARISION
  
         
INVALID:
    PRINT IV   
    DEC RANGE        
    
    JMP COMPARISION
       

ENDD:
    PRINT M1           

    MOV AX,VT_C1       
    ADD AX,48          
    MOV DX,AX
    MOV AH,2           
    INT 21H

    ; Similar process for printing votes of candidate 2 and candidate 3
    PRINT M2
    MOV AX,VT_C2
    ADD AX,48
    MOV DX,AX
    MOV AH,2
    INT 21H

    PRINT M3
    MOV AX,VT_C3
    ADD AX,48
    MOV DX,AX
    MOV AH,2
    INT 21H

    ; Comparison and declaration of winner
    MOV AX,VT_C1
    MOV BX,VT_C2
    CMP AX,BX
    JE TIE            ; If votes for candidate 1 and candidate 2 are equal, check with candidate 3
    JG C1_C3       ; If candidate 1 has more votes than candidate 2, check with candidate 3
    JL C2_C3         ; If candidate 2 has more votes than candidate 1, compare with candidate 3

TIE:
    MOV BX,VT_C3
    CMP AX,BX
    JE DRAW_RES       ; If all candidates have equal votes, it's a tie
    JL C3_WINNER     ; If candidate 1 and candidate 2 have less votes and candidate 3 has more, candidate 3 wins 

DRAW_RES:
    PRINT DRAW        ; Print tie message
    JMP EXIT

C1_C3:
    MOV BX,VT_C3
    CMP AX,BX 
    JE TIE
    JG WINNER
    JL C2_C3
 
C2_C3:
    MOV AX,VT_C2
    MOV BX,VT_C3
    CMP AX,BX
    JE TIE
    JG WINNER

C3_WINNER:
    MOV AX,VT_C3
    JMP WINNER

WINNER:
    MOV RESULT,AX    ; Store the result
    JMP PRINT_RESULT

PRINT_RESULT:
    CALL ENTERKEY     
    MOV DX,RESULT
    ADD DX,48         
    MOV AH,2
    INT 21H

    MOV AX,RESULT
    CMP AX,VT_C1
    JE L1            ; If result matches votes for candidate 1, jump to L1
    CMP AX,VT_C2
    JE L2            ; If result matches votes for candidate 2, jump to L2
    CMP AX,VT_C3
    JE L3            ; If result matches votes for candidate 3, jump to L3

L1:
    PRINT W1         ; Declare winner and exit
    JMP EXIT

L2:
    PRINT W2
    JMP EXIT

L3:
    PRINT W3
    JMP EXIT

    
EXIT:
    MOV AH,4CH
    INT 21H

MAIN ENDP

INP_VOTE PROC        ; Subroutine for inputting votes
    INC RANGE          
    MOV AH,1
    INT 21H
    RET 
INP_VOTE ENDP

ENTERKEY PROC        ; Subroutine for printing new line
    MOV DX,10
    MOV AH,2
    INT 21H
    MOV DX,13
    MOV AH,2
    INT 21H
    RET
ENTERKEY ENDP

END MAIN
