//
//  SJWeatherViewController.m
//  四季公交
//
//  Created by tarena on 15/12/12.
//  Copyright © 2015年 tarena. All rights reserved.
//
#import "SJWeatherViewController.h"
#import "SJWeather.h"
#import "AFNetworking.h"
#import"UIImageView+WebCache.h"
#import "SJBMKTool.h"
#import "MBProgressHUD.h"

@interface SJWeatherViewController ()
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *journeyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *conditionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *hiloLabel;
@property (weak, nonatomic) IBOutlet UIView *showVeiw;
@property (nonatomic ,strong) NSString *cityName;
@property (nonatomic ,strong) CLGeocoder *geocoder;
@property (nonatomic ,strong) CLLocation *userLocation;

@end

@implementation SJWeatherViewController

-(instancetype)init{
    if (self = [super init]) {
        self.tabBarItem.image = [UIImage imageNamed:@"select－weather"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"unselect－weather-s"];
        self.tabBarItem.title = @"天气";
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%@", [SJBMKTool sharedSJBMKTool].userCity);
    self.cityName = [SJBMKTool sharedSJBMKTool].userCity;
    [self.geocoder geocodeAddressString:self.cityName completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (!error) {
            CLPlacemark *placemark = [placemarks firstObject];
            self.userLocation = placemark.location;
            NSLog(@"地表位置:%f ;%f",placemark.location.coordinate.latitude,placemark.location.coordinate.longitude);
            
        }
        else
            NSLog(@"error=%@",error.userInfo);
    }];
    NSLog(@"%@",self.userLocation);
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    //加载提示
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self getJSONFromServer];
    });
    
    
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}



#pragma mark --- 获取JSON数据
- (void)getJSONFromServer
{
    NSURL *url = nil;
    if (self.userLocation) {
        NSString *urlStr = [NSString stringWithFormat:@"http://api.worldweatheronline.com/free/v2/weather.ashx?q=%g,%g&num_of_days=7&format=json&tp=3&key=3903aa60b7fee335a01df1f1d470d",self.userLocation.coordinate.latitude,self.userLocation.coordinate.longitude];
            url = [NSURL URLWithString:urlStr];
        
        
    } else {
        url = [NSURL URLWithString:@"http://api.worldweatheronline.com/free/v2/weather.ashx?q=beijing&num_of_days=7&format=json&tp=3&key=3903aa60b7fee335a01df1f1d470d"];
    }
    NSLog(@"url%@",url);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //task
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSInteger statusCode = [(NSHTTPURLResponse*)response statusCode];
        if (statusCode == 200) {
            //NSData ==>  JSON  ==> OC对象
            
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            //JSON数据解析(模型类)
            [self parseAndUpdataWeatherView:jsonDic];
            
            //回到主线程刷新
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.showVeiw readableContentGuide];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        }
        
        
    }];
    [task resume];
    
}
#pragma mark --- JSON数据解析(模型类)
- (void) parseAndUpdataWeatherView:(NSDictionary *)jsonDic
{
    SJWeather *weather = [SJWeather weatherWithViewDic:jsonDic];
    if (self.cityName == nil) {
        self.cityName = @"北京";
        
    }
    self.cityLabel.text = self.cityName;
    self.conditionsLabel.text = weather.weatherDesc;
    NSRange rangeRun = [self.conditionsLabel.text rangeOfString:[NSString stringWithFormat:@"%@",@"Running"]];
    NSRange rangeSnow = [self.conditionsLabel.text rangeOfString:[NSString stringWithFormat:@"%@",@"Snowing"]];
    NSRange rangeHaze = [self.conditionsLabel.text rangeOfString:[NSString stringWithFormat:@"%@",@"Mist"]];
    if (rangeRun.length > 0) {
        self.journeyLabel.text = @"今日有雨，出行记得带伞。";
    }
    if (rangeSnow.length > 0) {
        self.journeyLabel.text = @"今日有雪，出行记得带伞。";
    }
    if (rangeHaze.length > 0) {
        self.journeyLabel.text = @"今天有雾霾，出行记得戴口罩。";
    }
    else {
        self.journeyLabel.text = @"天气不错，适合出行。";
    }
    
    self.temperatureLabel.text = weather.currentTemp;
    self.hiloLabel.text = [NSString stringWithFormat:@"%@˚/%@˚",weather.minTemp,weather.maxTemp];
    //    NSData *imageData = [NSData dataWithContentsOfURL:weather.iconURL];
    //    UIImage *image = [UIImage imageWithData:imageData];
    //    self.iconView.image = image;
    [self.iconView sd_setImageWithURL:weather.iconURL placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
}




- (CLGeocoder *)geocoder {
    if(_geocoder == nil) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

@end
