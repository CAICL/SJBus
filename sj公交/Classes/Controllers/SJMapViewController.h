//
//  SJMapViewController.h
//  sj公交
//
//  Created by 蔡春雷 on 15/12/12.
//  Copyright © 2015年 ccl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJSegmentList.h"
#import "SJSingleBusLine.h"

@interface SJMapViewController : UIViewController

@property (nonatomic,strong) Result *map_result;

@property (nonatomic,strong) SJResult *map_SJResult;
@end
