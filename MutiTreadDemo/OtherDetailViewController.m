//
//  OtherDetailViewController.m
//  MutiTreadDemo
//
//  Created by 公安信息 on 17/3/31.
//  Copyright © 2017年 张艳晓. All rights reserved.
//

#import "OtherDetailViewController.h"

@interface OtherDetailViewController ()
@property (strong, nonatomic)  UIImageView *imv1;
@property (strong, nonatomic)  UIImageView *imv2;
@property (strong, nonatomic)  UIImageView *imv3;
@end

@implementation OtherDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self p_setupViews];
    if (self.indexPath.section == 0) {
        [self delayExecution];
    }else if (self.indexPath.section == 1){
        [self queueDisplay];
    }else if (self.indexPath.section == 2){
        //1、dispatch_barrier_sync将自己的任务插入到队列的时候，需要等待自己的任务结束之后才会继续插入被写在它后面的任务，然后执行它们
        
       // 2、dispatch_barrier_async将自己的任务插入到队列之后，不会等待自己的任务结束，它会继续把后面的任务插入到队列，然后等待自己的任务结束后才执行后面任务。
        if (self.indexPath.row == 0) {
            [self testSyncBarrierBlock];
        }else if (self.indexPath.row == 1){
            [self testAsyncBarrierBlock];
        }
    }else{
        if (self.indexPath.row == 0) {
            [self dispatchOnce];
        }else if (self.indexPath.row == 1){
            [self dispatchApply];
        }
        
    }
}
-(void)p_setupViews
{
    UIImageView * imv1 =  [[UIImageView alloc] initWithFrame:CGRectMake(50, 74, 100, 100)];
    imv1.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:imv1];
    self.imv1 = imv1;
    UIImageView * imv2 =  [[UIImageView alloc] initWithFrame:CGRectMake(50, 180, 100, 100)];
    imv2.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:imv2];
    self.imv2 = imv2;
}
-(void)delayExecution{
    NSLog(@"打印线程----%@",[NSThread currentThread]);
    if (self.indexPath.row == 0) {
        //第一种方法：延迟3秒钟调用run函数
        [self performSelector:@selector(task1) withObject:nil afterDelay:3.0];
        //在异步函数中执行
        dispatch_queue_t queue = dispatch_queue_create("wendingding", 0);
        dispatch_async(queue, ^{
        [self performSelector:@selector(task2) withObject:nil afterDelay:1.0];
         });
        NSLog(@"异步函数");
    }else{
        //主队列
        dispatch_queue_t queue1= dispatch_get_main_queue();
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), queue1, ^{
            [self task1];
         });
        // 并发队列
        dispatch_queue_t queue2 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), queue2, ^{
            [self task2];
        });
        
    }
    
}

- (void)task1{
    
    NSLog(@"task1");
}
- (void)task2{


    NSLog(@"task2开始---%@",[NSThread currentThread]);
    int num = 0;
    for (int i = 0; i< 1000; i++) {
        num++;
    }
    NSLog(@"task2结束---");

}


-(void)queueDisplay{
    dispatch_queue_t global_quque = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t main_queue = dispatch_get_main_queue();
    if (self.indexPath.row == 0) {
        dispatch_async(global_quque, ^{
            //下载图片1
            UIImage *image1 = [self imageWithUrl:@"http://d.hiphotos.baidu.com/baike/c0%3Dbaike80%2C5%2C5%2C80%2C26/sign=2b9a12172df5e0fefa1581533d095fcd/cefc1e178a82b9019115de3d738da9773912ef00.jpg"];
            NSLog(@"图片1下载完成---%@",[NSThread currentThread]);
            //下载图片2
            UIImage *image2 = [self imageWithUrl:@"http://h.hiphotos.baidu.com/baike/c0%3Dbaike80%2C5%2C5%2C80%2C26/sign=f47fd63ca41ea8d39e2f7c56f6635b2b/1e30e924b899a9018b8d3ab11f950a7b0308f5f9.jpg"];
            NSLog(@"图片2下载完成---%@",[NSThread currentThread]);
            //回到主线程显示图片
            dispatch_async(main_queue, ^{
                NSLog(@"显示图片---%@",[NSThread currentThread]);
                self.imv1.image=image1;
                self.imv2.image=image2;
                //合并两张图片
                UIGraphicsBeginImageContextWithOptions(CGSizeMake(200, 100), NO, 0.0);
                [image1 drawInRect:CGRectMake(0, 0, 100, 100)];
                [image2 drawInRect:CGRectMake(100, 0, 100, 100)];
                self.imv3.image =UIGraphicsGetImageFromCurrentImageContext();
                //关闭上下文
                UIGraphicsEndImageContext();
                NSLog(@"图片合并完成---%@",[NSThread currentThread]);
            });
            //
        });

        
    }else{
        //1.创建一个队列组
        dispatch_group_t group = dispatch_group_create();
        //2.开启一个任务下载图片1
        __block UIImage *image1=nil;
        dispatch_group_async(group, global_quque, ^{
            image1= [self imageWithUrl:@"http://d.hiphotos.baidu.com/baike/c0%3Dbaike80%2C5%2C5%2C80%2C26/sign=2b9a12172df5e0fefa1581533d095fcd/cefc1e178a82b9019115de3d738da9773912ef00.jpg"];
            NSLog(@"图片1下载完成---%@",[NSThread currentThread]);
        });
        __block UIImage *image2=nil;
        dispatch_group_async(group, global_quque, ^{
            image2= [self imageWithUrl:@"http://d.hiphotos.baidu.com/baike/c0%3Dbaike80%2C5%2C5%2C80%2C26/sign=2b9a12172df5e0fefa1581533d095fcd/cefc1e178a82b9019115de3d738da9773912ef00.jpg"];
            NSLog(@"图片1下载完成---%@",[NSThread currentThread]);
        });
        //4.等group中的所有任务都执行完毕, 再回到主线程执行其他操作
        dispatch_group_notify(group,main_queue, ^{
            NSLog(@"显示图片---%@",[NSThread currentThread]);
            self.imv1.image=image1;
            self.imv2.image=image2;
            //合并两张图片
            //注意最后一个参数是浮点数（0.0），不要写成0。
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(200, 100), NO, 0.0);
            [image1 drawInRect:CGRectMake(0, 0, 100, 100)];
            [image2 drawInRect:CGRectMake(100, 0, 100, 100)];
            self.imv3.image=UIGraphicsGetImageFromCurrentImageContext();
            //关闭上下文
            UIGraphicsEndImageContext();
            NSLog(@"图片合并完成---%@",[NSThread currentThread]);
        });
    }
    
}
//封装一个方法，传入一个url参数，返回一张网络上下载的图片
-(UIImage *)imageWithUrl:(NSString *)urlStr
{
    NSURL *url=[NSURL URLWithString:urlStr];
    NSData *data=[NSData dataWithContentsOfURL:url];
    UIImage *image=[UIImage imageWithData:data];
    return image;
}

//一次性执行(常用来写单例)
-(void)dispatchOnce{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self task1];
    });
}

//并发地执行循环迭代
-(void)dispatchApply{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    size_t count = 10;
    dispatch_apply(count, queue, ^(size_t i) {
        NSLog(@"循环执行第%li次",i);
        
    });
}
-(void)testSyncBarrierBlock {
    dispatch_queue_t myConcurrentQueue = dispatch_queue_create("myConcurrentQueue", DISPATCH_QUEUE_CONCURRENT); // 需要自己创建
    
    dispatch_async(myConcurrentQueue, ^{  // 1.2是并行的
        NSLog(@"dispatch test 1");
        NSLog(@"---%@",[NSThread currentThread]);
    });
    
    dispatch_async(myConcurrentQueue, ^{
        NSLog(@"dispatch test 2");
    });
    
    dispatch_barrier_sync(myConcurrentQueue, ^{  // 
        NSLog(@"dispatch sync barrier start");
        NSLog(@"*************%@",[NSThread currentThread]);

        [self task2];
        [self task2];
        NSLog(@"dispatch sync barrier end");
    });
    
    dispatch_async(myConcurrentQueue, ^{   // 这两个是同时执行的
        NSLog(@"dispatch test 3");
    });
    
    dispatch_async(myConcurrentQueue, ^{
        NSLog(@"dispatch test 4");
    });
    
}
-(void)testAsyncBarrierBlock {
    dispatch_queue_t myConcurrentQueue = dispatch_queue_create("myConcurrentQueue", DISPATCH_QUEUE_CONCURRENT); // 需要自己创建
    
    dispatch_async(myConcurrentQueue, ^{  // 1.2是并行的
        NSLog(@"dispatch test 1");
    });
    
    dispatch_async(myConcurrentQueue, ^{
        NSLog(@"dispatch test 2");
    });
    // 任务结束，线程结束。
    NSLog(@"dispatch_barrier_async*************%@",[NSThread currentThread]);

    dispatch_barrier_async(myConcurrentQueue, ^{  //
        NSLog(@"dispatch async barrier start");
        [self task2];
        [self task2];
        NSLog(@"dispatch async barrier end");
    });
    
    dispatch_async(myConcurrentQueue, ^{   // 这两个是同时执行的
        NSLog(@"dispatch test 3");
    });
    
    dispatch_async(myConcurrentQueue, ^{
        NSLog(@"dispatch test 4");
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
