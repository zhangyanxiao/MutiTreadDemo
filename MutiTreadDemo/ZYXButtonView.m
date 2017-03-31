//
//  ZYXButtonView.m
//  algorithm1
//
//  Created by 公安信息 on 16/8/16.
//  Copyright © 2016年 zhangyanxiao. All rights reserved.
//

#import "ZYXButtonView.h"
#import "Masonry.h"
#import "UIView+ZYXExtension.h"

@interface ZYXButtonView ()
@property(nonatomic, strong) NSArray *titleArray;
@property(nonatomic, strong) NSMutableArray *buttonArray;
@property(nonatomic, strong) UIButton *selectedButton;
@property(nonatomic, strong) UIView *lineView;

@end

@implementation ZYXButtonView


-(NSMutableArray *)buttonArray{
    
    if (_buttonArray == nil) {
        _buttonArray = [NSMutableArray array];
    }
    
    return _buttonArray;
    
}

//初始化
- (instancetype)initWithTitleArray:(NSArray *)titleArray
{
    self = [super init];
    if (self) {
        self.titleArray = titleArray;
        [self p_setupViews];
    }
    return self;
}

// 添加子视图
- (void)p_setupViews{
    for (int i = 0; i < self.titleArray.count; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 1000+i;
        [self.buttonArray addObject:button];
        [self addSubview:button];
    }
    UIView *lineView = [[UIView alloc]init];
    [self addSubview:lineView];
    self.lineView = lineView;
}

// 设置子视图的size
- (void)layoutSubviews{
    [super layoutSubviews];
    __weak typeof(self) weakSelf = self;
    if (self.lineColor) {
        self.lineView.backgroundColor = self.lineColor;
    }
    
    CGFloat buttonWidth = self.width_extension/weakSelf.titleArray.count;
    [self.buttonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton * button = obj;

        [weakSelf setButtonAttribute:button];
        
        [button mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_equalTo(buttonWidth);
            make.centerY.equalTo(weakSelf.mas_centerY);
            make.left.equalTo(weakSelf.mas_left).offset(idx * buttonWidth);
            
            
        }];
        
        
    }];
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(1.5);
        make.bottom.equalTo(weakSelf.mas_bottom);
        if (self.button_Width) {
            make.width.mas_equalTo(self.button_Width).priorityMedium(100); ////优先级中等    
            
            
        }else{
            make.width.mas_equalTo(buttonWidth);
            
        }
        
        
        if (self.selectedButton) {
            make.centerX.equalTo(self.selectedButton);
            
        }
        
        
        
    }];

    
    
}

//设置buton的属性
-(void)setButtonAttribute:(UIButton *)button{
    NSInteger index = button.tag - 1000;
    
    if (self.normalTitleColor) {
        [button setTitleColor:self.normalTitleColor forState:(UIControlStateNormal)];
        
    }
    
    if (self.selectedTitleColor) {
        [button setTitleColor:self.selectedTitleColor forState:(UIControlStateSelected)];
    }

    if ([self.titleArray[index] isKindOfClass:[NSString class]]) {
        [button setTitle:self.titleArray[index] forState:(UIControlStateNormal)];
    }

    
    if (self.fontsize) {
        
        [button.titleLabel setFont:[UIFont systemFontOfSize:self.fontsize]];
    }
    
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];

    
    
}

-(void)setButtonClicked:(NSInteger)index{
    
    
    UIButton *button = [self viewWithTag:index+1000];
    [self buttonClicked:button];
    
    
}
//  给视图上的button实现点击事件
/*
 * 进行selectedButton的切换，通过index和self.indexBlock代码块，切换完毕刷新页面
 */
-(void)buttonClicked:(UIButton *)button{
    
    if (self.selectedButton != button) {
        
        self.selectedButton.selected = NO;
        button.selected = !button.selected;
        self.selectedButton = button;
        
        //        CGFloat buttonWidth = self.width_extension/self.titleArray.count;
        NSInteger index = self.selectedButton.tag - 1000;
        NSLog(@"index%d",index);
        if (self.indexBlock) {
            
            self.indexBlock(index);
            
        }
        
        //设置需要刷新
        [UIView animateWithDuration:0.5 animations:^{
            
            [self setNeedsLayout];
            
        }];
        
        
        
    }
    
}



@end
