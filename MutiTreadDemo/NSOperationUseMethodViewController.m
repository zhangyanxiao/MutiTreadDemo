//
//  NSOperationUseMethodViewController.m
//  MutiTreadDemo
//
//  Created by 公安信息 on 17/4/6.
//  Copyright © 2017年 张艳晓. All rights reserved.
//

#import "NSOperationUseMethodViewController.h"

@interface NSOperationUseMethodViewController ()
// 通常会使用一个全局队列，管理所有的异步操作
@property (nonatomic, strong) NSOperationQueue *queue;
@end

@implementation NSOperationUseMethodViewController

- (NSOperationQueue *)queue {
    if (_queue == nil) {
        _queue = [[NSOperationQueue alloc] init];
    }
    
    return _queue;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(50, 50, self.view.bounds.size.width-100, 40);
    btn1.backgroundColor = [UIColor orangeColor];
    [btn1 setTitle:@"基本操作" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btn1Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton * btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(50, 100, self.view.bounds.size.width-100, 40);
    btn2.backgroundColor = [UIColor orangeColor];
    [btn2 setTitle:@"依赖关系" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btn2Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];

    // 依赖关系Demo---UI布局
    UIButton * dependencyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dependencyBtn.frame = CGRectMake(50, 150, self.view.bounds.size.width-100, 40);
    dependencyBtn.backgroundColor = [UIColor orangeColor];
    [dependencyBtn setTitle:@"依赖关系使用Demo-开始运行" forState:UIControlStateNormal];
    [dependencyBtn addTarget:self action:@selector(dependencyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dependencyBtn];
    
//    UIButton * startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    startBtn.frame = CGRectMake(30, 200, 60, 40);
//    startBtn.backgroundColor = [UIColor lightGrayColor];
//    [startBtn setTitle:@"开始" forState:UIControlStateNormal];
//    [startBtn addTarget:self action:@selector(startBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:startBtn];
    
    UIButton * pauseAndResumeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pauseAndResumeBtn.frame = CGRectMake(100, 200, 60, 40);
    pauseAndResumeBtn.backgroundColor = [UIColor lightGrayColor];
    [pauseAndResumeBtn setTitle:@"暂停" forState:UIControlStateNormal];
    [pauseAndResumeBtn setTitle:@"恢复" forState:(UIControlStateSelected)];
    
    [pauseAndResumeBtn addTarget:self action:@selector(pauseAndResumeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pauseAndResumeBtn];
    
    UIButton * cancelAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelAllBtn.frame = CGRectMake(170, 200, 60, 40);
    cancelAllBtn.backgroundColor = [UIColor lightGrayColor];
    [cancelAllBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelAllBtn addTarget:self action:@selector(cancelAllBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelAllBtn];
    
    UIButton * btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(50, 250, self.view.bounds.size.width-100, 40);
    btn3.backgroundColor = [UIColor orangeColor];
    [btn3 setTitle:@"操作监听" forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(btn3Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
    UIButton * btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.frame = CGRectMake(50, 300, self.view.bounds.size.width-100, 40);
    btn4.backgroundColor = [UIColor orangeColor];
    [btn4 setTitle:@"线程间通信" forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(btn4Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn4];
    
}
-(void)btn1Clicked:(UIButton *)sender{
    NSInvocationOperation * operation1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(test1) object:nil];
    
    //    [operation1 start]; // start 会在当前线程执行 selector 方法，不会开启线程

    NSInvocationOperation * operation2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(test2) object:nil];
    NSBlockOperation * operation3 = [[NSBlockOperation alloc] init];
    [operation3 addExecutionBlock:^{
        [self test3];
    }];
    [operation3 addExecutionBlock:^{
        for (int i=0; i<5; i++) {
            NSLog(@"NSBlockOperation3--2----%@",[NSThread currentThread]);
        }
    }];
    
    //最大任务数
    self.queue.maxConcurrentOperationCount = 2;
    /*
     队列是一个`并发`队列
     操作添加到队列中，就会`异步`执行！
     */
    //把操作添加到队列中
    [self.queue addOperation:operation1];
    [self.queue addOperation:operation2];
    [self.queue addOperation:operation3];
}

-(void)test1{
    for (int i=0; i<5; i++) {
        NSLog(@"NSInvocationOperation--test1--%@",[NSThread currentThread]);
    }
}
-(void)test2{
    for (int i=0; i<5; i++) {
        NSLog(@"NSInvocationOperation--test2--%@",[NSThread currentThread]);
    }
    
}
-(void)test3{
    for (int i=0; i<5; i++) {
        NSLog(@"NSBlockOperation3----test3-----%@",[NSThread currentThread]);
    }
}

-(void)btn2Clicked:(UIButton *)sender{
    NSInvocationOperation * operation1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(test1) object:nil];
    NSInvocationOperation * operation2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(test2) object:nil];
    NSBlockOperation * operation3 = [[NSBlockOperation alloc] init];
    [operation3 addExecutionBlock:^{
        [self test3];
    }];
    [operation3 addExecutionBlock:^{
        for (int i=0; i<5; i++) {
            NSLog(@"NSBlockOperation3--2----%@",[NSThread currentThread]);
        }
    }];
    //设置操作依赖
    //先执行operation2，再执行operation1，最后执行operation3
    [operation3 addDependency:operation1];
    [operation1 addDependency:operation2];
    
    //创建NSOperationQueue
    NSOperationQueue * queue=[[NSOperationQueue alloc]init];
    queue.maxConcurrentOperationCount = 2;
    //把操作添加到队列中
    [queue addOperation:operation1];
    [queue addOperation:operation2];
    [queue addOperation:operation3];
    
}
#pragma mark----依赖关系Demo
-(void)dependencyBtnClicked:(UIButton *)sender{
    NSBlockOperation * op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"用户登录 %@",[NSThread currentThread]);
    }];
    NSBlockOperation * op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"付费 %@",[NSThread currentThread]);
        for(int i = 0; i< 10000; i++){
            NSLog(@"*********%d",i);
        }
    }];
    NSBlockOperation * op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"下载%@",[NSThread currentThread]);
        
    }];
    NSBlockOperation * op4 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"通知用户%@",[NSThread currentThread]);
    }];
    
    // 设置依赖关系 依赖关系，可以跨队列指定！
    // 注意！！！都不要出现循环依赖！
    [op2 addDependency:op1];
    [op3 addDependency:op2];
    [op4 addDependency:op3];
    
    // waitUntilFinished NO 异步 YES 同步

    [self.queue addOperations:@[op1,op2,op3] waitUntilFinished:NO];
    // 向主队列添加操作
    [[NSOperationQueue mainQueue] addOperation:op4];

}


-(void)pauseAndResumeBtnClicked:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    // 判断队列中是否有任务
    if (self.queue.operationCount == 0) {
        NSLog(@"队列中没有任务");
        return;
    }else{
        self.queue.suspended = !self.queue.isSuspended;
    }
}
-(void)cancelAllBtnClicked:(UIButton *)sender{
    // 取消`队列`中没有调度的全部操作，如果正在执行的操作，不会被取消
    // 提示：如果要让正在执行的操作取消，需要自定义操作，系统提供的不行！
    NSLog(@"取消全部");
    [self.queue cancelAllOperations];

}

-(void)btn3Clicked:(UIButton *)sender{
    NSLog(@"当前线程%@",[NSThread currentThread]);
    //创建对象，封装操作
    NSBlockOperation * operation = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"--operation--%@",[NSThread currentThread]);
        }
    }];
    //监听操作的执行完毕
    operation.completionBlock=^{
        NSLog(@"operation中任务完成后执行该部分-----%@",[NSThread currentThread]);// 在上一个任务执行完后，会执行operation.completionBlock=^{}代码段，且是在另一子线程执行。
    };
    //把任务添加到队列中（自动执行，自动开线程）
    [self.queue addOperation:operation];
}
-(void)btn4Clicked:(UIButton *)sender{

    [self.queue addOperationWithBlock:^{
        NSLog(@"耗时的操作... %@", [NSThread currentThread]);
        
        // 在主线程更新UI
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSLog(@"更新 UI %@", [NSThread currentThread]);
        }];
    }];

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
