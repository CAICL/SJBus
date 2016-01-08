//
//  SJMainViewController.m
//  SJ公交
//
//  Created by tarena on 15/12/12.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "SJMainViewController.h"
#import "SJCityViewController.h"
#import "SJDataTool.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import "BMKLocationService+SJLocationSer.h"
#import "SJBMKTool.h"
#import <AFNetworking.h>
#import "SJEachLoadTableViewController.h"
#import "SJSegmentListTableVC.h"
#import "Masonry.h"
#import "MBProgressHUD+KR.h"
#import "SJSearchStationViewController.h"
#import "SJRouteViewController.h"
#import "SJSegmentViewController.h"


@interface SJMainViewController ()<UIScrollViewDelegate,BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *loadTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewTopLayout;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewInScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *textView;
@property (weak, nonatomic) IBOutlet UIButton *startStationBtn;
@property (weak, nonatomic) IBOutlet UIButton *endStationBtn;
@property (weak, nonatomic) IBOutlet UIButton *goButton;

////滚动视图
@property (nonatomic, strong) UIScrollView *scrollerView;
@property(nonatomic,strong)UIPageControl *pageControl;
@property (nonatomic, strong) UIButton *titleButton;

@property (nonatomic, strong) BMKLocationService *bmkLocationService;
@property (nonatomic, strong) BMKGeoCodeSearch *geoCodeSearch;
@property (nonatomic, strong) BMKReverseGeoCodeOption *reverseGeoOption;
@property (nonatomic ,strong) NSString *str;
/// afn 网络连接判断
@property (nonatomic, strong) AFNetworkReachabilityManager *afn_Reachability_Manager;

@end

@implementation SJMainViewController
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.tabBarItem.image = [UIImage imageNamed:@"select_search"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"unselect_search"];
        self.tabBarItem.title = @"搜索";
        [SJBMKTool sharedSJBMKTool].userCity = @"北京";
    }
    return self;
}


#pragma mark - IBAction

/// 公交线路历史记录
- (IBAction)searchBus:(id)sender {

    SJRouteViewController *route = [SJRouteViewController new];
    [self.navigationController pushViewController:route animated:YES];
    
}
/// 
- (IBAction)changeBus:(id)sender {
    
    SJSegmentViewController *segment = [SJSegmentViewController new];
    [self.navigationController pushViewController:segment animated:YES];
    
}

- (IBAction)clickSeachBus:(id)sender {
    if (self.afn_Reachability_Manager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        [MBProgressHUD showError:@"当前没有网络连接"];
        return;
    }
    
    
    if (self.loadTextField.text.length ) {
        SJEachLoadTableViewController *eachRoadVC = [[SJEachLoadTableViewController alloc]init];
        eachRoadVC.roadStr = self.loadTextField.text;
        eachRoadVC.cityName = self.str;
        eachRoadVC.pushNum = YES;
        [self.navigationController pushViewController:eachRoadVC animated:YES];
        
    }
    else
    {
        [MBProgressHUD showError:@"请输入您要搜的车次。"];
        
    }
    
}
- (IBAction)startStationClick:(UIButton *)sender {
    
    if (self.afn_Reachability_Manager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        [MBProgressHUD showError:@"当前没有网络连接"];
        return;
    }
    
    
    SJSearchStationViewController *searchVC = [SJSearchStationViewController new];
    searchVC.isStartStation = YES;
    [self presentViewController:searchVC animated:YES completion:nil];
}
- (IBAction)endStationClick:(UIButton *)sender {
    
    if (self.afn_Reachability_Manager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        [MBProgressHUD showError:@"当前没有网络连接"];
        return;
    }
    
    SJSearchStationViewController *searchVC = [SJSearchStationViewController new];
    
    searchVC.isStartStation = NO;
    [self presentViewController:searchVC animated:YES completion:nil];
}


- (IBAction)startToEndPlaceBtnClock:(id)sender {
    
    if (self.afn_Reachability_Manager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        [MBProgressHUD showError:@"当前没有网络连接"];
        return;
    }
    
    SJSegmentListTableVC *segmentLineTVC = [[SJSegmentListTableVC alloc]init];
//    segmentLineTVC.label1 = self.startPointTextFeild.text;
//    segmentLineTVC.lable2 = self.endPointTextFeild.text;
   // 推出
     segmentLineTVC.pushNum = YES;
    [self.navigationController pushViewController:segmentLineTVC animated:YES];
}
- (IBAction)changeStartAndEndBtnTitle:(id)sender {
    NSString *startStr = self.startStationBtn.titleLabel.text;
// 换button的title
    [self.startStationBtn setTitle:self.endStationBtn.titleLabel.text forState:UIControlStateNormal];
    [self.endStationBtn setTitle:startStr forState:UIControlStateNormal];
// 换单例类的属性值
    BMKPoiInfo *info = [SJBMKTool sharedSJBMKTool].startStationInfo;
    [SJBMKTool sharedSJBMKTool].startStationInfo = [SJBMKTool sharedSJBMKTool].endStationInfo;
    [SJBMKTool sharedSJBMKTool].endStationInfo = info;
    
}

#pragma mark --- BMKGeoCodeSearchDelegate
/// 反地理编码
/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    if (self.reverseGeoOption) {
        for (BMKPoiInfo *info in result.poiList) {

            NSLog(@"_______%f------%f", info.pt.latitude, info.pt.longitude);
        }
    }
    
    NSLog(@"------%@", result.addressDetail.city);

    [SJBMKTool sharedSJBMKTool].userCity = result.addressDetail.city;
    for (BMKPoiInfo *info in result.poiList) {
        NSLog(@"_+_+_+_%@", info.name);
    }

    [self.bmkLocationService stopUserLocationService];

    
}

#pragma mark --- BMKLocationServiceDelegate

/**
 *用户位置更新后，会调用此函数
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    NSLog(@"aaaaa:%f,%f", _bmkLocationService.userLocation.location.coordinate.latitude, _bmkLocationService.userLocation.location.coordinate.longitude);
   
    BMKReverseGeoCodeOption *reverseGeoCodeOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeoCodeOption.reverseGeoPoint = _bmkLocationService.userLocation.location.coordinate;

    if(! [_geoCodeSearch reverseGeoCode:reverseGeoCodeOption]) {
        NSLog(@"反地理编码失败");
    }
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error {
    [SJBMKTool sharedSJBMKTool].userCity = @"北京";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:98.0/255 green:158.0/255 blue:245.0/255 alpha:1];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    _bmkLocationService.delegate = self;
    _geoCodeSearch.delegate = self;  //此处记得不用时候需要置nil, 否则影响内存的释放.
  
    [self keyboardNotification];
    
// 路线搜索按钮 显示站点名
    if ([SJBMKTool sharedSJBMKTool].startStationInfo.name != nil) {
        [self.startStationBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.startStationBtn setTitle:[SJBMKTool sharedSJBMKTool].startStationInfo.name forState:UIControlStateNormal];
    }
    if ([SJBMKTool sharedSJBMKTool].endStationInfo.name != nil) {
        [self.endStationBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
         [self.endStationBtn setTitle:[SJBMKTool sharedSJBMKTool].endStationInfo.name forState:UIControlStateNormal];
    }
   
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _bmkLocationService.delegate = nil;
    _geoCodeSearch.delegate = nil;  // 不用时, 置nil;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // 处理shortCutItem 通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoTestVc:) name:@"gotoVc" object:nil];
    
    
    self.bmkLocationService = [BMKLocationService bmkLocationService];
    self.geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    
    
    //导航按钮
    UIButton *titleButton = [[UIButton alloc]init];
    self.titleButton = titleButton;
    
    [titleButton setTitle:@"四季公交[北京]" forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [titleButton setFont:[UIFont systemFontOfSize:14]];
    titleButton.frame = CGRectMake(0, 0, 200, 40);
    [titleButton addTarget:self action:@selector(chooseCity) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleButton;


    //设置滚动视图
    [self setUpScrollView];
   // [self setUpPageController];
    //监听通知
    [self listenNotifications];
}

#pragma mark --- 边框设置
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
-(void)cityChange:(NSNotification *)notification{
    NSLog(@"%s",__func__);
    self.str = notification.userInfo[@"SelectedCityName"];
    NSString *cityName = [NSString stringWithFormat:@"四季公交[%@]",self.str];
    [self.titleButton setTitle:cityName forState:UIControlStateNormal];
    
}
#pragma mark - ==== 监听通知 ====
//监听通知
-(void)listenNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityChange:) name:@"cityChange" object:nil];
}

// 监听键盘
- (void)keyboardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardWillShow:(NSNotification *)noti {
    CGRect keyboardFrame = [noti.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    NSTimeInterval durations = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = [noti.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    // 如果屏幕高 - textView的 y - textview 的 高  < 键盘高的时候,
    CGFloat text_bottom = self.view.bounds.size.height -  self.textView.frame.origin.y - self.textView.frame.size.height;
    CGFloat keyboard_h = keyboardFrame.size.height;
    if (text_bottom < keyboard_h) {
        self.textViewTopLayout.constant -= keyboard_h - text_bottom;
    }
    
    [UIView animateWithDuration:durations delay:0 options:options animations:^{
        [self.view layoutIfNeeded];
        
    } completion:nil];
// 当textView 随键盘联动时, 将其放在view的最上层.
    [self.view bringSubviewToFront:self.textView];
}
- (void)keyboardWillHide:(NSNotification *)noti {
    
    NSTimeInterval durations = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = [noti.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    self.textViewTopLayout.constant = 10;
    
    [UIView animateWithDuration:durations delay:0 options:options animations:^{
        [self.view layoutIfNeeded];
        
    } completion:nil];
}
#pragma mark - ==== 设置ScrollView ====
- (void)setUpScrollView {
    
    self.scrollView.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.scrollView.contentSize = CGSizeMake(4*[UIScreen mainScreen].bounds.size.width , 0);
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    for (int i = 0; i < 4 ; i++) {
        NSString *imageName = [NSString stringWithFormat:@"img_0%d",i+1];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
        //  |-5-[imageView]-5|  ;    V:|-5-[imageView]-5|  边界空5个点
        imageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width * i ,
                                     0,
                                     [UIScreen mainScreen].bounds.size.width ,
                                     self.scrollView.bounds.size.height);
        
        [self.scrollView addSubview:imageView];
    }
}



-(void)setUpPageController{
    self.pageControl = [[UIPageControl alloc]init];
    float y = self.scrollerView.bounds.origin.y + self.scrollerView.bounds.size.height;
    self.pageControl.frame = CGRectMake(0, y - 10, self.scrollerView.bounds.size.width, 20);
    self.pageControl.numberOfPages = 4;
    self.pageControl.pageIndicatorTintColor = [UIColor blackColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    self.pageControl.userInteractionEnabled = NO;
    [self.view addSubview:self.pageControl];
    
}

// 实现UIScrollView 的滚动方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 如何计算当前滚动到第几页
    // 1.获取滚动的X方向的偏移值
    CGFloat offseX = scrollView.contentOffset.x;
    // 用已经偏移的值加上半个页面的宽度
    offseX = offseX + scrollView.frame.size.width * 0.5;
    
    // 2.滚动的X方向的偏移值除以一张图片的宽度（每页的宽度），取商就是当前的页第几页
    int page = offseX / scrollView.frame.size.width;
    
    // 3.将页数设置给UIPageControl
    self.pageControl.currentPage = page;
    
}

//选择城市
-(void)chooseCity{
    SJCityViewController *cityVC = [[SJCityViewController alloc]init];
    
    [self.navigationController pushViewController:cityVC animated:YES];
    
}

#pragma mark - ==== 3D touch ====
- (void)gotoTestVc:(NSNotification *)noti {
    NSString *type = noti.userInfo[@"type"];
    UIViewController *testVc;
    if ([type isEqualToString:@"1"]) {
        testVc = [[SJRouteViewController alloc] initWithNibName:@"SJRouteViewController" bundle:nil];
    } else if ([type isEqualToString:@"2"]) {
        testVc = [[SJSegmentViewController alloc] initWithNibName:@"SJSegmentViewController" bundle:nil];
    }
    [self.navigationController pushViewController:testVc animated:YES];
}

#pragma mark - ==== lazy loading ====
- (AFNetworkReachabilityManager *)afn_Reachability_Manager {
    if(_afn_Reachability_Manager == nil) {
        _afn_Reachability_Manager = [AFNetworkReachabilityManager sharedManager];
    }
    return _afn_Reachability_Manager;
}

@end
