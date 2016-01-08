//
//  SJWeather.h
//  四季公交
//
//  Created by tarena on 15/12/12.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SJWeather : NSObject
//城市名字
@property (nonatomic ,strong) NSString *cityName;
//天气图标URL
@property (nonatomic ,strong) NSURL *iconURL;
//天气情况描述
@property (nonatomic ,strong) NSString *weatherDesc;
//当前天气温度
@property (nonatomic ,strong) NSString *currentTemp;
//最高温
@property (nonatomic ,strong) NSString *minTemp;
//最低文
@property (nonatomic ,strong) NSString *maxTemp;
//提供接口(给定参数，返回一个已经解析好的模型对象)
+(id) weatherWithViewDic:(NSDictionary *)jsonDic;
@end
