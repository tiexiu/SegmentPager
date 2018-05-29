//
//  BaseSubScrollViewControllerStyle2.h
//  SegmentPagerStyle1
//
//  Created by s on 2018/5/25.
//  Copyright © 2018年 s. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SubScrollViewDelegate<NSObject>
@optional
- (void)subScrollViewWillBeginDraggin:(UIScrollView *)scrollView;
- (void)subScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)subScrollViewDidEndDecelerating:(UIScrollView *)scrollView;
@end

@interface BaseSubScrollViewControllerStyle2 : UIViewController

@property (nonatomic,weak) id<SubScrollViewDelegate>subScrollViewDelegate;
@property (nonatomic) UIScrollView *baseScrollView;
@end
