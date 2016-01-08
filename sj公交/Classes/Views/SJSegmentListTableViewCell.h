//
//  SJSegmentListTableViewCell.h
//  SJ公交
//
//  Created by tarena on 15/12/18.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJSegmentListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *startStation;

@property (weak, nonatomic) IBOutlet UILabel *busName;

@property (weak, nonatomic) IBOutlet UILabel *endStation;
@end
