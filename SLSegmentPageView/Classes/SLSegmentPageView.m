//
//  SLSegmentPageView.m
//  wjw2
//
//  Created by SHAO LEI on 17/4/27.
//  Copyright © 2017年 Huaao Tech. All rights reserved.
//

#import "SLSegmentPageView.h"
#import "objc/runtime.h"

static const float SLSegmentPageTitleHeight  = 44;
static const float SLSegmentPageTitleFont = 15;
static const NSInteger SLSegmentPageTag = 1056501;

const char SLSegmentPageOriginalX;
const char SLSegmentPageOriginalY;
const char SLSegmentPageOriginalW;
const char SLSegmentPageOriginalH;
char const SLSegmentPageSelectItem;
char const SLSegmentPageContentController;

@interface SLSegmentPageView ()<UIScrollViewDelegate>
{
    NSInteger _totalBtnNum;
}
@property (nonatomic, weak) UIScrollView *titleScrollView;
@property (nonatomic, weak) UIScrollView *contentScrollView;
@property (nonatomic, strong) NSMutableArray<__kindof UIButton *> *btnMuArr;
@property (nonatomic, copy) NSDictionary *vcDict;
@property (nonatomic, copy) NSArray<__kindof NSString *> *titleArr;
@property (nonatomic, weak) UIView *lineView;
@property (nonatomic, strong) NSSet *controllerSet;

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
    if (self.controllerSet.count) {
        for (UIViewController *vc in self.controllerSet) {
            [[self getCurrentVC] addChildViewController:vc];
        }
    }
    [self createShowView];
}

- (void)initData{
    _pageScrollEnabled = NO;
    self.backgroundColor = [UIColor whiteColor];
    _titleColor = _lineColor = [UIColor blackColor];
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

- (void)slPageTitleArr:(NSArray *(^)())titleArr contentController:(UIViewController *(^)(NSInteger))showView{
    if (self.titleScrollView == nil && self.contentScrollView == nil) {
        NSArray *arr = titleArr();
        if (arr.count) {
            _totalBtnNum = [arr count];
            _titleArr = titleArr();
        }
        objc_setAssociatedObject(self, &SLSegmentPageContentController, showView, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
}

- (void)slPageNumber:(NSInteger)number title:(NSString *(^)(NSInteger))title contentController:(UIViewController *(^)(NSInteger))showView{
    if (self.titleScrollView == nil && self.contentScrollView == nil) {
        _totalBtnNum = number;
        NSMutableArray *muArr = [NSMutableArray arrayWithCapacity:number];
        while (muArr.count < number) {
            [muArr addObject:title(muArr.count)];
        }
        _titleArr = muArr;
        objc_setAssociatedObject(self, &SLSegmentPageContentController, showView, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }

}

- (void)slPageItem:(void (^)(UIViewController *, NSInteger))item{
    objc_setAssociatedObject(self, &SLSegmentPageSelectItem, item, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(void)createShowView{
    if (self.titleScrollView == nil) {
        [self createClassfiyTitle];
    }
    if (self.contentScrollView == nil) {
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
    _titleWidth = (_titleWidth ? _titleWidth : self.frame.size.width / _totalBtnNum);
    UIScrollView *titleSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,SLSegmentPageTitleHeight)];
    titleSV.contentSize = CGSizeMake(_titleWidth*_totalBtnNum, 0);
    titleSV.backgroundColor= [UIColor clearColor];
    titleSV.showsHorizontalScrollIndicator = NO;
    [self addSubview:titleSV];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, SLSegmentPageTitleHeight-1, _titleWidth*_totalBtnNum, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [titleSV addSubview:line];
    for (int i = 0; i<_totalBtnNum; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*_titleWidth, 0, _titleWidth, SLSegmentPageTitleHeight);
        [btn setTitle:self.titleArr[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = SLSegmentPageTag+i;
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:_titleColor forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:SLSegmentPageTitleFont];
        [titleSV addSubview:btn];
        [self.btnMuArr addObject:btn];
        
        if (i >0){
            UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake( -0.5, 10, 1, SLSegmentPageTitleHeight-20)];
            verticalLine.backgroundColor = [UIColor lightGrayColor];
            [btn addSubview:verticalLine];
        }
        
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
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableSet *conArr = [[NSMutableSet alloc] init];
    for (int i = 0 ; i<_totalBtnNum; i++) {
        UIViewController *page;
        UIViewController *(^showView)(NSInteger) = objc_getAssociatedObject(self, &SLSegmentPageContentController);
        if (showView) {
            page = showView(i);
        }
        if (page) {
            page.currentBounds = CGRectMake(0, 0, scrollV.frame.size.width, scrollV.frame.size.height);
            page.view.frame =CGRectMake(i*scrollV.frame.size.width, 0, scrollV.frame.size.width, scrollV.frame.size.height);
            [scrollV addSubview:page.view];
            [[self getCurrentVC] addChildViewController:page];
            [conArr addObject:page];
            [dict setObject:page forKey:[NSString stringWithFormat:@"%zi",SLSegmentPageTag+i]];
        }
    }
    self.vcDict = dict;
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
        [self showBtnSelect:SLSegmentPageTag];
    }else{
        CGFloat contentSet = scrollView.contentOffset.x;  //移动的距离
        CGFloat lineMoveX = _titleWidth*contentSet/self.frame.size.width;
        [self moveLineWithXpoint:lineMoveX];
        int btnNum = (int)(contentSet/self.frame.size.width);
        if (lineMoveX <=  _titleWidth/2+(_titleWidth * btnNum)) {
            [self showBtnSelect:btnNum + SLSegmentPageTag];
        }
        else if (lineMoveX < _titleWidth+(_titleWidth* btnNum)) {
            [self showBtnSelect: btnNum+SLSegmentPageTag+1];
        }
    }
}

#pragma mark 点击titlebtn
-(void)titleClick:(UIButton *)btn{
    //选择第几个btn
    _selectOne = btn.tag-SLSegmentPageTag;
    [self showBtnSelect:btn.tag];
    //移动btn下面的横线
    [self moveLineWithXpoint:btn.frame.origin.x];
    //移动内容的scrollview
    [self moveBigScorllContentSizeWithNum:btn.tag-SLSegmentPageTag];
    
    
    void (^selectItem)(UIViewController *, NSInteger) = objc_getAssociatedObject(self, &SLSegmentPageSelectItem);
    if (selectItem) {
        selectItem(self.vcDict[[NSString stringWithFormat:@"%zi",btn.tag]],_selectOne);
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
    
    [self setClassifyTitleContentSize:btnTag-SLSegmentPageTag];
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

- (void)setCurrentBounds:(CGRect)currentBounds{
        objc_setAssociatedObject(self, &SLSegmentPageOriginalX,  @(currentBounds.origin.x), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, &SLSegmentPageOriginalY,  @(currentBounds.origin.y), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, &SLSegmentPageOriginalW, @(currentBounds.size.width), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, &SLSegmentPageOriginalH,  @(currentBounds.size.height),OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGRect)currentBounds{

    return CGRectMake([objc_getAssociatedObject(self, &SLSegmentPageOriginalX) floatValue], [objc_getAssociatedObject(self, &SLSegmentPageOriginalY) floatValue], [objc_getAssociatedObject(self, &SLSegmentPageOriginalW) floatValue], [objc_getAssociatedObject(self,  &SLSegmentPageOriginalH) floatValue]);
}

@end
