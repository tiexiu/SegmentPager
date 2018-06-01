//
//  TitleScrollView.h
//  s1
//
//  Created by s on 2018/4/27.
//  Copyright © 2018年 s. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TitleSelectedDelegate<NSObject>
- (void)titleSelected:(NSInteger)index;

@end

@interface TitleScrollView : UIScrollView

@property (nonatomic,weak) id<TitleSelectedDelegate>titleSelectedDelegate;

// 横滚结束后才进行title横滚动画
- (void)updateTitleScrollViewWithIndex:(NSUInteger)index;
- (void)titleScrollViewWithTitleArray:(NSArray *)titleArray height:(CGFloat)height initialIndex:(NSInteger)index;

@end
