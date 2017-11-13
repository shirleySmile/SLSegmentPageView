//
//  SLViewController.m
//  SLSegmentPageView
//
//  Created by 276482207 on 05/03/2017.
//  Copyright (c) 2017 276482207. All rights reserved.
//

#import "SLViewController.h"
#import <SLSegmentPageView/SLSegmentPageView.h>

@interface SLViewController ()

@end

@implementation SLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *color = @[[UIColor redColor],[UIColor yellowColor],[UIColor blueColor],[UIColor greenColor],[UIColor purpleColor],];
    SLSegmentPageView *page = [[SLSegmentPageView alloc] initWithFrame:CGRectMake(20, 64, self.view.frame.size.width-40, 300)];
    [page slPageTitleArr:^NSArray *{
         return @[@"好好",@"学习",@"✨",@"天天",@"向上"];
    } contentController:^UIViewController *(NSInteger item) {
        UIViewController *Vc = [[UIViewController alloc] init];
        Vc.view.backgroundColor = color[item];
        return Vc;
    }];

    [self.view addSubview:page];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
