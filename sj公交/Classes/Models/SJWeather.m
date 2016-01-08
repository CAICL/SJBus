//
//  SJWeather.m
//  四季公交
//
//  Created by tarena on 15/12/12.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "SJWeather.h"

@implementation SJWeather
+ (id)weatherWithViewDic:(NSDictionary *)jsonDic
{
    return [[self alloc]initWithJsonDic:jsonDic];
}
- (id)initWithJsonDic:(NSDictionary *)jsonDic
{
    self = [super init];
    if (self) {
        self.cityName = jsonDic[@"data"][@"request"][0][@"query"];
        //  NSLog(@"cityName = %@",self.cityName);
        NSString *iconStr = jsonDic[@"data"][@"current_condition"][0][@"weatherIconUrl"][0][@"value"];
        self.iconURL = [NSURL URLWithString:iconStr];
        // NSLog(@"iconURL = %@",self.iconURL);
        self.currentTemp = [NSString stringWithFormat:@"%@˚",jsonDic[@"data"][@"current_condition"][0][@"temp_C"]];
        // NSLog(@"current = %@",self.currentTemp);
        self.weatherDesc = jsonDic[@"data"][@"current_condition"][0][@"weatherDesc"][0][@"value"];
        // NSLog(@"weatherDesc = %@",self.weatherDesc);
        self.minTemp = jsonDic[@"data"][@"weather"][0][@"mintempC"];
        // NSLog(@"min = %@",self.minTemp);
        self.maxTemp = jsonDic[@"data"][@"weather"][0][@"maxtempC"];
        // NSLog(@"max = %@",self.maxTemp);
    }
    return self;
}

@end
