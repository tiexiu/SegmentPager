//
//  TableViewControllerStyle2.m
//  SegmentPagerStyle1
//
//  Created by s on 2018/5/25.
//  Copyright © 2018年 s. All rights reserved.
//

#import "TableViewControllerStyle2.h"
#import "GestureRecognizerTableView.h"

static NSString *const tableCellStyle2ID = @"TableCellIDStyle2";
static CGFloat const rowHeight = 44.0f;

@interface TableViewControllerStyle2 ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger arrayCount;
}
@property (nonatomic) GestureRecognizerTableView *tableView;
@end

@implementation TableViewControllerStyle2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    self.baseScrollView = self.tableView;
}


#pragma --mark delegate&dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellStyle2ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableCellStyle2ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击了第%ld个cell",indexPath.row);
}

- (GestureRecognizerTableView *)tableView {
    if (!_tableView) {
        _tableView = [[GestureRecognizerTableView alloc] initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = rowHeight;
        _tableView.bounces = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:tableCellStyle2ID];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return _tableView;
}

@end
