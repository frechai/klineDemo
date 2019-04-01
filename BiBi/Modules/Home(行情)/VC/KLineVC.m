//
//  KLineVC.m
//  BiBi
//
//  Created by frechai on 2018/4/3.
//  Copyright © 2018年 frechai. All rights reserved.
//

#import "KLineVC.h"

#import "Kline_headDisplayView.h"
#import "Kline_menuView.h"
#import "KlineView.h"
#import "Kline_volumeView.h"
#import "KlineVM.h"
#import "Kline_headDisplayView.h"
#import "KlineMaskView.h"

@interface KLineVC ()<KLineMenuDelegate,UIScrollViewDelegate,VMStocksArrDelegate>

@property (nonatomic, strong) UIView *titleview;
@property (nonatomic, strong) Kline_headDisplayView *headview;
@property (nonatomic, strong) Kline_menuView *menuview;
@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, strong) KlineView *klineview;
@property (nonatomic, strong) Kline_volumeView *volumeview;
@property (nonatomic, strong) KlineModel *lastModel;
@property (nonatomic, strong) KlineMaskView *klinemaskview;

@property (nonatomic, strong) KlineVM *VM;
@property (nonatomic, strong) NSArray *stockArr;
@property (nonatomic, strong) NSMutableArray *stockPointArr;
@property (nonatomic, strong) NSMutableArray *klinePointArr;
@property (nonatomic, strong) NSMutableArray *volumePointArr;
@property (nonatomic, strong) NSMutableArray *targetPointArr;
//手势相关
@property (nonatomic, assign) CGPoint currentPoint;  // 手指当前坐标

@end

@implementation KLineVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.topViewRatio = [StockChartGlobalVariable topViewRatio];
        self.klineTypeViewRatio = [StockChartGlobalVariable klineTypeViewRatio];
        self.klineViewRatio = [StockChartGlobalVariable kLineMainViewRatio];
        self.volumeViewRatio = [StockChartGlobalVariable kLineVolumeViewRatio];
    }
    return self;
}

#pragma mark 懒加载------
#pragma mark ---titleview
-(UIView *)titleview
{
    UIView *view = [[UIView alloc] init];
    [view sizeToFit];
    UILabel *titleLb = [[UILabel alloc] init];
    titleLb.text = @"ETC/BTC";
    titleLb.textColor = KWhiteColor;
    titleLb.font = [UIFont systemFontOfSize:18];
    titleLb.textAlignment = NSTextAlignmentCenter;
    [view addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(view.mas_centerY);
        make.edges.equalTo(view).with.insets(UIEdgeInsetsMake(0, 0, 0, -8));
    }];
    UIImageView *arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];//选择箭头图标
    [view addSubview:arrowImage];
    [arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(view.mas_centerY);
        make.right.equalTo(view.mas_right);
        make.left.equalTo(titleLb.mas_right);
    }];
    
    return view;
}

#pragma mark scrollview
- (UIScrollView *)scrollview
{
    if (_scrollview == nil) {
        _scrollview = [[UIScrollView alloc] init];
        _scrollview.showsVerticalScrollIndicator = NO;
        _scrollview.showsHorizontalScrollIndicator = NO;
        _scrollview.delegate = self;
        _scrollview.bounces = NO;
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
        //缩放手势
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchEvent:)];
        [_scrollview addGestureRecognizer:pinch];
        

    }
    
    return _scrollview;
}

#pragma mark ---klineview
- (KlineView *)klineview
{
    if (!_klineview) {
        _klineview = [[KlineView alloc] init];
        _klineview.backgroundColor = NormalColor;
        
        //长按手势
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressEvent:)];
        [_klineview addGestureRecognizer:longPress];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panEvent:)];
        [_klineview addGestureRecognizer:pan];
    }
    
    return _klineview;
}

#pragma mark ---volumeview
- (Kline_volumeView *)volumeview
{
    if (!_volumeview) {
        _volumeview = [[Kline_volumeView alloc] init];
        _volumeview.backgroundColor = NormalColor;
    }
    
    return _volumeview;
}

-(KlineVM *)VM
{
    if (!_VM) {
        _VM = [KlineVM shareInstance];
        _VM.delegate = self;
    }
    
    return _VM;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [StockChartGlobalVariable ressetoffset];  //x轴标记为设为0，表示没有X轴左右偏移为0
    [StockChartGlobalVariable ressetKlineWidth]; 
    self.stockArr = [NSMutableArray new];
    self.stockPointArr = [NSMutableArray new];
    //请求k线数据
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.VM requestKlineDataWithType:@""];
}

- (void)setUpUI
{
    //返回
    self.isShowLiftBack = YES; //默认是此值
    self.view.backgroundColor = [UIColor blackColor];
    //标题
    self.navigationItem.titleView = self.titleview;
    //收藏
    [self addNavigationItemWithImageNames:@[@"xuanxiang"] isLeft:NO target:self action:@selector(rightNavItemClick:) tags:@[@"100"]];
    //指标面板
    self.headview = [Kline_headDisplayView shareInstance];
    [self.view addSubview:self.headview];
    [self.headview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view);
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(@155);
    }];
    
    //菜单栏
    self.menuview = [Kline_menuView menuBtnView];
    self.menuview.delegate = self;
    self.menuview.menuBlock();
    [self.view addSubview:self.menuview];
    [self.menuview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headview.mas_bottom).offset(7);
        make.left.right.mas_equalTo(self.view);
        make.height.equalTo(@44);
    }];
    
    //图表
    [self.view addSubview:self.scrollview];
    [self.scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.menuview.mas_bottom).offset(10);
        make.centerX.equalTo(self.view.mas_centerX);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    //kline
    [self.scrollview addSubview:self.klineview];
    [self.klineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollview.mas_top);
        make.left.right.equalTo(self.scrollview);
        make.centerX.equalTo(self.scrollview.mas_centerX);
        make.height.equalTo(self.scrollview.mas_height).multipliedBy(self.klineViewRatio);
    }];
    
    //volumeview
    [self.scrollview addSubview:self.volumeview];
    [self.volumeview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.klineview.mas_bottom).offset(2);
        make.left.right.equalTo(self.scrollview);
        make.centerX.equalTo(self.scrollview.mas_centerX);
        make.height.equalTo(self.scrollview.mas_height).multipliedBy(self.volumeViewRatio);
    }];
    
    [self.scrollview setNeedsLayout];
    [self.scrollview layoutIfNeeded];

    //委托模块
    
    //购买模块

}

#pragma mark 收藏
- (void)rightNavItemClick:(UIButton *)btn
{
    DLog(@"点击收藏了");
    
}

#pragma mark 菜单点击事件代理
- (void)clickBtnIndex:(NSInteger)index
{
    DLog(@"点击了k线模块--%zd",index);
    
}


#pragma mark VM delegate
- (void)delegateAcceptStockArr:(NSMutableArray *)arr
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.stockArr = [NSArray arrayWithArray:arr];
    //最新一个数据
    self.lastModel = [arr lastObject];
    //加载头部数据
    [[Kline_headDisplayView shareInstance] headViewDisplayWithModel:self.lastModel]; //刷新头部指标数值
    
    //转换点坐标
    [self convertPositionWithStockArr:arr isLeft:nopan];
}

#pragma mark 转换点坐标
- (void)convertPositionWithStockArr:(NSArray *)arr isLeft:(klinedirection)pandirection
{
    CGFloat mainHeight = CGRectGetHeight(self.klineview.frame);
    CGFloat volumeHeight = CGRectGetHeight(self.volumeview.frame);
    self.stockPointArr = [self.VM convertPositionWithStockArr:arr mainHeight:mainHeight*0.7 volumeHeight:volumeHeight targetHeight:0 isLeft:pandirection];
    if (self.stockPointArr.count == 3) {
        self.klinePointArr = [NSMutableArray arrayWithArray:self.stockPointArr[0]];
        self.volumePointArr = [NSMutableArray arrayWithArray:self.stockPointArr[1]];
        self.targetPointArr = [NSMutableArray arrayWithArray:self.stockPointArr[2]];
    }
    //刷新点坐标
    [self updateChartView];
}

#pragma mark 刷新点坐标图表
- (void)updateChartView
{
    KlinePositionModel *pmodel = [[self.klinePointArr firstObject] firstObject];
    //最大最小值
    self.klineview.highest = pmodel.Highest;
    self.klineview.lowest = pmodel.Lowest;
    //k线坐标点数组
    self.klineview.KlinePositonArray = self.klinePointArr;
    //成交量坐标点数组
    self.volumeview.volumeArr = self.volumePointArr;
}


#pragma mark 手势事件==========================================
#pragma mark 滑动手势
- (void)panEvent:(UIPanGestureRecognizer *)pan
{
    CGPoint newPoint = CGPointZero;
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.currentPoint = [pan translationInView:self.klineview];
    }else if (pan.state == UIGestureRecognizerStateChanged) {
        newPoint = [pan translationInView:self.klineview];
//        DLog(@"左右拖动点: %.2f,%.2f",newPoint.x,newPoint.y);
        
        CGFloat klineWidth = [StockChartGlobalVariable kLineWidth];
        CGFloat klineInterval = [StockChartGlobalVariable kLineGap];
        if (newPoint.x > 0) {
            int offset = (newPoint.x - self.currentPoint.x)/(klineWidth + klineInterval);
            if (offset <= 0) return;
            
            [StockChartGlobalVariable setoffsetX:offset];
            DLog(@"左滑偏移:%d",offset);
            //左滑
            [self convertPositionWithStockArr:self.stockArr isLeft:isleftpan];
        }else if (newPoint.x < 0){
            int offset = (newPoint.x - self.currentPoint.x)/(klineWidth + klineInterval);
            if (offset >= 0 ) return;
            
            [StockChartGlobalVariable setoffsetX:offset];
            DLog(@"右滑偏移:%d",offset);
            //右滑
            [self convertPositionWithStockArr:self.stockArr isLeft:isrightpan];
        }
        
        self.currentPoint = newPoint;
    }
    

    if (pan.state == UIGestureRecognizerStateEnded) {
        
    }
//    CGPoint movePoint = [pan translationInView:self.scrollview];
//    CGFloat distance = movePoint.x;//x轴
//    if (pan.state == UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged) {
//        if (ABS(distance) < ([StockChartGlobalVariable kLineWidth] + [StockChartGlobalVariable kLineGap])/2 || distance < 0 || distance > ScreenWidth) {
//            return;
//        }
//
//        CGFloat result = (distance/([StockChartGlobalVariable kLineWidth] + [StockChartGlobalVariable kLineGap]));
//        NSString *str = [NSString stringWithFormat:@"%.f",result];
//        NSInteger startIndex = [str integerValue];
//
//        //x轴标记为
//        [StockChartGlobalVariable setJoinSignX:startIndex];
//        //[self convertPositionWithStockArr:self.stockArr panDistance:startIndex];
//    }
}
#pragma mark 长按事件
- (void)longPressEvent:(UILongPressGestureRecognizer *)longPress
{
    static CGFloat oldPositionX = 0;
    
    if (longPress.state == UIGestureRecognizerStateBegan || longPress.state == UIGestureRecognizerStateChanged) {
        
        CGPoint location =  [longPress locationInView:self.klineview];
        
        if (ABS(location.x - oldPositionX) < ([StockChartGlobalVariable kLineWidth] + [StockChartGlobalVariable kLineGap])/2 || location.x < 0 || location.x > ScreenWidth) {
            return;
        }
        oldPositionX = location.x;
        
        CGFloat result = (oldPositionX/([StockChartGlobalVariable kLineWidth] + [StockChartGlobalVariable kLineGap]));
        NSString *str = [NSString stringWithFormat:@"%.f",result];
        NSInteger startIndex = [str integerValue];
        NSArray *klineArr = [self.klinePointArr firstObject];
        KlinePositionModel *model = klineArr[startIndex];
        [[Kline_headDisplayView shareInstance] headViewDisplayWithModel:model.Stock];

        //self.klineMutArr k线数组
        if (startIndex < 0) startIndex = 0;
        if (startIndex >= klineArr.count) startIndex = klineArr.count - 1;
        if (!self.klinemaskview) {
            self.klinemaskview = [[KlineMaskView alloc] init];
            self.klinemaskview.backgroundColor = [UIColor clearColor];
            [self.klineview addSubview:self.klinemaskview];
            [self.klinemaskview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.klineview.mas_centerX);
                make.left.top.height.right.equalTo(self.klineview);
            }];

        }else{
            self.klinemaskview.hidden = NO;
        }
        //选中的股票
        self.klinemaskview.selectedKlineModel = model;
     
        //[[KLineMAView shareInstance] maviewDisplayDataWithModel:model.Stock];
    }else if (longPress.state == UIGestureRecognizerStateEnded || longPress.state == UIGestureRecognizerStateFailed || longPress.state == UIGestureRecognizerStateCancelled){
        self.klinemaskview.hidden = YES;
        [[Kline_headDisplayView shareInstance] headViewDisplayWithModel:self.lastModel];
        //[[KLineMAView shareInstance] maviewDisplayDataWithModel:self.lastModel];
    }
}

#pragma mark 缩放事件
- (void)pinchEvent:(UIPinchGestureRecognizer *)pinch
{
    static CGFloat oldScale = 1.0f;
    CGFloat difValue = pinch.scale - oldScale;
    if (ABS(difValue) > Y_StockChartScaleBound) {
        //k线原宽度
        CGFloat oldKLineWidth = [StockChartGlobalVariable kLineWidth];
        //缩放k线宽度
        [StockChartGlobalVariable setkLineWith:oldKLineWidth *(difValue > 0 ? (1+Y_StockChartScaleFactor) : (1-Y_StockChartScaleFactor))];
        
        if (oldKLineWidth >= Y_StockChartKLineMaxWidth || oldKLineWidth <= Y_StockChartKLineMinWidth) {
            return;
        }
        
        oldScale = pinch.scale;
        
        [self convertPositionWithStockArr:self.stockArr isLeft:nopan];
    }
}



@end
