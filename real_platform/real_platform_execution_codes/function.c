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

#include <unistd.h>

#include <assert.h>

/*操作文件相关头文件*/
// #include <sys/types.h>
// #include <sys/stat.h>
#include <fcntl.h>





/* 把指定线程绑定到特定CPU */ 
void bound_thread_to_CPU(pthread_attr_t *attr, int target_cpu, int schedule_mode) // target_cpu范围从 0~sysconf(_SC_NPROCESSORS_CONF)-1
{
    /* 根据attr属性绑定cpu */
    cpu_set_t cpuset;
    CPU_ZERO(&cpuset);

    assert(target_cpu < sysconf(_SC_NPROCESSORS_CONF) && target_cpu >= 0);
    CPU_SET(target_cpu,&cpuset);
    
    // if(schedule_mode == SCHEDULE_MODE_RAND_MRW || schedule_mode == SCHEDULE_MODE_PA_MRW)
    // {
    //     //判断绑定合法性
    //     assert(target_cpu < sysconf(_SC_NPROCESSORS_CONF) && target_cpu >= 0);
    //     CPU_SET(target_cpu,&cpuset);

    // }
    // if(schedule_mode == SCHEDULE_MODE_PA || schedule_mode == SCHEDULE_MODE_RAND)
    // {
    //     //判断绑定合法性
    //     assert(target_cpu < 2 && target_cpu >= 0);
    //     if(target_cpu == 0)
    //     {
    //         CPU_SET(0,&cpuset);
    //         CPU_SET(1,&cpuset);
    //         CPU_SET(2,&cpuset);
    //         CPU_SET(3,&cpuset);         
    //     }
    //     if(target_cpu == 1)
    //     {  
    //         CPU_SET(4,&cpuset);
    //         CPU_SET(5,&cpuset);     
    //     }

        
    // }

    // if(schedule_mode == SCHEDULE_MODE_PA_Han)
    // {
    //     //判断绑定合法性
    //     assert(target_cpu < 2 && target_cpu >= 0);
    //     if(target_cpu == 0)
    //     {
    //         CPU_SET(0,&cpuset);
    //         CPU_SET(1,&cpuset);
    //         CPU_SET(2,&cpuset);
    //         CPU_SET(3,&cpuset);         
    //     }
    //     if(target_cpu == 1)
    //     {  
    //         CPU_SET(4,&cpuset);
    //         CPU_SET(5,&cpuset);     
    //     }        
    // }else{
    //     //判断绑定合法性
    //     assert(target_cpu < sysconf(_SC_NPROCESSORS_CONF) && target_cpu >= 0);
    //     CPU_SET(target_cpu,&cpuset);

    // }


    pthread_attr_setaffinity_np(attr,sizeof(cpu_set_t),&cpuset);
    
}


/* 读取指定文件的一行 */
int read_line(int fd, char *buff, int len_buff)
{// read just one line from the date file.
	int length;
	char *position;
	length = read(fd, buff, len_buff);
    if (length > 0)
    {
		position = strstr(buff,"\n");
		if (position != NULL)
		{
			*position = '\0';

			/*fd move back*/
			lseek(fd, -(length - (position - buff + 1)), SEEK_CUR);
			length = position - buff;
		}
		else
		{
			length = strlen(buff);
		}


    }
    else
    {
    	length = 0;
    }

    return length;
}


/* 初始化子任务 */
void init_subtask(subtask_p stp, sem_t* sem_base, pthread_attr_t *attr, int compare_case){

    // int V_numb = 4;                     // 子任务个数
    struct sched_param param;
    param.sched_priority = sched_get_priority_max(SCHED_FIFO);		// 所有子任务比最高优先级
	
    char file_path[64] = "";
    char file_name[128] = "";
	char buff[64], *fn_p, *buff_p;
    int fd, length, temp_save, pre_index;

    /**************** 用来初始化Uf的 *******************/
    switch (compare_case)
    {
    case COMPARE_U:
		strncpy(file_path,"../data/U/",strlen("../data/U/"));
		break;
	case COMPARE_V:
		strncpy(file_path,"../data/V/",strlen("../data/V/"));
		break;
	case COMPARE_pr:
		strncpy(file_path,"../data/pr/",strlen("../data/pr/"));
		break;
    }
    file_path[strlen(file_path)] = '\0';

    sprintf(&file_path[strlen(file_path)],"%g",stp->temp_todo);
    file_path[strlen(file_path)] = '\0';

    strncpy(&file_path[strlen(file_path)],"/DAG_",strlen("/DAG_"));
    file_path[strlen(file_path)] = '\0';

    sprintf(&file_path[strlen(file_path)],"%d",stp->current_DAG_numb);
    file_path[strlen(file_path)] = '\0';

    /*****************************************************/




    // ************ 开始初始化 V_numb ******************
    fn_p = file_name;
    strncpy(fn_p,file_path,strlen(file_path));
    fn_p += strlen(file_path);

    strncpy(fn_p,"/V_numb.txt",strlen("/V_numb.txt"));
    fn_p += strlen("/V_numb.txt");

    *fn_p = '\0';


    fd = open(file_name,O_RDONLY);

    length = read_line(fd,buff,sizeof(buff));
    
    close(fd);

    temp_save = atoi(buff);

    for (int i = 0; i < temp_save; i++)
    {
        (stp+i)->V_numb = temp_save;
    }
    // **************************************************
    
    

    // ************ 开始初始化 processor *****************
    
    fn_p = file_name;
    strncpy(fn_p,file_path,strlen(file_path));
    fn_p += strlen(file_path);

    switch (stp->schedule_mode)
    {
    case SCHEDULE_MODE_PA_WF:
        strncpy(fn_p,"/processor_PA_WF.txt",strlen("/processor_PA_WF.txt"));    // !!!!!!!!! 
        fn_p += strlen("/processor_PA_WF.txt");
        break;
    case SCHEDULE_MODE_PA_MRW:
        strncpy(fn_p,"/processor_PA_MRW.txt",strlen("/processor_PA_MRW.txt"));   
        fn_p += strlen("/processor_PA_MRW.txt");
        break;
    case SCHEDULE_MODE_RAND_WF:
        strncpy(fn_p,"/processor_Rand_WF.txt",strlen("/processor_Rand_WF.txt"));   
        fn_p += strlen("/processor_Rand_WF.txt");
        break;
    case SCHEDULE_MODE_RAND_MRW:
        strncpy(fn_p,"/processor_Rand_MRW.txt",strlen("/processor_Rand_MRW.txt"));   
        fn_p += strlen("/processor_Rand_MRW.txt");
        break;
    } 
    

    *fn_p = '\0';


    fd = open(file_name,O_RDONLY);

    for (int i = 0; i < stp->V_numb; i++)
    {
        length = read_line(fd,buff,sizeof(buff));
        temp_save = atoi(buff);
        (stp+i)->processor = temp_save - 1;
    } 
    close(fd);

    // *******************************************

    // ************ 开始初始化 C *****************
    
    fn_p = file_name;
    strncpy(fn_p,file_path,strlen(file_path));
    fn_p += strlen(file_path);

    switch (stp->schedule_mode)
    {
    case SCHEDULE_MODE_PA_WF:
        strncpy(fn_p,"/PA_C.txt",strlen("/PA_C.txt"));
        fn_p += strlen("/PA_C.txt");
        break;
    case SCHEDULE_MODE_PA_MRW:
        strncpy(fn_p,"/PA_C.txt",strlen("/PA_C.txt"));
        fn_p += strlen("/PA_C.txt");
        break;
    case SCHEDULE_MODE_RAND_WF:
        strncpy(fn_p,"/Rand_C.txt",strlen("/Rand_C.txt"));
        fn_p += strlen("/Rand_C.txt");
        break;
    case SCHEDULE_MODE_RAND_MRW:
        strncpy(fn_p,"/Rand_C.txt",strlen("/Rand_C.txt"));
        fn_p += strlen("/Rand_C.txt");
        break;
    } 

    *fn_p = '\0';

    fd = open(file_name,O_RDONLY);

    for (int i = 0; i < stp->V_numb; i++)
    {
        length = read_line(fd,buff,sizeof(buff));
        temp_save = atoi(buff);
        (stp+i)->C = temp_save;
        switch (stp->schedule_mode)
        {
        case SCHEDULE_MODE_PA_WF:
            if((stp+i)->processor < 4)
            {
                (stp+i)->C_workload_numb = temp_save * ONE_MS_LITTLE;
            }else{
                (stp+i)->C_workload_numb = temp_save * ONE_MS_BIG;
            }
            break;
        case SCHEDULE_MODE_PA_MRW:
            if((stp+i)->processor < 4)
            {
                (stp+i)->C_workload_numb = temp_save * ONE_MS_LITTLE;
            }else{
                (stp+i)->C_workload_numb = temp_save * ONE_MS_BIG;
            }
            break;
        case SCHEDULE_MODE_RAND_WF:
            if((stp+i)->processor < 4)
            {
                (stp+i)->C_workload_numb = temp_save * ONE_MS_LITTLE;
            }else{
                (stp+i)->C_workload_numb = temp_save * ONE_MS_BIG;
            }    
            break;    
        case SCHEDULE_MODE_RAND_MRW:
            if((stp+i)->processor < 4)
            {
                (stp+i)->C_workload_numb = temp_save * ONE_MS_LITTLE;
            }else{
                (stp+i)->C_workload_numb = temp_save * ONE_MS_BIG;
            }   
            break; 
        }
    } 
    close(fd);

    // *******************************************



    // ************ 开始初始化 suc_numb *****************
    
    fn_p = file_name;
    strncpy(fn_p,file_path,strlen(file_path));
    fn_p += strlen(file_path);

    switch (stp->schedule_mode)
    {
    case SCHEDULE_MODE_PA_WF:
        strncpy(fn_p,"/PA_suc_numb.txt",strlen("/PA_suc_numb.txt"));
        fn_p += strlen("/PA_suc_numb.txt");
        break;
    case SCHEDULE_MODE_PA_MRW:
        strncpy(fn_p,"/PA_suc_numb.txt",strlen("/PA_suc_numb.txt"));
        fn_p += strlen("/PA_suc_numb.txt");
        break;
    case SCHEDULE_MODE_RAND_WF:
        strncpy(fn_p,"/Rand_suc_numb.txt",strlen("/Rand_suc_numb.txt"));
        fn_p += strlen("/Rand_suc_numb.txt");
        break;
    case SCHEDULE_MODE_RAND_MRW:
        strncpy(fn_p,"/Rand_suc_numb.txt",strlen("/Rand_suc_numb.txt"));
        fn_p += strlen("/Rand_suc_numb.txt");
        break;
    } 

    

    *fn_p = '\0';


    fd = open(file_name,O_RDONLY);

    for (int i = 0; i < stp->V_numb; i++)
    {
        length = read_line(fd,buff,sizeof(buff));
        temp_save = atoi(buff);
        (stp+i)->suc_numb = temp_save;
    } 
    close(fd);

    // *******************************************

    // ************ 开始初始化 constraint *****************
    
    fn_p = file_name;
    strncpy(fn_p,file_path,strlen(file_path));
    fn_p += strlen(file_path);

    switch (stp->schedule_mode)
    {
    case SCHEDULE_MODE_PA_WF:
        strncpy(fn_p,"/PA_pre.txt",strlen("/PA_pre.txt"));
        fn_p += strlen("/PA_pre.txt");
        break;
    case SCHEDULE_MODE_PA_MRW:
        strncpy(fn_p,"/PA_pre.txt",strlen("/PA_pre.txt"));
        fn_p += strlen("/PA_pre.txt");
        break;
    case SCHEDULE_MODE_RAND_WF:
        strncpy(fn_p,"/Rand_pre.txt",strlen("/Rand_pre.txt"));
        fn_p += strlen("/Rand_pre.txt");
        break;
    case SCHEDULE_MODE_RAND_MRW:
        strncpy(fn_p,"/Rand_pre.txt",strlen("/Rand_pre.txt"));
        fn_p += strlen("/Rand_pre.txt");
        break;
    } 

    

    *fn_p = '\0';


    fd = open(file_name,O_RDONLY);

    for (int i = 0; i < stp->V_numb; i++)
    {
        pre_index = 0;
        length = read_line(fd,buff,sizeof(buff));
        buff_p = buff;
        do
        {
            (stp+i)->constraint[pre_index] = atoi(buff_p) - 1;
            buff_p = strstr(buff_p+1," ");
            pre_index++;
        } while (buff_p != NULL);
        // if ((stp+i)->constraint[0] == 0)
        // {
        //     (stp+i)->constraint[0] = -1;
        // }else{
        //     (stp+i)->constraint[pre_index] = -1;
        // }
        (stp+i)->constraint[pre_index] = -1;
    } 
    close(fd);



    // *******************************************
    // **************************** 其他参数初始化************
    for (int i = 0; i < stp->V_numb; i++)
    {
        (stp+i)->sem_base = sem_base;
        (stp+i)->subtask_order = i;
        (stp+i)->finish = 0;
        *((stp+i)->WCRT) = 0;
        pthread_attr_init(attr+i);
        pthread_attr_setschedparam(attr+i,&param);
        pthread_attr_setschedpolicy(attr+i, SCHED_FIFO);
        bound_thread_to_CPU(attr+i, (stp+i)->processor, stp->schedule_mode);
        
    }


}



/* 用来模拟子任务执行 */
void* subtask_threads(void* param)
{
    subtask_p stp;
    stp = (subtask_p) param;

    long int target;
    int ms, res;
    long int total1,total2;
    struct timespec ts;

    ts.tv_sec = stp->begin_time->tv_sec + DAG_TASK_DDL/1000;
    ts.tv_nsec = stp->begin_time->tv_nsec + (DAG_TASK_DDL % 1000) * 1000000;

    total1 = stp->C_workload_numb;
    // printf("%ld,\n",total1);
    //使用信号量模拟子任务间优先约束
    for (int i = 0; i < SUBTASK_NUMB_MAX && stp->constraint[i] != -1; i++)
    {
        //循环阻塞 pre, stp->constraint[i] 里面储存了该子任务受到谁的阻塞
        // printf("thread %d waiting %d value %d\n", stp->subtask_order, stp->constraint[i], (stp->sem_base+stp->constraint[i])->__align);
        // sem_getvalue(stp->sem_base + stp->constraint[i],&ms);
        // printf("thread %d before: %d\n",stp->subtask_order,ms);
        res = sem_timedwait(stp->sem_base + stp->constraint[i], &ts);

        if (res != 0) // 超时了，不可调度！
        {
            //像main函数的超时信号量输出信号。
            sem_post(stp->sem_timeout_p);
        }

        
        
    }
    
    // 开始负载
    clock_gettime(CLOCK_REALTIME, &ts);
    target = ts.tv_sec * 1000000000 + ts.tv_nsec + stp->C * 1000000;

    if (stp->current_DDL < target)
    {
        //超时了，不可调度
        sem_post(stp->sem_timeout_p);
        return (void*)0;
    }else{
        //可以调度开始负载
   
        while(total1 > 0)
        {
            total1--;
        }

        clock_gettime(CLOCK_REALTIME, &ts);

        // 如果没超时就写入信号量
        total1 = stp->begin_time->tv_sec * 1000000000 + stp->begin_time->tv_nsec;
        total2 = ts.tv_sec * 1000000000 + ts.tv_nsec;
        ms = (total2 - total1) / 1000000;

        *(stp->WCRT) = ms > *(stp->WCRT) ? ms : *(stp->WCRT);
        // printf("WCRT is: %d\n",*(stp->WCRT));
        *stp->finish_count += 1;

        for (int i = 0; i < stp->suc_numb; i++)
        {
            sem_post(stp->sem_base+stp->subtask_order);
        }


        if (*(stp->finish_count) == stp->V_numb)
        {
            // 完成了也向main发送，最后对比finish_count的数量判断是否可调度
            sem_post(stp->sem_timeout_p);
        }   
    }

    
    
    
    // sem_getvalue(stp->sem_base + stp->subtask_order, &res);
    // printf("before: %d ---",res);
    // sem_post(stp->sem_base + stp->subtask_order);
    // res = sem_post(stp->sem_base + stp->subtask_order);
    // printf("post %d success! ---", stp->subtask_order, res);
    // sem_getvalue(stp->sem_base + stp->subtask_order, &res);
    // printf("after: %d ---\n",res);
}

/* 重置前numb个信号量的值为0 */
void reset_sem(sem_t *sem_array_p, int numb)
{
    for(int i = 0; i < numb; i++)
    {
        (sem_array_p + i)->__align = 0;
    }
}


void self_scheduler(int schedule_mode,int compare_case,subtask_p stp,pthread_t *tid, struct timespec *begin_time, int *WCRT,sem_t *sem_timeout_p, sem_t *sem, pthread_attr_t *attr, int *finish_count)
{
	long int total_time;
	struct timespec timeout;						//相当于定时器，用sem_timedwait()看是否超过ddl
	struct sched_param param;
	int flag, res;									// flag用来判断是否可调度
	// sem_t *sem_timeout_p;
	double total_WCRT;
	int sched_DAG_numb;

	/*************** 参数类型初始化 ******************/
	// int schedule_mode = SCHEDULE_MODE_PA_WF;		/********  用来确定处理器分配模式  **********/ 
	// int schedule_mode = SCHEDULE_MODE_PA_MRW;
	// int schedule_mode = SCHEDULE_MODE_RAND_MRW;

	// int compare_case = COMPARE_U;
	// int compare_case = COMPARE_V;
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
		(stp+i)->begin_time = begin_time;	//传地址
		(stp+i)->tid_p = tid+i;
		(stp+i)->WCRT = WCRT;
	}

	switch (compare_case)
	{
	case COMPARE_U:
        switch (schedule_mode)
        {
        case SCHEDULE_MODE_PA_WF:
            strncpy(result_path,"../result/PA_WF_U",strlen("../result/PA_WF_U"));
			result_path[strlen("../result/PA_WF_U")] = '\0';
            break;
        case SCHEDULE_MODE_PA_MRW:
            strncpy(result_path,"../result/PA_MRW_U",strlen("../result/PA_MRW_U"));
			result_path[strlen("../result/PA_MRW_U")] = '\0';
            break;
        case SCHEDULE_MODE_RAND_WF:
            strncpy(result_path,"../result/Rand_WF_U",strlen("../result/Rand_WF_U"));
			result_path[strlen("../result/Rand_WF_U")] = '\0';
            break;
        case SCHEDULE_MODE_RAND_MRW:
            strncpy(result_path,"../result/Rand_MRW_U",strlen("../result/Rand_MRW_U"));
			result_path[strlen("../result/Rand_MRW_U")] = '\0';
            break;
        }
		break;
	case COMPARE_V:
		switch (schedule_mode)
        {
        case SCHEDULE_MODE_PA_WF:
            strncpy(result_path,"../result/PA_WF_V",strlen("../result/PA_WF_V"));
			result_path[strlen("../result/PA_WF_V")] = '\0';
            break;
        case SCHEDULE_MODE_PA_MRW:
            strncpy(result_path,"../result/PA_MRW_V",strlen("../result/PA_MRW_V"));
			result_path[strlen("../result/PA_MRW_V")] = '\0';
            break;
        case SCHEDULE_MODE_RAND_WF:
            strncpy(result_path,"../result/Rand_WF_V",strlen("../result/Rand_WF_V"));
			result_path[strlen("../result/Rand_WF_V")] = '\0';
            break;
        case SCHEDULE_MODE_RAND_MRW:
            strncpy(result_path,"../result/Rand_MRW_V",strlen("../result/Rand_MRW_V"));
			result_path[strlen("../result/Rand_MRW_V")] = '\0';
            break;
        }
		break;
	case COMPARE_pr:
		switch (schedule_mode)
        {
        case SCHEDULE_MODE_PA_WF:
            strncpy(result_path,"../result/PA_WF_pr",strlen("../result/PA_WF_pr"));
			result_path[strlen("../result/PA_WF_pr")] = '\0';
            break;
        case SCHEDULE_MODE_PA_MRW:
            strncpy(result_path,"../result/PA_MRW_pr",strlen("../result/PA_MRW_pr"));
			result_path[strlen("../result/PA_MRW_pr")] = '\0';
            break;
        case SCHEDULE_MODE_RAND_WF:
            strncpy(result_path,"../result/Rand_WF_pr",strlen("../result/Rand_WF_pr"));
			result_path[strlen("../result/Rand_WF_pr")] = '\0';
            break;
        case SCHEDULE_MODE_RAND_MRW:
            strncpy(result_path,"../result/Rand_MRW_pr",strlen("../result/Rand_MRW_pr"));
			result_path[strlen("../result/Rand_MRW_pr")] = '\0';
            break;
        }
		break;
	}
	
	
	mkdir(result_path, 0777);

    switch (schedule_mode)
    {
    case SCHEDULE_MODE_PA_WF:
        for (int i = 0; i < SUBTASK_NUMB_MAX; i++)
		{
			(stp+i)->schedule_mode = SCHEDULE_MODE_PA_WF;
		}
        break;
    case SCHEDULE_MODE_PA_MRW:
        for (int i = 0; i < SUBTASK_NUMB_MAX; i++)
		{
			(stp+i)->schedule_mode = SCHEDULE_MODE_PA_MRW;
		}
        break;
    case SCHEDULE_MODE_RAND_WF:
        for (int i = 0; i < SUBTASK_NUMB_MAX; i++)
		{
			(stp+i)->schedule_mode = SCHEDULE_MODE_RAND_WF;
		}
        break;
    case SCHEDULE_MODE_RAND_MRW:
        for (int i = 0; i < SUBTASK_NUMB_MAX; i++)
		{
			(stp+i)->schedule_mode = SCHEDULE_MODE_RAND_MRW;
		}
        break;
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
	// for (double current_todo = calculate_max; current_todo > calculate_min; current_todo -= calculate_step)			//递减
	{
		printf("begin  %g\n",current_todo);
		/* 初始化超时信号量和普通信号量 */
		// sem_timeout_p = &sem_timeout;
		sem_init(sem_timeout_p, 0, 0);
        for (int i = 0; i < SUBTASK_NUMB_MAX; i++)
        {
            sem_init((sem+i),0,0);
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
			stp->temp_todo = current_todo;						//初始化利用率为了读取数据
			stp->current_DAG_numb = current_DAG_numb;			//开始初始化第几个DAG
			
			init_subtask(stp, sem, attr, compare_case);
	
			// printf("%d,%d,%d\n",stp[0].C,stp[3].C,stp[10].C);
			// printf("%ld,%ld,%ld\n",stp[0].C_workload_numb,stp[3].C_workload_numb,stp[10].C_workload_numb);

			// return 0;
			*WCRT = 0; 								//初始化 WCRT， 每个DAG任务只需要初始化一次，剩下比大小就行
			for (int i = 0; i < stp[0].V_numb; i++)
			{

				(stp+i)->sem_timeout_p = sem_timeout_p;
				// stp[i].begin_time = &begin_time;	//传地址
				(stp+i)->subtask_order = i;
				// stp[i].tid_p = &tid[i];
				(stp+i)->finish_count = finish_count;
				// stp[i].WCRT = &WCRT;
			}
			
			for (int loop = 0; (loop < LOOP_NUMB) && flag; loop ++)	// 要执行多少遍。
			{
				// 重置信号量的值
				reset_sem(sem, SUBTASK_NUMB_MAX);

				// 重置完整子任务数量
				*finish_count = 0;

				// usleep(100000);
				
				clock_gettime(CLOCK_REALTIME, begin_time);
				total_time = begin_time->tv_sec * 1000000000 + begin_time->tv_nsec;

				for (int i = 0; i < stp->V_numb; i++)
				{
					stp[i].current_DDL = total_time	+ DAG_TASK_DDL * 1000000;	
				}

				
				for (int i = 0; i < stp->V_numb; i++)
				{
					pthread_create((tid+i),attr+i,subtask_threads,(void*)(stp+i));		
				}

				for (int i = 0; i < stp->V_numb; i++)
				{
					pthread_join(*(tid+i), NULL);
				}
				

				timeout.tv_nsec = begin_time->tv_nsec + (DAG_TASK_DDL % 1000) * 1000000;
				timeout.tv_sec = begin_time->tv_sec + DAG_TASK_DDL / 1000;
				
				
				res = sem_timedwait(sem_timeout_p,&timeout);			// res = 0 表示在规定时间内收到了信号， res = -1 表示超时了。
				if(*finish_count != stp->V_numb)
				{
					// 不可调度
					// printf("finish_count %d, res %d, %d, %d, %d\n", finish_count, res, stp[0].V_numb,loop, WCRT);
					sleep(DAG_TASK_DDL/1000 + 1); //休眠2000ms=2s 用来清空，所有子任务的执行时间都不会超过 DAG_TASK_DDL / 1000 + 1 秒，相当于向上取整
					flag = 0;
					break;
				}else if(*WCRT > DAG_TASK_DDL)
				{
					sleep(DAG_TASK_DDL/1000 + 1); 
					flag = 0;
					break;
				}else if (*finish_count == stp->V_numb)
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
				
			}
            
            
			//当前的DAG 执行完LOOP_NUMB后可调度，记录可调度数量并更新总的响应时间
            fp = fopen(result_name_index,"a"); //确保创建文件
            fclose(fp);
            fp = fopen(result_name_WCRT,"a"); //确保创建文件
            fclose(fp);
			if (flag == 1)
			{
				sched_DAG_numb ++;
				total_WCRT += *WCRT;

				// 可调度的话记录 index 
				sprintf(buff,"%d\n\0",current_DAG_numb);
    			// buff[strlen(buff)] = '\0';
				fp = fopen(result_name_index,"a");
				res = fwrite(buff,1,strlen(buff),fp);
				fclose(fp);

				// // 记录index 对应的 WCRT
				sprintf(buff,"%d\n\0",*WCRT);
    			// buff[strlen(buff)] = '\0';

				fp = fopen(result_name_WCRT,"a");
				res = fwrite(buff,1,strlen(buff),fp);
				fclose(fp);
			}
			// switch (compare_case)
			// {
			// case COMPARE_U:
            //     switch (schedule_mode)
            //     {
            //     case SCHEDULE_MODE_PA_WF:
            //         printf("PA_WF Uf %g WCRT: %g, %d / %d\n", current_todo, (double)total_WCRT / sched_DAG_numb, sched_DAG_numb, current_DAG_numb);
            //         break;
            //     case SCHEDULE_MODE_PA_MRW:
            //         printf("PA_MRW Uf %g WCRT: %g, %d / %d\n", current_todo, (double)total_WCRT / sched_DAG_numb, sched_DAG_numb, current_DAG_numb);
            //         break;
            //     case SCHEDULE_MODE_RAND_WF:
            //         printf("RAND_WF Uf %g WCRT: %g, %d / %d\n", current_todo, (double)total_WCRT / sched_DAG_numb, sched_DAG_numb, current_DAG_numb);
            //         break;
            //     case SCHEDULE_MODE_RAND_MRW:
            //         printf("RAND_MRW Uf %g WCRT: %g, %d / %d\n", current_todo, (double)total_WCRT / sched_DAG_numb, sched_DAG_numb, current_DAG_numb);
            //         break;
            //     }
			// 	break;
			// case COMPARE_V:
			// 	switch (schedule_mode)
            //     {
            //     case SCHEDULE_MODE_PA_WF:
            //         printf("PA_WF V %g WCRT: %g, %d / %d\n", current_todo, (double)total_WCRT / sched_DAG_numb, sched_DAG_numb, current_DAG_numb);
            //         break;
            //     case SCHEDULE_MODE_PA_MRW:
            //         printf("PA_MRW V %g WCRT: %g, %d / %d\n", current_todo, (double)total_WCRT / sched_DAG_numb, sched_DAG_numb, current_DAG_numb);
            //         break;
            //     case SCHEDULE_MODE_RAND_WF:
            //         printf("RAND_WF V %g WCRT: %g, %d / %d\n", current_todo, (double)total_WCRT / sched_DAG_numb, sched_DAG_numb, current_DAG_numb);
            //         break;
            //     case SCHEDULE_MODE_RAND_MRW:
            //         printf("RAND_MRW V %g WCRT: %g, %d / %d\n", current_todo, (double)total_WCRT / sched_DAG_numb, sched_DAG_numb, current_DAG_numb);
            //         break;
            //     }
			// 	break;
			// case COMPARE_pr:
			// 	switch (schedule_mode)
            //     {
            //     case SCHEDULE_MODE_PA_WF:
            //         printf("PA_WF pr %g WCRT: %g, %d / %d\n", current_todo, (double)total_WCRT / sched_DAG_numb, sched_DAG_numb, current_DAG_numb);
            //         break;
            //     case SCHEDULE_MODE_PA_MRW:
            //         printf("PA_MRW pr %g WCRT: %g, %d / %d\n", current_todo, (double)total_WCRT / sched_DAG_numb, sched_DAG_numb, current_DAG_numb);
            //         break;
            //     case SCHEDULE_MODE_RAND_WF:
            //         printf("RAND_WF pr %g WCRT: %g, %d / %d\n", current_todo, (double)total_WCRT / sched_DAG_numb, sched_DAG_numb, current_DAG_numb);
            //         break;
            //     case SCHEDULE_MODE_RAND_MRW:
            //         printf("RAND_MRW pr %g WCRT: %g, %d / %d\n", current_todo, (double)total_WCRT / sched_DAG_numb, sched_DAG_numb, current_DAG_numb);
            //         break;
            //     }
			// 	break;
			
			// default:
			// 	break;
			// }

            if (current_DAG_numb % 10 == 0)
            {
                printf("%d,", current_DAG_numb);
                fflush(stdout);
            }
            

            sleep(1);
			
		}

        printf("\n");
		// 当前利用率计算完了，汇总并输出可调度率和数值
		switch (compare_case)
			{
			case COMPARE_U:
				switch (schedule_mode)
                {
                case SCHEDULE_MODE_PA_WF:
                    printf("PA_WF Uf %g WCRT is: %g, schedulability ratio is: %g%%\n", current_todo, total_WCRT / sched_DAG_numb, sched_DAG_numb / (double)DAG_NUMB_PER_POINT * 100);
                    break;
                case SCHEDULE_MODE_PA_MRW:
                    printf("PA_MRW Uf %g WCRT is: %g, schedulability ratio is: %g%%\n", current_todo, total_WCRT / sched_DAG_numb, sched_DAG_numb / (double)DAG_NUMB_PER_POINT * 100);
                    break;
                case SCHEDULE_MODE_RAND_WF:
                    printf("RAND_W Uf %g WCRT is: %g, schedulability ratio is: %g%%\n", current_todo, total_WCRT / sched_DAG_numb, sched_DAG_numb / (double)DAG_NUMB_PER_POINT * 100);
                    break;
                case SCHEDULE_MODE_RAND_MRW:
                    printf("RAND_MRW Uf %g WCRT is: %g, schedulability ratio is: %g%%\n", current_todo, total_WCRT / sched_DAG_numb, sched_DAG_numb / (double)DAG_NUMB_PER_POINT * 100);
                    break;
                }
				break;
			case COMPARE_V:
				switch (schedule_mode)
                {
                case SCHEDULE_MODE_PA_WF:
                    printf("PA_WF V %g WCRT is: %g, schedulability ratio is: %g%%\n", current_todo, total_WCRT / sched_DAG_numb, sched_DAG_numb / (double)DAG_NUMB_PER_POINT * 100);
                    break;
                case SCHEDULE_MODE_PA_MRW:
                    printf("PA_MRW V %g WCRT is: %g, schedulability ratio is: %g%%\n", current_todo, total_WCRT / sched_DAG_numb, sched_DAG_numb / (double)DAG_NUMB_PER_POINT * 100);
                    break;
                case SCHEDULE_MODE_RAND_WF:
                    printf("RAND_W V %g WCRT is: %g, schedulability ratio is: %g%%\n", current_todo, total_WCRT / sched_DAG_numb, sched_DAG_numb / (double)DAG_NUMB_PER_POINT * 100);
                    break;
                case SCHEDULE_MODE_RAND_MRW:
                    printf("RAND_MRW V %g WCRT is: %g, schedulability ratio is: %g%%\n", current_todo, total_WCRT / sched_DAG_numb, sched_DAG_numb / (double)DAG_NUMB_PER_POINT * 100);
                    break;
                }
				break;
			case COMPARE_pr:
				switch (schedule_mode)
                {
                case SCHEDULE_MODE_PA_WF:
                    printf("PA_WF pr %g WCRT is: %g, schedulability ratio is: %g%%\n", current_todo, total_WCRT / sched_DAG_numb, sched_DAG_numb / (double)DAG_NUMB_PER_POINT * 100);
                    break;
                case SCHEDULE_MODE_PA_MRW:
                    printf("PA_MRW pr %g WCRT is: %g, schedulability ratio is: %g%%\n", current_todo, total_WCRT / sched_DAG_numb, sched_DAG_numb / (double)DAG_NUMB_PER_POINT * 100);
                    break;
                case SCHEDULE_MODE_RAND_WF:
                    printf("RAND_W pr %g WCRT is: %g, schedulability ratio is: %g%%\n", current_todo, total_WCRT / sched_DAG_numb, sched_DAG_numb / (double)DAG_NUMB_PER_POINT * 100);
                    break;
                case SCHEDULE_MODE_RAND_MRW:
                    printf("RAND_MRW pr %g WCRT is: %g, schedulability ratio is: %g%%\n", current_todo, total_WCRT / sched_DAG_numb, sched_DAG_numb / (double)DAG_NUMB_PER_POINT * 100);
                    break;
                }
				break;
			}
		
	}
	

}