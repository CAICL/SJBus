//
//  SJsingleBusLine.m
//  sj公交
//
//  Created by 蔡春雷 on 15/12/20.
//  Copyright © 2015年 ccl. All rights reserved.
//

#import "SJsingleBusLine.h"

@implementation SJsingleBusLine
+ (id)parse:(NSDictionary *)responseObj {
    id model = [self new];
    [responseObj enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:@"result"]) {
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dic in obj) {
                [arr addObject:[Result parse:dic]];
            }
            obj = [arr copy];
        }
        
        [model setValue:obj forKey:key];
    }];
    return model;
}

// 防止向不存在的可以赋值 崩溃
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}
// 防止把nil赋值给key 崩溃
- (void)setNilValueForKey:(NSString *)key{}
@end


@implementation Result

+ (id)parse:(NSDictionary *)responseObj {
    id model = [self new];
    [responseObj enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:@"description"]) {
            key = @"desc";
        }
        if ([key isEqualToString:@"auto"]) {
            key = @"auto_Result";
        }
        if ([key isEqualToString:@"stationdes"]) {
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dic in obj) {
                [arr addObject:[Stationdes parse:dic]];
            }
            obj = [arr copy];
        }
        [model setValue:obj forKey:key];
    }];
    return model;
}
// 防止向不存在的可以赋值 崩溃
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}
// 防止把nil赋值给key 崩溃
- (void)setNilValueForKey:(NSString *)key{}
@end


@implementation Stationdes
+ (id)parse:(NSDictionary *)responseObj {
    id model = [self new];
    //    [responseObj enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
    //
    //        [model setValue:obj forKey:key];
    //    }];
    [model setValuesForKeysWithDictionary:responseObj];
    return model;
}
// 防止向不存在的可以赋值 崩溃
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}
// 防止把nil赋值给key 崩溃
- (void)setNilValueForKey:(NSString *)key{}

@end

