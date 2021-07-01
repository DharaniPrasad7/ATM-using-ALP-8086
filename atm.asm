
include 'emu8086.inc'

org 100h   
        
.model large
.data
game_start_str dw '  ',0ah,0dh

dw ' ',0ah,0dh
dw ' ',0ah,0dh
dw ' ',0ah,0dh
dw '                ****************************************************',0ah,0dh
dw '               ||                                                  ||',0ah,0dh                                        
dw '               ||       *<-    #WELCOME TO CIT ATM#     ->*        ||',0ah,0dh
dw '               ||                                                  ||',0ah,0dh
dw '               ||--------------------------------------------------||',0ah,0dh
dw '               ||                                                  ||',0ah,0dh
dw '               ||             **********************               ||',0ah,0dh
dw '               ||             *                    *               ||',0ah,0dh          
dw '               ||             *Press Enter to start*               ||',0ah,0dh
dw '               ||             *                    *               ||',0ah,0dh
dw '               ||             **********************               ||',0ah,0dh
dw '               ||                                                  ||',0ah,0dh 
dw '               ||                                                  ||',0ah,0dh
dw '               ||                                                  ||',0ah,0dh
dw '                ****************************************************',0ah,0dh
dw '$',0ah,0dh   
.code
main proc
mov ax,@data
mov ds,ax

mov ax, 0B800h
mov es,ax

jmp prog_start



jmp start
msg1 db "ATM                                        $"
msg2 db "SERVICES                                   $"

opt2 db "1.WITHDRAWAL$"
opt3 db "2.DEPOSIT$"
opt4 db "3.BALANCE ENQUIRY$" 
opt5 db "4.EXIT $"

;Pin Messages
pinmsg1 db "Enter the pin: $"
pinmsg2 db  "Invalid Pin$"   
pinerror db "Enter a valid Pin $"

;Account Messages
accmsg1 db "Enter the account number: $"
accmsg2 db "Invalid Account Number$"

;Balance Messages
balmsg db "Insufficient Balance$"

;Withdrawal Messages
Wd_msg db "Collect the cash$"
Wd_msg2 db " Enter the amount: $"
Wd_min db "Minimal WithDrawal amount is 100!!!$"

;Deposit Messages
dpmsg db "The amount is Deposited $"
dplmsg db "Deposit Limit is 25000 $"
dp_min db "Minimal Deposit amount is 100!!!$"  
                             ; 12345
;General Messages
mul100 db "Enter the amount in multiple's of 100 only$"
Con_trans db "Another Transaction(1/0):$"   
Thank_you db "Thank You !!!$"

;Account Details
pin dw 1234
acc dw 45678
acc_holder db "Hello Jerome$"
acc_balance dw 0     

ACC_NO dw 12345,45678,36789,37890               ;Array to store Account details
PIN_NO dw 4567,1234,6789,1098                   ;Array to store pin Number
BAL dw 20000,15000,10000,9000                   ;Array to store balance of the Account Holders
n dw 4 
m dw 4                                         ;No of Account Holders
w dw 00000  
count dw 0 
tries dw 3   
pass dw 0

restore proc
    mov n,4
    ret
restore endp



try1:   

mov ah,9h
mov dx,offset pinerror
int 21h
   
mov ah,9h
mov dx,offset accmsg1
int 21h

call SCAN_NUM
mov bx,cx    

jmp tryagain

                                

start:  
lea si,ACC_NO
lea di,PIN_NO

                                                        ;Account Number Verification
mov ah,9h
mov dx,offset accmsg1
int 21h

call SCAN_NUM
mov bx,cx              
mov cx,n

loop1:         
mov ax,[si]
inc si
inc si

cmp bx,ax
jz true 
loop loop1
          
mov ah,09h
mov dx,offset accmsg2
int 21h
hlt


true:
 CALL CLEAR_SCREEN                                                       ;Pin Verification 
mov ah,9h
mov dx,offset pinmsg1
int 21h 

add n,1
sub n,cx  
lea si,BAL

call SCAN_NUM
mov bx,cx
mov cx,n 
loop2:
mov ax,[di]  
mov pass,ax
mov dx,[si]
inc di
inc di
inc si
inc si
loop loop2 
mov acc_balance,dx  
tryagain:
cmp bx,pass
jz true1

CALL CLEAR_SCREEN
mov bx,count
;mov ax,tries
inc count
cmp bx,tries  

jnz try1   
 

mov ah,09h
mov dx,offset pinmsg2
int 21h
hlt


true1: 
CALL CLEAR_SCREEN      
mov ah,9h       
mov dx,offset msg1           ;Print "ATM"
int 21h

mov ah,02h
mov dl,0ah
int 21h   
int 21h
mov dl,0dh
int 21h

mov ah,9h
mov dx,offset msg2           ;Print "SERVICES"
int 21h

mov ah,02h
mov dl,0ah
int 21h
mov dl,0dh
int 21h

continue:


mov ah,02h
mov dl,0ah
int 21h
mov dl,0dh
int 21h

 
mov ah,9h 
mov dx,offset opt2           ;Print "1.WITH DRAWAL "
int 21h

mov ah,02h
mov dl,0ah
int 21h
mov dl,0dh
int 21h


mov ah,9h
mov dx,offset opt3           ;Print "2.DEPOSIT "
int 21h

mov ah,02h
mov dl,0ah
int 21h
mov dl,0dh
int 21h


mov ah,9h
mov dx,offset opt4            ;Print "3.BALANCE ENQUIRY "
int 21h 

mov ah,02h
mov dl,0ah
int 21h
mov dl,0dh
int 21h


mov ah,9h
mov dx,offset opt5            ;Print "4.EXIT "
int 21h    



mov ah,02h
mov dl,0ah
int 21h
mov dl,0dh
int 21h

print "ENTER THE OPTION : "    ;Print "Asks for Option"

call SCAN_NUM                  ; Inbuilt function to get Input

mov ah,02h
mov dl,0ah
int 21h   
int 21h

mov al,cl
      
cmp al,01h
jz  wd

cmp al,02h
jz dp

cmp al,03h
jz be

cmp al,04h 
CALL CLEAR_SCREEN
call restore
jmp start


wd:                               ;WithDrawal Module
CALL CLEAR_SCREEN 

scan:
mov ah,9h
mov dx,offset Wd_msg2
int 21h


call SCAN_NUM

mov bx,100

cmp cx,bx
jnc next
mov ah,9h
mov dx,offset Wd_min
int 21h
jmp wd


next:
mov ax,cx
mov dx,00
mov bx,100
div bx
cmp dx,0
jz input
call CLEAR_SCREEN

mov ah,09h
mov dx,offset mul100
int 21h

jmp scan
input:
mov bx,acc_balance 

cmp bx,cx
jnc  balance1
mov ah,9h
mov dx,offset balmsg
int 21h
jmp wd

balance1:

mov ah,02h
mov dl,0ah
int 21h
mov dl,0dh
int 21h
  
sub acc_balance,cx
mov ah,9h
mov dx,offset Wd_msg
int 21h   

mov ah,02h
mov dl,0ah
int 21h
mov dl,0dh
int 21h

mov dx,0
mov ah,9h
mov dx,offset Con_trans
int 21h

call SCAN_NUM
cmp cx,01h
jz true1

mov ah,02h
mov dl,0ah
int 21h
mov dl,0dh
int 21h


mov ah,9h
mov dx,offset Thank_you
int 21h

l1:

hlt

dp:
scan1:                             ;Deposit Module
CALL CLEAR_SCREEN

mov ah,9h
mov dx,offset Wd_msg2
int 21h

call SCAN_NUM

mov bx,100

cmp cx,bx
jnc next1
mov ah,9h
mov dx,offset dp_min
int 21h
jmp scan1

next1:
mov bx,25000

cmp bx,cx
jc  dpl
mov ax,cx
mov dx,00
mov bx,100
div bx
cmp dx,0
jz input2
call CLEAR_SCREEN

mov ah,09h
mov dx,offset mul100
int 21h

jmp scan1
input2:

add acc_balance,cx
call CLEAR_SCREEN
mov ah,9h
mov dx,offset dpmsg
int 21h 

mov ah,02h
mov dl,0ah
int 21h
mov dl,0dh
int 21h


mov ah,9h
mov dx,offset Con_trans
int 21h

call SCAN_NUM
cmp cx,01h
jz true1

mov ah,02h
mov dl,0ah
int 21h
mov dl,0dh
int 21h

mov ah,9h
mov dx,offset Thank_you
int 21h
hlt

dpl:
call CLEAR_SCREEN
mov ah,9h
mov dx,offset dplmsg
int 21h
jmp dp



be:                              ;Balance Enquiry Module
CALL CLEAR_SCREEN
print " YOUR BALANCE IS : "
mov ax,acc_balance
CALL PRINT_NUM_UNS  

mov ah,02h
mov dl,0ah
int 21h
mov dl,0dh
int 21h

mov ah,9h
mov dx,offset Con_trans
int 21h

call SCAN_NUM
cmp cx,01h
jz true1

mov ah,02h
mov dl,0ah
int 21h
mov dl,0dh
int 21h

mov ah,9h
mov dx,offset Thank_you
int 21h
hlt
 
 


ret 


prog_start:      
          
mov ah,09h
    mov dh,0
    mov dx, offset game_start_str
    int 21h
                                           ;wait for input to enter into prog
    inputkey:
        mov ah,1
        int 21h
        cmp al,13d
        jne input2
        call clear_screen 
                          
jmp start   



DEFINE_SCAN_NUM               ;Function to get input
DEFINE_CLEAR_SCREEN           ;Function for clear Screen
DEFINE_PRINT_NUM              ;Function to print signed number
DEFINE_PRINT_NUM_UNS          ;Function to print 

END