//
//  SLSegmentPageView.h
//  wjw2
//
//  Created by SHAO LEI on 17/4/27.
//  Copyright © 2017年 Huaao Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,SLSegmentPageSeparateStyle) {
    SLSegmentPageSeparateStyleNone = 2,
    SLSegmentPageSeparateStyleFull = 1,
    SLSegmentPageSeparateStyleSingleLine = 0,
    SLSegmentPageSeparateStyleOverall = 3,
};


@class SLSegmentPageView;

@protocol SLSegmentPageViewDateSource <NSObject>

@required
- (NSInteger)slSegmentPageNumberOfPage;
- (NSString *)slSegmentPageTitleForItem:(NSInteger)item;
- (UIViewController *)slSegmentPageWithSubviewsForItem:(NSInteger)item;

@end

@protocol SLSegmentPageViewDelegate <NSObject>

@optional
- (void)slSegmentPageView:(SLSegmentPageView *)SegmentPageView selectItem:(NSInteger)item;

@end

@interface SLSegmentPageView : UIView

@property (nonatomic, assign) CGFloat titleWidth; //default titleArr total with equal to screenWith
@property (nonatomic, strong) UIColor *titleColor;  //default the color equal to  the navigation bar
@property (nonatomic, strong) UIColor *lineColor;   //default equal to titleColor;
@property (nonatomic, strong) UIColor *tintColor;   //default equal to lightGrayColor;
@property (nonatomic, assign) NSInteger selectOne; //default show first view
@property (nonatomic, assign) BOOL pageScrollEnabled;  //contentScrollView default NO
@property (nonatomic, assign) SLSegmentPageSeparateStyle separateStyle;

//block create pageview or make delegate create
@property (nonatomic,weak)id<SLSegmentPageViewDelegate> delegate; //nullable
@property (nonatomic,weak)id<SLSegmentPageViewDateSource> dataSource; //nullable
/*
 * priority
 * RETURN NSArray  is title name array , type is NSString
 * RETURN UIViewController is each item show viewcontroller
 */
- (void)slSegmentPageWithTitleArr:(NSArray *(^)())titleArr contentController:(UIViewController *(^)(NSInteger item))showView;

@end

@interface UIViewController (PageFrame)

//show content frame
@property (nonatomic,assign)CGRect currentBounds;

@end

