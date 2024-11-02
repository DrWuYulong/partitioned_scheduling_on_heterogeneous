#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <pthread.h>
#include <sched.h>
#include <semaphore.h>



int main ()
{
	// int ret = 0;
	// int prio;
    // pid_t pid = getpid();
 
    // int curschdu = sched_getscheduler(pid);
    // if(curschdu <0 )
    // {
    //     printf( "getschedu err %s\n");
    // }
    // printf("%d schedu befor %d\n",pid, curschdu);
	
	// // for (int i = 0; i < 1000000000; i++)
	// // {
	// // 	/* code */
	// // }
 
    // struct sched_param s_parm;
    // s_parm.sched_priority = 80;
    // printf("schedu max %d min %d\n",sched_get_priority_max(SCHED_FIFO),sched_get_priority_min(SCHED_FIFO));
    
    // ret = sched_setscheduler(pid, SCHED_FIFO, &s_parm);
    // if(ret <0)
    // {
    //    printf( "setschedu err %s\n");
    // }
 


    // curschdu = sched_getscheduler(pid);
    
 
    // printf("schedu after %d\n",curschdu);
	// for (int i = 0; i < 1000000000; i++)
	// {
	// 	/* code */
	// }

	// struct sched_param temp_aram;
	// ret = sched_getparam(pid,&temp_aram);
	// printf("currrent priority is: %d\n", temp_aram.sched_priority);


	printf("*************************\n");
	pthread_t tid;
	int policy, res;
	struct sched_param param;

	tid = pthread_self();
	res = pthread_getschedparam(tid, &policy, &param);
	printf("before: %d, %d\n", policy, param.sched_priority);


	param.sched_priority = 85;
	res = pthread_setschedparam(tid,SCHED_FIFO,&param);

	res = pthread_getschedparam(tid, &policy, &param);
	printf("after: %d, %d\n", policy, param.sched_priority);
	// tid = pthread_self(); //当前线程的pid


	// res = pthread_getattr_np(tid, &attr);
	// ret = pthread_attr_getschedpolicy(&attr,&sp);
	// printf("当前优先级策略为: %d\n", sp);
	// ret = pthread_attr_getschedparam(&attr, &param);
	// printf("ret: %d, 当前优先级为: %d\n", ret, param.sched_priority);
	
	

	return 0;
}