//
//  SJMainViewController.m
//  SJ公交
//
//  Created by tarena on 15/12/12.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "SJMainViewController.h"
#import "SJCityViewController.h"

@interface SJMainViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *startPointTextFeild;
@property (weak, nonatomic) IBOutlet UITextField *endPointTextFeild;

//滚动视图
@property (nonatomic, strong) UIScrollView *scrollerView;
@property(nonatomic,strong)UIPageControl *pageControl;
@property (nonatomic, strong) UIButton *titleButton;
@end

@implementation SJMainViewController
-(instancetype)init{
    if (self = [super init]) {
        self.tabBarItem.image = [UIImage imageNamed:@"123"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"123"];
        self.tabBarItem.title = @"搜索";
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //导航按钮
    UIButton *titleButton = [[UIButton alloc]init];
    self.titleButton = titleButton;
//    NSString *str = [NSString stringWithFormat:@"公交[%@]",@"北京市"];
    [titleButton setTitle:@"公交" forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    titleButton.frame = CGRectMake(0, 0, 200, 40);
    [titleButton addTarget:self action:@selector(chooseCity) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleButton;
    //搜索
    UIImageView *startImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"123"]];
    startImageView.contentMode = UIViewContentModeCenter;
    startImageView.frame = CGRectMake(0, 0, 30, 20);
    self.startPointTextFeild.leftViewMode = UITextFieldViewModeAlways;
    self.startPointTextFeild.leftView =startImageView;
    
    UIImageView *endImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"123"]];
    endImageView.contentMode = UIViewContentModeCenter;
    endImageView.frame = CGRectMake(0, 0, 30, 20);
    self.endPointTextFeild.leftViewMode = UITextFieldViewModeAlways;
    self.endPointTextFeild.leftView = endImageView;
    //设置滚动视图
    [self setUpScrollView];
    [self setUpPageController];
    //监听通知
    [self listenNotifications];
    
}
-(void)listenNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityChange:) name:@"cityChange" object:nil];
}
-(void)cityChange:(NSNotification *)notification{
    NSLog(@"%s",__func__);
    NSString *cityName = notification.userInfo[@"SelectedCityName"];
    [self.titleButton setTitle:cityName forState:UIControlStateNormal];
    
}
-(void)setUpScrollView{
    self.scrollerView = [[UIScrollView alloc]init];
    self.scrollerView.delegate = self;
    self.scrollerView.frame = CGRectMake(0, 20, self.view.bounds.size.width, 160);
    for (int i = 0; i < 4 ; i++) {
        NSString *imageName = [NSString stringWithFormat:@"%d",i+1];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = CGRectMake(self.view.bounds.size.width * i, 44, self.view.bounds.size.width, self.view.bounds.size.height);
        [self.scrollerView addSubview:imageView];
    }
    self.scrollerView.contentSize = CGSizeMake(4*self.view.bounds.size.width, self.scrollerView.bounds.size.height);
    self.scrollerView.pagingEnabled = YES;
    self.scrollerView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollerView];
}
-(void)setUpPageController{
    self.pageControl = [[UIPageControl alloc]init];
    float y = self.scrollerView.bounds.origin.y + self.scrollerView.bounds.size.height;
    self.pageControl.frame = CGRectMake(0, y - 10, self.scrollerView.bounds.size.width, 20);
    self.pageControl.numberOfPages = 4;
    self.pageControl.pageIndicatorTintColor = [UIColor blackColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    self.pageControl.userInteractionEnabled = NO;
    [self.view addSubview:self.pageControl];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int index = round(scrollView.contentOffset.x/self.scrollerView.bounds.size.width);
    self.pageControl.currentPage = index;
}

//选择城市
-(void)chooseCity{
    SJCityViewController *cityVC = [[SJCityViewController alloc]init];
    
    [self.navigationController pushViewController:cityVC animated:YES];
    
}

@end
