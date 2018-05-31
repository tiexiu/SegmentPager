//
//  ScrollViewControllerStyle2.m
//  SegmentPagerStyle1
//
//  Created by s on 2018/5/25.
//  Copyright © 2018年 s. All rights reserved.
//

#import "ScrollViewControllerStyle2.h"
#import "GestureRecognizerScrollView.h"

@interface ScrollViewControllerStyle2 ()<UIScrollViewDelegate>
@property (nonatomic) GestureRecognizerScrollView *scrollView;

@end

@implementation ScrollViewControllerStyle2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.baseScrollView = self.scrollView;
    [self.view addSubview:self.baseScrollView];
    [self setupUI];
}

- (void)setupUI {
    
    NSDictionary *scrollViewDic = @{@"scrollView" : self.scrollView};
    NSArray *hConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics:nil views:scrollViewDic];
    NSArray *vConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|" options:0 metrics:nil views:scrollViewDic];
    [self.view addConstraints:hConstraint];
    [self.view addConstraints:vConstraint];
    
    
    UIView *backgroundView = [UIView new];
    backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:backgroundView];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[backgroundView(==scrollView)]|"
                                                                            options:0
                                                                            metrics:nil
                                                                              views:@{@"backgroundView":backgroundView,@"scrollView" : self.scrollView}]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[backgroundView]|"
                                                                            options:0
                                                                            metrics:nil
                                                                              views:@{@"backgroundView":backgroundView,@"scrollView" : self.scrollView}]];
    
    UIView *view1 = [UIView new]; view1.backgroundColor = randomColor; view1.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *view2 = [UIView new]; view2.backgroundColor = randomColor; view2.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *view3 = [UIView new]; view3.backgroundColor = randomColor; view3.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *view4 = [UIView new]; view4.backgroundColor = randomColor; view4.translatesAutoresizingMaskIntoConstraints = NO;
    [backgroundView addSubview:view1];
    [backgroundView addSubview:view2];
    [backgroundView addSubview:view3];
    [backgroundView addSubview:view4];
    
    
    NSDictionary *metric = @{@"margin":@10,@"viewHeight":@500};
    NSString *hVFL1 = @"H:|-margin-[view1]-margin-|";
    NSString *hVFL2 = @"H:|-margin-[view2]-margin-[view3(==view2)]-margin-|";
    NSString *hVFL3 = @"H:|-margin-[view4]-margin-|";
    NSString *vVFL1 = @"V:|-margin-[view1(==viewHeight)]-margin-[view2(==view1)]-margin-[view4(==view1)]-margin-|";
    NSString *vVFL2 = @"V:|-margin-[view1(==viewHeight)]-margin-[view3(==view1)]-margin-[view4(==view1)]-margin-|";
    
    [backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:hVFL1 options:0 metrics:metric views:@{@"view1":view1}]];
    [backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:hVFL2 options:0 metrics:metric views:@{@"view2":view2,@"view3":view3}]];
    [backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:hVFL3 options:0 metrics:metric views:@{@"view4":view4}]];
    [backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vVFL1 options:0 metrics:metric views:@{@"view1":view1,@"view2":view2,@"view4":view4}]];
    [backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vVFL2 options:0 metrics:metric views:@{@"view1":view1,@"view3":view3,@"view4":view4}]];
}

- (GestureRecognizerScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[GestureRecognizerScrollView alloc] init];
        _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollView;
}


@end
