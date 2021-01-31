
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega16
;Program type             : Application
;Clock frequency          : 4.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : No
;global 'const' stored in FLASH: Yes
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _i=R4
	.DEF _posit=R7
	.DEF _time_counter=R8
	.DEF _keyValue=R6
	.DEF _aa=R11
	.DEF _bb=R10
	.DEF _cc=R13
	.DEF _dd=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_comp_isr
	JMP  0x00

_led_7:
	.DB  0x3F,0x6,0x5B,0x4F,0x66,0x6D,0x7D,0x7
	.DB  0x7F,0x6F
_position:
	.DB  0xC3,0xC3,0xA3,0x93

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x3:
	.DB  0x7F,0xBF,0xDF,0xEF,0xF7,0xFB,0xFD,0xFE
_0x4:
	.DB  0x3F,0x6,0x5B,0x4F,0x66,0x6D,0x7D,0x7
	.DB  0x7F,0x6F,0x77,0x7C,0x39,0x5E,0x79,0x71
_0x3C:
	.DB  0x0,0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x08
	.DW  _resit
	.DW  _0x3*2

	.DW  0x02
	.DW  0x04
	.DW  _0x3C*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;//#include "avr/io.h"
;         //包含AVR单片机寄存器定义的头文件
;         #include <mega16.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include "NBCAVR.h"         //包含位操作的头文件
;
;#define uchar unsigned char
;#define uint  unsigned int
;
;#define LED_Data  PORTB
;#define Dataport PORTC
;#define LED_1 PIOD4
;#define LED_2 PIOD5
;#define LED_3 PIOD6
;#define LED_4 PIOA6
;
;#define S1 PIOD2           //定义按键IO
;#define S2 PIOD0
;#define S3 PIOD3
;#define S4 PIOD1
;#define S5 PIOA7
;
;
;
;
;
;flash char led_7[10]={0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F};
;//flash char position[6]={0xfe,0xfd,0xfb,0xf7,0xef,0xdf};
;//flash char position[4]={0xff,0xbf,0xdf,0xef};
;flash char position[4]={0xc3,0xc3,0xa3,0x93};
;flash char positiona[4]={0x43,0x03,0x03,0x03};                                      // 位选PORTA
;uchar resit[8]={0x7F, 0xBF, 0xDF, 0xEF, 0xF7, 0xFB, 0xFD, 0xFE};

	.DSEG
;
;int i=0;
;//int time_counter; // 中断次数计数单元
;char posit;
;bit point_on, time_1s_ok;
;
;char time[2]; // 时、分、秒计数
;char dis_buff[4]; // 显示缓冲区，存放要显示的 6 个字符的段码值
;uint time_counter; // 1 秒计数器
;//bit point_on; // 秒显示标志
;
;
;
;uchar keyValue;             //定义扫描结果参数
;//uchar  dis[16]={0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,
;             //  0    1    2    3    4    5    6    7
;              // 0x7F,0x6F,0x77,0x7C,0x39,0x5E,0x79,0x71};//0~F的段码
;             //  8    9    A    B    C    D    E    F
;
;
;
;
;
;
;
;
;uchar keyValue;             //定义扫描结果参数
;uchar  dis[16]={0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,
;             //  0    1    2    3    4    5    6    7
;               0x7F,0x6F,0x77,0x7C,0x39,0x5E,0x79,0x71};//0~F的段码
;             //  8    9    A    B    C    D    E    F
;
;uchar aa; //片选
;uchar bb;//字符
;uchar cc;//信号量
;uchar dd;
;
;
;//***********************************************************************************
;//延时
;//***********************************************************************************
;void delay(uint time)
; 0000 004A {

	.CSEG
_delay:
; 0000 004B 	uint i,j;
; 0000 004C 	for(i = 0;i < time; i++)
	CALL __SAVELOCR4
;	time -> Y+4
;	i -> R16,R17
;	j -> R18,R19
	__GETWRN 16,17,0
_0x6:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x7
; 0000 004D 	{
; 0000 004E 	  for(j = 0;j < 30; j++);
	__GETWRN 18,19,0
_0x9:
	__CPWRN 18,19,30
	BRSH _0xA
	__ADDWRN 18,19,1
	RJMP _0x9
_0xA:
; 0000 004F     }
	__ADDWRN 16,17,1
	RJMP _0x6
_0x7:
; 0000 0050 }
	CALL __LOADLOCR4
	ADIW R28,6
	RET
;
;//***********************************************************************************
;//IO初始化操作
;//***********************************************************************************
;void IO_init(void)
; 0000 0056 {
_IO_init:
; 0000 0057     DDRB =0xFF;            //设置PB口为输出
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0058 	DDRD.7=1;        //蜂鸣器
	SBI  0x11,7
; 0000 0059     DDRC =0xFF;            //设置PC口为输出
	OUT  0x14,R30
; 0000 005A /*	DIRD0=0;		            //设置PB0口为输出口
; 0000 005B     DIRD1=0;
; 0000 005C     DIRD2=0;
; 0000 005D 	DIRD3=0;
; 0000 005E     PIOD0=1;
; 0000 005F     PIOD1=1;
; 0000 0060     PIOD2=1;
; 0000 0061     PIOD3=1;
; 0000 0062 
; 0000 0063 	DIRD4=1;
; 0000 0064     DIRD5=1;
; 0000 0065     DIRD6=1;
; 0000 0066 	DIRD7=1;
; 0000 0067     DIRA6=1;
; 0000 0068 	DIRA7=0;*/
; 0000 0069 	DDRD =0xf0;    //设置PD口为输入
	LDI  R30,LOW(240)
	OUT  0x11,R30
; 0000 006A 	PORTD=0x0f;    //设置PD上拉
	LDI  R30,LOW(15)
	OUT  0x12,R30
; 0000 006B 
; 0000 006C 
; 0000 006D     PORTC = 0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 006E     DDRC = 0xff;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 006F      PORTA = 0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0070 
; 0000 0071     DDRA = 0x40;
	LDI  R30,LOW(64)
	OUT  0x1A,R30
; 0000 0072     PORTB = 0xff;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 0073     DDRB = 0xff;
	OUT  0x17,R30
; 0000 0074 
; 0000 0075 
; 0000 0076 
; 0000 0077 }
	RET
;
;
;
;
;
;
;
;
;
;
;
;
;
;  void display() // 扫描显示函数，执行时间 12ms
; 0000 0086 {
_display:
; 0000 0087     PORTA.6=0;
	CBI  0x1B,6
; 0000 0088     PORTD =0x03;
	LDI  R30,LOW(3)
	OUT  0x12,R30
; 0000 0089  //char i;
; 0000 008A  //for(i=0;i<=3;i++)
; 0000 008B  //{
; 0000 008C  PORTC = led_7[dis_buff[posit]];
	MOV  R30,R7
	RCALL SUBOPT_0x0
	LD   R30,Z
	RCALL SUBOPT_0x1
	OUT  0x15,R0
; 0000 008D  if (point_on && posit==2) PORTC |= 0x80; // (1)
	SBRS R2,0
	RJMP _0x10
	LDI  R30,LOW(2)
	CP   R30,R7
	BREQ _0x11
_0x10:
	RJMP _0xF
_0x11:
	SBI  0x15,7
; 0000 008E 
; 0000 008F  //PORTD = position[posit];
; 0000 0090  //PORTA = positiona[posit];
; 0000 0091 
; 0000 0092 
; 0000 0093  if(posit==0)
_0xF:
	TST  R7
	BRNE _0x12
; 0000 0094     {
; 0000 0095        PORTA.6=1;
	SBI  0x1B,6
; 0000 0096     }
; 0000 0097     else
	RJMP _0x15
_0x12:
; 0000 0098     {
; 0000 0099        PORTD = position[posit];
	MOV  R30,R7
	LDI  R31,0
	SUBI R30,LOW(-_position*2)
	SBCI R31,HIGH(-_position*2)
	LPM  R0,Z
	OUT  0x12,R0
; 0000 009A     }
_0x15:
; 0000 009B 
; 0000 009C 
; 0000 009D 
; 0000 009E  //delay_ms(2); // (2)
; 0000 009F  //PORTC = 0xff; // (3)
; 0000 00A0  if(++posit >= 4)
	INC  R7
	LDI  R30,LOW(4)
	CP   R7,R30
	BRLO _0x16
; 0000 00A1     {
; 0000 00A2         posit = 0;
	CLR  R7
; 0000 00A3     }
; 0000 00A4  //}
; 0000 00A5 }
_0x16:
	RET
;
;
;
;
;
;
;interrupt [TIM0_COMP] void timer0_comp_isr(void)
; 0000 00AD {
_timer0_comp_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00AE  display(); // 调用 LED 扫描显示
	RCALL _display
; 0000 00AF  if (++time_counter>=500)
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
	CPI  R30,LOW(0x1F4)
	LDI  R26,HIGH(0x1F4)
	CPC  R31,R26
	BRLO _0x17
; 0000 00B0  {
; 0000 00B1  time_counter = 0;
	CLR  R8
	CLR  R9
; 0000 00B2  time_1s_ok = 1;
	SET
	BLD  R2,1
; 0000 00B3  }
; 0000 00B4 }
_0x17:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;
;
;
;
;
;
;
;void time_to_disbuffer(void) // 时间值送显示缓冲区函数
; 0000 00BE {
_time_to_disbuffer:
; 0000 00BF  char i,j=0;
; 0000 00C0  for (i=0;i<=1;i++)
	ST   -Y,R17
	ST   -Y,R16
;	i -> R17
;	j -> R16
	LDI  R16,0
	LDI  R17,LOW(0)
_0x19:
	CPI  R17,2
	BRSH _0x1A
; 0000 00C1  {
; 0000 00C2  dis_buff[j++] = time[i] % 10;
	MOV  R30,R16
	SUBI R16,-1
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x2
	CALL __MODW21
	MOVW R26,R22
	ST   X,R30
; 0000 00C3  dis_buff[j++] = time[i] / 10;
	MOV  R30,R16
	SUBI R16,-1
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x2
	CALL __DIVW21
	MOVW R26,R22
	ST   X,R30
; 0000 00C4  }
	SUBI R17,-1
	RJMP _0x19
_0x1A:
; 0000 00C5 }
	RJMP _0x2000001
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;void keyScan()
; 0000 00DD  {
_keyScan:
; 0000 00DE //    PORTD=0x00;
; 0000 00DF     uchar x,y;
; 0000 00E0     DDRD =0x03;                      //设置PD口高4位为输入
	ST   -Y,R17
	ST   -Y,R16
;	x -> R17
;	y -> R16
	LDI  R30,LOW(3)
	OUT  0x11,R30
; 0000 00E1     PORTD=0x0c;                      //设置PD高4位上拉,此时PIND高4位全1
	LDI  R30,LOW(12)
	OUT  0x12,R30
; 0000 00E2     if((PIND&0x0c)!=0x0c)        //判断是否有按键按下
	IN   R30,0x10
	ANDI R30,LOW(0xC)
	CPI  R30,LOW(0xC)
	BREQ _0x1B
; 0000 00E3     {
; 0000 00E4      delay(20);                  //延时消抖
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	RCALL SUBOPT_0x3
; 0000 00E5      if((PIND&0x0c)!=0x0c)       //再次判断是否有按键按下
	BREQ _0x1C
; 0000 00E6 	   {
; 0000 00E7 //	   PORTB=0x0f;
; 0000 00E8        x=(PIND&0x0c);
	IN   R30,0x10
	ANDI R30,LOW(0xC)
	MOV  R17,R30
; 0000 00E9        DDRD =0x0c;
	LDI  R30,LOW(12)
	OUT  0x11,R30
; 0000 00EA 
; 0000 00EB 
; 0000 00EC 
; 0000 00ED         {
; 0000 00EE        delay(400);
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	RCALL SUBOPT_0x3
; 0000 00EF 
; 0000 00F0               if((PIND&0x0c)!=0x0c)
	BREQ _0x1D
; 0000 00F1               cc=0;
	CLR  R13
; 0000 00F2               //长按实现函数
; 0000 00F3                          }
_0x1D:
; 0000 00F4 
; 0000 00F5 
; 0000 00F6 
; 0000 00F7 
; 0000 00F8 
; 0000 00F9 
; 0000 00FA     aa=aa%8;
	MOV  R26,R11
	CLR  R27
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __MODW21
	MOV  R11,R30
; 0000 00FB     aa++;
	INC  R11
; 0000 00FC 
; 0000 00FD 
; 0000 00FE 
; 0000 00FF 
; 0000 0100 
; 0000 0101 
; 0000 0102     bb=bb%10;
	MOV  R26,R10
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	MOV  R10,R30
; 0000 0103       bb++;
	INC  R10
; 0000 0104 
; 0000 0105 
; 0000 0106 
; 0000 0107        delay(5);
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay
; 0000 0108        y=(PIND&0x03);
	IN   R30,0x10
	ANDI R30,LOW(0x3)
	MOV  R16,R30
; 0000 0109        keyValue=x|y;
	MOV  R30,R16
	OR   R30,R17
	MOV  R6,R30
; 0000 010A        while((PIND&0x03)!=0x03);
_0x1E:
	IN   R30,0x10
	ANDI R30,LOW(0x3)
	CPI  R30,LOW(0x3)
	BRNE _0x1E
; 0000 010B        }
; 0000 010C 
; 0000 010D        //等待按键松开
; 0000 010E 
; 0000 010F //       PORTB=0xf0;
; 0000 0110     }
_0x1C:
; 0000 0111  }
_0x1B:
_0x2000001:
	LD   R16,Y+
	LD   R17,Y+
	RET
;
; void keyHandle()
; 0000 0114  {
_keyHandle:
; 0000 0115         switch(keyValue)
	MOV  R30,R6
	LDI  R31,0
; 0000 0116           {
; 0000 0117             case 0x06:                 //S17            上
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x24
; 0000 0118                 {
; 0000 0119                   PORTB=0XFF;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 011A                   time_1s_ok = 0;
	CLT
	BLD  R2,1
; 0000 011B 
; 0000 011C                  break;
	RJMP _0x23
; 0000 011D                 }
; 0000 011E             case 0x0a:                 //S18           左
_0x24:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x25
; 0000 011F                 {
; 0000 0120                  PORTB=led_7[bb];;
	MOV  R30,R10
	RCALL SUBOPT_0x1
	OUT  0x18,R0
; 0000 0121                  time_1s_ok = 0;
	CLT
	BLD  R2,1
; 0000 0122                  time[1]=0;
	LDI  R30,LOW(0)
	__PUTB1MN _time,1
; 0000 0123                  time[0]=0;
	STS  _time,R30
; 0000 0124                  break;
	RJMP _0x23
; 0000 0125                 }
; 0000 0126             case 0x05:                 //S19         下
_0x25:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x26
; 0000 0127                 {
; 0000 0128 
; 0000 0129                      time_1s_ok = 1;       //数码管
	SET
	BLD  R2,1
; 0000 012A 
; 0000 012B 
; 0000 012C                  break;
	RJMP _0x23
; 0000 012D                 }
; 0000 012E             case 0x09:                 //S20           右
_0x26:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x28
; 0000 012F                 {
; 0000 0130                 PORTB=resit[aa];
	MOV  R30,R11
	LDI  R31,0
	SUBI R30,LOW(-_resit)
	SBCI R31,HIGH(-_resit)
	LD   R30,Z
	OUT  0x18,R30
; 0000 0131 
; 0000 0132 
; 0000 0133 
; 0000 0134 
; 0000 0135 
; 0000 0136 
; 0000 0137 
; 0000 0138 
; 0000 0139 
; 0000 013A                  break;
; 0000 013B                 }
; 0000 013C             default:
_0x28:
; 0000 013D //                 PORTB=0xf0;
; 0000 013E          break;
; 0000 013F           }
_0x23:
; 0000 0140  }
	RET
;
;//***********************************************************************************
;//主函数
;//***********************************************************************************
;void main()
; 0000 0146 {
_main:
; 0000 0147     IO_init();                //IO初始化
	RCALL _IO_init
; 0000 0148     PORTB=0xff;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 0149 
; 0000 014A 
; 0000 014B 
; 0000 014C 
; 0000 014D     TCCR0=0x0b; // 内部时钟，64 分频（2M/64=31.25KHz），CTC 模式
	LDI  R30,LOW(11)
	OUT  0x33,R30
; 0000 014E     TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 014F     OCR0=0x7C; //125/31.25=4ms//计数次数
	LDI  R30,LOW(124)
	OUT  0x3C,R30
; 0000 0150     TIMSK=0x02; // 允许 T/C0 比较匹配中断
	LDI  R30,LOW(2)
	OUT  0x39,R30
; 0000 0151 
; 0000 0152      #asm("sei");
	sei
; 0000 0153 
; 0000 0154 
; 0000 0155 
; 0000 0156 
; 0000 0157 
; 0000 0158 
; 0000 0159 
; 0000 015A 
; 0000 015B 
; 0000 015C 
; 0000 015D 
; 0000 015E 
; 0000 015F 
; 0000 0160     while(1)                  //死循环
_0x29:
; 0000 0161      {
; 0000 0162  //     PORTB=0xff;
; 0000 0163 //      PORTC=0x66;
; 0000 0164 /*      LED_1=1;
; 0000 0165       LED_2=1;
; 0000 0166       LED_3=1;
; 0000 0167       LED_4=1;*/
; 0000 0168      keyScan();             //按键扫描
	RCALL _keyScan
; 0000 0169      keyHandle();           //按键处理
	RCALL _keyHandle
; 0000 016A      display();
	RCALL _display
; 0000 016B                                             display();
	RCALL _display
; 0000 016C 
; 0000 016D 
; 0000 016E 
; 0000 016F 
; 0000 0170 
; 0000 0171 
; 0000 0172 
; 0000 0173 
; 0000 0174 
; 0000 0175 
; 0000 0176 
; 0000 0177 
; 0000 0178 
; 0000 0179 
; 0000 017A 
; 0000 017B 
; 0000 017C 
; 0000 017D 
; 0000 017E 
; 0000 017F 
; 0000 0180 
; 0000 0181 
; 0000 0182 
; 0000 0183       display();
	RCALL _display
; 0000 0184       keyScan();             //按键扫描
	RCALL _keyScan
; 0000 0185       keyHandle();           //按键处理
	RCALL _keyHandle
; 0000 0186 
; 0000 0187 
; 0000 0188        if (time_1s_ok) // 1 秒到
	SBRS R2,1
	RJMP _0x2C
; 0000 0189       {
; 0000 018A         time_1s_ok = 0;
	CLT
	BLD  R2,1
; 0000 018B         point_on = ~point_on;
	LDI  R30,LOW(1)
	EOR  R2,R30
; 0000 018C         if(i>=1)
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R4,R30
	CPC  R5,R31
	BRLT _0x2D
; 0000 018D         {
; 0000 018E             if(time[0]>=31)
	LDS  R26,_time
	CPI  R26,LOW(0x1F)
	BRSH _0x3B
; 0000 018F             {PORTB=0xff;
; 0000 0190             PORTD.7=0;}
; 0000 0191             else if(time[0]%2==0)
	CLR  R27
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __MODW21
	SBIW R30,0
	BRNE _0x32
; 0000 0192             {PORTB = 0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0193             PORTD.7=1;}
	SBI  0x12,7
; 0000 0194             else
	RJMP _0x35
_0x32:
; 0000 0195            { PORTB = 0xff;
_0x3B:
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 0196             PORTD.7=0;}
	CBI  0x12,7
_0x35:
; 0000 0197 
; 0000 0198         }
; 0000 0199         if (++time[0] >= 60) // 以下时间调整
_0x2D:
	LDS  R26,_time
	SUBI R26,-LOW(1)
	STS  _time,R26
	CPI  R26,LOW(0x3C)
	BRLO _0x38
; 0000 019A         {
; 0000 019B             time[0] = 0;
	LDI  R30,LOW(0)
	STS  _time,R30
; 0000 019C             //PORTD.7=1;
; 0000 019D              i++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
	SBIW R30,1
; 0000 019E             if (++time[1] >= 60)
	__GETB1MN _time,1
	SUBI R30,-LOW(1)
	__PUTB1MN _time,1
	CPI  R30,LOW(0x3C)
	BRLO _0x39
; 0000 019F             {
; 0000 01A0                 time[1] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _time,1
; 0000 01A1                 //if (++time[2] >= 24) time[2] = 0;
; 0000 01A2             }
; 0000 01A3         }
_0x39:
; 0000 01A4         time_to_disbuffer(); // 新调整好的时间送显示缓冲区
_0x38:
	RCALL _time_to_disbuffer
; 0000 01A5       }
; 0000 01A6 
; 0000 01A7 
; 0000 01A8 
; 0000 01A9 
; 0000 01AA      }
_0x2C:
	RJMP _0x29
; 0000 01AB }
_0x3A:
	RJMP _0x3A

	.DSEG
_resit:
	.BYTE 0x8
_time:
	.BYTE 0x2
_dis_buff:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LDI  R31,0
	SUBI R30,LOW(-_dis_buff)
	SBCI R31,HIGH(-_dis_buff)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDI  R31,0
	SUBI R30,LOW(-_led_7*2)
	SBCI R31,HIGH(-_led_7*2)
	LPM  R0,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x2:
	MOVW R22,R30
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_time)
	SBCI R31,HIGH(-_time)
	LD   R26,Z
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay
	IN   R30,0x10
	ANDI R30,LOW(0xC)
	CPI  R30,LOW(0xC)
	RET


	.CSEG
__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
