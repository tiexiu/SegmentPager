//
//  BaseSubScrollViewControllerStyle1.h
//  SegmentPager
//
//  Created by s on 2018/5/16.
//  Copyright © 2018年 s. All rights reserved.
//

#import "BaseSubScrollViewControllerStyle1.h"

static CGFloat const refreshControlHeight = 50.f;

@implementation BaseSubScrollViewControllerStyle1

- (instancetype)init {
    if (self = [super init]) {
        self.navigationController.navigationBarHidden = YES;
        topEdgeInset = 200.f;
        titleHeight = [UIFont systemFontOfSize:25].lineHeight;
    }
    return self;
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.subScrollViewDidScrollDelegate respondsToSelector:@selector(subScrollViewWillBeginDraggin:)]) {
        [self.subScrollViewDidScrollDelegate subScrollViewWillBeginDraggin:scrollView];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.subScrollViewDidScrollDelegate respondsToSelector:@selector(subScrollViewDidScroll:)]) {
        [self.subScrollViewDidScrollDelegate subScrollViewDidScroll:scrollView];
    }
    
    if (scrollView.contentOffset.y <= -(refreshControlHeight+topEdgeInset+titleHeight)) {
        if (self.refreshControl.tag == 0) {
            self.refreshControl.text = @"释放刷新";
        }
        self.refreshControl.tag = 1;
    }else {
        self.refreshControl.text = @"下拉刷新";
        self.refreshControl.tag = 0;
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (self.refreshControl.tag == 1) {
        [UIView animateWithDuration:.3 animations:^{
            self.refreshControl.text = @"正在刷新";
            scrollView.contentInset = UIEdgeInsetsMake(topEdgeInset+titleHeight+refreshControlHeight, 0, 0, 0);
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:.3 animations:^{
                self.refreshControl.text = @"下拉刷新";
                self.refreshControl.tag = 0;
                scrollView.contentInset = UIEdgeInsetsMake(topEdgeInset+titleHeight, 0, 0, 0);
            }];
        });
    }
}

- (UILabel *)refreshControl {
    if(!_refreshControl) {
        _refreshControl = [[UILabel alloc] initWithFrame:CGRectMake(0, -refreshControlHeight, CGRectGetWidth(self.view.frame), refreshControlHeight)];
        _refreshControl.text = @"下拉刷新";
        _refreshControl.textAlignment = NSTextAlignmentCenter;
        _refreshControl.tag = 0;
    }
    return _refreshControl;
}

@end
