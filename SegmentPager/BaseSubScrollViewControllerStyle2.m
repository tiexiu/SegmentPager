//
//  BaseSubScrollViewControllerStyle2.m
//  SegmentPagerStyle1
//
//  Created by s on 2018/5/25.
//  Copyright © 2018年 s. All rights reserved.
//

#import "BaseSubScrollViewControllerStyle2.h"

@interface BaseSubScrollViewControllerStyle2 ()<UIScrollViewDelegate>

@end

@implementation BaseSubScrollViewControllerStyle2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.subScrollViewDelegate respondsToSelector:@selector(subScrollViewWillBeginDraggin:)]) {
        [self.subScrollViewDelegate subScrollViewWillBeginDraggin:scrollView];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.subScrollViewDelegate respondsToSelector:@selector(subScrollViewDidScroll:)]) {
        [self.subScrollViewDelegate subScrollViewDidScroll:scrollView];
    }
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.subScrollViewDelegate respondsToSelector:@selector(subScrollViewDidEndDecelerating:)]) {
        [self.subScrollViewDelegate subScrollViewDidEndDecelerating:scrollView];
    }
}



@end
