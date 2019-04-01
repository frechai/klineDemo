
//
//  Y_StockChartGlobalVariable.h
//  YM_klineMaster
//
//  Created by frechai on 2018/4/3.
//  Copyright © 2018年 frechai. All rights reserved.
//
#import "StockChartGlobalVariable.h"

/**
 *  K线蜡烛图的宽度，默认5
 */
static CGFloat Y_StockChartKLineWidth = 4;

/**
 *  K线图的间隔，默认1
 */
static CGFloat Y_StockChartKLineGap = 1;


/**
 *  顶部显示控件高度占比，默认0.08
 */
static CGFloat YM_topViewRatio = 0.0;

/**
 *  类型选择控件高度占比，默认0.06
 */
static CGFloat YM_klineTypeViewRatio = 0.0;

/**
 *  MainView的高度占比,默认为0.5
 */
static CGFloat Y_StockChartKLineMainViewRatio = 0.7;

/**
 *  VolumeView的高度占比,默认为0.2
 */
static CGFloat Y_StockChartKLineVolumeViewRatio = 0.3;


/**
 *  是否为EMA线
 */
static Y_StockChartTargetLineStatus Y_StockChartKLineIsEMALine = Y_StockChartTargetLineStatusMA;


/**
 *  是否为MACD线,默认MACD
 */
static Y_StockChartTargetLineStatus Y_StockChartKLineIsMACDLine = Y_StockChartTargetLineStatusMACD;

/**
 *  是否进入了详情页
 */
static BOOL isDetail = NO;

/**
 *k线滑动在x轴位移
 */
static NSInteger offSetX = 0;

/**
 *k线滑动过程中数组起始元素下标
 */
static NSInteger startIndex = 0;


@implementation StockChartGlobalVariable


/**
 *k线滑动过程中数组起始元素下标
 */
+ (NSInteger)startIndex
{
    return startIndex;
}

+ (void)setStartIndex:(NSInteger)startX
{
    startIndex = startX;
}


/**
 *k线滑动在x轴位移
 */
+ (NSInteger)offsetX
{
    return offSetX;
}


+ (void)setoffsetX:(NSInteger)offsetX
{
    offSetX += offsetX;
}

+ (void)ressetoffset
{
    offSetX = 0;
}

/**
 *  K线图的宽度，默认4
 */
+(CGFloat)kLineWidth
{
    return Y_StockChartKLineWidth;
}
+(void)setkLineWith:(CGFloat)kLineWidth
{
    if (kLineWidth > Y_StockChartKLineMaxWidth) {
        kLineWidth = Y_StockChartKLineMaxWidth;
    }else if (kLineWidth < Y_StockChartKLineMinWidth){
        kLineWidth = Y_StockChartKLineMinWidth;
    }
    Y_StockChartKLineWidth = kLineWidth;
}
+ (void)ressetKlineWidth
{
    Y_StockChartKLineWidth = 4;
    Y_StockChartKLineGap = 1;
}


/**
 *  K线图的间隔，默认1
 */
+(CGFloat)kLineGap
{
    return Y_StockChartKLineGap;
}

+(void)setkLineGap:(CGFloat)kLineGap
{
    Y_StockChartKLineGap = kLineGap;
}

/**
 *  顶部显示控件高度占比，默认0.08
 */
+ (CGFloat)topViewRatio
{
    return YM_topViewRatio;
}
+ (void)setTopViewRatio:(CGFloat)Ratio
{
    YM_topViewRatio = Ratio;
}

/**
 *  类型选择控件高度占比，默认0.06
 */
+ (CGFloat)klineTypeViewRatio
{
    return YM_klineTypeViewRatio;
}
+ (void)setklineTypeViewRatio:(CGFloat)Ratio
{
    YM_klineTypeViewRatio = Ratio;
}


/**
 *  MainView的高度占比,默认为0.5
 */
+ (CGFloat)kLineMainViewRatio
{
    return Y_StockChartKLineMainViewRatio;
}

+ (void)setkLineMainViewRatio:(CGFloat)Ratio
{
    Y_StockChartKLineMainViewRatio = Ratio;
}

/**
 *  VolumeView的高度占比,默认为0.2
 */
+ (CGFloat)kLineVolumeViewRatio
{
    return Y_StockChartKLineVolumeViewRatio;
}
+ (void)setkLineVolumeViewRatio:(CGFloat)Ratio
{
    Y_StockChartKLineVolumeViewRatio = Ratio;
}


/**
 *  isEMA线
 */

+ (CGFloat)isEMALine
{
    return Y_StockChartKLineIsEMALine;
}
+ (void)setisEMALine:(Y_StockChartTargetLineStatus)type
{
    Y_StockChartKLineIsEMALine = type;
}


/**
 *  isMACD线
 */
+ (CGFloat)isMACD
{
    return Y_StockChartKLineIsMACDLine;
}

+ (void)setisMACDLine:(Y_StockChartTargetLineStatus)type
{
    Y_StockChartKLineIsMACDLine = type;
}

/**
 *是否进入了详情页
 */
+ (BOOL)isDetailView
{
    return isDetail;
}

+ (void)setisDetailView:(BOOL)isDetailView
{
    isDetail = isDetailView;
}


@end
