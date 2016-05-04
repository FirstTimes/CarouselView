//
//  CarouselView.m
//  CarousrelView
//
//  Created by 李锐 on 16/5/3.
//  Copyright © 2016年 lirui. All rights reserved.
//

#import "CarouselView.h"

@interface CarouselView (){
    @private
    NSInteger pictureCount;
    CarouselViewLayoutMode layoutMode;
}


@property (nonatomic,strong) NSArray * imageViews;

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UIPageControl * pageControl;



@end


@implementation CarouselView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor yellowColor];
    self.pageControlHidden = NO;
    self.currentPage = 0;
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:frame];
    self.scrollView.pagingEnabled = YES;
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
    self->pictureCount = images.count;
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
    self.pageControl.center = CGPointMake(imageWidth * 0.5, imageHeight - 10);
}


- (void)changePage{
    int page = 0;
    if (self->layoutMode == CarouselViewLayoutHorizontal) {
        page = (self.scrollView.contentOffset.x + self.scrollView.bounds.size.width * 0.5) / self.scrollView.bounds.size.width;
    }
    else{
        page = (self.scrollView.contentOffset.y + self.scrollView.bounds.size.height * 0.5) / self.scrollView.bounds.size.height;
    }
    self.currentPage = page - 1;
}

- (void)loopScroll{
    if (self->layoutMode == CarouselViewLayoutHorizontal) {
        NSInteger page = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
        if (page == 0) {
            [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * self->pictureCount, 0)];
        }
        if (page == self->pictureCount + 1){
            [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0)];
        }
    }
    else{
        NSInteger page = self.scrollView.contentOffset.y / self.scrollView.frame.size.height;
        if (page == 0) {
            [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.frame.size.height * self->pictureCount)];
        }
        if (page == self->pictureCount + 1){
            [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.frame.size.height)];
        }
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

