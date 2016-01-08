//
//  SJSegmentList.m
//  SJ公交
//
//  Created by tarena on 15/12/17.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "SJSegmentList.h"

@implementation SJSegmentList

+(id)parse:(NSDictionary *)responseObj{
    id model = [self new];
    [responseObj enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:@"result"]) {
            NSMutableArray *result = [NSMutableArray array];
            for (NSDictionary *dic in obj) {
                [result addObject:[Result parse:dic]];
            }
            obj = [result copy];
        }
        [model setValue:obj forKey:key];
    }];
    return model;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

- (void)setNilValueForKey:(NSString *)key{}


@end



@implementation Result

+(id)parse:(NSDictionary *)responseObj{
    id model = [self new];
    [responseObj enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:@"segmentList"]) {
            NSMutableArray *segmentList = [NSMutableArray array];
            for (NSDictionary *dic in obj) {
                [segmentList addObject:[Segmentlist parse:dic]];
            }
            obj = [segmentList copy];
        }
        [model setValue:obj forKey:key];
    }];
    
    return model;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

- (void)setNilValueForKey:(NSString *)key{}

@end



@implementation Segmentlist

+(id)parse:(NSDictionary *)responseObj{
    id model = [self new];
    [model setValuesForKeysWithDictionary:responseObj];
    return model;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

- (void)setNilValueForKey:(NSString *)key{}
@end


