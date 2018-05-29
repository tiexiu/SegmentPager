//
//  HitTestView.m
//  SegmentPager
//
//  Created by s on 2018/5/25.
//  Copyright © 2018年 s. All rights reserved.
//

#import "HitTestView.h"

@implementation HitTestView
/*
 点击穿透，点击事件可以穿透superScrollView，superScrollView下方的banner可以响应点击事件
 */
- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    UIView *hitView = [super hitTest:point withEvent:event];
    if(hitView == self){
        return nil;
    }
    return hitView;
}

@end
