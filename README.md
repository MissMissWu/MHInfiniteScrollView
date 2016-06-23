# MHInfiniteScrollView

# 简介
一个基于UIScrollView，利用三个UIImageView，实现无限循环滚动的控件。

# Usage

```objc

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

	//初始化
	MHInfiniteScrollView *scrollView = [[MHInfiniteScrollView alloc] init];
	//设置尺寸
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
	 
```

# 期待
- 如果在使用过程中遇到BUG，希望你能Issues我，谢谢（或者尝试下载最新的框架代码看看BUG修复没有）。
- 如果在使用过程中发现功能不够用，希望你能Issues我，我非常想为这个框架增加更多好用的功能，谢谢。
- 如果你想为MHInfiniteScrollView输出代码，请拼命Pull Requests我。

# 座右铭
- 爱生活、爱代码、爱篮球、爱我所爱！我是程序猿，我为自己代言！！！


