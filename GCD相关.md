# GCD 相关
1. dispatch_group,如果我们需要所有并行异步执行完成后，执行其他的方法。则应该使用：1. dispatch_group_notify(group,queue,block) 【其他方法执行完毕后，获得通知，执行notify的方法】2.dispatch_barrier_async【阻塞，需要queue之前的方法执行完毕后，然后执行这个barrier里面的方法，然后在执行barrier之后的queue里面的方法】
2. dispatch_apply(count,queue,block)：重复执行count次数的block。并且apply会等待里面所有的block执行完毕后，才执行后面的东西
```Objective-C
dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_DEFAULT,0);
dispatch_apply(10,queue,^(size_t index){
	NSLog(@"%@",@(index));
});
NSLog(@"done");

//会先输出 4 1 3 0 9... 最后才输出done
```
3. dispatch_suspend 暂停执行queue
4. dispatch_resume 恢复执行queue
5. Dispatch Semaphore dispatch信号量，当计数为0的时候等待，计数>=1的时候减去1而继续执行
```Objective-C
dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW,1ull*NESC_PER_SEC);
//如果执行的话，semaphore会减1
long result = dispatch_semaphore_wait(semaphore,time);
if (result == 0){
	//由于semaphore的计数值大于等于1，并且待机的指定时间内
	//Dispatch Semaphore 的计数值大于等于1
	//所以Dispatch Semaphore的计数值减去1
	//可执行需要进行排它控制的处理
}else{
	//由于semaphore的计数值为0，因此在达到指定时间为止待机
}


//semaphore 计数+1
dispatch_semaphore_signal(semaphore)
```
6. dispatch_io_create[可用来分段读取文件，可有效提高文件读取速度] 
![](http://7xwb99.com1.z0.glb.clouddn.com/2016-07-17-14687272332435.jpg)
7. Dispatch Source



