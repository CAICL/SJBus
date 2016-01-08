//
//  SJDetailViewController.m
//  四季公交
//
//  Created by tarena on 15/12/16.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "SJDetailViewController.h"
#import "SJStationTableViewCell.h"
#import "SJMapViewController.h"
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


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationItem.title = self.sj_result.key_name;
    [self.tableVeiw registerNib:[UINib nibWithNibName:@"SJStationTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
    [self setHeaderView];
    self.tableVeiw.dataSource = self;
    self.tableVeiw.delegate = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"地图" style:0 target:self action:@selector(gotoMapController)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    
}




-(void)gotoMapController{
    SJMapViewController *mapVC = [[SJMapViewController alloc]init];
    
    mapVC.map_SJResult = self.sj_result;
    [self.navigationController pushViewController:mapVC animated:YES];
}
#pragma mark --- 设置headerView
- (void) setHeaderView
{
    self.front_name.text = self.sj_result.front_name;
    self.terminal_name.text = self.sj_result.terminal_name;
    NSString *str1 = self.sj_result.start_time;
    NSString *str2 = [str1 substringToIndex:2];
    NSString *str3 = [str1 substringFromIndex:2];
    self.startTime.text = [NSString stringWithFormat:@"%@:%@",str2,str3];
    NSString *str4 = self.sj_result.end_time;
    NSString *str5 = [str4 substringToIndex:2];
    NSString *str6 = [str4 substringFromIndex:2];
    self.endTime.text = [NSString stringWithFormat:@"%@:%@",str5,str6];
    
}

#pragma mark --- UITableViewController

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sj_result.stationdes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SJStationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    SJStationdes *sj_stationdes = self.sj_result.stationdes[indexPath.row];
    
    cell.name.text = sj_stationdes.name;
    cell.stationNum.text = sj_stationdes.stationNum;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.userInteractionEnabled = NO;
    
    //设置不让点中
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //设置字体颜色
    cell.textLabel.textColor = [UIColor whiteColor];
    //隐藏每行的分隔线
    self.tableVeiw.separatorColor = [UIColor colorWithWhite:0.5 alpha:0.2];
    
    
    return cell;
}


@end
