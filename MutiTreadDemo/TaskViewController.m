//
//  TaskViewController.m
//  MutiTreadDemo
//
//  Created by 公安信息 on 17/3/30.
//  Copyright © 2017年 张艳晓. All rights reserved.
//

#import "TaskViewController.h"
#import "Masonry.h"

@interface TaskViewController ()

@property (nonatomic, strong) UIImageView * imv1;
@property (nonatomic, strong) UIImageView * imv2;
@property (nonatomic, strong) UITextView * textView;
@property (nonatomic, strong) NSString * imgUrl1;
@property (nonatomic, strong) NSString * imgUrl2;
@property (nonatomic, strong) UIImage * image1;
@property (nonatomic, strong) UIImage * image2;

@property (nonatomic, strong) UIButton * controlBtn;

@property (nonatomic, assign) dispatch_queue_t  currentQueue;

@end

@implementation TaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.imgUrl1 = @"https://d262ilb51hltx0.cloudfront.net/fit/t/880/264/1*zF0J7XHubBjojgJdYRS0FA.jpeg";
    self.imgUrl2 = @"https://d262ilb51hltx0.cloudfront.net/fit/t/880/264/1*kE8-X3OjeiiSPQFyhL2Tdg.jpeg";
    [self p_setupViews];
    
}

-(void)p_setupViews{
    UIImageView * imv1 =  [[UIImageView alloc] initWithFrame:CGRectMake(50, 74, 100, 100)];
    imv1.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:imv1];
    self.imv1 = imv1;
    
    UIImageView * imv2 =  [[UIImageView alloc] initWithFrame:CGRectMake(50, 180, 100, 100)];
    imv2.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:imv2];
    self.imv2 = imv2;
    
    self.controlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.controlBtn.backgroundColor = [UIColor whiteColor];
    self.controlBtn.frame = CGRectMake(50, self.view.bounds.size.height-80, self.view.bounds.size.width - 100, 60);
    [self.controlBtn setTitle:@"开启" forState:UIControlStateNormal];
    [self.controlBtn setTitle:@"关闭" forState:UIControlStateSelected];
    [self.controlBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.controlBtn addTarget:self action:@selector(controlBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.controlBtn];
    
    self.textView = [[UITextView alloc] init];
    [self.view addSubview:self.textView];
    self.textView.font = [UIFont systemFontOfSize:15];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imv2.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.controlBtn.mas_top).offset(-20);
    }];
    self.textView.text = @"主队列，同步添加多个任务\n会crash！！！！！\n原因如下：\n1、主队列在执行dispatch_sync函数,函数会把一个block加入到指定的队列，此函数要求执行完block才返回.\n2、dispatch_sync函数把block加入的指定队列，是主队列时。就会出现下面的状况：\n \n原主队列有A,B三个任务，在A任务完成后，执行B任务时，突然需要在B中嵌套一个D任务，按照先进先出的原则，现在主队列有正在进行中的任务B和待执行任务D，但是有一个要求，D要求它先执行完再执行其他的,此时我们可以发现队列中的任务产生了冲突，D要求它先执行完再执行其他的，但是B完成任务的前提是D完成任务。造成死锁";
    
}
#pragma mark ---响应方法
-(void)controlBtnClicked:(UIButton *)sender{
    if (self.controlBtn.selected) {
        self.controlBtn.selected = NO;
        self.imv1.image = nil;
        self.imv2.image = nil;
        self.image1 = nil;
        self.image2 = nil;
        
        
    }else {
        self.controlBtn.selected = YES;
        // 选中，开始多线程任务
        [self handleMutiThread];
    }
}
-(void)handleMutiThread{
    if (self.indexPath.section == 0) {
        // 同步添加任务
        // 分四种线程
        switch (self.indexPath.row) {
            case 0:{
                
                [self mainQueueSync];
                [self task5];
            }
                break;
            case 1:{
                
                [self globalQueueSync];
                [self task5];
                
            }
                break;
            case 2:{
                [self serialQueueSync];
                [self task5];
                
            }
                break;
            case 3:{
                NSLog(@"并发队列");
                [self concurrentQueueSync];
                [self task5];
            }
                break;
                
            default:
                break;
        }
        
        
        
    }else if(self.indexPath.section == 1){
        // 异步添加任务
        switch (self.indexPath.row) {
            case 0:{
                
                [self mainQueueAsync];
                [self task5];
            }
                break;
            case 1:{
                [self globalQueueAsync];
                [self task5];
            }
                break;
            case 2:{
                [self serialQueueAsync];
                [self task5];
            }
                break;
            case 3:{
                [self concurrentQueueAsync];
                [self task5];
            }
                break;
                
            default:
                break;
        }
        

        
    }
}
//mainqueue
-(void)mainQueueSync{

    
    dispatch_queue_t mainqueue = dispatch_get_main_queue();
    
    [self syncAddWithQueue:mainqueue];
    [self task4];

}
-(void)globalQueueSync{
    self.textView.text = @"全局队列，同步添加多个任务\n1、同步——不开新线程 \n2、当前在主线程，所以4个任务运行在主线程中；\n3、虽然是全局队列，但是只有一个线程，所以任务仍然根据添加顺序依次执行；\n4、同步函数的特点执行完一个，再执行下一个；";
    dispatch_queue_t globalqueue = dispatch_get_global_queue(0, 0);
    [self syncAddWithQueue:globalqueue];

}

-(void)serialQueueSync{
    self.textView.text = @"串行队列，同步添加多个任务\n1、同步——不开新线程 \n2、当前在主线程，所以4个任务运行在主线程中；\n3、虽然是串行队列，但是只有一个线程，所以任务仍然根据添加顺序依次执行；\n4、同步函数的特点执行完一个，再执行下一个；\n\n串行队列为什么在此时不会卡死呢？解释如下：\n主队列有A,B,C三个任务，在A任务完成后，执行B任务时，突然创建了一个串行队列，串行队列里添加了一个E,F,G三个任务，按照先进先出的原则，主队列有未完成的任务B和待执行任务C,D;串行队列有E,F,G三个任务，但是任务B和串行队列并不在一个队列中，线程此时执行B开始后，继续执行串行队列中的EFG三任务后，回到任务B完成，再继续以后的任务";
    dispatch_queue_t serialqueue = dispatch_queue_create("serialqueue", DISPATCH_QUEUE_SERIAL);
    [self syncAddWithQueue:serialqueue];
    [self task4];
}
-(void)concurrentQueueSync{
    self.textView.text = @"并发队列，同步添加多个任务\n1、同步——不开新线程 \n2、当前在主线程，所以4个任务运行在主线程中；\n3、虽然是并发队列，但是只有一个线程，所以任务仍然根据添加顺序依次执行；\n4、同步函数的特点执行完一个，再执行下一个；";
    dispatch_queue_t concurrentqueue = dispatch_queue_create("concurrentqueue", DISPATCH_QUEUE_CONCURRENT);
    [self syncAddWithQueue:concurrentqueue];
    [self task4];
    
}

-(void)syncAddWithQueue:(dispatch_queue_t)queue{
    dispatch_sync(queue, ^{
        
        [self task1];
//        [self performSelectorOnMainThread:@selector(refreshView) withObject:nil waitUntilDone:YES];
    });
    dispatch_sync(queue, ^{
        [self task2];
//        [self performSelectorOnMainThread:@selector(refreshView) withObject:nil waitUntilDone:YES];
    });
    
    dispatch_sync(queue, ^{
        [self task3];
//        [self performSelectorOnMainThread:@selector(refreshView) withObject:nil waitUntilDone:YES];
    });
    
//    dispatch_sync(queue, ^{
//        [self task4];
////        [self performSelectorOnMainThread:@selector(refreshView) withObject:nil waitUntilDone:YES];
//    });
}

-(void)mainQueueAsync{
    self.textView.text = @"主队列，异步添加多个任务\n\n1、异步，开线程，但是因为是在主线程中创建主队列，所以，尽管不会再开主线程\n2、当前在主线程，异步函数dispatch——async不要求函数中任务执行完再执行下面的，所以会先执行task5\n3、又因为主队列，是串行队列，所以其余任务是顺序执行的\n4、只有主线程一条，一个完成，在执行下一个";
     dispatch_queue_t mainqueue = dispatch_get_main_queue();
    [self asyncAddWithQueue:mainqueue];
}
-(void)globalQueueAsync{
    self.textView.text = @"全局队列，异步添加多个任务\n\n1、异步，开线程，不确定开几条线程\n2、当前在主线程，异步函数dispatch_async开线程，主线程中只执行task5，异步添加的任务都会在子线程执行\n3、全局队列，也是并发队列，所以任务会同时进行，并且线程各不相同（也有相同的）";
    dispatch_queue_t globalqueue = dispatch_get_global_queue(0, 0);
    [self asyncAddWithQueue:globalqueue];
}

-(void)serialQueueAsync{
    self.textView.text = @"串行队列，异步添加多个任务\n\n1、异步，开线程，因是串行队列，只开一条子线程\n2、当前在主线程，异步函数dispatch_async开线程，主线程中只执行task5，异步添加的任务都会在子线程执行\n3、串行队列，所以任务会依次执行，线程相同\n4、串行队列：遵循FIFO原则，会先取出先进去的任务，执行完这个任务再去取下一个任务。";
    // 5 主线程
    // 1-->2(完成)-->3-->4 子线程
    dispatch_queue_t serialqueue = dispatch_queue_create("serialqueue", DISPATCH_QUEUE_SERIAL);
    [self asyncAddWithQueue:serialqueue];
    [self task4];
}
-(void)concurrentQueueAsync{
    self.textView.text = @"并发队列，异步添加多个任务\n\n1、异步，开线程，不确定开几条线程\n2、当前在主线程，异步函数dispatch_async开线程，主线程中只执行task5，异步添加的任务都会在各子线程执行\n3、并发队列，所以任务会同时进行，并且线程各不相同（也有相同的）\n4、并发队列：也遵循FIFO原则，但时间太快可忽略不计，取出所有任务同时执行。所以任务中task的开始顺序，不确定，结束顺序更不确定，因为谁快谁结束早";
    dispatch_queue_t concurrentqueue = dispatch_queue_create("concurrentqueue", DISPATCH_QUEUE_CONCURRENT);
    [self asyncAddWithQueue:concurrentqueue];
}

-(void)asyncAddWithQueue:(dispatch_queue_t)queue{
    dispatch_async(queue, ^{
        [self task1];
    });
    dispatch_async(queue, ^{
        [self task2];
    });
    
    dispatch_async(queue, ^{
        [self task3];
    });
    
//    dispatch_async(queue, ^{
//        [self task4];
//    });
    dispatch_async(queue, ^{
        [self task1];
    });
    dispatch_async(queue, ^{
        [self task2];
    });
    
    dispatch_async(queue, ^{
        [self task3];
    });
    
//    dispatch_async(queue, ^{
//        [self task4];
//    });
    
}


// 任务
- (void)task1{
    
   NSLog(@"task1---%@",[NSThread currentThread]);

}
- (void)task2{
    
    NSLog(@"task2开始---%@",[NSThread currentThread]);
    int num = 0;
    for (int i = 0; i< 1000; i++) {
        num++;
    }
    NSLog(@"task2结束---");
}

- (void)task3{
    
    NSLog(@"task3开始---%@",[NSThread currentThread]);
//    [self loadImageSource:self.imgUrl1 AndTask:3];
//    NSLog(@"task3结束---");
    
}
- (void)task4{
    
    NSLog(@"task4开始---%@",[NSThread currentThread]);
//    [self loadImageSource:self.imgUrl2 AndTask:4];
//    NSLog(@"task4结束");
}
-(void)loadImageSource:(NSString *)url AndTask:(NSInteger)taskNum{
    
    NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    UIImage *image = [UIImage imageWithData:imgData];
    if (imgData!=nil) {
        // image存在
        
        if (taskNum == 3) {
            self.image1 = image;
        }else if (taskNum == 4){
            self.image2 = image;
        }else{
            NSLog(@"查看任务");
        }
    }else{
        NSLog(@"there no image data");
    }
    
}

-(void)refreshView
{
    self.imv1.image = self.image1;
    self.imv2.image = self.image2;
}
- (void)task5{
    
    NSLog(@"task5---%@",[NSThread currentThread]);
    
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
