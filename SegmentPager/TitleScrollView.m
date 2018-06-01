//
//  TitleScrollView.m
//  s1
//
//  Created by s on 2018/4/27.
//  Copyright © 2018年 s. All rights reserved.
//

#import "TitleScrollView.h"

@interface TitleScrollView()
{
    CGFloat lineBarheight;
    CGFloat horizontalScrollOffsetX;
}
@property (nonatomic) NSArray *titleArray;
@property (nonatomic) NSMutableArray *labelFrameArray;
// titleLabel下方动画指示条
@property (nonatomic) UIView *animaticLineBar;
@end

@implementation TitleScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.backgroundColor = [UIColor whiteColor];
        self.bounces = NO;
        horizontalScrollOffsetX = 0;
        _labelFrameArray = [NSMutableArray array];
    }
    return self;
}
- (void)titleScrollViewWithTitleArray:(NSArray *)titleArray height:(CGFloat)height initialIndex:(NSInteger)index {
    lineBarheight = 2;
    _titleArray = titleArray;
    // 添加label,保存label的frame
    __block CGFloat labelX = 0;
    @weakify(self);
    [_titleArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        UILabel *label = [[UILabel alloc] init];
        label.text = obj;
        label.userInteractionEnabled = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:ceilf(height*0.6)];
        CGSize size = CGSizeMake(MAXFLOAT, height);//设置高度宽度的最大限度
        CGRect rect = [label.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:height]} context:nil];
        CGSize labelSize = CGSizeMake( rect.size.width , height-lineBarheight);
        label.frame = (CGRect){CGPointMake(labelX,0),labelSize};
        [self addSubview:label];
        labelX = labelX + labelSize.width;
        [self addTapGestureWithLabel:label OfIndex:idx];
        [self.labelFrameArray addObject:[NSValue valueWithCGRect:label.frame]];
    }];

    
    self.contentSize = CGSizeMake(labelX, height);
    [self addAnimatedLineAtIndex:index];
}

- (void)updateTitleScrollViewWithIndex:(NSUInteger)index {
    [self titleScrollWithIndex:index];
}


- (void)addTapGestureWithLabel:(UILabel *)label OfIndex:(NSUInteger)index{
    label.tag = index;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnLabel:)];
    [label addGestureRecognizer:tap];
}

- (void)tapOnLabel:(UITapGestureRecognizer *)tap {
    UILabel *label = (UILabel *)tap.view;
    NSUInteger indexOnTap = label.tag;
    [self titleScrollWithIndex:indexOnTap];
    
    if ([self.titleSelectedDelegate respondsToSelector:@selector(titleSelected:)]) {
        [self.titleSelectedDelegate titleSelected:indexOnTap];
    }
}

- (void) titleScrollWithIndex:(NSUInteger)indexOnTap {
    // 获取第index个label的centerX
    CGRect frameOfLabelAtIndex = [self.labelFrameArray[indexOnTap] CGRectValue];
    CGFloat centerXOfLabelAtIndex = frameOfLabelAtIndex.origin.x + frameOfLabelAtIndex.size.width/2;
    
    // 目标偏移量
    CGFloat targetOffSetX = centerXOfLabelAtIndex - self.bounds.size.width/2;
    // 满足偏移量不超过屏幕两侧才执行偏移
    if (targetOffSetX > 0 && targetOffSetX < (self.contentSize.width - self.bounds.size.width)) {
        [self setContentOffset: CGPointMake(targetOffSetX , 0) animated:YES];
    }else if (targetOffSetX < 0) {
        // scrollView首部不满足偏移条件，有可能显示不全，直接设置划到最左
        [self setContentOffset:CGPointZero animated:YES];
    }else if (targetOffSetX > 0) {
        // scollView尾部不满足便宜条件，直接划到最右
        [self setContentOffset:CGPointMake((self.contentSize.width - self.bounds.size.width), 0) animated:YES];
    }
    // lineBar动画
    [UIView animateWithDuration:0.5 animations:^{
        CGRect targetFrame = [self getTargetFrameOfAnimaticLineBarWithIndex:indexOnTap];
        [self.animaticLineBar setFrame:targetFrame];
    } completion:^(BOOL finished) {
    }];
}
- (void)addAnimatedLineAtIndex:(NSInteger)index {
    CGRect animateLineFrame = [self getTargetFrameOfAnimaticLineBarWithIndex:index];
    _animaticLineBar = [[UIView alloc] initWithFrame:animateLineFrame];
    _animaticLineBar.backgroundColor = [UIColor blackColor];
    [self addSubview:_animaticLineBar];
}
- (CGRect)getTargetFrameOfAnimaticLineBarWithIndex:(NSUInteger)index {
    CGRect frameOfLabelAtIndex = [self.labelFrameArray[index] CGRectValue];
    CGPoint lineBarOrigin = CGPointMake(frameOfLabelAtIndex.origin.x, CGRectGetMaxY(frameOfLabelAtIndex)-lineBarheight);
    CGSize linebarSize = CGSizeMake(frameOfLabelAtIndex.size.width, lineBarheight);
    CGRect targetFrame = (CGRect){lineBarOrigin,linebarSize};
    return targetFrame;
}
- (CGSize)sizeForString:(NSString *)string inFont:(UIFont *)font{
    CGSize size = [string sizeWithAttributes:@{NSFontAttributeName:font}];
    CGSize statuseStrSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    return statuseStrSize;
}

//- (NSMutableArray *)labelFrameArray {
//    if (!_labelFrameArray) {
//        _labelFrameArray = [[NSMutableArray alloc] init];
//    }
//    return _labelFrameArray;
//}

@end
