//
//  ZYXButtonView.h
//  algorithm1
//
//  Created by 公安信息 on 16/8/16.
//  Copyright © 2016年 zhangyanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^Buttonblock)(NSInteger);

@interface ZYXButtonView : UIView

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
@property(nonatomic, copy) Buttonblock indexBlock;

// button正常状态下的文字颜色
@property (nonatomic, strong) UIColor * normalTitleColor;
// button选中状态下的文字颜色
@property (nonatomic, strong) UIColor * selectedTitleColor;

@property(nonatomic, assign) CGFloat button_Width;

@property (nonatomic, assign) CGFloat fontsize;

@property (nonatomic, strong) UIColor * lineColor;

- (void)setButtonClicked:(NSInteger)index;

- (instancetype)initWithTitleArray:(NSArray *)titleArray;



@end
