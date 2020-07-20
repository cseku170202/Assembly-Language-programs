include "emu8086.inc"
.model small
.stack 100h
.data 
a dw ?
b dw ?
;c dw 2 
.code
main proc 
        call scan_num
         mov ax,cx  ;scan 
         mov a,ax
         mov bx,2
         cmp ax,0
         jg print
         
         print:
            add ax,1
            mul a   ;mul with ax and set value in ax
            div bx ; div bx by ax save it ax
            add ax,1
            
            printn
            call print_num_uns
    
    
    
  define_scan_num
  define_print_num_uns
exit:
    mov ah,4ch
    int 21h
end main