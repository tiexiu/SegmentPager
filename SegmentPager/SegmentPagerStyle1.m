//
//  NewSegmentPagerViewController.m
//  SegmentPager
//
//  Created by s on 2018/5/21.
//  Copyright © 2018年 s. All rights reserved.
//

#import "SegmentPagerStyle1.h"
#import "HorizontalCollectionView.h"
#import "TitleScrollView.h"
#import "TableViewControllerStyle1.h"
#import "CollectionViewControllerStyle1.h"
#import "ScrollViewControllerStyle1.h"
#import "UIView+Layer.h"
#import "HitTestView.h"

static CGFloat const bannerHeight = 200.0f;
static CGFloat const titleScrollHeight = 40.0f;
static CGFloat const sumBannerTitleHeight = 200.0f + 40.0f;

@interface SegmentPagerStyle1 ()<SubScrollViewDelegate,HorizontalCollectionViewDisplayCellDelegate,HorizontalCollectionViewScrollDelegate,TitleSelectedDelegate>
{
    // 获取subSvrollView的滑动方向
    CGFloat scrollingOffsetY;
}
@property (nonatomic) UIView *bannerBackview;
@property (nonatomic) UIView *banner;

@property (nonatomic) NSArray *titleArray;
@property (nonatomic) TitleScrollView *titleScroll;
@property (nonatomic) HitTestView *titleScrollBackgroundView;

@property (nonatomic) HorizontalCollectionView *horizontalCollection;
@property (nonatomic) NSArray *vcArray;
@property (nonatomic) TableViewControllerStyle1 *table;
@property (nonatomic) CollectionViewControllerStyle1 *collection;
@property (nonatomic) ScrollViewControllerStyle1 *scroller;

@property (nonatomic) UIAlertController *alert;

// 上次离开某页面时title的位置
@property (nonatomic) NSMutableDictionary *leavingDic;
//  准备进入某页面是title的位置
@property (nonatomic) NSMutableDictionary *enteringDic;

@end

@implementation SegmentPagerStyle1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Style1";
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    scrollingOffsetY = -bannerHeight;
    
    self.titleArray = @[@"tableView",@"collectionView",@"scrollView"];
    self.vcArray = @[self.table,self.collection,self.scroller];

    [self.view addSubview:self.horizontalCollection];
    [self.view addSubview:self.titleScrollBackgroundView];
    [self.view bringSubviewToFront:self.titleScrollBackgroundView];
    [self.titleScrollBackgroundView addSubview:self.titleScroll];
    [self.titleScrollBackgroundView addSubview:self.bannerBackview];
    [self.bannerBackview addSubview:self.banner];
}

#pragma --mark SubScrollViewDidScrollDelegate
- (void)subScrollViewWillBeginDraggin:(UIScrollView *)scrollView {
    scrollingOffsetY = scrollView.contentOffset.y;
}
- (void)subScrollViewDidScroll:(UIScrollView *)scrollView {
    // 横滚不触发移动titleScrollView事件
    if (scrollView.isDecelerating == NO && scrollView.isTracking == NO && scrollView.isDragging == NO){
        return;
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;  // [-200~0]
    if (offsetY > -titleScrollHeight) {
        offsetY = -titleScrollHeight;
    }else if (offsetY < -sumBannerTitleHeight) {
        offsetY = -sumBannerTitleHeight;
    }
       
    CGFloat scrollerYInView = [scrollView convertRect:scrollView.frame toView:self.view].origin.y;
    
    CGFloat scrollDirection = scrollingOffsetY - scrollView.contentOffset.y;
    if (scrollDirection > 0) {       // 下滑
        if (scrollerYInView >= self.titleScroll.bottom) {
            self.titleScroll.bottom = -offsetY ;
        }
    }else if (scrollDirection < 0) {      // 上滑
        if (scrollView.contentOffset.y > -sumBannerTitleHeight) {
            self.titleScroll.top = (self.titleScroll.top + scrollDirection ) < 0 ? 0 : (self.titleScroll.top + scrollDirection);
        }else {
            self.titleScroll.bottom = sumBannerTitleHeight;
        }
    }
    scrollingOffsetY = scrollView.contentOffset.y;
}

#pragma --mark HorizontalCollectionViewWillDisplayCellDelegate
- (void)horizontalCollectionViewDidEndDisplayingCellAtIndexPath:(NSInteger)index {
    // 当前index两侧的cell
    // 离开页面的值
    NSNumber *num = [NSNumber numberWithFloat:self.titleScroll.bottom];
    NSString *key = [NSString stringWithFormat:@"%ld",(long)index];
    [self.leavingDic setObject:num forKey:key];
}
- (void)horizontalCollectionViewWillDisplayCellAtIndexPath:(NSInteger)index {
    // 将要显示页面
    NSNumber *num = [NSNumber numberWithFloat:self.titleScroll.bottom];
    NSString *key = [NSString stringWithFormat:@"%ld",(long)index];
    [self.enteringDic setObject:num forKey:key];
    
    BOOL flag = [[self.leavingDic allKeys] containsObject:key];
    CGFloat leavingBottom = (flag) ? [[self.leavingDic objectForKey:key] floatValue] : sumBannerTitleHeight;
    CGFloat enteringBottom = [[self.enteringDic objectForKey:key] floatValue];
    
    BaseSubScrollViewControllerStyle1 *vc = (BaseSubScrollViewControllerStyle1 *)self.vcArray[index];
    CGFloat contentOffsetY = vc.baseScrollView.contentOffset.y;
    vc.baseScrollView.contentOffset = CGPointMake(0, contentOffsetY-enteringBottom+leavingBottom);
}
#pragma --mark 监听事件
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    CGRect titleRect = [(NSValue *)[change objectForKey:@"new"] CGRectValue];
    CGFloat titleBottom = CGRectGetMaxY(titleRect);
    CGFloat titleHeight = CGRectGetHeight(titleRect);

    self.bannerBackview.frame = CGRectMake(0, titleBottom-bannerHeight-titleHeight, CGRectGetWidth(self.view.frame), bannerHeight);
    self.banner.frame = CGRectMake(0,bannerHeight+titleHeight -titleBottom, CGRectGetWidth(self.view.frame), bannerHeight);
}
#pragma --mark bannerTapAction
- (void)tapOnBanner {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"点击头图" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:NO completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:nil];
        });
    }];

}
#pragma --mark HorizontalCollectionViewScrollDelegate
- (void)horizontalCollectionViewWillEndDragging:(UIScrollView *)scrollView currentIndex:(NSInteger)currentIndex targetIndex:(NSInteger)targetIndex{
  
    [self.titleScroll updateTitleScrollViewWithIndex:targetIndex];
    
    BaseSubScrollViewControllerStyle1 *vc = (BaseSubScrollViewControllerStyle1 *)self.vcArray[targetIndex];
    scrollingOffsetY = vc.baseScrollView.contentOffset.y;
}
#pragma --mark TitleSelectedDelegate
- (void)titleSelected:(NSInteger)index {
    [self.horizontalCollection updatePageWithIndex:index];

    BaseSubScrollViewControllerStyle1 *vc = (BaseSubScrollViewControllerStyle1 *)self.vcArray[index];
    scrollingOffsetY = vc.baseScrollView.contentOffset.y;
    
}
#pragma --mark lazyLoad
- (TitleScrollView *)titleScroll {
    if (_titleScroll == nil) {
        _titleScroll = [[TitleScrollView alloc] initWithFrame:(CGRect){
            CGPointMake(0, bannerHeight) ,
            CGSizeMake(CGRectGetWidth(self.view.frame), titleScrollHeight)
        }];
        [_titleScroll titleScrollViewWithTitleArray:self.titleArray height:titleScrollHeight initialIndex:0];
        _titleScroll.titleSelectedDelegate = self;
        [_titleScroll addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _titleScroll;
}
- (HorizontalCollectionView *)horizontalCollection {
    if (_horizontalCollection == nil) {
        _horizontalCollection = [[HorizontalCollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
        [_horizontalCollection contentCollectionViewWithControllers:self.vcArray index:0];

        _horizontalCollection.horizontalCollectionViewScrollDelegate = self;
        _horizontalCollection.horizontalCellDisplayDelegate = self;
    }
    return _horizontalCollection;
}

- (HitTestView *)titleScrollBackgroundView {
    if (!_titleScrollBackgroundView) {
        _titleScrollBackgroundView = [[HitTestView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
        _titleScrollBackgroundView.backgroundColor = [UIColor clearColor];
    }
    return _titleScrollBackgroundView;
}

- (UIView *)bannerBackview {
    if (!_bannerBackview) {
        _bannerBackview = [[UIView alloc] initWithFrame:CGRectMake(0,0, CGRectGetWidth(self.view.frame), bannerHeight)];
        _bannerBackview.clipsToBounds = YES;
    }
    return _bannerBackview;
}
- (UIView *)banner {
    if (!_banner) {
        _banner = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , CGRectGetWidth(self.view.frame), bannerHeight)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:_banner.bounds];
        imageView.image = [UIImage imageNamed:@"banner1"];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer *p = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnBanner)];
        [_banner addGestureRecognizer:p];
        [_banner addSubview:imageView];
    }
    return _banner;
}

- (TableViewControllerStyle1 *)table {
    if (!_table) {
        _table = [[TableViewControllerStyle1 alloc] init];
        _table.subScrollViewDidScrollDelegate = self;
    }
    return _table;
}

- (CollectionViewControllerStyle1 *)collection {
    if (!_collection) {
        _collection = [[CollectionViewControllerStyle1 alloc] init];
        _collection.subScrollViewDidScrollDelegate = self;
        
    }
    return _collection;
}
- (ScrollViewControllerStyle1 *)scroller {
    if (!_scroller) {
        _scroller = [[ScrollViewControllerStyle1 alloc] init];
        _scroller.subScrollViewDidScrollDelegate = self;
    }
    return _scroller;
}

- (NSMutableDictionary *)leavingDic {
    if (!_leavingDic) {
        _leavingDic = [NSMutableDictionary dictionary];
    }
    return _leavingDic;
}
- (NSMutableDictionary *)enteringDic {
    if (!_enteringDic) {
        _enteringDic = [NSMutableDictionary dictionary];
    }
    return _enteringDic;
}


@end
