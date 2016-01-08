//
//  SJsingleBusLine.h
//  sj公交
//
//  Created by 蔡春雷 on 15/12/20.
//  Copyright © 2015年 ccl. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SJResult,SJStationdes;
@interface SJSingleBusLine : NSObject

@property (nonatomic, strong) NSArray<SJResult *> *result;

@property (nonatomic, assign) NSInteger error_code;

@property (nonatomic, copy) NSString *reason;
+ (id)parse:(NSDictionary *)responseObj;

@end
//_________________________________________________

@interface SJResult : NSObject

@property (nonatomic, copy) NSString *time_desc;

@property (nonatomic, copy) NSString *gpsfile_id;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *front_name;

@property (nonatomic, copy) NSString *company;

@property (nonatomic, copy) NSString *express_way;

@property (nonatomic, copy) NSString *speed;

@property (nonatomic, copy) NSString *basic_price;

@property (nonatomic, copy) NSString *terminal_spell;

@property (nonatomic, copy) NSString *paper_table_id;

@property (nonatomic, copy) NSString *terminal_name;

@property (nonatomic, copy) NSString *line_id;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *air;

@property (nonatomic, copy) NSString *photo_folder;

// auto ->auto_Result
@property (nonatomic, copy) NSString *auto_Result;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *length;

@property (nonatomic, copy) NSString *commutation_ticket;

@property (nonatomic, copy) NSString *front_spell;

@property (nonatomic, copy) NSString *key_name;

@property (nonatomic, copy) NSString *total_price;

@property (nonatomic, copy) NSString *double_deck;

@property (nonatomic, copy) NSString *loop;

@property (nonatomic, strong) NSArray<SJStationdes *> *stationdes;

@property (nonatomic, copy) NSString *start_time;

@property (nonatomic, copy) NSString *end_time;

@property (nonatomic, copy) NSString *data_source;

@property (nonatomic, copy) NSString *ic_card;
// description -> desc
@property (nonatomic, copy) NSString *desc;

+ (id)parse:(NSDictionary *)responseObj;
@end
//____________________________________________________

@interface SJStationdes : NSObject

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *stationNum;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *xy;

+ (id)parse:(NSDictionary *)responseObj;
@end

