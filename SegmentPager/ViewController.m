//
//  ViewController.m
//  SegmentPager
//
//  Created by s on 2018/5/16.
//  Copyright © 2018年 s. All rights reserved.
//

#import "ViewController.h"
#import "SegmentPagerStyle2.h"
#import "SegmentPagerStyle1.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    for (int i = 0; i < 2; i ++) {
        NSArray *titleArray = [NSArray arrayWithObjects:
                               @"Each SubTableView Can Pull To Refresh",
                               @"Only Main SuperView Can Pull To Refresh",
                               nil];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setFrame:CGRectMake(0, i*(40+20)+100, self.view.bounds.size.width, 40)];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:20];
        button.tag = i;
        [button addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
}

- (void)push:(UIButton *)button {
    if (button.tag == 0) {
        SegmentPagerStyle1 *vc= [[SegmentPagerStyle1 alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(button.tag == 1) {
        SegmentPagerStyle2 *vc = [[SegmentPagerStyle2 alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
