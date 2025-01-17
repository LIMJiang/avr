//#include "avr/io.h"
         //包含AVR单片机寄存器定义的头文件   
         #include <mega16.h> 
#include "NBCAVR.h"         //包含位操作的头文件

#define uchar unsigned char
#define uint  unsigned int

#define LED_Data  PORTB
#define Dataport PORTC
#define LED_1 PIOD4
#define LED_2 PIOD5
#define LED_3 PIOD6
#define LED_4 PIOA6

#define S1 PIOD2           //定义按键IO
#define S2 PIOD0          
#define S3 PIOD3          
#define S4 PIOD1         
#define S5 PIOA7





flash char led_7[10]={0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F};
//flash char position[6]={0xfe,0xfd,0xfb,0xf7,0xef,0xdf};
//flash char position[4]={0xff,0xbf,0xdf,0xef};
flash char position[4]={0xc3,0xc3,0xa3,0x93};
flash char positiona[4]={0x43,0x03,0x03,0x03};                                      // 位选PORTA
uchar resit[8]={0x7F, 0xBF, 0xDF, 0xEF, 0xF7, 0xFB, 0xFD, 0xFE};

int i=0;
//int time_counter; // 中断次数计数单元
char posit;
bit point_on, time_1s_ok;

char time[2]; // 时、分、秒计数
char dis_buff[4]; // 显示缓冲区，存放要显示的 6 个字符的段码值
uint time_counter; // 1 秒计数器
//bit point_on; // 秒显示标志



uchar keyValue;             //定义扫描结果参数
//uchar  dis[16]={0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,
             //  0    1    2    3    4    5    6    7
              // 0x7F,0x6F,0x77,0x7C,0x39,0x5E,0x79,0x71};//0~F的段码
             //  8    9    A    B    C    D    E    F








uchar keyValue;             //定义扫描结果参数
uchar  dis[16]={0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,
             //  0    1    2    3    4    5    6    7    
               0x7F,0x6F,0x77,0x7C,0x39,0x5E,0x79,0x71};//0~F的段码
             //  8    9    A    B    C    D    E    F  

uchar aa; //片选
uchar bb;//字符
uchar cc;//信号量
uchar dd;


//***********************************************************************************
//延时
//***********************************************************************************
void delay(uint time)
{
	uint i,j;
	for(i = 0;i < time; i++)
	{
	  for(j = 0;j < 30; j++);
    }
}

//***********************************************************************************
//IO初始化操作
//***********************************************************************************
void IO_init(void)
{
    DDRB =0xFF;            //设置PB口为输出
	DDRD.7=1;        //蜂鸣器
    DDRC =0xFF;            //设置PC口为输出

	DDRD =0xf0;    //设置PD口为输入
	PORTD=0x0f;    //设置PD上拉

    
    PORTC = 0x00;
    DDRC = 0xff;
     PORTA = 0x00;

    DDRA = 0x40;
    PORTB = 0xff;
    DDRB = 0xff;



}













  void display() // 扫描显示函数，执行时间 12ms
{
    PORTA.6=0;
    PORTD =0x03;
 //char i;
 //for(i=0;i<=3;i++)
 //{
 PORTC = led_7[dis_buff[posit]];
 if (point_on && posit==2) PORTC |= 0x80; // (1)

 //PORTD = position[posit];
 //PORTA = positiona[posit];  
 
 
 if(posit==0)
    {
       PORTA.6=1; 
    }
    else
    {
       PORTD = position[posit];
    }
 
 
 
 //delay_ms(2); // (2)
 //PORTC = 0xff; // (3)
 if(++posit >= 4)
    {
        posit = 0;
    }
 //}
}






interrupt [TIM0_COMP] void timer0_comp_isr(void)                                  
{
 display(); // 调用 LED 扫描显示
 if (++time_counter>=500)
 {
 time_counter = 0;
 time_1s_ok = 1;
 }
}








void time_to_disbuffer(void) // 时间值送显示缓冲区函数
{
 char i,j=0;
 for (i=0;i<=1;i++)
 {
 dis_buff[j++] = time[i] % 10;
 dis_buff[j++] = time[i] / 10;
 }
}






















void keyScan()                             
 {
//    PORTD=0x00;
    uchar x,y; 
    DDRD =0x03;                      //设置PD口高4位为输入
    PORTD=0x0c;                      //设置PD高4位上拉,此时PIND高4位全1
    if((PIND&0x0c)!=0x0c)        //判断是否有按键按下
    {
     delay(20);                  //延时消抖
     if((PIND&0x0c)!=0x0c)       //再次判断是否有按键按下
	   {
//	   PORTB=0x0f;
       x=(PIND&0x0c);
       DDRD =0x0c;                      

    aa=aa%8; 
    aa++;

    bb=bb%10;
      bb++;
   
       delay(5);
       y=(PIND&0x03);
       keyValue=x|y;
       while((PIND&0x03)!=0x03); 
       }     

       //等待按键松开
       
//       PORTB=0xf0;
    }
 }

 void keyHandle()                     
 {      
        switch(keyValue)         
          {
            case 0x06:                 //S17            上
                {
                  PORTB=0XFF;
                  time_1s_ok = 0; 
                  
                 break;          
                }
            case 0x0a:                 //S18           左
                {
                 PORTB=led_7[bb];;       
                 time_1s_ok = 0;
                 time[1]=0;
                 time[0]=0;
                 break;
                }
            case 0x05:                 //S19         下
                {  
                 
                     time_1s_ok = 1;       //数码管
                
                     
                 break;
                }
            case 0x09:                 //S20           右
                {    
                PORTB=resit[aa];
                
              
                
                
                
               
                   
               
                
                 break;
                }
            default:
//                 PORTB=0xf0;
         break;
          }
 }

//***********************************************************************************
//主函数
//***********************************************************************************
void main()
{      
    IO_init();                //IO初始化
    PORTB=0xff;      
    
    
    
    
    TCCR0=0x0b; // 内部时钟，64 分频（2M/64=31.25KHz），CTC 模式
    TCNT0=0x00; 
    OCR0=0x7C; //125/31.25=4ms//计数次数
    TIMSK=0x02; // 允许 T/C0 比较匹配中断

     #asm("sei");
    
    
    
    
    
    
    
    
    
    
    
    
    
    while(1)                  //死循环
     {
 //     PORTB=0xff;
//      PORTC=0x66;
/*      LED_1=1;
      LED_2=1;
      LED_3=1;
      LED_4=1;*/
     keyScan();             //按键扫描
     keyHandle();           //按键处理
     display(); 
     display(); 
      display(); 
      keyScan();             //按键扫描
      keyHandle();           //按键处理
     
     
       if (time_1s_ok) // 1 秒到
      {
        time_1s_ok = 0;
        point_on = ~point_on;  
        if(i>=1)
        {    
            if(time[0]>=31) 
            {PORTB=0xff;  
            PORTD.7=0;}
            else if(time[0]%2==0) 
            {PORTB = 0x00; 
            PORTD.7=1;}
            else
           { PORTB = 0xff; 
            PORTD.7=0;}
             
        }
        if (++time[0] >= 60) // 以下时间调整
        {
            time[0] = 0;
            //PORTD.7=1;  
             i++;
            if (++time[1] >= 60)
            {
                time[1] = 0;
                //if (++time[2] >= 24) time[2] = 0;
            }
        }
        time_to_disbuffer(); // 新调整好的时间送显示缓冲区
      }
   
     

     
     }  
}
