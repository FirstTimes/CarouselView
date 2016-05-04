//
//  ViewController.m
//  CarousrelView
//
//  Created by 李锐 on 16/5/3.
//  Copyright © 2016年 lirui. All rights reserved.
//

#import "ViewController.h"
#import "CarouselView.h"

@interface ViewController () <UIScrollViewDelegate>

@property (nonatomic,strong) CarouselView * carousrlView;

@property (nonatomic,strong) NSArray * images;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    self.images = [NSArray arrayWithObjects:@"lol_0.jpg",@"lol_1.jpg",@"lol_2.jpg",@"lol_3.jpg",@"lol_4.jpg", nil];

    self.carousrlView = [[CarouselView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 300)];
    [self.carousrlView setContentMode:CarouselViewLayoutVertical andImages:self.images];
    self.carousrlView.delegate = self;
    [self.view addSubview:self.carousrlView];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.carousrlView changePage];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self.carousrlView loopScroll];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
