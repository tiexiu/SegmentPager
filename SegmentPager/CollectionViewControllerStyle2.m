//
//  CollectionViewControllerStyle2.m
//  SegmentPagerStyle1
//
//  Created by s on 2018/5/25.
//  Copyright © 2018年 s. All rights reserved.
//

#import "CollectionViewControllerStyle2.h"
#import "GestureRecognizerCollectionView.h"


static NSString *collectionCellStyle2ID = @"collectionCellStyle2ID";
@interface CollectionViewControllerStyle2 ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic) GestureRecognizerCollectionView *collection;
@property (nonatomic) UICollectionViewFlowLayout *flowLayout;

@end

@implementation CollectionViewControllerStyle2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.baseScrollView = self.collection;
    [self.view addSubview:self.collection];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((self.view.bounds.size.width-30)/2, 200);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

#pragma mark -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 14;
}
// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self.collection dequeueReusableCellWithReuseIdentifier:collectionCellStyle2ID forIndexPath:indexPath];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    UILabel *label = [[UILabel alloc] initWithFrame:cell.bounds];
    //    label.text = [NSString stringWithFormat:@"%ld",indexPath.];
    [cell addSubview:label];
    cell.backgroundColor = randomColor;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"选中第%ld个cell",indexPath.row);
}

- (GestureRecognizerCollectionView *)collection {
    if (_collection == nil) {
        _collection = [[GestureRecognizerCollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:self.flowLayout];
        _collection.dataSource = self;
        _collection.delegate = self;
        _collection.showsVerticalScrollIndicator = NO;
        _collection.showsHorizontalScrollIndicator = NO;
        [_collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:collectionCellStyle2ID];
        _collection.bounces = NO;
        _collection.backgroundColor = [UIColor whiteColor];
        _collection.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return _collection;
}
-(UICollectionViewFlowLayout *)flowLayout {
    if (_flowLayout == nil) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _flowLayout.sectionHeadersPinToVisibleBounds = YES;
    }
    return _flowLayout;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
