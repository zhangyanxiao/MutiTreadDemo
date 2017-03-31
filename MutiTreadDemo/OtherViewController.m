//
//  OtherViewController.m
//  MutiTreadDemo
//
//  Created by 公安信息 on 17/3/30.
//  Copyright © 2017年 张艳晓. All rights reserved.
//

#import "OtherViewController.h"
#import "OtherDetailViewController.h"

static NSString * tableViewCell = @"tableViewCell";

@interface OtherViewController ()
@property (nonatomic, strong) NSMutableArray * dataArray;
@end

@implementation OtherViewController
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
    self.dataArray = @[@[@"[self performSelector:@selector(run) withObject:nil afterDelay:2.0];",@"dispatch_after(时间，次数，线程，任务)"],@[@"普通方法",@"dispatch_group_t group = dispatch_group_create();//创建队列组",@"dispatch_group_async(group, global_quque, 任务block）向任务组异步添加任务",@"dispatch_group_notify(group,main_queue, 任务block）等前面的异步操作都执行完毕后，回到主线程"],@[@"dispatch_barrier_sync",@"dispatch_barrier_async"],@[@"dispatch_once单例",@"dispatch_apply循环执行多次"]].mutableCopy;
    
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray * array = self.dataArray[section];
    return array.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:tableViewCell forIndexPath:indexPath];
    cell.textLabel.text = self.dataArray[indexPath.section][indexPath.row];
    cell.textLabel.textColor = [UIColor blueColor];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    return cell;
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0,10, self.view.bounds.size.width, 30)];
    label.backgroundColor = [UIColor yellowColor];
    if (section == 0) {
        label.text = @"延时执行";
    }else if (section == 1){
        label.text = @"队列组-从网络上下载两张图片，把两张图片合并成一张最终显示在view上。";
        label.numberOfLines = 0;
    }else if (section == 2){
        label.text = @"阻塞操作";
    }else{
        label.text = @"其余";
    }
    return label;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OtherDetailViewController * detailVC = [[OtherDetailViewController alloc] init];
    detailVC.indexPath = indexPath;
    [self.navigationController pushViewController:detailVC animated:YES];
    
    
    
    
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
