//
//  CarouselView.h
//  CarousrelView
//
//  Created by 李锐 on 16/5/3.
//  Copyright © 2016年 lirui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CarouselViewLayoutMode) {
    CarouselViewLayoutHorizontal,
    CarouselViewLayoutVertical
};

typedef NS_ENUM(NSInteger, PageControlPosition) {
    PageControlPositionTopLeft,
    PageControlPositionTopMiddle,
    PageControlPositionTopRight,
    PageControlPositionMiddleLeft,
    PageControlPositionMiddleRight,
    PageControlPositionBottomLeft,
    PageControlPositionBottomMiddle,
    PageControlPositionBottomRight
};


@interface CarouselView : UIView

/// 是否隐藏页码显示
@property (nonatomic,assign) BOOL  pageControlHidden;


/// 页码颜色，默认白色
@property (nonatomic,strong) UIColor * pageIndicatorTintColor;

/// 当前页码颜色，默认灰色
@property (nonatomic,strong) UIColor * currentPageIndicatorTintColor;

/// 页码控制器的位置
@property (nonatomic,assign) PageControlPosition pagePosition;

@property (nonatomic,weak) id<UIScrollViewDelegate>  delegate;   //代理

/// 初始化
- (instancetype)initWithFrame:(CGRect)frame;

/// 传入布局的模式和图片名称数组
- (void)setContentMode:(CarouselViewLayoutMode)contentMode andImages:(NSArray*)images;

/// 改变页面
- (void)changePage;

/// 循环滚动
- (void)loopScroll;

/* 设置自动滚动时间间隔
 *
 * timeInterval 时间间隔 数值应大于0
 *
 */
- (void)autoScrollWithTimeInterval:(NSTimeInterval)timeInterval;


- (void)resumeAutoScroll;

/// 自动滚动
- (void)pauseAutoScroll;



@end
