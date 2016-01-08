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
#import "SJStationViewController.h"
#import "SJBMKTool.h"
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD+KR.h"
#import "PreserveRecodeLineDB.h"
#import "SJRouteDBTool.h"
#import "SJMainViewController.h"
#import "SJSegmentViewController.h"

@interface SJSegmentListTableVC ()
//路线方案
@property (nonatomic, strong)NSArray *SegentListArray;

@property (nonatomic, strong)NSString *cityName;
@property (nonatomic, strong) CLGeocoder *geocoder;

@property (nonatomic, assign) CLLocationCoordinate2D startPoint1;     //起始站 经纬度
@property (nonatomic, assign) CLLocationCoordinate2D endPoint1;  //终点站 经纬度

@end
static NSString *identifier = @"cell";
@implementation SJSegmentListTableVC
- (CLGeocoder *)geocoder {
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    //小菊花
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self geocoder1];
    });
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SJSegmentListTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
    //去除cell分割线
    self.tableView.separatorStyle = NO;
    self.label1 = [SJBMKTool sharedSJBMKTool].startStationInfo.name;
    self.lable2 = [SJBMKTool sharedSJBMKTool].endStationInfo.name;                  
    
}
-(void)geocoder1{
    self.cityName = [SJBMKTool sharedSJBMKTool].userCity;
    NSLog(@"开始地理编码");
    NSLog(@"city%@",self.cityName);
    [self.geocoder geocodeAddressString:[NSString stringWithFormat:@"%@%@",self.cityName,self.label1] completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (!error) {
            CLPlacemark *placemark = [placemarks firstObject];
            self.startPoint1 = placemark.location.coordinate;
            [self.geocoder geocodeAddressString:[NSString stringWithFormat:@"%@%@",self.cityName,self.lable2] completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                if (!error) {
                    CLPlacemark *placemark = [placemarks firstObject];
                    self.endPoint1 = placemark.location.coordinate;
                    [self getJSONFormServer];
                }
            }];
        }
    }];
}
//发送网络请求
-(void)getJSONFormServer{
    
    
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *startPoint = [NSString stringWithFormat:@"%lf,%lf",[SJBMKTool sharedSJBMKTool].startStationInfo.pt.longitude,[SJBMKTool sharedSJBMKTool].startStationInfo.pt.latitude];
    NSLog(@"---------%lf,%lf",self.startPoint1.longitude,self.startPoint1.latitude);
    NSString *endPoint = [NSString stringWithFormat:@"%lf,%lf",[SJBMKTool sharedSJBMKTool].endStationInfo.pt.longitude,[SJBMKTool sharedSJBMKTool].endStationInfo.pt.latitude];
    NSLog(@"=========%lf,%lf",self.endPoint1.longitude,self.endPoint1.latitude);
    
    NSCharacterSet *character = [NSCharacterSet URLQueryAllowedCharacterSet];
    self.cityName = [self.cityName stringByAddingPercentEncodingWithAllowedCharacters:character];
    if (self.urlStr.length == 0) {
        self.urlStr = [NSString stringWithFormat:@"http://op.juhe.cn/189/bus/transfer.php?key=b7a54c46d9c654d00a9b241c23639524&city=%@&xys=%@;%@",self.cityName,startPoint,endPoint];
    }
    
    NSLog(@"UUUUURRRRLLLL %@",self.urlStr);
    //    NSString *string = @"http://op.juhe.cn/189/bus/transfer.php?key=b7a54c46d9c654d00a9b241c23639524&city=010&xys=116.4604213,39.9204703;116.2883602,39.8236433";
    
    [manager GET:self.urlStr parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析所有线路方式
        SJSegmentList *segmentList = [SJSegmentList parse:responseObject];
        if (segmentList == nil) {
            [self showAlert];
            [self.navigationController popViewControllerAnimated:YES];
        }
        self.SegentListArray = segmentList.result;
        //回主线程更新
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求数据为空");
        return ;
    }];
    
}
//弹出警告框
-(void)showAlert{
    
    [MBProgressHUD showError:@"地址错误！"];
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
        SJStationViewController *station = [[SJStationViewController alloc] init];
        //Segmentlist *selectStation = self.SegentListArray[indexPath.section];
        Result *_result = self.SegentListArray[indexPath.section];
        station.result = _result;
        [self.navigationController pushViewController:station animated:YES];
        //将选中的线路存到数据库中
        //        PreserveRecodeLineDB *db = [PreserveRecodeLineDB new];
        //        [db insertDataWithRouteNum:nil endStation:nil startName:self.label1 endName:self.lable2 changeBusURL:self.urlStr isRouteLine:NO];
        PreserveRecodeLineDB *db = [[PreserveRecodeLineDB alloc]init];
        NSArray *array = [db selecteDataWithisRouteLine:NO];
        if (array.count == 0) {
            [db insertDataWithRouteNum:nil endStation:nil startName:self.label1 endName:self.lable2 changeBusURL:self.urlStr isRouteLine:NO];
            return ;
        }
        for (SJRouteDBTool *tool in array) {
            if ([self.urlStr isEqualToString:tool.urlStr]) {
                return ;
            }
        }
        [db insertDataWithRouteNum:nil endStation:nil startName:self.label1 endName:self.lable2 changeBusURL:self.urlStr isRouteLine:NO];
        
    }
    
}


@end
