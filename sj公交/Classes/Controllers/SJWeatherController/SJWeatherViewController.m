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
        self.tabBarItem.image = [UIImage imageNamed:@"123"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"123"];
        self.tabBarItem.title = @"天气";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [self getJSONFromServer];
    
}

#pragma mark --- 获取JSON数据
- (void)getJSONFromServer
{
    NSURL *url = nil;
    if (self.userLocation) {
        NSString *urlStr = [NSString stringWithFormat:@"http://api.worldweatheronline.com/free/v2/weather.ashx?q=%g,%g&num_of_days=7&format=json&tp=3&key=3903aa60b7fee335a01df1f1d470d",self.userLocation.coordinate.latitude,self.userLocation.coordinate.longitude];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            NSLog(@"请求成功:%@",responseObject);
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            NSLog(@"请求失败:%@",error.userInfo);
        }];
        NSLog(@"cityName = %@",self.cityName);
        self.geocoder = [CLGeocoder new];
        [self.geocoder reverseGeocodeLocation:self.userLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (!error) {
                CLPlacemark *placemark = [placemarks firstObject];
                self.cityName = placemark.locality;
            }
        }];
        url = [NSURL URLWithString:urlStr];
        
        
    } else {
        url = [NSURL URLWithString:@"http://api.worldweatheronline.com/free/v2/weather.ashx?q=beijing&num_of_days=7&format=json&tp=3&key=3903aa60b7fee335a01df1f1d470d"];
    }
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
        self.cityLabel.text = weather.cityName;
        
    }
    self.conditionsLabel.text = weather.weatherDesc;
    NSRange rangeRun = [self.conditionsLabel.text rangeOfString:[NSString stringWithFormat:@"%@",@"Running"]];
    NSRange rangeSnow = [self.conditionsLabel.text rangeOfString:[NSString stringWithFormat:@"%@",@"Snowing"]];
    if (rangeRun.length > 0) {
       self.journeyLabel.text = @"今日有雨，出行记得带伞。";
    }
    if (rangeSnow.length > 0) {
        self.journeyLabel.text = @"今日有雪，出行记得带伞。";
    } else {
        self.journeyLabel.text = @"天气不错，适合出行。";
    }
    
    self.temperatureLabel.text = weather.currentTemp;
    self.hiloLabel.text = [NSString stringWithFormat:@"%@˚/%@˚",weather.minTemp,weather.maxTemp];
//    NSData *imageData = [NSData dataWithContentsOfURL:weather.iconURL];
//    UIImage *image = [UIImage imageWithData:imageData];
//    self.iconView.image = image;
    [self.iconView sd_setImageWithURL:weather.iconURL placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
}




@end
