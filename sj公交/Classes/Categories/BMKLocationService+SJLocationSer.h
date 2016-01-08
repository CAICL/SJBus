//
//  BMKLocationService+SJLocationSer.h
//  sj公交
//
//  Created by 6666666666666666 on 15/12/13.
//  Copyright © 2015年 ccl. All rights reserved.
//

#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "Singleton.h"

@interface BMKLocationService (SJLocationSer)


/// 返回一个百度定位对象(BMKLocationService *) 并启动定位功能
+ (BMKLocationService *) bmkLocationService;
@end
