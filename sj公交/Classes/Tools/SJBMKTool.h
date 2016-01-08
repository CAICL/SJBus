//
//  SJBMPTool.h
//  sj公交
//
//  Created by 6666666666666666 on 15/12/13.
//  Copyright © 2015年 ccl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件


@interface SJBMKTool : NSObject
singleton_interface(SJBMKTool)


/// 获取用户当前的城市
@property (nonatomic,copy) NSString *userCity;

/// 路径搜索起始站点信息
@property (nonatomic, strong) BMKPoiInfo *startStationInfo;
/// 路径搜索结束站点信息
@property (nonatomic, strong) BMKPoiInfo *endStationInfo;

@end
