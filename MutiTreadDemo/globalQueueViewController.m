//
//  globalQueueViewController.m
//  MutiTreadDemo
//
//  Created by 公安信息 on 17/3/29.
//  Copyright © 2017年 张艳晓. All rights reserved.
//

#import "globalQueueViewController.h"
#import "globalTaskViewController.h"

static NSString * tableViewCell = @"tableViewCell";
@interface globalQueueViewController ()

@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation globalQueueViewController
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.view.backgroundColor = [UIColor blueColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:tableViewCell];
    self.dataArray = @[@"主队列",@"全局队列",@"串行队列",@"并发队列"].mutableCopy;
    
        UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0,100, self.view.bounds.size.width, 80)];
    //    headView.backgroundColor = [UIColor lightGrayColor];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10,0, self.view.bounds.size.width-20, 80)];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentLeft;
        label.text = @"有1，2，3，4共4个任务添加到以下队列中，以同步或异步的方式";
        [headView addSubview:label];
        self.tableView.tableHeaderView = headView;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:tableViewCell forIndexPath:indexPath];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0,10, self.view.bounds.size.width, 30)];
    label.backgroundColor = [UIColor yellowColor];
    if (section == 0) {
        label.text = @"同步dispatch_sync";
    }else if (section == 1){
        label.text = @"异步dispatch_async";
    }
    return label;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    globalTaskViewController * taskVC = [[globalTaskViewController alloc] init];
    taskVC.indexPath = indexPath;
    [self.navigationController pushViewController:taskVC animated:YES];
    
    
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
