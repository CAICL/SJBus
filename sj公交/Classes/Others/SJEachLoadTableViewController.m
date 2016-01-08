//
//  SJEachLoadTableViewController.m
//  四季公交
//
//  Created by tarena on 15/12/14.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "SJEachLoadTableViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD+KR.h"
#import "SJEachLoadTableViewCell.h"
#import "SJDetailViewController.h"
#import "SJRouteDBTool.h"
#import "PreserveRecodeLineDB.h"
#import "SJMainViewController.h"
#import "SJRouteViewController.h"

@interface SJEachLoadTableViewController ()
@property (nonatomic ,strong) UITextField *textField;

@property (nonatomic ,strong) NSArray *busArray;

@end

@implementation SJEachLoadTableViewController

static NSString *identifier = @"Cell";
- (NSArray *)busArray {
    if(_busArray == nil) {
        _busArray = [[NSArray alloc] init];
    }
    return _busArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationItem.title = @"公交";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(clickCancelButton)];
    //小菊花
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 解析json
        [self getJSONFromServer];
    });
    
    // 注册单元格
    [self.tableView registerNib:[UINib nibWithNibName:@"SJEachLoadTableViewCell" bundle:nil]
         forCellReuseIdentifier:identifier];
    
    //去掉多余的cell
    self.tableView.tableFooterView = [UIView new];
    //行高
    self.tableView.rowHeight = 60;
    
    
}

#pragma mark - LeftBarButtonActionClick
- (void) clickCancelButton
{
    //    NSArray *array = self.navigationController.viewControllers;
    //   [self.navigationController popToViewController:[array objectAtIndex:0] animated:YES];
    
    if (self.pushNum == YES) {
        SJMainViewController *main = self.navigationController.viewControllers[0];
        [self.navigationController popToViewController:main animated:YES];
    }
    else
    {
        SJRouteViewController *route = self.navigationController.viewControllers[1];
        [self.navigationController popToViewController:route animated:YES];
    }
    
    
}

#pragma mark - 解析JSON数据
- (void) getJSONFromServer
{
    
    //  如果没有城市初始值, 默认为北京
    if (self.cityName == nil) {
        self.cityName = @"北京";
    }
    NSCharacterSet *character = [NSCharacterSet URLQueryAllowedCharacterSet];
    self.cityName = [self.cityName stringByAddingPercentEncodingWithAllowedCharacters:character];
    self.roadStr = [self.roadStr stringByAddingPercentEncodingWithAllowedCharacters:character];
    
    NSString *urlStr  = [NSString stringWithFormat:@"http://op.juhe.cn/189/bus/busline?key=b7a54c46d9c654d00a9b241c23639524&city=%@&%%20bus=%@",self.cityName,self.roadStr];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        SJSingleBusLine *sj =  [SJSingleBusLine parse:responseObject];
        if (sj.result == nil) {
            [self.navigationController popViewControllerAnimated:YES];
            [MBProgressHUD showError:@"车次有误!"];
        }
        self.busArray = sj.result;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [MBProgressHUD hideHUDForView:self.view];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error.userInfo);
    }];
    
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.busArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SJEachLoadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    SJResult *sj_result = self.busArray[indexPath.row];
    
    cell.key_name.text = sj_result.key_name;
    cell.front_name.text = sj_result.front_name;
    cell.terminal_name.text = sj_result.terminal_name;
    NSRange range = [cell.key_name.text rangeOfString:[NSString stringWithFormat:@"%@",@"地铁"]];
    if (range.length > 0) {
        cell.imageView.image = [UIImage imageNamed:@"6f061d950a7b020876861f4a62d9f2d3562cc8c9.jpg"];
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"icon_on_the_way_car"];
    }
    
    //    //设置背景颜色
    //    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    //设置不让点中
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //设置字体颜色
    cell.textLabel.textColor = [UIColor whiteColor];
    //隐藏每行的分隔线
    self.tableView.separatorColor = [UIColor colorWithWhite:0.5 alpha:0.2];
    //设置Page属性
    self.tableView.pagingEnabled = YES;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   //跳到detail界面
    SJDetailViewController *detialStation = [SJDetailViewController new];
    SJResult *sj_result = self.busArray[indexPath.row];
    
    detialStation.sj_result = sj_result;
    [self.navigationController pushViewController:detialStation animated:YES];
    //将选中的路线保存到数据库中
    PreserveRecodeLineDB *db = [[PreserveRecodeLineDB alloc]init];
    NSArray *array = [db selecteDataWithisRouteLine:YES];
    if (array.count == 0) {
        [db insertDataWithRouteNum:sj_result.key_name endStation:sj_result.terminal_name startName:nil endName:nil changeBusURL:nil isRouteLine:YES];
        return ;
    }
    for (SJRouteDBTool *tool in array) {
        if ([sj_result.key_name isEqualToString:tool.routeNum]  && [sj_result.terminal_name isEqualToString:tool.endStation] ) {
            return ;
        }
    }
    [db insertDataWithRouteNum:sj_result.key_name endStation:sj_result.terminal_name startName:nil endName:nil changeBusURL:nil isRouteLine:YES];
    
    
}

@end
