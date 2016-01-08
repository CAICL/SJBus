//
//  SJBMPTool.m
//  sj公交
//
//  Created by 6666666666666666 on 15/12/13.
//  Copyright © 2015年 ccl. All rights reserved.
//

#import "SJBMPTool.h"

@implementation SJBMPTool
singleton_implementation(SJBMPTool)

+ (BMKLocationService *)shareBmkLocationService {

        BMKLocationService *_bmkLocationService = nil;
        //设置定位精确度，默认：kCLLocationAccuracyBest
        [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
        //指定最小距离更新(米)，默认：kCLDistanceFilterNone
        [BMKLocationService setLocationDistanceFilter:10.f];
        
        _bmkLocationService = [[BMKLocationService alloc]init];
        //启动LocationService
        [_bmkLocationService startUserLocationService];
        
        //_bmkLocationService.delegate = self;
        
        /** 使用地图时要将以下属性赋值到BMKMapView上 */
        //        //罗盘态
        //        _mapView.showsUserLocation = NO;
        //        _mapView.userTrackingMode = BMKUserTrackingModeFollow;
        //        _mapView.showsUserLocation = YES;
        

    return _bmkLocationService;
}

@end
