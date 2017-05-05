//
//  SLSegmentPageView.m
//  wjw2
//
//  Created by SHAO LEI on 17/4/27.
//  Copyright © 2017年 Huaao Tech. All rights reserved.
//

#import "SLSegmentPageView.h"
#import "objc/runtime.h"

static const float SLSegmentPageTitleHeight  = 44.0;
static const float SLSegmentPageTitleFont = 15.0;
static const NSInteger SLSegmentPageTitleTag = 1056501;
const char *SLSegmentPageOriginalW;
const char *SLSegmentPageOriginalH;
const char *SLSegmentPageTitleArrAction;
const char *SLSegmentPageContentControllerAction;

@interface SLSegmentPageView ()<UIScrollViewDelegate>
{
    NSInteger _totalBtnNum;
    BOOL _isBlock;
}
@property (nonatomic, weak)UIScrollView *titleScrollView;
@property (nonatomic, weak) UIScrollView *contentScrollView;
@property (nonatomic, strong)NSMutableArray<__kindof UIButton *> *btnMuArr;
@property (nonatomic, weak) UIView *lineView;
@property (nonatomic, strong)NSSet *controllerSet;

@end


@implementation SLSegmentPageView

- (void)dealloc
{
    _lineView = nil;
    [_contentScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _contentScrollView =nil;
    _titleScrollView = nil;
    _btnMuArr = nil;
    _titleColor = nil;
}

- (void)layoutSubviews{
    [self createShowView];
}

- (void) initData{
    _pageScrollEnabled = NO;
    self.backgroundColor = [UIColor whiteColor];
    _titleColor = _lineColor =[UIColor blackColor];
    _tintColor = [UIColor lightGrayColor];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)slSegmentPageWithTitleArr:(NSArray *(^)())titleArr contentController:(UIViewController *(^)(NSInteger))showView{
    _isBlock = YES;
    objc_setAssociatedObject(self, &SLSegmentPageTitleArrAction, titleArr, OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &SLSegmentPageContentControllerAction, showView, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(void)createShowView{
    if (self.dataSource || _isBlock) {
        [self createClassfiyTitle];
        [self createContentView];
    }
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    if(_titleScrollView){
        _titleScrollView.frame = CGRectMake(0, 0, self.frame.size.width,SLSegmentPageTitleHeight);
    }
    if(_contentScrollView){
        _contentScrollView.frame = CGRectMake(0, SLSegmentPageTitleHeight, self.frame.size.width, self.frame.size.height-SLSegmentPageTitleHeight);
    }
}


#pragma mark 创建分类标题view
-(void)createClassfiyTitle{
    [self.titleScrollView removeFromSuperview];
    NSArray *titleArr;
    if (_isBlock) {
        NSArray *(^titleArrBlock)() = objc_getAssociatedObject(self, &SLSegmentPageTitleArrAction);
        if (titleArrBlock) {
            titleArr = titleArrBlock();
            _totalBtnNum = [titleArr count];
        }
    }else{
       _totalBtnNum = [self.dataSource slSegmentPageNumberOfPage];
    }
    _titleWidth = (_titleWidth ? _titleWidth : self.frame.size.width / _totalBtnNum);
    UIScrollView *titleSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,SLSegmentPageTitleHeight)];
    titleSV.contentSize = CGSizeMake(_titleWidth*_totalBtnNum, 0);
    titleSV.backgroundColor= [UIColor clearColor];
    titleSV.showsHorizontalScrollIndicator = NO;
    [self addSubview:titleSV];

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, SLSegmentPageTitleHeight-1, _titleWidth*_totalBtnNum, 1)];
    line.backgroundColor = self.tintColor;
    [titleSV addSubview:line];
    
    for (NSInteger i = 0; i<_totalBtnNum; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*_titleWidth, 0, _titleWidth, SLSegmentPageTitleHeight);
        if (_isBlock) {
            [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        }else{
            [btn setTitle:[self.dataSource slSegmentPageTitleForItem:i] forState:UIControlStateNormal];
        }
        [btn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = SLSegmentPageTitleTag+i;
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:_titleColor forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:SLSegmentPageTitleFont];
        [titleSV addSubview:btn];
        [self.btnMuArr addObject:btn];
        
        [self createLineWithBtn:btn num:i];
        
        if (i == self.selectOne) {
            btn.selected = YES;
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(self.selectOne*_titleWidth, SLSegmentPageTitleHeight-1, _titleWidth, 1)];
            line.backgroundColor = _lineColor;
            [titleSV addSubview:line];
            _lineView = line;
        }
    }
    _titleScrollView = titleSV;
}

-(void)createLineWithBtn:(UIButton *)btn num:(NSInteger)i{
    
    if (self.separateStyle == SLSegmentPageSeparateStyleSingleLine) {
        if ( i > 0){
            UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake( -0.5, (SLSegmentPageTitleHeight-20)/2, 1, 20)];
            verticalLine.backgroundColor = self.tintColor;
            [btn addSubview:verticalLine];
        }
    }
    if (self.separateStyle == SLSegmentPageSeparateStyleNone) {
        return;
    }
    if (self.separateStyle == SLSegmentPageSeparateStyleFull) {
        if ( i > 0){
            UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake( -0.5, 0, 1, SLSegmentPageTitleHeight)];
            verticalLine.backgroundColor = self.tintColor;
            [btn addSubview:verticalLine];
        }
    }
    if (self.separateStyle == SLSegmentPageSeparateStyleOverall) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _titleWidth, 1)];
        line.backgroundColor = self.tintColor;
        [btn addSubview:line];
        if ( i > 0){
            UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake( -0.5, 0, 1, SLSegmentPageTitleHeight)];
            verticalLine.backgroundColor = self.tintColor;
            [btn addSubview:verticalLine];
        }
        self.layer.borderColor = self.tintColor.CGColor;
        self.layer.borderWidth = 1.0;
    }
    
}

- (void)setSelectOne:(NSInteger)selectOne{
    _selectOne = selectOne;
    if (_titleScrollView) {
        if (selectOne<self.btnMuArr.count) {
            [self titleClick:self.btnMuArr[selectOne]];
        }
    }
}


#pragma mark 创建新闻内容页面
-(void)createContentView{
    [self.contentScrollView removeFromSuperview];
    UIScrollView *scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SLSegmentPageTitleHeight, self.frame.size.width, (self.frame.size.height?self.frame.size.height:SLSegmentPageTitleHeight)-SLSegmentPageTitleHeight)];
    scrollV.backgroundColor = [UIColor clearColor];
    scrollV.pagingEnabled = YES;
    scrollV.showsHorizontalScrollIndicator = NO;
    scrollV.bounces = NO;
    scrollV.scrollEnabled = _pageScrollEnabled;
    scrollV.contentSize = CGSizeMake(_totalBtnNum* self.frame.size.width, 0);
    [scrollV setContentOffset:CGPointMake(self.selectOne *self.frame.size.width, 0) animated:NO];
    scrollV.delegate =self;
    [self addSubview:scrollV];
    NSMutableSet *conArr = [[NSMutableSet alloc] init];
    for (int i = 0 ; i<_totalBtnNum; i++) {
        UIViewController *page;
        if (_isBlock) {
            UIViewController *(^itemBlock)(NSInteger item) = objc_getAssociatedObject(self, &SLSegmentPageContentControllerAction);
            page = itemBlock(i);
        }else{
            page = [self.dataSource slSegmentPageWithSubviewsForItem:i];
        }
        if (page) {
            page.segmentPageWidth = scrollV.frame.size.width;
            page.segmentPageHeight = scrollV.frame.size.height;
            page.view.frame =CGRectMake(i*scrollV.frame.size.width, 0, scrollV.frame.size.width, scrollV.frame.size.height);
            [scrollV addSubview:page.view];
            [[self getCurrentVC] addChildViewController:page];
            [conArr addObject:page];
        }
    }
    self.controllerSet = conArr;
    _contentScrollView = scrollV;
}

-(NSMutableArray *)btnMuArr{
    if (_btnMuArr == nil) {
        _btnMuArr = [[NSMutableArray alloc] init];
    }
    return _btnMuArr;
}

#pragma mark UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x == 0) {
        [self moveLineWithXpoint:0];
        [self showBtnSelect:SLSegmentPageTitleTag];
    }else{
        CGFloat contentSet = scrollView.contentOffset.x;  //移动的距离
        CGFloat lineMoveX = _titleWidth*contentSet/self.frame.size.width;
        [self moveLineWithXpoint:lineMoveX];
        int btnNum = (int)(contentSet/self.frame.size.width);
        if (lineMoveX <=  _titleWidth/2+(_titleWidth * btnNum)) {
            [self showBtnSelect:btnNum + SLSegmentPageTitleTag];
        }
        else if (lineMoveX < _titleWidth+(_titleWidth* btnNum)) {
            [self showBtnSelect: btnNum+SLSegmentPageTitleTag+1];
        }
    }
}

#pragma mark 点击titlebtn
-(void)titleClick:(UIButton *)btn{
    //选择第几个btn
    _selectOne = btn.tag-SLSegmentPageTitleTag;
    [self showBtnSelect:btn.tag];
    //移动btn下面的横线
    [self moveLineWithXpoint:btn.frame.origin.x];
    //移动内容的scrollview
    [self moveBigScorllContentSizeWithNum:btn.tag-SLSegmentPageTitleTag];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(slSegmentPageView:selectItem:)]) {
        [self.delegate slSegmentPageView:self selectItem:_selectOne];
    }
}

#pragma mark 点击第几个分类btn
-(void)showBtnSelect:(NSInteger)btnTag{
    for (int i = 0; i<self.btnMuArr.count; i++) {
        UIButton *otherBtn = self.btnMuArr[i];
        if (otherBtn.tag == btnTag) {
            otherBtn.selected = YES;
        }else{
            otherBtn.selected = NO;
        }
    }
    
    [self setClassifyTitleContentSize:btnTag-SLSegmentPageTitleTag];
}

#pragma mark 设置分类标题scrollView的偏移量   num选择的第几个btn
-(void)setClassifyTitleContentSize:(NSInteger)num{
    if (_titleScrollView.contentSize.width > self.frame.size.width) {
        long selectBtnOffsetMinX = (num)*_titleWidth;  //选择btn的对原点的距离
        
        float disLeftPoint = selectBtnOffsetMinX - _titleScrollView.contentOffset.x;  //距离左点
        float disRightPoint = (_titleScrollView.contentOffset.x + self.frame.size.width) - selectBtnOffsetMinX; //距离右点
        
        if (disLeftPoint<_titleWidth || disRightPoint <(_titleWidth * 2)){
            [UIView animateWithDuration:0.2 animations:^{
                if (disLeftPoint<_titleWidth) {
                    _titleScrollView.contentOffset = CGPointMake( num>0?selectBtnOffsetMinX-_titleWidth : 0, 0);
                }
                if (disRightPoint <(_titleWidth * 2)){
                    _titleScrollView.contentOffset = CGPointMake(selectBtnOffsetMinX+(self.frame.size.width-(_titleWidth *( (disRightPoint <_titleWidth &&( _totalBtnNum - num) <=1)?1:2))) , 0);
                }
            }];
        }
    }
}

#pragma mark 移动title下标线
-(void)moveLineWithXpoint:(CGFloat)x{
    [UIView animateWithDuration:0.1 animations:^{
        CGRect rx = _lineView.frame;
        rx.origin.x = x;
        _lineView.frame =rx;
    }];
}
#pragma mark 移动新闻列表到第几页
-(void)moveBigScorllContentSizeWithNum:(NSInteger)tag{
    [self.contentScrollView setContentOffset:CGPointMake(self.frame.size.width*tag, 0) animated:self.pageScrollEnabled];
}


- (UIViewController *)getCurrentVC
{
    id currentId = nil;
    if (self.delegate) {
        currentId = self.delegate;
    }
    if (self.dataSource) {
        currentId = self.dataSource;
    }
    if ([currentId isKindOfClass:[UIViewController class]]) {
        return (UIViewController *)self.delegate;
    }
    if ([currentId isKindOfClass:[UIView class]]) {
        return [self getCurrentViewController:(UIView *)self.delegate];
    }
    return [self getCurrentViewController:self];
}

- (UIViewController *)getCurrentViewController:(UIView *)view{
    UIResponder *nextResponder =  view;
    do
    {
        nextResponder = [nextResponder nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]])
            return (UIViewController*)nextResponder;
        
    } while (nextResponder != nil);
    
    return nil;
}

@end



@implementation UIViewController (PageFrame)


- (void)setSegmentPageWidth:(CGFloat)segmentPageWidth{
        objc_setAssociatedObject(self, &SLSegmentPageOriginalW, @(segmentPageWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setSegmentPageHeight:(CGFloat)segmentPageHeight{
        objc_setAssociatedObject(self, &SLSegmentPageOriginalH,  @(segmentPageHeight),OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)segmentPageWidth{
    return [objc_getAssociatedObject(self, &SLSegmentPageOriginalW) floatValue];
}
- (CGFloat)segmentPageHeight{
    return [objc_getAssociatedObject(self,  &SLSegmentPageOriginalH) floatValue];
}

@end
