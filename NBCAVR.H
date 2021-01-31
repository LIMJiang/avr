/***************************************************************************************************    
文件名称：	NBCAVR.h
功能描述：	实现AVR单片机IO数据向量、方向向量的位操作
作者：      北方蓝芯科技开发有限公司
维护记录：  2011-8-22
***************************************************************************************************/
#define uchar unsigned char
#define uint  unsigned int
/***************************************************************************************************    
//位表
***************************************************************************************************/
typedef  struct {
    uchar BIT0        :1;                         /* Port  Bit 0 */
    uchar BIT1        :1;                         /* Port  Bit 1 */
    uchar BIT2        :1;                         /* Port  Bit 2 */
    uchar BIT3        :1;                         /* Port  Bit 3 */
    uchar BIT4        :1;                         /* Port  Bit 4 */
    uchar BIT5        :1;                         /* Port  Bit 5 */
    uchar BIT6        :1;                         /* Port  Bit 6 */
    uchar BIT7        :1;                         /* Port  Bit 7 */
  } Bit;
 
//*******************************************************************************************************************************
//1、按位定义IO数据向量,即数据输入输出电平,1为高电平,0为低电平
/***************************************************************************************************    
//按位定义PA数据向量
***************************************************************************************************/                                     
#define PIOA   (*(volatile Bit*)(0x3B))    

#define PIOA0  PIOA.BIT0
#define PIOA1  PIOA.BIT1
#define PIOA2  PIOA.BIT2
#define PIOA3  PIOA.BIT3
#define PIOA4  PIOA.BIT4
#define PIOA5  PIOA.BIT5
#define PIOA6  PIOA.BIT6
#define PIOA7  PIOA.BIT7

/***************************************************************************************************    
//按位定义PB数据向量
***************************************************************************************************/
#define PIOB   (*(volatile Bit*)(0x38))  

#define PIOB0  PIOB.BIT0
#define PIOB1  PIOB.BIT1
#define PIOB2  PIOB.BIT2
#define PIOB3  PIOB.BIT3
#define PIOB4  PIOB.BIT4
#define PIOB5  PIOB.BIT5
#define PIOB6  PIOB.BIT6
#define PIOB7  PIOB.BIT7

/***************************************************************************************************    
//按位定义PC数据向量
***************************************************************************************************/
#define PIOC   (*(volatile Bit*)(0x35))  

#define PIOC0  PIOC.BIT0
#define PIOC1  PIOC.BIT1
#define PIOC2  PIOC.BIT2
#define PIOC3  PIOC.BIT3
#define PIOC4  PIOC.BIT4
#define PIOC5  PIOC.BIT5
#define PIOC6  PIOC.BIT6
#define PIOC7  PIOC.BIT7

/***************************************************************************************************    
//按位定义PD数据向量
***************************************************************************************************/
#define PIOD   (*(volatile Bit*)(0x32))    

#define PIOD0  PIOD.BIT0
#define PIOD1  PIOD.BIT1
#define PIOD2  PIOD.BIT2
#define PIOD3  PIOD.BIT3
#define PIOD4  PIOD.BIT4
#define PIOD5  PIOD.BIT5
#define PIOD6  PIOD.BIT6
#define PIOD7  PIOD.BIT7

//*******************************************************************************************************************************
//2、按位定义IO方向向量,即端口的输入输出方向,1为输出,0为输入
/***************************************************************************************************    
//按位定义DDRA方向向量
***************************************************************************************************/
#define DIRA    (*(volatile Bit*)(0x3A))    

#define DIRA0   DIRA.BIT0
#define DIRA1   DIRA.BIT1
#define DIRA2   DIRA.BIT2
#define DIRA3   DIRA.BIT3
#define DIRA4   DIRA.BIT4
#define DIRA5   DIRA.BIT5
#define DIRA6   DIRA.BIT6
#define DIRA7   DIRA.BIT7

/***************************************************************************************************    
//按位定义DDRB方向向量
***************************************************************************************************/
#define DIRB    (*(volatile Bit*)(0x37))   

#define DIRB0   DIRB.BIT0
#define DIRB1   DIRB.BIT1
#define DIRB2   DIRB.BIT2
#define DIRB3   DIRB.BIT3
#define DIRB4   DIRB.BIT4
#define DIRB5   DIRB.BIT5
#define DIRB6   DIRB.BIT6
#define DIRB7   DIRB.BIT7

/***************************************************************************************************    
//按位定义DDRC方向向量
***************************************************************************************************/
#define DIRC    (*(volatile Bit*)(0x34))      

#define DIRC0   DIRC.BIT0
#define DIRC1   DIRC.BIT1
#define DIRC2   DIRC.BIT2
#define DIRC3   DIRC.BIT3
#define DIRC4   DIRC.BIT4
#define DIRC5   DIRC.BIT5
#define DIRC6   DIRC.BIT6
#define DIRC7   DIRC.BIT7

/***************************************************************************************************    
//按位定义DDRD方向向量
***************************************************************************************************/
#define DIRD    (*(volatile Bit*)(0x31))     

#define DIRD0   DIRD.BIT0
#define DIRD1   DIRD.BIT1
#define DIRD2   DIRD.BIT2
#define DIRD3   DIRD.BIT3
#define DIRD4   DIRD.BIT4
#define DIRD5   DIRD.BIT5
#define DIRD6   DIRD.BIT6
#define DIRD7   DIRD.BIT7
