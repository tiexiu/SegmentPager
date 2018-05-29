//
//  GestureRecognizerScrollView.m
//  s1
//
//  Created by s on 2018/5/15.
//  Copyright © 2018年 s. All rights reserved.
//

#import "GestureRecognizerScrollView.h"

@implementation GestureRecognizerScrollView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


@end
