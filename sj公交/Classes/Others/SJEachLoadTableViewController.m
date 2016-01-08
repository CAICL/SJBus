//
//  SJEachLoadTableViewController.m
//  四季公交
//
//  Created by tarena on 15/12/14.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "SJEachLoadTableViewController.h"
#import "Masonry.h"
#import "AFNetworking.h"
#import "SJEachRoadBus.h"
#import "SJEachLoadTableViewCell.h"
#import "SJDetailViewController.h"

@interface SJEachLoadTableViewController ()
@property (nonatomic ,strong) UITextField *textField;
@property (nonatomic ,strong) NSString *cityName;
@property (nonatomic ,strong) SJEachRoadBus *eachRoadBus;
@property (nonatomic ,strong) NSArray *busArray;
@property (nonatomic ,assign) NSInteger busArrayCound;
@property (nonatomic ,strong) NSArray *roadLineArray;
@property (nonatomic ,strong) NSMutableArray *roadLineMutableArray;

//@property (nonatomic ,strong) UITableView *tableView;
@end

@implementation SJEachLoadTableViewController
static NSString *identifier = @"Cell";
- (NSArray *)busArray {
    if(_busArray == nil) {
        _busArray = [[NSArray alloc] init];
    }
    return _busArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"公交";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(clickCancelButton)];
    [self getJSONFromServer];
    [self.tableView registerNib:[UINib nibWithNibName:@"SJEachLoadTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
    
   //去掉多余的cell
   self.tableView.tableFooterView = [UIView new];
    //行高
    self.tableView.rowHeight = 60;
    
}
- (void) clickCancelButton
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

#pragma mark --- 解析JSON数据
- (void) getJSONFromServer
{
    NSString *urlStr = nil;
        if (self.cityName) {
//             urlStr = [NSString stringWithFormat:@"http://op.juhe.cn/189/bus/busline?key=b7a54c46d9c654d00a9b241c23639524&city=%@&%%20bus=%@",self.cityName,self.textField.text];
//            NSCharacterSet *character = [NSCharacterSet URLQueryAllowedCharacterSet];
//            urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:character];
            
        }
        else{
            self.cityName = @"北京";
            
            
        }
    NSCharacterSet *character = [NSCharacterSet URLQueryAllowedCharacterSet];
    self.cityName = [self.cityName stringByAddingPercentEncodingWithAllowedCharacters:character];
    self.roadStr = [self.roadStr stringByAddingPercentEncodingWithAllowedCharacters:character];
    
    urlStr = [NSString stringWithFormat:@"http://op.juhe.cn/189/bus/busline?key=b7a54c46d9c654d00a9b241c23639524&city=%@&%%20bus=%@",self.cityName,self.roadStr];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager new];
    
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        self.busArray = [self parseAndUpdataEachRoadView:responseObject isBusArray:YES ];
      //  self.roadLineArray = [self parseAndUpdataEachRoadView:responseObject isBusArray:NO];
      //  self.busArrayCound = self.busArray.count;
        NSLog(@"busArray = %@",self.busArray[0]);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"QLJerror:%@",error.userInfo);
    }];
    
}
#pragma mark --- JSON数据解析（模型类）
- (NSArray *)parseAndUpdataEachRoadView:(NSDictionary *)responseObject isBusArray:(BOOL)isBusArray
{
    NSArray *busarray = responseObject[@"result"];
    NSArray *roadLinearray = nil;
      for (NSDictionary *busDic in busarray) {
        roadLinearray = busDic[@"stationdes"];
        [self.roadLineMutableArray addObject:roadLinearray];
      
        
    }
    
    
    
     NSMutableArray *busMutableArray = [NSMutableArray array];
   // NSMutableArray *roadLineMutableArrau = [NSMutableArray array];
    if (isBusArray) {
       
        for (NSDictionary *busDic in busarray) {
            self.eachRoadBus = [SJEachRoadBus eachRoadBusWithDic:busDic];
            [busMutableArray addObject:self.eachRoadBus];
        }
    }

    return [busMutableArray copy];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

  
    NSLog(@"%ld",self.busArray.count);
    return self.busArray.count;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SJEachLoadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    SJEachRoadBus *eachRoadBus = self.busArray[indexPath.row];
//    NSLog(@"keyname = %@",eachRoadBus.key_name);
//    NSLog(@"cell = %@",cell.key_name);
    cell.key_name.text = eachRoadBus.key_name;
    cell.front_name.text = eachRoadBus.front_name;
    cell.terminal_name.text = eachRoadBus.terminal_name;
    
   
    NSRange range = [cell.key_name.text rangeOfString:[NSString stringWithFormat:@"%@",@"地铁"]];
    if (range.length > 0) {
        cell.imageView.image = [UIImage imageNamed:@"6f061d950a7b020876861f4a62d9f2d3562cc8c9.jpg"];
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"icon_on_the_way_car"];
    }
    
    
//    //设置背景颜色
//    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    //设置不让点中
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //设置字体颜色
    cell.textLabel.textColor = [UIColor whiteColor];
    //隐藏每行的分隔线
    self.tableView.separatorColor = [UIColor colorWithWhite:0.5 alpha:0.2];
    //设置Page属性
    self.tableView.pagingEnabled = YES;

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SJDetailViewController *detialStation = [SJDetailViewController new];
    SJEachRoadBus *eachRoadBus = self.busArray[indexPath.row];
    
    detialStation.eachRoadBus = eachRoadBus;
    detialStation.stationArray = [self.roadLineMutableArray[indexPath.row] copy];
    
    [self.navigationController pushViewController:detialStation animated:YES];
    
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/







- (NSArray *)roadLineArray {
	if(_roadLineArray == nil) {
		_roadLineArray = [[NSArray alloc] init];
	}
	return _roadLineArray;
}

- (NSMutableArray *)roadLineMutableArray {
	if(_roadLineMutableArray == nil) {
		_roadLineMutableArray = [[NSMutableArray alloc] init];
	}
	return _roadLineMutableArray;
}



@end
