#define _GNU_SOURCE

// #include <wiringPi.h>
#include <sys/time.h>
#include <stdio.h>
#include <stdlib.h>
// #include <softPwm.h>

/*实时调度所需头文件*/
#include <limits.h>
#include <pthread.h>
#include <sched.h>
#include <sys/mman.h>


#include <unistd.h>

void thread(void* a){
	cpu_set_t cpuset, nowcpu;
	CPU_ZERO(&cpuset);
   	CPU_SET(2,&cpuset);
  	pthread_setaffinity_np(pthread_self(), sizeof(cpuset), &cpuset);
	while(1){
		for(int i = 0; i < 100000000; i++);
		pthread_getaffinity_np(pthread_self(),sizeof(nowcpu),&nowcpu);
		for(int i = 0; i < 6; i++)
		{
			if(CPU_ISSET(i,&nowcpu)){
				printf("this is thread 1 cpu is: %d\n",i);
			}
		}
		
	}
}


int main()
{
	pthread_t t1;
	pthread_attr_t attr;
	struct sched_param param;

	

	 /* 进程将锁定内存，两个参数表示当前的和以后会用到的都加锁，防止内存交换出现 */
    // if(mlockall(MCL_CURRENT|MCL_FUTURE) == -1) {
    //         printf("mlockall failed: %m\n");
    //         exit(-2);
    // }

    pthread_attr_init(&attr);
    pthread_attr_setschedpolicy(&attr, SCHED_FIFO);
    param.sched_priority = 80;
    pthread_attr_setschedparam(&attr, &param);
    pthread_attr_setinheritsched(&attr, PTHREAD_EXPLICIT_SCHED);
    printf("cpu number is: %d\n",sysconf(_SC_NPROCESSORS_CONF));


    

    pthread_create(&t1, &attr, (void*)thread, NULL);
    pthread_join(t1,NULL);

    return 0;

}
