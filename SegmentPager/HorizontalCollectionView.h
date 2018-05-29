//
//  ContentCollectionView.h
//  s1
//
//  Created by s on 2018/5/10.
//  Copyright © 2018年 s. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HorizontalCollectionViewDisplayCellDelegate<NSObject>
@optional
- (void)horizontalCollectionViewWillDisplayCellAtIndexPath:(NSInteger)index;
- (void)horizontalCollectionViewDidEndDisplayingCellAtIndexPath:(NSInteger)index;

@end

@protocol HorizontalCollectionViewScrollDelegate<NSObject>
@optional
- (void)horizontalCollectionViewWillBegingDragging:(UIScrollView *)scrollView atIndex:(NSInteger)index;
- (void)horizontalCollectionViewWillEndDragging:(UIScrollView *)scrollView currentIndex:(NSInteger)currentIndex targetIndex:(NSInteger)targetIndex;
- (void)horizontalCollectionViewDidEndDecelerating:(UIScrollView *)scrollView atIndex:(NSInteger)index;


@end


@interface HorizontalCollectionView : UICollectionView

@property (nonatomic,weak) id<HorizontalCollectionViewDisplayCellDelegate>horizontalCellDisplayDelegate;

@property (nonatomic,weak) id<HorizontalCollectionViewScrollDelegate>horizontalCollectionViewScrollDelegate;

- (void)contentCollectionViewWithControllers:(NSArray *)controllersArray index:(NSUInteger)index;

- (void)updatePageWithIndex:(NSUInteger)index;

@end
