//使用gcc编译的时候语法： gcc -o test test.c -lwiringPi
// test 是目标可执行文件，test.c是源文件， -l表示引用了外部库，后面直接接外部库名称（这里面是wiringPi.h，注意P要大写）
#include <wiringPi.h>
#include <sys/time.h>
#include <stdio.h>
#include <stdlib.h>
#define Echo 4
#define Trig 5//定义两个关键的gpio口
float getDistance()
{
	struct timeval tv1;//起始时间结构体
	struct timeval tv2;//停止时间结构体
	long start;//开始时间
	long stop;//停止时间
	float dis;//距离
	pinMode(Echo,INPUT);//将ECHO口定为输入口，接收超声波
	pinMode(Trig,OUTPUT);//将Trig口定为输出口，输出10us脉冲


	//tg 输出十微秒脉冲
	digitalWrite (Trig, LOW);
	delayMicroseconds(1);
	digitalWrite (Trig, HIGH);
	delayMicroseconds(10);
	digitalWrite (Trig, LOW);
	//当echo从0变1的时刻，记录下开始时间，并存在tv1时间结构体中
	while(digitalRead(Echo)==0);
	gettimeofday(&tv1,NULL);
	//当echo从1变0的时刻，记录下停止时间，并存在tv2时间结构体中
	while(digitalRead(Echo)==1);
	gettimeofday(&tv2,NULL);	
	//将时间赋给start和stop变量并计算距离
	start=tv1.tv_sec*1000000+tv1.tv_usec;
	printf("start: %ld.%06ld\n",tv1.tv_sec, tv1.tv_usec);
	stop=tv2.tv_sec*1000000+tv2.tv_usec;
	printf("stop:  %ld.%06ld\n",tv2.tv_sec, tv2.tv_usec);
	dis=(float)(stop-start)/1000000*34000/2;
	return dis;
 } 



int main()
{
	int ret;
	printf("begin\n");
	ret=wiringPiSetup();//初始化wiringPi
	if(ret==-1){
	    printf("wiringPiSetup failed\n");
	    exit(-1);
	}
	int flag = 1;	
     	while(1){
		float dis;
		dis = getDistance();
		printf("distance is %0.2f cm, %0.2f m\n", dis, dis/100);
		delay(1000);
		flag ++;
	}	
	return 0;
}
