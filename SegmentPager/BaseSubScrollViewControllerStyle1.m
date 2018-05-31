//
//  BaseSubScrollViewControllerStyle1.h
//  SegmentPager
//
//  Created by s on 2018/5/16.
//  Copyright © 2018年 s. All rights reserved.
//

#import "BaseSubScrollViewControllerStyle1.h"

@interface BaseSubScrollViewControllerStyle1 ()
@property (nonatomic) UIAlertController *alert;
@end

@implementation BaseSubScrollViewControllerStyle1

- (instancetype)init {
    if (self = [super init]) {
        self.navigationController.navigationBarHidden = YES;
        topEdgeInset = BANNER_HEIGHT;
    }
    return self;
}

- (void)refresh:(UIRefreshControl *)sender {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [sender endRefreshing];
        [self presentViewController:self.alert animated:NO completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.alert dismissViewControllerAnimated:NO completion:nil];
            });
        }];
    });
}
-(UIAlertController *)alert {
    if (!_alert) {
        _alert = [UIAlertController alertControllerWithTitle:nil message:@"刷新完成" preferredStyle:UIAlertControllerStyleAlert];
    }
    return _alert;
}
- (UIRefreshControl *)refresh {
    if (!_refresh) {
        _refresh = [[UIRefreshControl alloc] init];
        _refresh.tintColor = [UIColor redColor];
        [_refresh addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    }
    return _refresh;
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
}

@end
