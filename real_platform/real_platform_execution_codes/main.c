#define _GNU_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <semaphore.h>
#include "function.h"

/*实时调度所需头文件*/
#include <limits.h>
#include <pthread.h>
#include <sched.h>
#include <sys/mman.h>
#include <sys/time.h>
// #include <sys/delay.h>
// #include <sys/preempt.h>
#include <sys/stat.h>		// 用来创建文件夹
#include <sys/types.h>		// 用来创建文件夹
#include <fcntl.h>			// 操作文件读写

#include <unistd.h>

#include <assert.h>

static sem_t sem[SUBTASK_NUMB_MAX];								// 信号量集合，用来表示哪个任务完成了
static struct subtask stp[SUBTASK_NUMB_MAX];					// 子任务集合
static pthread_t tid[SUBTASK_NUMB_MAX];							//线程控制块集合
static pthread_attr_t attr[SUBTASK_NUMB_MAX];					//线程属性集合

static struct timespec begin_time;								//几率每次开始DAG的时间

static sem_t sem_timeout;										// 主程序信号量，用来检测是否超时
static int finish_count;										// 用来保存当前已经完成多少个任务了
static int WCRT;

static struct test tt1;


int main ()
{
	// int schedule_mode = SCHEDULE_MODE_PA;

	mkdir("../result",0777);
	

	/*************** 参数类型初始化 ******************/
	// int schedule_mode = SCHEDULE_MODE_PA_WF;		/********  用来确定处理器分配模式  **********/ 
	// int schedule_mode = SCHEDULE_MODE_PA_MRW;
	// int schedule_mode = SCHEDULE_MODE_RAND_WF
	// int schedule_mode = SCHEDULE_MODE_RAND_MRW;

	// int compare_case = COMPARE_U;
	// int compare_case = COMPARE_V;
	// int compare_case = COMPARE_pr;

	/************************************************/
	// self_scheduler(SCHEDULE_MODE_PA_WF,COMPARE_U,stp,tid,&begin_time, &WCRT, &sem_timeout, sem, attr, &finish_count);
	// self_scheduler(SCHEDULE_MODE_PA_WF,COMPARE_V,stp,tid,&begin_time, &WCRT, &sem_timeout, sem, attr, &finish_count);
	// self_scheduler(SCHEDULE_MODE_PA_WF,COMPARE_pr,stp,tid,&begin_time, &WCRT, &sem_timeout, sem, attr, &finish_count);
	
	// self_scheduler(SCHEDULE_MODE_PA_WF,COMPARE_V,stp,tid,&begin_time, &WCRT, &sem_timeout, sem, attr, &finish_count);
	// self_scheduler(SCHEDULE_MODE_RAND_WF,COMPARE_V,stp,tid,&begin_time, &WCRT, &sem_timeout, sem, attr, &finish_count);
	self_scheduler(SCHEDULE_MODE_PA_WF,COMPARE_pr,stp,tid,&begin_time, &WCRT, &sem_timeout, sem, attr, &finish_count);
	self_scheduler(SCHEDULE_MODE_RAND_WF,COMPARE_pr,stp,tid,&begin_time, &WCRT, &sem_timeout, sem, attr, &finish_count);
	
	
	
	

	return 0;
}