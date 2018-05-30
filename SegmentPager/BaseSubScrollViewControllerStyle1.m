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
}

@end
