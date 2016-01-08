//
//  SJSearchStationViewController.m
//  sj公交
//
//  Created by 6666666666666666 on 15/12/24.
//  Copyright © 2015年 ccl. All rights reserved.
//

#import "SJSearchStationViewController.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import "SJBMKTool.h"

@interface SJSearchStationViewController ()<UITableViewDataSource, UITableViewDelegate,BMKPoiSearchDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *allStationArr;
@property (nonatomic, strong) NSMutableArray *searchStationArrM;
@property (nonatomic, strong) BMKPoiSearch *poiSearch;

@end

@implementation SJSearchStationViewController
- (IBAction)backBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)searchStationClick:(id)sender {
    [self.textField resignFirstResponder];
    //创建BMKPoiSearchOption对象
    BMKCitySearchOption *option = [BMKCitySearchOption new];
    //设置属性(pageIndex; pageCapacity; city; keyword)
    option.city = [SJBMKTool sharedSJBMKTool].userCity;
    option.keyword = [NSString stringWithFormat:@"公交车站 %@", self.textField.text];
    option.pageIndex = 0;
    option.pageCapacity = 100;
    //发送请求
    BOOL isSuccess = [self.poiSearch poiSearchInCity:option];
    if (isSuccess) {
        NSLog(@"检索成功");
    }
}
#pragma mark - ==== BMKPoiSearchDelegate ====
/**
 *返回POI搜索结果
 *@param searcher 搜索对象
 *@param poiResult 搜索结果列表
 *@param errorCode 错误号，@see BMKSearchErrorCode
 onGetPoiResult
 */
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode{
   
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        //从poiResult中获取服务器返回的数据
        
        for (BMKPoiInfo *info in poiResult.poiInfoList) {
#warning TODO: info.name.length判断有待修改
            if ([info.name rangeOfString:self.textField.text].location != NSNotFound ) {
                [self.searchStationArrM addObject:info];
            }
        }
        self.allStationArr = self.searchStationArrM;
        [self.tableView reloadData];

    }
}
#pragma mark - ==== 生命周期 ====
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.poiSearch.delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.poiSearch.delegate = nil;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    //去掉多余的cell
    self.tableView.tableFooterView = [UIView new];
    
    // 配置 textfield
    UIImageView *startImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_icon1"]];
    startImageView.contentMode = UIViewContentModeScaleAspectFit;
    startImageView.frame = CGRectMake(0, 0, 10, 10);
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.leftView =startImageView;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - ==== tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return self.allStationArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = @"";
    cell.detailTextLabel.text = @"";
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }

    BMKPoiInfo *info = self.allStationArr[indexPath.row];
    cell.textLabel.text = info.name;
    
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    
    cell.detailTextLabel.text = info.address;
    NSLog(@"%@:   %@",info.name, info.address);
  //  cell.detailTextLabel.text = poiInfo.address;
    //设置不让点中
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.tableFooterView = [UIView new];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     BMKPoiInfo *info = self.allStationArr[indexPath.row];
//    NSLog(@"站点经纬度: (%f, %f)", poiInfo.pt.latitude, poiInfo.pt.longitude);
//    NSLog(@"站点: %@", poiInfo.address);
    if (self.isStartStation == YES) {
        [SJBMKTool sharedSJBMKTool].startStationInfo = info;
    }else{
        [SJBMKTool sharedSJBMKTool].endStationInfo = info;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ==== lazy loading ====

- (NSArray *)allStationArr {
	if(_allStationArr == nil) {
		_allStationArr = [[NSArray alloc] init];
	}
	return _allStationArr;
}

- (BMKPoiSearch *)poiSearch {
	if(_poiSearch == nil) {
		_poiSearch = [[BMKPoiSearch alloc] init];
	}
	return _poiSearch;
}

- (NSMutableArray *)searchStationArrM {
	if(_searchStationArrM == nil) {
		_searchStationArrM = [[NSMutableArray alloc] init];
	}
	return _searchStationArrM;
}

@end
