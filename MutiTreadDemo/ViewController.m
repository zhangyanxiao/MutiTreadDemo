//
//  ViewController.m
//  MutiTreadDemo
//
//  Created by 公安信息 on 17/3/29.
//  Copyright © 2017年 张艳晓. All rights reserved.
//

#import "ViewController.h"
#import "ZYXButtonView.h"
#import "mainQueueViewController.h"
#import "globalQueueViewController.h"
#import "OtherViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UITableViewController * showViewController;
@property (nonatomic, strong) UIView * contentView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor yellowColor];
//    self.title = @"哈哈";
    [self setChildrenControllers];
    
    [self p_setupSubViews];
    
    [self p_setupTitle];

}
- (void)p_setupTitle{
    UIView * titleView = [[UIView alloc] init];
    titleView.frame = CGRectMake(10, 0, self.view.bounds.size.width - 20, 26);
    self.navigationItem.titleView = titleView;
    NSArray * array = @[@"当前在主线程",@"当前在子线程",@"GCD常用操作"];
    ZYXButtonView * buttonView = [[ZYXButtonView alloc] initWithTitleArray:array];
    buttonView.selectedTitleColor = [UIColor orangeColor];
    buttonView.normalTitleColor = [UIColor blackColor];
    buttonView.fontsize = 16;
    buttonView.lineColor = [UIColor orangeColor];
    buttonView.frame = titleView.bounds;
    [titleView addSubview:buttonView];
    buttonView.indexBlock = ^(NSInteger index){
        
        [self.showViewController.view removeFromSuperview];
        
        UITableViewController *showVC = self.childViewControllers[index];
        self.showViewController = showVC;
        showVC.view.frame = self.contentView.bounds;
        [self.contentView addSubview:self.showViewController.view];

        
    };
    [buttonView setButtonClicked:0];
    
}

-(void)setChildrenControllers{
    
    mainQueueViewController * mainVC = [[mainQueueViewController alloc] init];
    
    [self addChildViewController:mainVC];
    
    
    globalQueueViewController * gloalVC = [[globalQueueViewController alloc] init];
    [self addChildViewController:gloalVC];

    
    OtherViewController * otherVC = [[OtherViewController alloc] init];
   
    [self addChildViewController:otherVC];
    
    
}

-(void)p_setupSubViews{
    
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = [UIColor redColor];
    contentView.frame = self.view.bounds;
    [self.view addSubview:contentView];
    self.contentView = contentView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
