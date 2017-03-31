//
//  UIView+ZYXExtension.h
//  algorithm1
//
//  Created by 公安信息 on 16/8/15.
//  Copyright © 2016年 zhangyanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZYXExtension)

@property (nonatomic, assign) CGFloat x_extension;
@property (nonatomic, assign) CGFloat y_extension;
@property (nonatomic, assign) CGFloat centerX_extension;
@property (nonatomic, assign) CGFloat centerY_extension;
@property (nonatomic, assign) CGFloat width_extension;
@property (nonatomic, assign) CGFloat height_extension;
@property (nonatomic, assign) CGSize size_extension;
@property (nonatomic, assign) CGPoint origin_extension;

@property (nonatomic, strong) NSString * logframe;

@property (nonatomic, strong) NSString * logcenter;

@property (nonatomic, strong) NSString * logContentInset;




@end
