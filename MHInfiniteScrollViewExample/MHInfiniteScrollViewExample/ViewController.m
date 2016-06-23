//
//  ViewController.m
//  MHInfiniteScrollViewExample
//
//  Created by apple on 16/6/21.
//  Copyright © 2016年 Mike_He. All rights reserved.
//

#import "ViewController.h"

#import "MHInfiniteScrollView.h"

#import "MHInfiniteController.h"

@interface ViewController ()<MHInfiniteScrollViewDelegate>
/** 滚动视图 */
@property (nonatomic , weak) MHInfiniteScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *intruduceLabel;
@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 控制器即将显示的时候 开启滚动 提高性能
    [self.scrollView startAutoScroll];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 控制器即将消失的时候 停止滚动 提高性能
    [self.scrollView stopAutoScroll];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"MHInfiniteController";

    
    MHInfiniteScrollView *scrollView = [[MHInfiniteScrollView alloc] init];
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
    
    
    
    
    //介绍
    self.intruduceLabel.text = @"特性:    该控件是基于UIScrollView，利用三个UIImageView实现的无限循环滚动。\n\n作者:   CoderMikeHe(https://github.com/CoderMikeHe) \n\n不足:   图片数量必须 >=3 才好使。";
    
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
- (IBAction)buttonClicked:(UIButton *)sender
{
    MHInfiniteController *infinite = [[MHInfiniteController alloc] init];
    [self.navigationController pushViewController:infinite animated:YES];
}


@end
