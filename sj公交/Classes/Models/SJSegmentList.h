//
//  SJSegmentList.h
//  SJ公交
//
//  Created by tarena on 15/12/17.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Result,Segmentlist;
@interface SJSegmentList : NSObject

@property (nonatomic, strong) NSArray<Result *> *result;

@property (nonatomic, assign) NSInteger error_code;

@property (nonatomic, copy) NSString *reason;

+(id)parse:(NSDictionary *)responseObj;

@end
@interface Result : NSObject

@property (nonatomic, copy) NSString *footEndLength;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *bounds;

@property (nonatomic, strong) NSArray<Segmentlist *> *segmentList;

+(id)parse:(NSDictionary *)responseObj;

@end

@interface Segmentlist : NSObject

@property (nonatomic, copy) NSString *busName;

@property (nonatomic, copy) NSString *passDepotName;

@property (nonatomic, copy) NSString *startName;

@property (nonatomic, copy) NSString *coordinateList;

@property (nonatomic, copy) NSString *endName;

@property (nonatomic, copy) NSString *driverLength;

@property (nonatomic, copy) NSString *passDepotCount;

@property (nonatomic, copy) NSString *footCoordinateList;

@property (nonatomic, copy) NSString *footLength;

@property (nonatomic, copy) NSString *passDepotCoordinate;

+(id)parse:(NSDictionary *)responseObj;

@end

