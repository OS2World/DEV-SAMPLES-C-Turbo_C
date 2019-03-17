        NAME    c0
        PAGE    60,132
;[]------------------------------------------------------------[]
;|      C0-OS2.ASM -- Turbo C Start Up Code for OS/2            |
;|                                                              |
;|      Copyright (c) 1988 by Sam Denton                        |
;|      All Rights Reserved.                                    |
;[]------------------------------------------------------------[]

;       Segment and Group declarations

_TEXT   SEGMENT BYTE PUBLIC 'CODE'
_TEXT   ENDS
_DATA   SEGMENT PARA PUBLIC 'DATA'
environ@        dd      __argc@
__argv@         dd      __argc@
__argc@         dw      0
_DATA   ENDS
_EMUSEG SEGMENT WORD PUBLIC 'DATA'
_EMUSEG ENDS
_CVTSEG SEGMENT WORD PUBLIC 'DATA'
_CVTSEG ENDS
_SCNSEG SEGMENT WORD PUBLIC 'DATA'
_SCNSEG ENDS
_BSS    SEGMENT WORD PUBLIC 'BSS'
_BSS    ENDS
_BSSEND SEGMENT BYTE PUBLIC 'BSSEND'
_BSSEND ENDS
_STACK  SEGMENT STACK 'STACK'
        dw      200 dup(?)
_STACK  ENDS
SSEG    SEGMENT STACK 'STACK'
        dw      200 dup(?)
SSEG    ENDS

DGROUP  GROUP   _DATA, _EMUSEG, _CVTSEG, _SCNSEG, _BSS, _BSSEND
        ASSUME  CS:_TEXT, DS:DGROUP

;       External References

        extrn   _main:far
        extrn   _exit:far
        extrn   DosExit:far
        public  __exit

        SUBTTL  Start Up Code
        PAGE
;/*                                                     */
;/*-----------------------------------------------------*/
;/*                                                     */
;/*     Start Up Code                                   */
;/*     -------------                                   */
;/*                                                     */
;/*-----------------------------------------------------*/
;/*                                                     */
_TEXT   SEGMENT
STARTX          PROC    NEAR

;       Prepare main arguments

;       ExitCode = main(argc,argv,envp);

                push    word ptr environ@+2
                push    word ptr environ@
                push    word ptr __argv@+2
                push    word ptr __argv@
                push    __argc@
                call    _main

;       Flush and close streams and files

                push    ax
                call    _exit

;       Restore "Divide overflow" interrupt vector

__exit          proc    far

;       Set DS to DGROUP

                db      6Ah,1
                db      6Ah,0
                call    DosExit

__exit          endp
STARTX          ENDP

;       The DGROUP@ variable is used to reload DS with DGROUP

DGROUP@@        dw      seg DGROUP
_TEXT   ENDS
        END     STARTX
