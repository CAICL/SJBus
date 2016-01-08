//
//  SJDetailViewController.m
//  四季公交
//
//  Created by tarena on 15/12/16.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "SJDetailViewController.h"
#import "SJStationTableViewCell.h"

@interface SJDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UINavigationBar *headNavigationVIew;
@property (weak, nonatomic) IBOutlet UIView *headerVeiw;
@property (weak, nonatomic) IBOutlet UILabel *front_name;
@property (weak, nonatomic) IBOutlet UILabel *terminal_name;
@property (weak, nonatomic) IBOutlet UILabel *startTime;

@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet UITableView *tableVeiw;
@property (nonatomic ,strong) NSMutableArray *coordinate;

@end
static NSString *identifier = @"Cell1";

@implementation SJDetailViewController

- (NSArray *)stationArray {
    if(_stationArray == nil) {
        _stationArray = [self.eachRoadBus.notationArray copy];
    }
    return _stationArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableVeiw registerNib:[UINib nibWithNibName:@"SJStationTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
    [self setHeaderView];
    self.tableVeiw.dataSource = self;
    self.tableVeiw.delegate = self;
    for (NSDictionary *dic in self.stationArray) {
        [self.coordinate addObject:dic[@"xy"]];
        NSLog(@"xy1 = %@",dic[@"xy"]);
    }
    NSLog(@"xy=%@",self.coordinate);
    
}

#pragma mark --- 设置headerView
- (void) setHeaderView
{
    self.front_name.text = self.eachRoadBus.front_name;
    self.terminal_name.text = self.eachRoadBus.terminal_name;
    self.startTime.text = self.eachRoadBus.start_time;
    self.endTime.text = self.eachRoadBus.end_time;
}

#pragma mark --- UITableViewController

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.eachRoadBus.busStationNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SJStationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    NSDictionary *dic = self.stationArray[indexPath.row];
    cell.name.text = dic[@"name"];
    cell.stationNum.text = dic[@"stationNum"];
  
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.userInteractionEnabled = NO;
    
    //设置不让点中
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //设置字体颜色
    cell.textLabel.textColor = [UIColor whiteColor];
    //隐藏每行的分隔线
    self.tableVeiw.separatorColor = [UIColor colorWithWhite:0.5 alpha:0.2];
    //设置Page属性
    self.tableVeiw.pagingEnabled = YES;
    
    
    return cell;
}




@end
