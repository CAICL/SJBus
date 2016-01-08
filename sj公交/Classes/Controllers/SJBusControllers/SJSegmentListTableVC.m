//
//  SJSegmentListTableVC.m
//  SJ公交
//
//  Created by tarena on 15/12/15.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "SJSegmentListTableVC.h"
#import "SJSegmentList.h"
#import "AFNetworking.h"
#import "SJSegmentListTableVC.h"
#import "SJSegmentListTableViewCell.h"
#import "SJSegmentList.h"
#import "SJStationTableViewController.h"

@interface SJSegmentListTableVC ()
//路线方案
@property (nonatomic, strong)NSArray *SegentListArray;

@end
static NSString *identifier = @"cell";
@implementation SJSegmentListTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //发送请求
    [self getJSONFormServer];
    [self.tableView registerNib:[UINib nibWithNibName:@"SJSegmentListTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
    //去除cell分割线
    self.tableView.separatorStyle = NO;
    
}
//发送网络请求
-(void)getJSONFormServer{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *string = @"http://op.juhe.cn/189/bus/transfer.php?key=b7a54c46d9c654d00a9b241c23639524&city=010&xys=116.4604213,39.9204703;116.2883602,39.8236433";
    
    [manager GET:string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //解析所有线路方式
        SJSegmentList *segmentList = [SJSegmentList parse:responseObject];
        self.SegentListArray = segmentList.result;
        //回主线程更新
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
    
}


#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.SegentListArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Result * result =self.SegentListArray[section];
    return result.segmentList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SJSegmentListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    Result *result = self.SegentListArray[indexPath.section];
    Segmentlist *segmentlist = result.segmentList[indexPath.row];
    cell.startStation.text = segmentlist.startName;
    cell.busName.text = segmentlist.busName;
    cell.endStation.text = segmentlist.endName;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSString *str = [NSString stringWithFormat:@"方案%ld",(long)section+1];
    return str;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section>=0) {
        SJStationTableViewController *station = [[SJStationTableViewController alloc] init];
        [self.navigationController pushViewController:station animated:YES];
    }
    
}
@end
