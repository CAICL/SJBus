//
//  SJMapViewController.m
//  sj公交
//
//  Created by 蔡春雷 on 15/12/12.
//  Copyright © 2015年 ccl. All rights reserved.
//

//#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
//
//#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
//
//#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
//
//#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
//
//#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
//
//#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
//
//#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
//
//#import < BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
#import "SJMapViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import "SJDataTool.h"
#import "BMKLocationService+SJLocationSer.h"
#import "SJBMKTool.h"

@interface SJMapViewController ()<BMKMapViewDelegate, BMKLocationServiceDelegate>

@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) BMKLocationService *bmkLocationService;
@property (nonatomic, strong) BMKPointAnnotation *bmkAnnotation;
@property (nonatomic, strong) NSArray *busStationArr;         //车站
@property (nonatomic, strong) NSArray *busLineArr;            //存放要画线点的坐标
@property (nonatomic, assign) CLLocationCoordinate2D *stratPoint;
@property (nonatomic, assign) CLLocationCoordinate2D *endPoint;
/// 地图上的遮盖线
@property (nonatomic,strong) BMKPolyline *polyline;
@end

@implementation SJMapViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"地图";
        self.tabBarItem.image = [UIImage imageNamed:@"select－location-pin"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"unselect－location-pin-s"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:98.0/255 green:158.0/255 blue:245.0/255 alpha:1];
     [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
//添加 tabbar
    self.title = @"地图";
    
//初始化百度地图 设置代理
    self.mapView.delegate  = self;
//打开位置服务
    self.bmkLocationService.delegate = self;
//在地图上画线
    [self mapPathWithResult];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ====== 地图绘制路线 ======
/**
 *  通过上一个控制器传入的 Result类型 绘制路线的路径和对站点添加大头针
 */
- (void)mapPathWithResult
{
    NSArray *busLineArr = [NSArray array];
    NSArray *busStationCoordinate = [NSArray array];
    NSArray *busStationNameArr = [NSArray array];
    NSMutableArray *busStationMutableArr = [NSMutableArray array];
    NSMutableArray *busStationNameMutableArr = [NSMutableArray array];
    NSMutableArray *busStationCoordinateMutbleArr = [NSMutableArray array];

    if(self.map_SJResult == nil) {
    for (Segmentlist *map_segment in self.map_result.segmentList) {
        busLineArr = [map_segment.coordinateList componentsSeparatedByString:@";"];
        busStationCoordinate = [map_segment.passDepotCoordinate componentsSeparatedByString:@";"];
        busStationNameArr = [map_segment.passDepotName componentsSeparatedByString:@" "];
       // busStationCoordinate
// 此处根据 反地理编码的起始点和终点确定开始和终点的大头针坐标
        
        [self drawPathWithBusline:busLineArr andBusStations:busStationCoordinate andStationName:busStationNameArr];
    }
    }else {
        for (SJStationdes *station in self.map_SJResult.stationdes) {
            [busStationMutableArr addObject:station.xy];
            [busStationNameMutableArr addObject:station.name];
        }
        [self drawPathWithBusline:nil andBusStations:[busStationMutableArr mutableCopy] andStationName:[busStationNameMutableArr copy]];
        
    }
}
/**
 根据传入 路线的模型类数据:
 0. 添加起点和终点标记(不再此方法实现)
 1. 添加站点大头针
 2. 绘制经过路线
 3. 将地图缩放至路线大小
 */
- (void)drawPathWithBusline:(NSArray *)busLine andBusStations:(NSArray *)busStation andStationName:(NSArray *)stationName{
    

    for (int i = 0; i < busStation.count; i++) {
        NSString *coordinateStr = busStation[i];
        NSString *stationStr = stationName[i];
        NSArray *coordinateArr = [coordinateStr componentsSeparatedByString:@","];
        BMKPointAnnotation *point = [[BMKPointAnnotation alloc] init];

        point.coordinate = CLLocationCoordinate2DMake([coordinateArr[1] doubleValue], [coordinateArr[0] doubleValue]);
        //
        point.title = stationStr;
        [self.mapView addAnnotation:point];
    }
    
    
    // 绘制 经过的路线.
    NSInteger count = busLine.count;
    //分配空间
    BMKMapPoint *tempPoints = (BMKMapPoint *)malloc(sizeof(BMKMapPoint)*count);
    for (int i = 0; i < count; i++) {
        
        NSArray *coordinateArr = [busLine[i] componentsSeparatedByString:@","];
        BMKMapPoint point = BMKMapPointForCoordinate(CLLocationCoordinate2DMake([coordinateArr[1] doubleValue], [coordinateArr[0] doubleValue]));
        tempPoints[i] = point;
 
    }
    self.polyline = [BMKPolyline polylineWithPoints:tempPoints count:count];
    if (self.polyline) {
        [self.mapView addOverlay:self.polyline];
    }
    [self mapViewFitPloyLine:self.polyline];
    //释放内存
    free(tempPoints);
}
#pragma mark ------  显示路线全貌  ------

// 根据用户的位置点 把所有的位置都显示在地图范围内
- (void)mapViewFitPloyLine:(BMKPolyline *)polyLine {
    CGFloat ltX,ltY,maX,maY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];

    ltX = pt.x, ltY = pt.y;
    maX = pt.x, maY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint temp = polyLine.points[i];
        if (temp.x <  ltX) {
            ltX = temp.x;
        }
        if (temp.y < ltY) {
            ltY = temp.y;
        }
        if (temp.x > maX) {
            maX = temp.x;
        }
        if (temp.y > maY) {
            maY = temp.y;
        }
        BMKMapRect rect;
        rect.origin = BMKMapPointMake(ltX - 300, ltY - 300);
        rect.size = BMKMapSizeMake(maX - ltX + 500, maY - ltY + 500);
        [self.mapView setVisibleMapRect:rect];
    }
}


#pragma mark - ====== BMKLocationServiceDelegate ======
//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    //NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude)
    ;
    NSLog(@"aaaaa:%f,%f", _bmkLocationService.userLocation.location.coordinate.latitude, _bmkLocationService.userLocation.location.coordinate.longitude);
}
/**
 *在将要启动定位时，会调用此函数
 */
- (void)willStartLocatingUser{
    NSLog(@"asdfadsf");
}
#pragma mark - ====== BMKMapViewDelegate ======
//显示大头针
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        NSLog(@"%@", annotationView);
        //如果有起点 设置终点的图片 否则设置起点图片
#warning TODO 首末点大头针的图片
        NSLog(@"======%lu======", (unsigned long)self.mapView.annotations.count);
        if (self.mapView.annotations.count == 0) {
            annotationView.image = [UIImage imageNamed:@"map_up_station"];
        }else{
            annotationView.image = [UIImage imageNamed:@"map_up"];
        }
        annotationView.draggable = NO;
        annotationView.animatesDrop = YES;
        return annotationView;
    }
    return nil;
}
/**
 *当mapView新添加annotation views时，调用此接口
 *@param mapView 地图View
 *@param views 新添加的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    
}


/// 遮盖的显示
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay {
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView *polyLineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polyLineView.fillColor = [[UIColor clearColor] colorWithAlphaComponent:0.7];
        polyLineView.strokeColor = [[UIColor greenColor] colorWithAlphaComponent:0.7];
        polyLineView.lineWidth = 5.0;
        return polyLineView;
    }
    return nil;
}


/**
 *  设置 百度MapView的一些属性
 */
- (void)setMapViewProperty
{
    // 显示定位图层
    self.mapView.showsUserLocation = YES;
    // 设置定位模式
    self.mapView.userTrackingMode = BMKUserTrackingModeNone;
    // 不允许旋转地图
    self.mapView.rotateEnabled = NO;
    // 显示比例尺 和比例尺位置
    self.mapView.showMapScaleBar = YES;
    self.mapView.mapScaleBarPosition = CGPointMake(self.view.frame.size.width - 50, self.view.frame.size.height - 50);
    
    // 定位图层自定义样式参数
    BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc]init];
    displayParam.isRotateAngleValid = NO;//跟随态旋转角度是否生效
    displayParam.isAccuracyCircleShow = NO;//精度圈是否显示
    displayParam.locationViewOffsetX = 0;//定位偏移量(经度)
    displayParam.locationViewOffsetY = 0;//定位偏移量（纬度）
    
    [self.mapView updateLocationViewWithParam:displayParam];
}

#pragma mark - ====== lazy loading ======

- (BMKMapView *)mapView {
	if(_mapView == nil) {
        _mapView = [[BMKMapView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.view addSubview:_mapView];
// 设置地图的属性的私有方法
        [self setMapViewProperty];
	}
	return _mapView;
}

- (BMKLocationService *)bmkLocationService {
	if(_bmkLocationService == nil) {
		_bmkLocationService = [BMKLocationService bmkLocationService];
	}
	return _bmkLocationService;
}

- (BMKPointAnnotation *)bmkAnnotation {
	if(_bmkAnnotation == nil) {
		_bmkAnnotation = [[BMKPointAnnotation alloc] init];
	}
	return _bmkAnnotation;
}



@end
