//
//  BaseSubScrollViewControllerStyle1.h
//  SegmentPager
//
//  Created by s on 2018/5/16.
//  Copyright © 2018年 s. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GestureRecognizerScrollView.h"

@protocol SubScrollViewDelegate<NSObject>
@optional
- (void)subScrollViewWillBeginDraggin:(UIScrollView *)scrollView;
- (void)subScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)subScrollViewDidEndDecelerating:(UIScrollView *)scrollView;
@end

@interface BaseSubScrollViewControllerStyle1 : UIViewController
{
    @protected
    CGFloat topEdgeInset;
}
@property (nonatomic,weak) id<SubScrollViewDelegate>subScrollViewDidScrollDelegate;
@property (nonatomic) UIScrollView *baseScrollView;
@property (nonatomic) UILabel *refreshControl;

@end
