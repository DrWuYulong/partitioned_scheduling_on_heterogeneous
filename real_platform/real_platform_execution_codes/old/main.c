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
	long int total_time;
	struct timespec timeout;						//相当于定时器，用sem_timedwait()看是否超过ddl
	struct sched_param param;
	int flag, res;									// flag用来判断是否可调度
	sem_t *sem_timeout_p;
	double total_WCRT;
	int sched_DAG_numb;

	/*************** 参数类型初始化 ******************/
	int schedule_mode = SCHEDULE_MODE_PA;		/********  用来确定处理器分配模式  **********/ 
	// int schedule_mode = SCHEDULE_MODE_RWB;
	// int schedule_mode = SCHEDULE_MODE_MCW;

	// int compare_case = COMPARE_U;
	int compare_case = COMPARE_V;
	// int compare_case = COMPARE_pr;
	/************************************************/
	char result_path[32] = "";
	char result_name_index[64] = "";
	char result_name_WCRT[64] = "";
	char buff[8] = "";
	FILE *fp = NULL;

	double calculate_min, calculate_max, calculate_step;

	//改变当前主函数策略为 SCHED_FIFO 优先级为最高 99
	param.sched_priority = sched_get_priority_max(SCHED_FIFO);
	pthread_setschedparam(pthread_self(), SCHED_FIFO, &param);

	for (int i = 0; i < SUBTASK_NUMB_MAX; i++)
	{
		stp[i].begin_time = &begin_time;	//传地址
		stp[i].tid_p = &tid[i];
		stp[i].WCRT = &WCRT;
	}

	switch (compare_case)
	{
	case COMPARE_U:
		if(schedule_mode == SCHEDULE_MODE_PA)
		{
			strncpy(result_path,"../result/PA_U",strlen("../result/PA_U"));
			result_path[strlen("../result/PA_U")] = '\0';
		}
		if (schedule_mode == SCHEDULE_MODE_MCW)
		{
			strncpy(result_path,"../result/MCW_U",strlen("../result/MCW_U"));
			result_path[strlen("../result/MCW_U")] = '\0';
		}	
		if (schedule_mode == SCHEDULE_MODE_RWB)
		{
			strncpy(result_path,"../result/RWB_U",strlen("../result/RWB_U"));
			result_path[strlen("../result/RWB_U")] = '\0';
		}
		break;
	case COMPARE_V:
		if(schedule_mode == SCHEDULE_MODE_PA)
		{
			strncpy(result_path,"../result/PA_V",strlen("../result/PA_V"));
			result_path[strlen("../result/PA_V")] = '\0';
		}
		if (schedule_mode == SCHEDULE_MODE_MCW)
		{
			strncpy(result_path,"../result/MCW_V",strlen("../result/MCW_V"));
			result_path[strlen("../result/MCW_V")] = '\0';
		}	
		if (schedule_mode == SCHEDULE_MODE_RWB)
		{
			strncpy(result_path,"../result/RWB_V",strlen("../result/RWB_V"));
			result_path[strlen("../result/RWB_V")] = '\0';
		}
		break;
	case COMPARE_pr:
		if(schedule_mode == SCHEDULE_MODE_PA)
		{
			strncpy(result_path,"../result/PA_pr",strlen("../result/PA_pr"));
			result_path[strlen("../result/PA_pr")] = '\0';
		}
		if (schedule_mode == SCHEDULE_MODE_MCW)
		{
			strncpy(result_path,"../result/MCW_pr",strlen("../result/MCW_pr"));
			result_path[strlen("../result/MCW_pr")] = '\0';
		}	
		if (schedule_mode == SCHEDULE_MODE_RWB)
		{
			strncpy(result_path,"../result/RWB_pr",strlen("../result/RWB_pr"));
			result_path[strlen("../result/RWB_pr")] = '\0';
		}
		break;
	}
	
	mkdir("../result",0777);
	mkdir(result_path, 0777);


	if (schedule_mode == SCHEDULE_MODE_PA)
	{
		for (int i = 0; i < SUBTASK_NUMB_MAX; i++)
		{
			stp[i].schedule_mode = SCHEDULE_MODE_PA;
		}
	}
	
	if (schedule_mode == SCHEDULE_MODE_MCW)
	{
		for (int i = 0; i < SUBTASK_NUMB_MAX; i++)
		{
			stp[i].schedule_mode = SCHEDULE_MODE_MCW;
		}
	}
	
	if (schedule_mode == SCHEDULE_MODE_RWB)
	{
		for (int i = 0; i < SUBTASK_NUMB_MAX; i++)
		{
			stp[i].schedule_mode = SCHEDULE_MODE_RWB;
		}
	}
	
	switch (compare_case)
	{
	case COMPARE_U:
		calculate_min = U_MIN;
		calculate_max = U_MAX;
		calculate_step = U_STEP;
		break;
	case COMPARE_V:
		calculate_min = V_MIN;
		calculate_max = V_MAX;
		calculate_step = V_STEP;
		break;
	case COMPARE_pr:
		calculate_min = pr_MIN;
		calculate_max = pr_MAX;
		calculate_step = pr_STEP;
		break;
	}
	
	for (double current_todo = calculate_min; current_todo < calculate_max + calculate_step; current_todo += calculate_step)			//递增
	// for (double current_todo = calculate_max; current_todo > calculate_min - calculate_step; current_todo -= calculate_step)			//递减
	{
		printf("begin  %g\n",current_todo);
		/* 初始化超时信号量和普通信号量 */
		sem_timeout_p = &sem_timeout;
		sem_init(sem_timeout_p, 0, 0);
		for (int i = 0; i < SUBTASK_NUMB_MAX; i++)
		{
			sem_init(sem+i,0,0);
		}
	
		strncpy(result_name_index,result_path,strlen(result_path));
		result_name_index[strlen(result_path)] = '\0';
		sprintf(&result_name_index[strlen(result_name_index)],"/%g_index.txt\0",current_todo);
		// result_name_index[strlen(result_name_index)] = '\0';


		strncpy(result_name_WCRT,result_path,strlen(result_path));
		result_name_WCRT[strlen(result_path)] = '\0';
		sprintf(&result_name_WCRT[strlen(result_name_WCRT)],"/%g_WCRT.txt\0",current_todo);
		// result_name_WCRT[strlen(result_name_WCRT)] = '\0';

		
		/* 初始化可调度标识符 */
		total_WCRT = 0;
		sched_DAG_numb = 0;

		for(int current_DAG_numb = 1; current_DAG_numb <= DAG_NUMB_PER_POINT; current_DAG_numb++)
		{
			flag = 1;
			//	***********初始化子任务************
			stp[0].temp_todo = current_todo;						//初始化利用率为了读取数据
			stp[0].current_DAG_numb = current_DAG_numb;			//开始初始化第几个DAG
			
			init_subtask(stp, sem, attr, compare_case);
	
			// printf("%d,%d,%d",stp[0].V_numb,stp[3].V_numb,stp[10].V_numb);
			// return 0;
			WCRT = 0; 								//初始化 WCRT， 每个DAG任务只需要初始化一次，剩下比大小就行
			for (int i = 0; i < stp[0].V_numb; i++)
			{

				stp[i].sem_timeout_p = sem_timeout_p;
				// stp[i].begin_time = &begin_time;	//传地址
				stp[i].subtask_order = i;
				// stp[i].tid_p = &tid[i];
				stp[i].finish_count = &finish_count;
				// stp[i].WCRT = &WCRT;
			}
			
			for (int loop = 0; (loop < LOOP_NUMB) && flag; loop ++)	// 要执行多少遍。
			{
				// 重置信号量的值
				reset_sem(sem, SUBTASK_NUMB_MAX);

				// 重置完整子任务数量
				finish_count = 0;

				// usleep(100000);
				
				clock_gettime(CLOCK_REALTIME, &begin_time);
				total_time = begin_time.tv_sec * 1000000000 + begin_time.tv_nsec;

				for (int i = 0; i < stp[0].V_numb; i++)
				{
					stp[i].current_DDL = total_time	+ DAG_TASK_DDL * 1000000;	
				}

				
				for (int i = 0; i < stp[0].V_numb; i++)
				{
					pthread_create(&tid[i],attr+i,subtask_threads,(void*)(stp+i));		
				}

				for (int i = 0; i < stp[0].V_numb; i++)
				{
					pthread_join(tid[i], NULL);
				}
				

				timeout.tv_nsec = begin_time.tv_nsec + (DAG_TASK_DDL % 1000) * 1000000;
				timeout.tv_sec = begin_time.tv_sec + DAG_TASK_DDL / 1000;
				
				
				res = sem_timedwait(sem_timeout_p,&timeout);			// res = 0 表示在规定时间内收到了信号， res = -1 表示超时了。
				if(finish_count != stp[0].V_numb)
				{
					// 不可调度
					// printf("finish_count %d, res %d, %d, %d, %d\n", finish_count, res, stp[0].V_numb,loop, WCRT);
					sleep(DAG_TASK_DDL/1000 + 1); //休眠2000ms=2s 用来清空，所有子任务的执行时间都不会超过 DAG_TASK_DDL / 1000 + 1 秒，相当于向上取整
					flag = 0;
					break;
				}else if(WCRT > DAG_TASK_DDL)
				{
					sleep(DAG_TASK_DDL/1000 + 1); 
					flag = 0;
					break;
				}else if (finish_count == stp[0].V_numb)
				{
					// 可调度
					sem_init(sem_timeout_p,0,0);
					// printf("%d WCRT is: %d\n", loop, WCRT);
				}else{
					// printf("special case ! finish_count: %d, res: %d, WCRT: %d\n", finish_count, res, WCRT);
					sleep(DAG_TASK_DDL/1000 + 1); 
					flag = 0;
					break;
				}
				usleep(100000);
				
			}
			//当前的DAG 执行完LOOP_NUMB后可调度，记录可调度数量并更新总的响应时间
			if (flag == 1)
			{
				sched_DAG_numb ++;
				total_WCRT += WCRT;

				// 可调度的话记录 index 
				sprintf(buff,"%d\n\0",current_DAG_numb);
    			// buff[strlen(buff)] = '\0';
				fp = fopen(result_name_index,"a");
				res = fwrite(buff,1,strlen(buff),fp);
				fclose(fp);

				// // 记录index 对应的 WCRT
				sprintf(buff,"%d\n\0",WCRT);
    			// buff[strlen(buff)] = '\0';

				fp = fopen(result_name_WCRT,"a");
				res = fwrite(buff,1,strlen(buff),fp);
				fclose(fp);
			}
			switch (compare_case)
			{
			case COMPARE_U:
				if(schedule_mode == SCHEDULE_MODE_PA)
				{
					printf("PA Uf %g WCRT: %g, %d / %d\n", current_todo, (double)total_WCRT / sched_DAG_numb, sched_DAG_numb, current_DAG_numb);
				}
				if(schedule_mode == SCHEDULE_MODE_MCW)
				{
					printf("MCW Uf %g WCRT: %g, %d / %d\n", current_todo, (double)total_WCRT / sched_DAG_numb, sched_DAG_numb, current_DAG_numb);
				}
				if(schedule_mode == SCHEDULE_MODE_RWB)
				{
					printf("RWB Uf %g WCRT: %g, %d / %d\n", current_todo, (double)total_WCRT / sched_DAG_numb, sched_DAG_numb, current_DAG_numb);
				}
				break;
			case COMPARE_V:
				if(schedule_mode == SCHEDULE_MODE_PA)
				{
					printf("PA V %g WCRT: %g, %d / %d\n", current_todo, (double)total_WCRT / sched_DAG_numb, sched_DAG_numb, current_DAG_numb);
				}
				if(schedule_mode == SCHEDULE_MODE_MCW)
				{
					printf("MCW V %g WCRT: %g, %d / %d\n", current_todo, (double)total_WCRT / sched_DAG_numb, sched_DAG_numb, current_DAG_numb);
				}
				if(schedule_mode == SCHEDULE_MODE_RWB)
				{
					printf("RWB V %g WCRT: %g, %d / %d\n", current_todo, (double)total_WCRT / sched_DAG_numb, sched_DAG_numb, current_DAG_numb);
				}
				break;
			case COMPARE_pr:
				if(schedule_mode == SCHEDULE_MODE_PA)
				{
					printf("PA pr %g WCRT: %g, %d / %d\n", current_todo, (double)total_WCRT / sched_DAG_numb, sched_DAG_numb, current_DAG_numb);
				}
				if(schedule_mode == SCHEDULE_MODE_MCW)
				{
					printf("MCW pr %g WCRT: %g, %d / %d\n", current_todo, (double)total_WCRT / sched_DAG_numb, sched_DAG_numb, current_DAG_numb);
				}
				if(schedule_mode == SCHEDULE_MODE_RWB)
				{
					printf("RWB pr %g WCRT: %g, %d / %d\n", current_todo, (double)total_WCRT / sched_DAG_numb, sched_DAG_numb, current_DAG_numb);
				}
				break;
			
			default:
				break;
			}
			
		}

		// 当前利用率计算完了，汇总并输出可调度率和数值
		switch (compare_case)
			{
			case COMPARE_U:
				if(schedule_mode == SCHEDULE_MODE_PA)
				{
					printf("PA Uf %g WCRT is: %g, schedulability ratio is: %g%%\n", current_todo, total_WCRT / sched_DAG_numb, sched_DAG_numb / (double)DAG_NUMB_PER_POINT * 100);
				}
				if(schedule_mode == SCHEDULE_MODE_MCW)
				{
					printf("MCW Uf %g WCRT is: %g, schedulability ratio is: %g%%\n", current_todo, total_WCRT / sched_DAG_numb, sched_DAG_numb / (double)DAG_NUMB_PER_POINT * 100);
				}
				if(schedule_mode == SCHEDULE_MODE_RWB)
				{
					printf("RWB Uf %g WCRT is: %g, schedulability ratio is: %g%%\n", current_todo, total_WCRT / sched_DAG_numb, sched_DAG_numb / (double)DAG_NUMB_PER_POINT * 100);
				}
				break;
			case COMPARE_V:
				if(schedule_mode == SCHEDULE_MODE_PA)
				{
					printf("PA V %g WCRT is: %g, schedulability ratio is: %g%%\n", current_todo, total_WCRT / sched_DAG_numb, sched_DAG_numb / (double)DAG_NUMB_PER_POINT * 100);
				}
				if(schedule_mode == SCHEDULE_MODE_MCW)
				{
					printf("MCW V %g WCRT is: %g, schedulability ratio is: %g%%\n", current_todo, total_WCRT / sched_DAG_numb, sched_DAG_numb / (double)DAG_NUMB_PER_POINT * 100);
				}
				if(schedule_mode == SCHEDULE_MODE_RWB)
				{
					printf("RWB V %g WCRT is: %g, schedulability ratio is: %g%%\n", current_todo, total_WCRT / sched_DAG_numb, sched_DAG_numb / (double)DAG_NUMB_PER_POINT * 100);
				}
				break;
			case COMPARE_pr:
				if(schedule_mode == SCHEDULE_MODE_PA)
				{
					printf("PA pr %g WCRT is: %g, schedulability ratio is: %g%%\n", current_todo, total_WCRT / sched_DAG_numb, sched_DAG_numb / (double)DAG_NUMB_PER_POINT * 100);
				}
				if(schedule_mode == SCHEDULE_MODE_MCW)
				{
					printf("MCW pr %g WCRT is: %g, schedulability ratio is: %g%%\n", current_todo, total_WCRT / sched_DAG_numb, sched_DAG_numb / (double)DAG_NUMB_PER_POINT * 100);
				}
				if(schedule_mode == SCHEDULE_MODE_RWB)
				{
					printf("RWB pr %g WCRT is: %g, schedulability ratio is: %g%%\n", current_todo, total_WCRT / sched_DAG_numb, sched_DAG_numb / (double)DAG_NUMB_PER_POINT * 100);
				}
				break;
			
			default:
				break;
			}
		
	}
	
	
	

	return 0;
}