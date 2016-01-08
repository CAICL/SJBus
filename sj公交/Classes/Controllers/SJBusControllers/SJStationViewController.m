//
//  SJStationViewController.m
//  sj公交
//
//  Created by tarena on 15/12/18.
//  Copyright © 2015年 ccl. All rights reserved.
//

#import "SJStationViewController.h"
#import "SJMapViewController.h"
#import "SJStationTableViewCell.h"


@interface SJStationViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SJStationViewController
static NSString *identifier = @"Cell1";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.tableView registerNib:[UINib nibWithNibName:@"SJStationTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"地图" style:0 target:self action:@selector(gotoMapController)];
    
}
-(void)gotoMapController{
    SJMapViewController *mapVC = [[SJMapViewController alloc]init];
    
    mapVC.map_result = self.result;
    [self.navigationController pushViewController:mapVC animated:YES];
}
#pragma mark - UITableViewDataSource & UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.result.segmentList.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"sssssss%lu",(unsigned long)self.result.segmentList.count);
    Segmentlist *segm = self.result.segmentList[section];
    
    return [segm.passDepotCount integerValue] +2;     // +2 -----> 加 某路车 上车站 和下沉站
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SJStationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1"];
    Segmentlist *segm = self.result.segmentList[indexPath.section];
    NSArray *stationArr = [segm.passDepotName componentsSeparatedByString:@" "];
    NSMutableArray *arrM = [NSMutableArray array];
    [arrM addObject:segm.startName];
    [arrM addObjectsFromArray:stationArr];
    [arrM addObject:segm.endName];
    NSLog(@"-----%@----", stationArr);
    
    cell.stationNum.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    cell.name.text = arrM[indexPath.row];
    //设置不让点中
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //设置字体颜色
    cell.textLabel.textColor = [UIColor whiteColor];
    //隐藏每行的分隔线
    self.tableView.separatorColor = [UIColor colorWithWhite:0.5 alpha:0.2];
    
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    Segmentlist *segm = self.result.segmentList[section];
    return segm.busName;
}

@end
