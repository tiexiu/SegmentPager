//
//  PrefixHeader.h
//  SegmentPager
//
//  Created by s on 2018/5/16.
//  Copyright © 2018年 s. All rights reserved.
//

#ifndef PrefixHeader_h
#define PrefixHeader_h


#define BANNER_HEIGHT 210
#define SCROLLTITLE_FONTSIZE 30


#define Device_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)，


#define TOP_BAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height+self.navigationController.navigationBar.frame.size.height

#define STATUS_BAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height
#define NAV_BAR_Height self.navigationController.navigationBar.frame.size.height

#ifdef DEBUG
#define LRLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define LRLog(...)
#endif



#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define SCREENH_HEIGHT [UIScreen mainScreen].bounds.size.height

/*
 * 随机颜色
 */
#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))



/*
 * @weakify(self);
 * @strongify(self);
 */
#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif


#endif /* PrefixHeader_h */
