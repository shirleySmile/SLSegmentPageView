//
//  SLSegmentPageView.h
//  wjw2
//
//  Created by SHAO LEI on 17/4/27.
//  Copyright © 2017年 Huaao Tech. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SLSegmentPageView : UIView


/**
 one item view
 */
@property (nonatomic, assign) CGFloat titleWidth; //default titleArr total with equal to screenWith
@property (nonatomic, weak) UIColor *selectTitleColor;  //default the color equal to  the black
@property (nonatomic, weak) UIColor *defaultTitleColor;  //default darkGrayColor
@property (nonatomic, weak) UIColor *selectLineColor; //default titleColor

/**
 titleView for line
 */
@property (nonatomic, assign) BOOL hasSeparateLine;   // has separate line view. default no
@property (nonatomic, assign) BOOL hasBottomLine;   // has separate line view. default no
@property (nonatomic, weak) UIColor *separateLineColor; //default lightGrayColor
@property (nonatomic, weak) UIColor *bottomLineColor; //default lightGrayColor

/**
 function
 */
@property (nonatomic, weak) UIColor *titleBgColor; //title view background color
@property (nonatomic, assign) NSInteger selectOne; //default show first view
@property (nonatomic, assign) BOOL pageScrollEnabled;  //contentScrollView default yes



/** 根据标题数组的个数显示 界面数量   titleArr kind of NSString */
- (void)slPageTitleArr:(NSArray *(^)(void))titleArr contentController:(UIViewController *(^)(NSInteger item))showView;

//根据显示界面数量，显示不同的标题 不同的界面
- (void)slPageNumber:(NSInteger)number title:(NSString *(^)(NSInteger item))title contentController:(UIViewController *(^)(NSInteger item))showView;

/**当前显示的是哪一个界面**/
- (void)slPageItem:(void (^)(UIViewController *currentVC,NSInteger item))item;


@end

@interface UIViewController (PageFrame)

//show content frame
@property (nonatomic,assign)CGRect currentBounds;

@end

