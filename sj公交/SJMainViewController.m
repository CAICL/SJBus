//
//  QDMainViewController.m
//  QD公交
//
//  Created by tarena on 15/12/11.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "SJMainViewController.h"

@interface SJMainViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *startPointTextFeild;
@property (weak, nonatomic) IBOutlet UITextField *endPointTextFeild;
//滚动视图
@property (nonatomic, strong) UIScrollView *scrollerView;
@property(nonatomic,strong)UIPageControl *pageControl;

@end

@implementation SJMainViewController
-(instancetype)init{
    if (self = [super init]) {
        self.title = @"公交";
        self.tabBarItem.image = [UIImage imageNamed:@"123"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"123"];
        self.tabBarItem.title = @"搜索";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
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








@end
