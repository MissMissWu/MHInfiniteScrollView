//
//  MHInfiniteScrollView.h
//  MHInfiniteScrollViewExample
//
//  Created by apple on 16/6/21.
//  Copyright © 2016年 Mike_He. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MHInfiniteScrollView;

@protocol MHInfiniteScrollViewDelegate <NSObject>

@optional

/** 点击图片回调 */
- (void)infiniteScrollView:(MHInfiniteScrollView *)infiniteScrollView didSelectItemAtIndex:(NSInteger)index;

/** 图片滚动回调 */
- (void)infiniteScrollView:(MHInfiniteScrollView *)infiniteScrollView didScrollToIndex:(NSInteger)index;

@end


@interface MHInfiniteScrollView : UIView

/** 图片数组 */
@property (strong , nonatomic) NSArray *images;

/** pageControl */
@property (nonatomic , weak , readonly) UIPageControl *pageControl;

/** 滚动方向 默认是 NO 水平方向滚动 */
@property (assign , nonatomic, getter=isScrollDirectionPortrait) BOOL scrollDirectionPortrait;

/** 是否需要无限循环滚动 */
@property (nonatomic , assign , getter = isInfiniteLoop) BOOL infiniteLoop;

/** 是否需要自动滚动 */
@property (nonatomic , assign , getter = isAutoScroll) BOOL autoScroll;


/** 代理 */
@property (nonatomic , weak) id <MHInfiniteScrollViewDelegate> delegate;

/** block方式监听点击 */
@property (nonatomic, copy) void (^clickItemOperationBlock)(NSInteger currentIndex);

/** block方式监听滚动 */
@property (nonatomic, copy) void (^itemDidScrollOperationBlock)(NSInteger currentIndex);

/**
 *  开始自动滚动 建议在控制器 viewWillAppear 中调用
 */
- (void)startAutoScroll;

/**
 *  停止自动滚动 建议在控制器 viewWillDisAppear 中调用
 */
- (void) stopAutoScroll;
@end
