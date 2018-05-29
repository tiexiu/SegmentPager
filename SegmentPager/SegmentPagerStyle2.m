//
//  SegmentPagerViewControllerWithoutNavgationBar.m
//  SegmentPager
//
//  Created by s on 2018/5/18.
//  Copyright © 2018年 s. All rights reserved.
//

#import "SegmentPagerStyle2.h"
#import "HitTestScrollView.h"
#import "TitleScrollView.h"
#import "HorizontalCollectionView.h"

#import "BaseSubScrollViewControllerStyle2.h"
#import "TableViewControllerStyle2.h"
#import "ScrollViewControllerStyle2.h"
#import "CollectionViewControllerStyle2.h"

@interface SegmentPagerStyle2 ()<UIScrollViewDelegate,SubScrollViewDelegate,HorizontalCollectionViewScrollDelegate,TitleSelectedDelegate>
{
    CGFloat titleFontSize;
    // 顶部视图的高度
    CGFloat topEdgeInset;
    // 设置superScrollView是否可以滑动
    BOOL canSuperScrollViewScroll;
    // 获取subSvrollView的滑动方向
    CGFloat subScrollingOffsetY;
        
    // 这个变量用来获取和保存【单次拖拽过程中】titleY最小即最靠近屏幕上方的值
    CGFloat maxSuperScrollYToView;
    // 这个变量用来获取和保存【单次拖拽过程中】subScrollView最靠近屏幕底部的值
    CGFloat minSubScrollY;
}

// 头部视图
@property (nonatomic) UIImageView *banner;
//// 装载横滚collectionView
@property (nonatomic) HitTestScrollView *superScrollView;
//// 装载subViewControllers
@property (nonatomic) HorizontalCollectionView *horizontalCollectionView;
//// 装载标题栏
@property (nonatomic) TitleScrollView *titleScrollView;
@property (nonatomic) NSArray *titleArray;

@property (nonatomic) NSArray *vcArray;
@property (nonatomic) CollectionViewControllerStyle2 *collection;
@property (nonatomic) TableViewControllerStyle2 *table;
@property (nonatomic) ScrollViewControllerStyle2 *scroller;
@end

@implementation SegmentPagerStyle2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    topEdgeInset = 200;
    titleFontSize = 25;
    canSuperScrollViewScroll = YES;
    
    [self.view addSubview:self.banner];
    [self.view addSubview:self.superScrollView];
    [self.superScrollView addSubview:self.titleScrollView];
    [self.superScrollView addSubview:self.horizontalCollectionView];
}

#pragma --mark SubScrollViewDidScrollDelegate
- (void)subScrollViewWillBeginDraggin:(UIScrollView *)scrollView {
    // 设定开始拖拽时的offset为minSubScrollY的初始值
    subScrollingOffsetY = scrollView.contentOffset.y;

    minSubScrollY = scrollView.contentOffset.y;
}
- (void)subScrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 获取单次拖拽过程中subScrollView.contentOffset的极限值
    if (minSubScrollY > scrollView.contentOffset.y) {
        minSubScrollY = scrollView.contentOffset.y;
    }
    
    CGFloat currentSuperScrollViewYToView = -self.superScrollView.contentOffset.y;   //[200,0]
    // superScrollView在进行下拉刷新时，subScrillView不可以滑动
    if (currentSuperScrollViewYToView >= topEdgeInset) {
        [scrollView setContentOffset:CGPointMake(0, minSubScrollY)];
        return;
    }
    
    scrollView.bounces = scrollView.contentOffset.y > (scrollView.contentSize.height-scrollView.bounds.size.height)/2 ? YES : NO;
    
    CGFloat direction = subScrollingOffsetY - scrollView.contentOffset.y;
    if (direction > 0 ) {        // 下滑
        if (scrollView.contentOffset.y > 0) {
            [self.superScrollView setContentOffset:CGPointMake(0,-maxSuperScrollYToView)];    // superScrollView永远停在最靠近屏幕顶部的位置
            canSuperScrollViewScroll = NO;
        } else if (scrollView.contentOffset.y == 0) {
            canSuperScrollViewScroll = YES;
        }
    }else if (direction < 0 ) {  // 上滑
        if (scrollView.contentOffset.y > 0) {
            if (currentSuperScrollViewYToView > 0 && currentSuperScrollViewYToView <= topEdgeInset) {
                [scrollView setContentOffset:CGPointMake(0, minSubScrollY)];
                canSuperScrollViewScroll = YES;
            }else {
                canSuperScrollViewScroll = NO;
            }
        }
    }
    
    // 获取单次拖拽过程中superScrollView.contentOffset.y的极限值
    if (maxSuperScrollYToView > currentSuperScrollViewYToView && scrollView.contentOffset.y >= 0) {
        maxSuperScrollYToView = currentSuperScrollViewYToView;
    }
    
    subScrollingOffsetY = scrollView.contentOffset.y;
}

#pragma --mark UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    CGFloat currentSuperScrollViewYToView = -scrollView.contentOffset.y;   //[200,0]
    maxSuperScrollYToView = currentSuperScrollViewYToView ;      // 设置初始值
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (canSuperScrollViewScroll == NO) {
        [scrollView setContentOffset:CGPointMake(0,-maxSuperScrollYToView)];    // title永远停在y值最小的位置，即靠近屏幕上方的位置
    }
    if (scrollView.contentOffset.y >= 0) {
        [scrollView setContentOffset:CGPointZero];
    }
    // 头视图跟随弹簧效果移动
    CGFloat bannerY = -(topEdgeInset+scrollView.contentOffset.y) > 0 ? -(topEdgeInset+scrollView.contentOffset.y) : 0;
    self.banner.frame = (CGRect){CGPointMake(0,bannerY),self.banner.bounds.size};
}

#pragma --mark HorizontalCollectionViewScrollDelegate
// 横滚时subScrollView不可以滚动
- (void)horizontalCollectionViewWillBegingDragging:(UIScrollView *)scrollView atIndex:(NSInteger)index{
    BaseSubScrollViewControllerStyle2 *vc = (BaseSubScrollViewControllerStyle2 *)self.vcArray[index];
    vc.baseScrollView.scrollEnabled = NO;
    
}
- (void)horizontalCollectionViewDidEndDecelerating:(UIScrollView *)scrollView atIndex:(NSInteger)index{
    BaseSubScrollViewControllerStyle2 *vc = (BaseSubScrollViewControllerStyle2 *)self.vcArray[index];
    vc.baseScrollView.scrollEnabled = YES;
}
- (void)horizontalCollectionViewWillEndDragging:(UIScrollView *)scrollView currentIndex:(NSInteger)currentIndex targetIndex:(NSInteger)targetIndex{
    [self.titleScrollView updateTitleScrollViewWithIndex:targetIndex];
    // 切换到新的控制器，默认superScroll可以滑动
    canSuperScrollViewScroll = YES;
}

#pragma --mark TitleSelectedDelegate
- (void)titleSelected:(NSInteger)index {
    [self.horizontalCollectionView updatePageWithIndex:index];
    // 切换到新的控制器，默认superScroll可以滑动
    canSuperScrollViewScroll = YES;
}

#pragma --mark LazyLoad
- (HitTestScrollView *)superScrollView {
    if (_superScrollView == nil) {
        CGRect superScrollViewFrame = CGRectMake(0,0,CGRectGetWidth(self.view.frame),CGRectGetHeight(self.view.frame)-CGRectGetHeight(self.navigationController.navigationBar.frame)-CGRectGetHeight([UIApplication sharedApplication].statusBarFrame));
        _superScrollView = [[HitTestScrollView alloc] initWithFrame:superScrollViewFrame];
        _superScrollView.contentSize = superScrollViewFrame.size;
        _superScrollView.contentInset = UIEdgeInsetsMake(topEdgeInset, 0, 0, 0);
        _superScrollView.contentOffset = CGPointMake(0,-topEdgeInset);
        _superScrollView.delegate = self;
        _superScrollView.bounces = YES;
        _superScrollView.showsVerticalScrollIndicator = NO;
        _superScrollView.showsHorizontalScrollIndicator = NO;
        
        
    }
    return _superScrollView;
}

- (TitleScrollView *)titleScrollView {
    if (_titleScrollView == nil) {
        UIFont *titleFont = [UIFont systemFontOfSize:titleFontSize];
        _titleScrollView = [[TitleScrollView alloc] initWithFrame:(CGRect){CGPointMake(0, 0),CGSizeMake(CGRectGetWidth(self.superScrollView.frame), ceil(titleFont.lineHeight))}];
        [_titleScrollView titleScrollViewWithTitleArray:self.titleArray font:titleFont initialIndex:0];
        _titleScrollView.titleSelectedDelegate = self;
    }
    return _titleScrollView;
}

- (HorizontalCollectionView *)horizontalCollectionView {
    if (_horizontalCollectionView == nil) {
        CGFloat collectionViewWidth = CGRectGetWidth(self.superScrollView.frame);
        CGFloat collectionViewHeight = CGRectGetHeight(self.superScrollView.frame) - CGRectGetHeight(self.titleScrollView.frame);
        CGPoint collectionViewOrgin = CGPointMake(0, CGRectGetMaxY(self.titleScrollView.frame));
        CGSize collectionViewSize = CGSizeMake(collectionViewWidth, collectionViewHeight);
        _horizontalCollectionView = [[HorizontalCollectionView alloc] initWithFrame:(CGRect){collectionViewOrgin,collectionViewSize}];
        [_horizontalCollectionView contentCollectionViewWithControllers:self.vcArray index:0];
        _horizontalCollectionView.horizontalCollectionViewScrollDelegate = self;
    }
    return _horizontalCollectionView;
}

- (NSArray *)titleArray {
    if (_titleArray == nil) {
        _titleArray = [NSArray arrayWithObjects:@"tableView",@"scrollView",@"collectionView",@"4",@"你看你妈呢", nil];
    }
    return _titleArray;
}

- (NSArray *)vcArray {
    if (!_vcArray) {
        _vcArray = [[NSMutableArray alloc] init];
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:self.titleArray.count];
        
        [array addObjectsFromArray:@[self.table,self.scroller,self.collection,self.table,self.scroller]];
        _vcArray = array;
    }
    return _vcArray;
}

- (UIImageView *)banner {
    if (_banner == nil) {
        CGRect bannerFrame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), topEdgeInset);
        _banner = [[UIImageView alloc] initWithFrame:bannerFrame];
        _banner.image = [UIImage imageNamed:@"banner1"];
        _banner.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _banner;
}

- (TableViewControllerStyle2 *)table {
    if (!_table) {
        _table = [[TableViewControllerStyle2 alloc] init];
        _table.subScrollViewDelegate = self;
    }
    return _table;
}

- (CollectionViewControllerStyle2 *)collection {
    if (!_collection) {
        _collection = [[CollectionViewControllerStyle2 alloc] init];
        _collection.subScrollViewDelegate = self;
    }
    return _collection;
}

- (ScrollViewControllerStyle2 *)scroller {
    if (!_scroller) {
        _scroller = [[ScrollViewControllerStyle2 alloc] init];
        _scroller.subScrollViewDelegate = self;
    }
    return _scroller;
}

@end