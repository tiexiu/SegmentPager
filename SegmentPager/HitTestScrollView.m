//
//  HitTestScrollView.m
//  s1
//
//  Created by s on 2018/5/4.
//  Copyright © 2018年 s. All rights reserved.
//

#import "HitTestScrollView.h"

@implementation HitTestScrollView

// 触摸穿透
//- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    UIView *hitView = [super hitTest:point withEvent:event];
//    NSLog(@"%@",hitView);
//
//    if(hitView == self){
//        return nil;
//    }
//    return hitView;
//}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGPoint hitViewPoint = [self convertPoint:point toView:self.hitView];
    if ([self.hitView pointInside:hitViewPoint withEvent:event]) {
        return self.hitView;
    }
    
    return [super hitTest:point withEvent:event];
}

@end
