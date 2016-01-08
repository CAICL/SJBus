//
//  SJDataTool.m
//  SJ公交
//
//  Created by tarena on 15/12/12.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "SJDataTool.h"
#import "SJCityGroup.h"

@implementation SJDataTool

static NSArray *_cityGroupArray = nil;
+(NSArray *)cityGroups{
    if (!_cityGroupArray) {
        _cityGroupArray = [[self alloc]getAndParseWithPlistFile:@"cityGroups.plist" withClass:[SJCityGroup class]];
    }
    return _cityGroupArray;
}
- (NSArray *)getAndParseWithPlistFile:(NSString *)plistFile withClass:(Class)className {
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:plistFile ofType:nil];
    NSArray *array = [NSArray arrayWithContentsOfFile:plistPath];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        id instance = [[className alloc]init];
        [instance setValuesForKeysWithDictionary:dic];
        [mutableArray addObject:instance];
    }
    return [mutableArray copy];
}
@end
