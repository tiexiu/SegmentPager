//
//  ContentCollectionView.m
//  s1
//
//  Created by s on 2018/5/10.
//  Copyright © 2018年 s. All rights reserved.
//

#import "HorizontalCollectionView.h"

static NSString *contentCollectionID = @"ContentCollectionViewCellID";
@interface HorizontalCollectionView()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    CGFloat pageWidth;
    CGFloat pageHeight;
    NSInteger currentIndex;
    
    CGFloat xxx;
}
@property (nonatomic) NSArray *vcArray;

@end

@implementation HorizontalCollectionView


- (instancetype)initWithFrame:(CGRect)frame {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = frame.size;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.backgroundColor = [UIColor clearColor];
        self.pagingEnabled = YES;
        self.bounces = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        pageWidth = self.bounds.size.width;
        pageHeight = self.bounds.size.height;
        [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:contentCollectionID];
    }
    return self;
}

- (void)contentCollectionViewWithControllers:(NSArray *)controllersArray index:(NSUInteger)index  {
    self.contentSize = CGSizeMake(pageWidth * controllersArray.count, pageHeight);
    self.vcArray = controllersArray;
    currentIndex = index;
}

#pragma --mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.bounds.size;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

#pragma --mark Delegate&DataSource
- (void)updatePageWithIndex:(NSUInteger)index {
    [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    currentIndex = index;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.vcArray.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:contentCollectionID forIndexPath:indexPath];
    UIViewController *vc = self.vcArray[indexPath.item];
    vc.view.frame = (CGRect){CGPointMake(0, 0),CGSizeMake(pageWidth, pageHeight)};
    [cell addSubview:vc.view];
    return cell;
}

#pragma --mark ScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    xxx = scrollView.contentOffset.x;
    if ([self.horizontalCollectionViewScrollDelegate respondsToSelector:@selector(horizontalCollectionViewWillBegingDragging:atIndex:)]) {
        [self.horizontalCollectionViewScrollDelegate horizontalCollectionViewWillBegingDragging:scrollView atIndex:currentIndex];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.horizontalCollectionViewScrollDelegate respondsToSelector:@selector(horizontalCollectionViewDidEndDecelerating:atIndex:)]) {
        [self.horizontalCollectionViewScrollDelegate horizontalCollectionViewDidEndDecelerating:scrollView atIndex:currentIndex];
    }    
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    NSInteger targetIndex = floor((targetContentOffset->x - pageWidth / 2) / pageWidth) + 1;
    [self updatePageWithIndex:targetIndex];
    
    if ([self.horizontalCollectionViewScrollDelegate respondsToSelector:@selector(horizontalCollectionViewWillEndDragging:currentIndex:targetIndex:)]) {
        [self.horizontalCollectionViewScrollDelegate horizontalCollectionViewWillEndDragging:scrollView currentIndex:currentIndex targetIndex:targetIndex];
    }
}
#pragma --mark HorizontalCollectionViewDisplayCellDelegate
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    // 当前index两侧的cell
    if ([self.horizontalCellDisplayDelegate respondsToSelector:@selector(horizontalCollectionViewDidEndDisplayingCellAtIndexPath:)]) {
        [self.horizontalCellDisplayDelegate horizontalCollectionViewDidEndDisplayingCellAtIndexPath:indexPath.item];
    }
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    // 当前方向后两个
    if ([self.horizontalCellDisplayDelegate respondsToSelector:@selector(horizontalCollectionViewWillDisplayCellAtIndexPath:)]) {
        [self.horizontalCellDisplayDelegate horizontalCollectionViewWillDisplayCellAtIndexPath:indexPath.item];
    }
    
}

@end
