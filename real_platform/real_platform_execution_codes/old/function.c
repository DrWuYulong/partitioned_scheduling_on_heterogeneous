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
    if(schedule_mode == SCHEDULE_MODE_MCW)
    {
        //判断绑定合法性
        assert(target_cpu < sysconf(_SC_NPROCESSORS_CONF) && target_cpu >= 0);
        CPU_SET(target_cpu,&cpuset);

    }
    if(schedule_mode == SCHEDULE_MODE_RWB)
    {
        //判断绑定合法性
        assert(target_cpu < sysconf(_SC_NPROCESSORS_CONF) && target_cpu >= 0);
        CPU_SET(target_cpu,&cpuset);

    }
    if(schedule_mode == SCHEDULE_MODE_PA)
    {
        //判断绑定合法性
        assert(target_cpu < 2 && target_cpu >= 0);
        if(target_cpu == 0)
        {
            CPU_SET(0,&cpuset);
            CPU_SET(1,&cpuset);
            CPU_SET(2,&cpuset);
            CPU_SET(3,&cpuset);
        }
        if(target_cpu == 1)
        {
            CPU_SET(4,&cpuset);
            CPU_SET(5,&cpuset);
        }

        
    }
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
    param.sched_priority = sched_get_priority_max(SCHED_FIFO);		// 所有子任务比最高优先级低1
	
    char file_path[32] = "";
    char file_name[64] = "";
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

    if(stp->schedule_mode == SCHEDULE_MODE_PA)
    {
        strncpy(fn_p,"/processor_PA.txt",strlen("/processor_PA.txt"));    // !!!!!!!!! Han, Chang 2个档位
        fn_p += strlen("/processor_PA.txt");
    }

    if(stp->schedule_mode == SCHEDULE_MODE_MCW)
    {
        strncpy(fn_p,"/processor_MCW.txt",strlen("/processor_MCW.txt"));   
        fn_p += strlen("/processor_MCW.txt");
    }
    
    if(stp->schedule_mode == SCHEDULE_MODE_RWB)
    {
        strncpy(fn_p,"/processor_RWB.txt",strlen("/processor_RWB.txt"));   
        fn_p += strlen("/processor_RWB.txt");
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

    strncpy(fn_p,"/C.txt",strlen("/C.txt"));
    fn_p += strlen("/C.txt");

    *fn_p = '\0';


    fd = open(file_name,O_RDONLY);

    for (int i = 0; i < stp->V_numb; i++)
    {
        length = read_line(fd,buff,sizeof(buff));
        temp_save = atoi(buff);
        (stp+i)->C = temp_save;
        switch (stp->schedule_mode)
        {
        case SCHEDULE_MODE_RWB:
            if((stp+i)->processor < 4)
            {
                (stp+i)->C_workload_numb = temp_save * ONE_MS_LITTLE;
            }else{
                (stp+i)->C_workload_numb = temp_save * ONE_MS_BIG;
            }
            break;
        case SCHEDULE_MODE_MCW:
            if((stp+i)->processor < 4)
            {
                (stp+i)->C_workload_numb = temp_save * ONE_MS_LITTLE;
            }else{
                (stp+i)->C_workload_numb = temp_save * ONE_MS_BIG;
            }
            break;
        case SCHEDULE_MODE_PA:
            if((stp+i)->processor < 1)
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

    strncpy(fn_p,"/suc_numb.txt",strlen("/suc_numb.txt"));
    fn_p += strlen("/suc_numb.txt");

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

    strncpy(fn_p,"/pre.txt",strlen("/pre.txt"));
    fn_p += strlen("/pre.txt");

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
