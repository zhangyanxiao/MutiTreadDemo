//
//  ZYXNSOperation.m
//  MutiTreadDemo
//
//  Created by 公安信息 on 17/4/6.
//  Copyright © 2017年 张艳晓. All rights reserved.
//

#import "ZYXNSOperation.h"

@implementation ZYXNSOperation
/*
自定义NSOperation的步骤很简单
重写-(void)main方法，在里面实现想执行的任务

重写-(void)main方法的注意点
自己创建自动释放池（因为如果是异步操作，无法访问主线程的自动释放池）
经常通过-(BOOL)isCancelled方法检测操作是否被取消，对取消做出响应
 */
-(void)main{
    // isCancelled方法检测操作是否被取消，对取消做出响应
    if(self.isCancelled){
        return;
    }
    NSURL * url = [NSURL URLWithString:self.imgUrl];
    NSData * imageData = [NSData dataWithContentsOfURL:url];
    if (self.isCancelled) {
        url = nil;
        imageData = nil;
        return;
    }
    
    UIImage * image = [UIImage imageWithData:imageData];
    if (self.isCancelled) {
        image = nil;
        return;
    }
    
    if (self.loadDelegate!=nil && [self.loadDelegate respondsToSelector:@selector(loadImageFinish:)]) {
        [(NSObject *)self.loadDelegate performSelectorOnMainThread:@selector(loadImageFinish:) withObject:image waitUntilDone:NO];
    }

    
}
@end
