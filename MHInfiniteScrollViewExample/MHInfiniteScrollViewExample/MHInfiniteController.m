//
//  MHInfiniteController.m
//  MHInfiniteScrollViewExample
//
//  Created by apple on 16/6/22.
//  Copyright © 2016年 Mike_He. All rights reserved.
//

#import "MHInfiniteController.h"
#import "MHInfiniteScrollView.h"
@interface MHInfiniteController ()<MHInfiniteScrollViewDelegate>
/** 滚动视图 */
@property (nonatomic , weak) MHInfiniteScrollView *scrollView;
@end

@implementation MHInfiniteController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.scrollView startAutoScroll];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.scrollView stopAutoScroll];
}
- (void) dealloc
{
    NSLog(@"-- MHInfiniteController dealloc --");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"无限循环";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    MHInfiniteScrollView *scrollView = [[MHInfiniteScrollView alloc] init];
    scrollView.backgroundColor = [UIColor redColor];
    scrollView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-60, 130);
    scrollView.center = self.view.center;
    //设置数据源
    scrollView.images = @[
                          [UIImage imageNamed:@"img_00"],
                          [UIImage imageNamed:@"img_01"],
                          [UIImage imageNamed:@"img_02"],
                          [UIImage imageNamed:@"img_03"],
                          [UIImage imageNamed:@"img_04"],
                          [UIImage imageNamed:@"img_00"],
                          [UIImage imageNamed:@"img_01"],
                          [UIImage imageNamed:@"img_02"],
                          [UIImage imageNamed:@"img_03"],
                          [UIImage imageNamed:@"img_04"]
                          ];
    //循环滚动
    scrollView.infiniteLoop = YES;
    
    //垂直方向滚动
    scrollView.scrollDirectionPortrait = NO;
    
    //不自动滚动
    scrollView.autoScroll = YES;
    
    //当前选择页的指示器颜色
    scrollView.pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    
    //未选中页的指示器颜色
    scrollView.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    
    //设置代理
    scrollView.delegate = self;
    
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - MHInfiniteScrollViewDelegate
- (void) infiniteScrollView:(MHInfiniteScrollView *)infiniteScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"点中---------%zd",index);
}
/*
 // 滚动调用
 - (void)infiniteScrollView:(MHInfiniteScrollView *)infiniteScrollView didScrollToIndex:(NSInteger)index
 {
 NSLog(@"滚动---------%zd",index);
 }
 */

@end
