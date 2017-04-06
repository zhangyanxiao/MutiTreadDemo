//
//  ZYXNSOperation.h
//  MutiTreadDemo
//
//  Created by 公安信息 on 17/4/6.
//  Copyright © 2017年 张艳晓. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol LoadImageDelegate <NSObject>

-(void)loadImageFinish:(UIImage *) image;

@end



@interface ZYXNSOperation : NSOperation
@property (nonatomic, strong) NSString * imgUrl;
@property (nonatomic, weak) id<LoadImageDelegate>loadDelegate;
@end
