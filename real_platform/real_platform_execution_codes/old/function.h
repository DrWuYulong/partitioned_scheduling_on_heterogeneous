/* 定义常量 */
#define DAG_NUMB_PER_POINT      10             // 每个点有多少个子任务
#define SUBTASK_NUMB_MAX        50              // 子任务数上限
#define DAG_TASK_DDL            1000            // DAG 任务的 DDL 单位毫秒
#define LOOP_NUMB               100             // 每个DAG任务执行多少次取最大值

#define SCHEDULE_MODE_PA        1               // 处理器分配模式导致不同的调度模式PA是1
#define SCHEDULE_MODE_RWB       2               // 处理器分配模式导致不同的调度模式RWB是2
#define SCHEDULE_MODE_MCW       3               // 处理器分配模式导致不同的调度模式MCW是3


#define COMPARE_U               1               //比较哪个类型的参数
#define COMPARE_V               2
#define COMPARE_pr              3

#define U_MIN                   0.1
#define U_STEP                  0.1
#define U_MAX                   0.7

#define V_MIN                   10
#define V_STEP                  4
#define V_MAX                   30

#define pr_MIN                   0.05
#define pr_STEP                  0.05
#define pr_MAX                   0.3


#define ONE_MS_BIG          220000          // 大核一毫秒需要的计算量 
// // #define ONE_MS_BIG          242850          // 大核一毫秒需要的计算量 
#define ONE_MS_LITTLE       165000          // 小核一毫秒需要的计算量
// // #define ONE_MS_LITTLE       214260          // 小核一毫秒需要的计算量

// #define ONE_MS                   200000
// #define ONE_MS_LITTLE_0       200000          // 小核一毫秒需要的计算量 215000 0            !
// #define ONE_MS_LITTLE_1       200000          // 小核一毫秒需要的计算量 210000 0            !
// #define ONE_MS_LITTLE_2       200000          // 小核一毫秒需要的计算量 210000 0            !
// #define ONE_MS_LITTLE_3       200000          // 小核一毫秒需要的计算量 210000 0   220000 1        
// #define ONE_MS_BIG_0          200000          // 大核一毫秒需要的计算量 210000 0   224000 1
// #define ONE_MS_BIG_1          200000          // 大核一毫秒需要的计算量 220000 0   228000 1




/* 定义结构体 */
struct subtask
{
	int C;						            //The execution time of this subtask
    long int C_workload_numb;                        //执行自增负载的次数
	int constraint[SUBTASK_NUMB_MAX+1];		//The constraint of this subtask
	int processor;				            //The processor that this subtask is allocated to be executed.
	int subtask_order;			            //The order of subtask
    int V_numb; 
    int suc_numb;                           //直接后继子任务个数
    sem_t *sem_base;
    struct timespec *begin_time;
    int *WCRT;
	int finish;					            // wheather finished
    int *finish_count;
    sem_t *sem_timeout_p;
    pthread_t *tid_p;                    // 线程控制块基地址
    long int current_DDL;                    // 当前释放的子任务的绝对DDL
    double temp_todo;
    int current_DAG_numb;                            // 保存当前要开始初始化第几个DAG
    int schedule_mode;                              //是PA 还是 RWB，1是 PA ；  2是RWB
};
typedef struct subtask *subtask_p;

struct test
{
    long int begin_time;
    long int WCRT;
    int processor;
    int tick;
};
typedef struct test *test_p;



/* 声明函数 */
void execution_simulation_big(int ticks);
void execution_simulation_little(int ticks);
void bound_thread_to_CPU(pthread_attr_t *attr, int target_cpu, int schedule_mode);
void init_subtask(subtask_p stp, sem_t* sem_base, pthread_attr_t *attr, int compare_case);
void* subtask_threads(void* param);
void reset_sem(sem_t *sem_array_p, int numb);
int read_line(int fd, char *buff, int len_buff);

