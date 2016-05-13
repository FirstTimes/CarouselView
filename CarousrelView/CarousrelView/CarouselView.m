//
//  CarouselView.m
//  CarousrelView
//
//  Created by 李锐 on 16/5/3.
//  Copyright © 2016年 lirui. All rights reserved.
//

#import "CarouselView.h"

@interface CarouselView ()
{
    @private
    NSInteger _pictureCount;
    NSTimeInterval _ti;
    CarouselViewLayoutMode layoutMode;
    BOOL isAutoScroll;
    
}

@property (nonatomic,strong) NSArray * imageViews;

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UIPageControl * pageControl;

@property (nonatomic,assign) NSInteger currentPage;

@property (nonatomic,strong) NSTimer * timer;

@end


@implementation CarouselView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    self.pageControlHidden = NO;
    self->isAutoScroll = NO;
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:frame];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    self.pageControl = [[UIPageControl alloc]init];
    self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [self addSubview:self.pageControl];
    
    return self;
}

- (void)setContentMode:(CarouselViewLayoutMode)contentMode andImages:(NSArray*)images{
    if (images == nil) {
        return;
    }
    self->_pictureCount = images.count;
    self->layoutMode = contentMode;
    
    NSString * first = [images firstObject];
    NSString * last = [images lastObject];
    
    NSMutableArray * tempArray = [NSMutableArray array];
    for (int i = 0; i < images.count + 2; i++) {
        if (i == 0) {
            [tempArray addObject:last];
        }
        else if (i == images.count + 1) {
            [tempArray addObject:first];
        }
        else{
            [tempArray addObject:[images objectAtIndex:i-1]];
        }
    }
    NSArray * reformArray = [NSArray arrayWithArray:tempArray];
    
    CGFloat imageWidth = self.scrollView.bounds.size.width;
    CGFloat imageHeight = self.scrollView.bounds.size.height;
    self.pageControl.numberOfPages = images.count;
    
    NSInteger imageCount = reformArray.count;
    
    if (contentMode == CarouselViewLayoutHorizontal){
        for (int i = 0; i < imageCount; i++) {
            CGFloat imageX = i * imageWidth;
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(imageX, 0, imageWidth, imageHeight)];
            imageView.image = [UIImage imageNamed:[reformArray objectAtIndex:i]];
            imageView.contentMode = UIViewContentModeScaleToFill;
            [self.scrollView addSubview:imageView];
        }
        self.scrollView.contentSize = CGSizeMake(imageWidth * imageCount, imageHeight);
        self.scrollView.contentOffset = CGPointMake(imageWidth, 0);
    }
    else{
        for (int i = 0; i < imageCount; i++) {
            CGFloat imageY = i * imageHeight;
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, imageY, imageWidth, imageHeight)];
            imageView.image = [UIImage imageNamed:[reformArray objectAtIndex:i]];
            imageView.contentMode = UIViewContentModeScaleToFill;
            [self.scrollView addSubview:imageView];
        }
        self.scrollView.contentSize = CGSizeMake(imageWidth, imageHeight * imageCount);
        self.scrollView.contentOffset = CGPointMake(0, imageHeight);
    }
    self.pageControl.currentPage = 0;
}

- (void)changePage{
    int page = 0;
    if (self->layoutMode == CarouselViewLayoutHorizontal) {
        page = (self.scrollView.contentOffset.x + self.scrollView.bounds.size.width * 0.5) / self.scrollView.bounds.size.width;
    }
    else{
        page = (self.scrollView.contentOffset.y + self.scrollView.bounds.size.height * 0.5) / self.scrollView.bounds.size.height;
    }
    if (page == self->_pictureCount + 1) {
        page = 1;
    }
    self.currentPage = page - 1;
}

- (void)loopScroll{
    if (self->layoutMode == CarouselViewLayoutHorizontal) {
        NSInteger page = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
        if (page == 0) {
            [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * self->_pictureCount, 0)];
        }
        if (page == self->_pictureCount + 1){
            [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0)];
        }
    }
    else{
        NSInteger page = self.scrollView.contentOffset.y / self.scrollView.frame.size.height;
        if (page == 0) {
            [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.frame.size.height * self->_pictureCount)];
        }
        if (page == self->_pictureCount + 1){
            [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.frame.size.height)];
        }
    }
}

- (void)autoScrollWithTimeInterval:(NSTimeInterval)timeInterval{
    if (timeInterval > 0.0) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(pageTurning) userInfo:nil repeats:YES];
        self->_ti = timeInterval;
    }
    else{
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(pageTurning) userInfo:nil repeats:YES];
        self->_ti = 2.0;
    }
    self->isAutoScroll = YES;
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)pageTurning{
    if (self->layoutMode == CarouselViewLayoutHorizontal) {
        CGFloat offsetX = self.scrollView.contentOffset.x + self.scrollView.bounds.size.width;
        CGPoint offset = CGPointMake(offsetX, 0);
        [self.scrollView setContentOffset:offset animated:YES];
    }
    else{
        CGFloat offsetY = self.scrollView.contentOffset.y + self.scrollView.bounds.size.height;
        CGPoint offset = CGPointMake(0, offsetY);
        [self.scrollView setContentOffset:offset animated:YES];
    }
    [self loopScroll];
}

- (void)resumeAutoScroll{
    if (self->isAutoScroll) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self->_ti target:self selector:@selector(pageTurning) userInfo:nil repeats:YES];
    }
    else{
        [self loopScroll];
    }
}

- (void)pauseAutoScroll{
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)setPagePosition:(PageControlPosition)pagePosition{
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat margin = 10;
    switch (pagePosition) {
        case PageControlPositionTopLeft:
            self.pageControl.center = CGPointMake(self->_pictureCount * margin, margin);
            break;
        case PageControlPositionTopMiddle:
            self.pageControl.center = CGPointMake(width * 0.5, margin);
            break;
        case PageControlPositionTopRight:
            self.pageControl.center = CGPointMake(width - self->_pictureCount * margin, margin);
            break;
        case PageControlPositionMiddleLeft:
            self.pageControl.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.pageControl.center = CGPointMake(margin, height * 0.5);
            break;
        case PageControlPositionMiddleRight:
            self.pageControl.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.pageControl.center = CGPointMake(width - margin, height * 0.5);
            break;
        case PageControlPositionBottomLeft:
            self.pageControl.center = CGPointMake(self->_pictureCount * margin, height - margin);
            break;
        case PageControlPositionBottomMiddle:
            self.pageControl.center = CGPointMake(width * 0.5, height - margin);
            break;
        case PageControlPositionBottomRight:
            self.pageControl.center = CGPointMake(width - self->_pictureCount * margin, height - margin);
            break;
        default:
            break;
    }
}



- (void)setDelegate:(id)delegate{
    self.scrollView.delegate = delegate;
}

- (void)setCurrentPage:(NSInteger)currentPage{
    self.pageControl.currentPage = currentPage;
}

- (void)setPageControlHidden:(BOOL)pageControlHidden{
    self.pageControl.hidden = pageControlHidden;
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor{
    self.pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor{
    self.pageControl.pageIndicatorTintColor = currentPageIndicatorTintColor;
}


@end

