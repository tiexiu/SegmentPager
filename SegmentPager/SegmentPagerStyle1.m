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


@interface SegmentPagerStyle1 ()<SubScrollViewDelegate,HorizontalCollectionViewDisplayCellDelegate,HorizontalCollectionViewScrollDelegate,TitleSelectedDelegate>
{
    CGFloat titleFontSize;
    CGFloat titleScrollHeight;
    CGFloat pageWidth;
    CGFloat pageHeight;
    
    // 顶部视图的高度
    CGFloat topEdgeInset;
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

@property (nonatomic) NSMutableDictionary *leavingDic;
@property (nonatomic) NSMutableDictionary *enteringDic;

//@property (nonatomic) UIView *statusBackgroundView;
@end

@implementation SegmentPagerStyle1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    self.view.backgroundColor = [UIColor whiteColor];
    pageWidth = self.view.bounds.size.width;
    pageHeight = self.view.bounds.size.height;
    topEdgeInset = BANNER_HEIGHT;
    titleFontSize = SCROLLTITLE_FONTSIZE;
    scrollingOffsetY = -topEdgeInset;
    titleScrollHeight = (ceil)([UIFont systemFontOfSize:titleFontSize].lineHeight);
    
    [self.view addSubview:self.horizontalCollection];
    [self.view addSubview:self.titleScrollBackgroundView];
    [self.view bringSubviewToFront:self.titleScrollBackgroundView];
    [self.titleScrollBackgroundView addSubview:self.titleScroll];
    [self.titleScrollBackgroundView addSubview:self.bannerBackview];
    [self.bannerBackview addSubview:self.banner];
//    [self.titleScrollBackgroundView addSubview:self.statusBackgroundView];
//    [self.titleScrollBackgroundView bringSubviewToFront:self.statusBackgroundView];
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
    }else if (offsetY < -topEdgeInset) {
        offsetY = -topEdgeInset;
    }
       
    CGFloat scrollerYInView = [scrollView convertRect:scrollView.frame toView:self.view].origin.y;
    
    CGFloat scrollDirection = scrollingOffsetY - scrollView.contentOffset.y;
    if (scrollDirection > 0) {       // 下滑
        if (scrollerYInView >= self.titleScroll.bottom) {
//            NSLog(@"scroll头在title下方");
            self.titleScroll.bottom = -offsetY ;
        }else {
//            NSLog(@"scroll头在上方");
        }
    }else if (scrollDirection < 0) {      // 上滑
        if (scrollView.contentOffset.y > -topEdgeInset) {
            self.titleScroll.top = (self.titleScroll.top + scrollDirection ) < 0 ? 0 : (self.titleScroll.top + scrollDirection);
        }else {     // scrollView在title下方进行弹性滑动
            self.titleScroll.bottom = topEdgeInset;
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
    CGFloat leavingBottom = (flag) ? [[self.leavingDic objectForKey:key] floatValue] : topEdgeInset;
    CGFloat enteringBottom = [[self.enteringDic objectForKey:key] floatValue];
    
    UIViewController *vc = self.vcArray[index];
    if ([NSStringFromClass(vc.superclass) isEqualToString:@"BaseSubScrollViewControllerStyle1"] ) {
        BaseSubScrollViewControllerStyle1 *v = (BaseSubScrollViewControllerStyle1 *)vc;
        CGFloat contentOffsetY = v.baseScrollView.contentOffset.y;
        v.baseScrollView.contentOffset = CGPointMake(0, contentOffsetY-enteringBottom+leavingBottom);
    }
}
#pragma --mark 监听事件
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    CGRect titleRect = [(NSValue *)[change objectForKey:@"new"] CGRectValue];
    CGFloat titleBottom = titleRect.origin.y + titleRect.size.height;
    CGFloat titleHeight = titleRect.size.height;

    self.bannerBackview.frame = CGRectMake(0, titleBottom-topEdgeInset, pageWidth, topEdgeInset-titleHeight);
    self.banner.frame = CGRectMake(0,topEdgeInset -titleBottom, pageWidth, topEdgeInset-titleHeight);
//    self.statusBackgroundView.alpha = (topEdgeInset-titleBottom)/(topEdgeInset-titleHeight);
}
#pragma --mark bannerTapAction
- (void)tapOnImage {
    NSLog(@"点击图片");
}
#pragma --mark HorizontalCollectionViewScrollDelegate
- (void)horizontalCollectionViewWillEndDragging:(UIScrollView *)scrollView currentIndex:(NSInteger)currentIndex targetIndex:(NSInteger)targetIndex{
  
    [self.titleScroll updateTitleScrollViewWithIndex:targetIndex];
    UIViewController *vc = self.vcArray[targetIndex];
    if ([NSStringFromClass(vc.superclass) isEqualToString:@"BaseSubScrollViewController"]) {
        BaseSubScrollViewControllerStyle1 *v = (BaseSubScrollViewControllerStyle1 *)vc;
        scrollingOffsetY = v.baseScrollView.contentOffset.y;
    }
}


#pragma --mark TitleSelectedDelegate
- (void)titleSelected:(NSInteger)index {
    [self.horizontalCollection updatePageWithIndex:index];
    UIViewController *vc = self.vcArray[index];
    if ([NSStringFromClass(vc.superclass) isEqualToString:@"BaseSubScrollViewController"]) {
        BaseSubScrollViewControllerStyle1 *v = (BaseSubScrollViewControllerStyle1 *)vc;
        scrollingOffsetY = v.baseScrollView.contentOffset.y;
    }
}

#pragma --mark lazyLoad
- (TitleScrollView *)titleScroll {
    if (_titleScroll == nil) {
        _titleScroll = [[TitleScrollView alloc] initWithFrame:(CGRect){
            CGPointMake(0, topEdgeInset-titleScrollHeight) ,
            CGSizeMake(CGRectGetWidth(self.view.frame), titleScrollHeight)
        }];
        [_titleScroll titleScrollViewWithTitleArray:self.titleArray font:[UIFont systemFontOfSize:titleFontSize] initialIndex:0];
        _titleScroll.titleSelectedDelegate = self;
        [_titleScroll addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _titleScroll;
}
- (HorizontalCollectionView *)horizontalCollection {
    if (_horizontalCollection == nil) {
        _horizontalCollection = [[HorizontalCollectionView alloc] initWithFrame:CGRectMake(0, 0, pageWidth, pageHeight)];
        [_horizontalCollection contentCollectionViewWithControllers:self.vcArray index:0];
        _horizontalCollection.horizontalCollectionViewScrollDelegate = self;
        _horizontalCollection.horizontalCellDisplayDelegate = self;
    }
    return _horizontalCollection;
}

- (HitTestView *)titleScrollBackgroundView {
    if (!_titleScrollBackgroundView) {
        _titleScrollBackgroundView = [[HitTestView alloc] initWithFrame:CGRectMake(0, 0, pageWidth, pageHeight)];
        _titleScrollBackgroundView.backgroundColor = [UIColor clearColor];
    }
    return _titleScrollBackgroundView;
}
- (NSArray *)titleArray {
    if (_titleArray == nil) {
        _titleArray = [NSArray arrayWithObjects:@"tableView",@"collectionView",@"scrollView", nil];
    }
    return _titleArray;
}

- (NSArray *)vcArray {
    if (!_vcArray) {
        _vcArray = [[NSMutableArray alloc] init];
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:self.titleArray.count];
        [array addObjectsFromArray:@[self.table,self.collection,self.scroller]];
        _vcArray = array;
    }
    return _vcArray;
}
- (UIView *)bannerBackview {
    if (!_bannerBackview) {
        _bannerBackview = [[UIView alloc] initWithFrame:CGRectMake(0,0, pageWidth, topEdgeInset-self.titleScroll.height)];
        _bannerBackview.clipsToBounds = YES;
    }
    return _bannerBackview;
}
- (UIView *)banner {
    if (!_banner) {
        _banner = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , pageWidth, topEdgeInset-self.titleScroll.height)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:_banner.bounds];
        imageView.image = [UIImage imageNamed:@"banner1"];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer *p = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnImage)];
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
//- (UIView *)statusBackgroundView {
//    if (!_statusBackgroundView) {
//        CGRect frame = self.navigationController.navigationBar.frame;
//        _statusBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, frame.size.width, 20)];
//        _statusBackgroundView.backgroundColor = [UIColor whiteColor];
//        _statusBackgroundView.alpha = 0;
//        _statusBackgroundView.userInteractionEnabled = NO;
//    }
//    return _statusBackgroundView;
//}


@end
