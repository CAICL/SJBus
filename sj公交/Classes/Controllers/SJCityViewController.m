//
//  SJCityViewController.m
//  SJ公交
//
//  Created by tarena on 15/12/12.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "SJCityViewController.h"
#import "SJCityGroup.h"
#import "SJDataTool.h"
#import "SJBMKTool.h"

@interface SJCityViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSArray *cityGroupsArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SJCityViewController
-(NSArray *)cityGroupsArray{
    _cityGroupsArray = [SJDataTool cityGroups];
    return _cityGroupsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.navigationItem.title = @"城市列表";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(goToMainVC)];
    
}
//返回
-(void)goToMainVC{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --- tableView协议

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.cityGroupsArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return 10;
    SJCityGroup *cityGroup = self.cityGroupsArray[section];
    return cityGroup.cities.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    SJCityGroup *cityGroup = self.cityGroupsArray[indexPath.section];
    cell.textLabel.text = cityGroup.cities[indexPath.row];
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    SJCityGroup *cityGroup = self.cityGroupsArray[section];
    return cityGroup.title;
}
//设置tableView的右边索引
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return [self.cityGroupsArray valueForKeyPath:@"title"];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SJCityGroup *cityGroup = self.cityGroupsArray[indexPath.section];
    NSString *cityName = cityGroup.cities[indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cityChange" object:self userInfo:@{@"SelectedCityName":cityName}];
    [SJBMKTool sharedSJBMKTool].userCity = cityName;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
