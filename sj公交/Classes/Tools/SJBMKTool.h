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

@interface SJBMPTool : NSObject
singleton_interface(SJBMPTool)

/// 返回一个百度定位对象(BMKLocationService *) 并启动定位功能
+ (BMKLocationService *)shareBmkLocationService;
@end
