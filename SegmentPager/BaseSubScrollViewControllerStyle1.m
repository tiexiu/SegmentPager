//
//  BaseSubScrollViewControllerStyle1.h
//  SegmentPager
//
//  Created by s on 2018/5/16.
//  Copyright © 2018年 s. All rights reserved.
//

#import "BaseSubScrollViewControllerStyle1.h"

@interface BaseSubScrollViewControllerStyle1 ()<UIScrollViewDelegate>
@end

@implementation BaseSubScrollViewControllerStyle1

- (instancetype)init {
    if (self = [super init]) {
        self.navigationController.navigationBarHidden = YES;
        topEdgeInset = BANNER_HEIGHT;
        refreshViewHeight = 50;
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
    // 下拉刷新
    if (scrollView.contentOffset.y <= -(topEdgeInset+refreshViewHeight)) {
        if (self.refresh.tag == 0) {
            self.refresh.text = @"松开刷新";
        }
        self.refresh.tag = 1;
    }else{
        //防止用户在下拉到contentOffset.y <= -50后不松手，然后又往回滑动，需要将值设为默认状态
        self.refresh.tag = 0;
        self.refresh.text = @"下拉刷新";
    }
}
//即将结束拖拽
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    if (self.refresh.tag == 1) {
        [UIView animateWithDuration:.3 animations:^{
            self.refresh.text = @"加载中..";
            scrollView.contentInset = UIEdgeInsetsMake(topEdgeInset+refreshViewHeight, 0.0f, 0.0f, 0.0f);
        }];
        //数据加载成功后执行；这里为了模拟加载效果，一秒后执行恢复原状代码
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:.3 animations:^{
                self.refresh.tag = 0;
                self.refresh.text = @"下拉刷新";
                scrollView.contentInset = UIEdgeInsetsMake(topEdgeInset, 0, 0, 0);
            }];
        });
    }
}

- (UILabel *)refresh {
    if (!_refresh) {
        UILabel *refresh = [[UILabel alloc] initWithFrame:CGRectMake(0,-refreshViewHeight, self.view.bounds.size.width, refreshViewHeight)];
        refresh.text  = @"下拉刷新";
        refresh.textAlignment = NSTextAlignmentCenter;
        refresh.tag = 0;
        self.refresh = refresh;
    }
    return _refresh;
}

@end
