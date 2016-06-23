//
//  MHInfiniteScrollView.m
//  MHInfiniteScrollViewExample
//
//  Created by apple on 16/6/21.
//  Copyright © 2016年 Mike_He. All rights reserved.
//

#import "MHInfiniteScrollView.h"


static NSUInteger const MHMaxImageCount = 3;

@interface MHInfiniteScrollView () <UIScrollViewDelegate>

/** 滚动视图 **/
@property (nonatomic , weak) UIScrollView *scrollView;

/** 定时器(用weak比较安全 定时器会强引用对象 导致释放掉) **/
@property (weak, nonatomic) NSTimer *timer;



@end



@implementation MHInfiniteScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化控件
        [self setupSubViews];
        
        // 初始化数据
        [self setup];
    }
    return self;
}


- (void)awakeFromNib
{
    // 初始化控件
    [self setupSubViews];
    
    // 初始化数据
    [self setup];
}


//解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview)
    {
        //防止 crash 动画 要设置为NO
        [self.scrollView scrollRectToVisible:CGRectZero animated:NO];
        
        [self stopTimer];
    }
}
//解决当timer释放后 回调scrollViewDidScroll时访问野指针导致崩溃
- (void)dealloc
{
    _scrollView.delegate = nil;
    NSLog(@"-----%@ dealloc -----" , [self class]);
}

#pragma mark - 初始化子控件
- (void) setupSubViews
{
    // 滚动视图
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor greenColor];
    // 先隐藏scrollView内部自带的 水平 和 垂直 控件  不然scrollView的子控件数目不对
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    // 图片控件
    for (int i = 0; i<MHMaxImageCount; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setBackgroundColor:[UIColor purpleColor]];
        imageView.userInteractionEnabled = YES;
        [scrollView addSubview:imageView];
        
        //添加手势
        UITapGestureRecognizer *itemTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemTaped:)];
        [imageView addGestureRecognizer:itemTap];
        
    }
 
    // 页码视图
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    [self addSubview:pageControl];
    _pageControl = pageControl;
}


#pragma mark - 初始化数据
- (void)setup
{
    _autoScroll = YES;
    _infiniteLoop = YES;
}

#pragma mark - 布局子控件
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    self.scrollView.frame = self.bounds;
    if (self.isScrollDirectionPortrait) {
        self.scrollView.contentSize = CGSizeMake(0, MHMaxImageCount * self.bounds.size.height);
    } else {
        self.scrollView.contentSize = CGSizeMake(MHMaxImageCount * self.bounds.size.width, 0);
    }
    
    for (int i = 0; i<MHMaxImageCount; i++)
    {
        UIImageView *imageView = self.scrollView.subviews[i];
        
        if (self.isScrollDirectionPortrait)
        {
            imageView.frame = CGRectMake(0, i * self.scrollView.frame.size.height, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        } else {
            imageView.frame = CGRectMake(i * self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        }
    }
    
    CGFloat margin = 20;
    CGFloat pageW = self.scrollView.frame.size.width- 2*margin;
    CGFloat pageH = 20;
    CGFloat pageX = margin;
    CGFloat pageY = self.scrollView.frame.size.height - pageH;
    self.pageControl.frame = CGRectMake(pageX, pageY, pageW, pageH);
    
    
    //这里需要更新一下文本内容
    [self reloadData];
}



#pragma mark - UIScrollViewDelegate
// 滚动就会调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.images.count) return; // 解决清除timer时偶尔会出现的问题
    
    // 找出最中间的那个图片控件
    NSInteger page = 0;
    CGFloat minDistance = MAXFLOAT;
    for (int i = 0; i<self.scrollView.subviews.count; i++)
    {
        UIImageView *imageView = self.scrollView.subviews[i];
        CGFloat distance = 0;
        if (self.isScrollDirectionPortrait) {
            distance = ABS(imageView.frame.origin.y - scrollView.contentOffset.y);
        } else {
            distance = ABS(imageView.frame.origin.x - scrollView.contentOffset.x);
        }
        if (distance < minDistance) {
            minDistance = distance;
            page = imageView.tag;
        }
    }
    
    self.pageControl.currentPage = page;
}
// 开始拖拽的时候 停止掉定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.isAutoScroll) [self stopTimer];
}
// 停止拖拽的时候 开启定时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.isAutoScroll) [self startTimer];
}
// 减速停止的时候 更新内容
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (!self.images.count) return; // 解决清除timer时偶尔会出现的问题
    [self reloadData];
}

// 代码调用setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated 停止滚动动画的时候  更新内容
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (!self.images.count) return; // 解决清除timer时偶尔会出现的问题
    [self reloadData];
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(infiniteScrollView:didScrollToIndex:)]) {
        [self.delegate infiniteScrollView:self didScrollToIndex:self.pageControl.currentPage];
    }else if(self.itemDidScrollOperationBlock)
    {
        self.itemDidScrollOperationBlock(self.pageControl.currentPage);
    }
}

#pragma mark - 点击手势
- (void)itemTaped:(UIGestureRecognizer *)gr
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(infiniteScrollView:didSelectItemAtIndex:)]) {
        [self.delegate infiniteScrollView:self didSelectItemAtIndex:self.pageControl.currentPage];
    }else if(self.clickItemOperationBlock)
    {
        self.clickItemOperationBlock(self.pageControl.currentPage);
    }
}



#pragma mark - setter
- (void)setImages:(NSArray *)images
{
    _images = images;
    
    // 设置页码
    self.pageControl.numberOfPages = images.count;
    self.pageControl.currentPage = 0;
    self.pageControl.hidesForSinglePage = images.count<=1;

    // 停止定时器
    [self stopTimer];
    
    // 开始定时器
    if (self.isAutoScroll)
    {
        [self startTimer];
    }
}

- (void)setAutoScroll:(BOOL)autoScroll
{
    _autoScroll = autoScroll;
    
    [self stopTimer];
    
    if (_autoScroll) {
        [self startTimer];
    }
}


- (void)setInfiniteLoop:(BOOL)infiniteLoop
{
    _infiniteLoop = infiniteLoop;
    
    [self reloadData];
}

#pragma mark - 内容更新
- (void)reloadData
{
    if(self.isInfiniteLoop)
    {
        //无限循环滚动 刷新数据
        [self reloadInfiniteLoopData];
    }else{
        // 非无限循环滚动 刷新数据
        [self reloadLimitLoopData];
    }

}


#pragma mark - 更新无限循环滚动的数据
- (void) reloadInfiniteLoopData
{
    // 设置图片
    for (int i = 0; i<self.scrollView.subviews.count; i++)
    {
        UIImageView *imageView = self.scrollView.subviews[i];
        //获取当前索引
        NSInteger index = self.pageControl.currentPage;
        if (i == 0)
        {
            index--;
        } else if (i == 2)
        {
            index++;
        }
        
        if (index < 0)
        {
            index = self.pageControl.numberOfPages - 1;
        } else if (index >= self.pageControl.numberOfPages)
        {
            index = 0;
        }
        imageView.tag = index;
        imageView.image = self.images[index];
        
    }
    // 设置偏移量在中间
    if (self.isScrollDirectionPortrait)
    {
        self.scrollView.contentOffset = CGPointMake(0, self.scrollView.frame.size.height);
    } else {
        self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    }
}


#pragma mark - 刷新有限的数据
- (void) reloadLimitLoopData
{
    // 设置图片
    for (int i = 0; i<self.scrollView.subviews.count  ; i++)
    {
        UIImageView *imageView = self.scrollView.subviews[i];
        //获取当前索引
        NSInteger index = self.pageControl.currentPage;
        NSInteger count = self.scrollView.subviews.count;
        NSInteger page = self.pageControl.numberOfPages;
        if (index < count-1)
        {
            index = i;
        }else if (index < page-1){
            if (i == 0)
            {
                index--;
            } else if (i == 2) {
                index++;
            }
        }else{
            index = i + page-count;
        }
        imageView.tag = index;
        imageView.image = self.images[index];
        
    }
    
    
    
    
    //获取当前索引
    NSInteger index = self.pageControl.currentPage;
    //子控件个数
    NSInteger count = self.scrollView.subviews.count;
    //图片总数
    NSInteger page = self.pageControl.numberOfPages;
    
    
    
    // 设置偏移量
    if (self.isScrollDirectionPortrait)
    {
        if (index < count-1)
        {
            self.scrollView.contentOffset = CGPointMake(0 , self.scrollView.frame.size.height * index);
        }else if (index < page-1)
        {
            self.scrollView.contentOffset = CGPointMake(0 , self.scrollView.frame.size.height);
        }else{
            self.scrollView.contentOffset = CGPointMake(0 , self.scrollView.frame.size.height*2 );
        }
    } else {
        
        if (index < count-1)
        {
            self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width * index, 0);
        }else if (index < page-1)
        {
            self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width , 0);
        }else{
            self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width*2 , 0);
        }
    }
}


/**
 *  开始自动滚动 建议在控制器 viewWillAppear 中调用
 */
- (void)startAutoScroll
{
    if (self.isAutoScroll) [self startTimer];
}

/**
 *  停止自动滚动 建议在控制器 viewWillDisAppear 中调用
 */
- (void) stopAutoScroll
{
    if (self.isAutoScroll) [self stopTimer];
}


#pragma mark - 定时器处理
- (void)startTimer
{
    if (self.timer) return;
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(next) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
}

- (void)stopTimer
{
    if (self.timer.isValid)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)next
{
 
    /** 核心思路
     *  自动滚动到下一页
     *  设置scrollView的contentOffset为2 * self.scrollView.frame.size.width 就是滚动到第三张imageview
     */
    //获取当前索引
    NSInteger index = self.pageControl.currentPage;
    //子控件个数
    NSInteger count = self.scrollView.subviews.count;
    //图片总数
    NSInteger page = self.pageControl.numberOfPages;
    
    
    if (self.isScrollDirectionPortrait)
    {
        if (self.isInfiniteLoop)
        {
            [self.scrollView setContentOffset:CGPointMake(0, 2 * self.scrollView.frame.size.height) animated:YES];
        }else
        {
            //非无限循环滚动
            if (index < count-1)
            {
                [self.scrollView setContentOffset:CGPointMake(0 , (index+1) * self.scrollView.frame.size.height) animated:YES];
            }else if (index < page-1)
            {
                [self.scrollView setContentOffset:CGPointMake(0 , 2 * self.scrollView.frame.size.height) animated:YES];
            }else{
                
                // 修改里面子控件的tag
                NSInteger tag = page-count;
                UIImageView *imageView = (UIImageView *)[self.scrollView viewWithTag:tag];
                imageView.tag = 0;
                
                [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            }

        }
        
    } else {
        
        if (self.isInfiniteLoop)
        {
            //无限循环滚动
            [self.scrollView setContentOffset:CGPointMake(2 * self.scrollView.frame.size.width, 0) animated:YES];
        }else{
            //非无限循环滚动

            if (index < count-1)
            {
                [self.scrollView setContentOffset:CGPointMake((index+1) * self.scrollView.frame.size.width, 0) animated:YES];
            }else if (index < page-1)
            {
                [self.scrollView setContentOffset:CGPointMake(2 * self.scrollView.frame.size.width, 0) animated:YES];
            }else{
                
                // 修改里面子控件的tag
                NSInteger tag = page-count;
                UIImageView *imageView = (UIImageView *)[self.scrollView viewWithTag:tag];
                imageView.tag = 0;
                
                [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            }
        }
    }
}
@end
