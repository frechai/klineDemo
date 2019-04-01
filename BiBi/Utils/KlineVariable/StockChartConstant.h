//
//  StockChartConstant.h
//  BiBi
//
//  Created by frechai on 2018/4/3.
//  Copyright © 2018年 frechai. All rights reserved.
//

#ifndef StockChartConstant_h
#define StockChartConstant_h


#endif /* StockChartConstant_h */

/**
 *k线图绘图区背景虚线条数
 */
#define klineviewHoritalLineCount 4

/**
 *成交量图绘图区背景虚线条数
 */
#define volumeviewHoritalLineCount 2

//图表红线颜色
#define riseColor [UIColor colorWithRed:224/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]

//图表绿线颜色
#define fallColor [UIColor colorWithRed:36/255.0 green:186/255.0 blue:79/255.0 alpha:1.0]

//kline MA7线颜色
#define MA7Color [UIColor colorWithRed:254/255.0 green:165/255.0 blue:0/255.0 alpha:1.0]

//kline MA30颜色
#define MA30Color [UIColor colorWithRed:251/255.0 green:28/255.0 blue:211/255.0 alpha:1.0]

#define StockLineDayHeight 15

#define StockPointRadius 2

#define StockScrollViewLeftGap 45


//Kline种类
typedef NS_ENUM(NSInteger, Y_StockChartCenterViewType) {
    Y_StockChartcenterViewTypeKline= 1, //K线
    Y_StockChartcenterViewTypeTimeLine,  //分时图
    Y_StockChartcenterViewTypeOther
};


//Accessory指标种类
typedef NS_ENUM(NSInteger, Y_StockChartTargetLineStatus) {
    Y_StockChartTargetLineStatusMACD = 100,    //MACD线
    Y_StockChartTargetLineStatusKDJ,    //KDJ线
    Y_StockChartTargetLineStatusAccessoryClose,    //关闭Accessory线
    Y_StockChartTargetLineStatusMA , //MA线
    Y_StockChartTargetLineStatusEMA,  //EMA线
    Y_StockChartTargetLineStatusCloseMA  //MA关闭线
};


typedef NS_ENUM(NSInteger,klinedirection) {
    isleftpan = 0,
    isrightpan,
    nopan,
};

/**
 *  K线图需要加载更多数据的通知
 */
#define Y_StockChartKLineNeedLoadMoreDataNotification @"Y_StockChartKLineNeedLoadMoreDataNotification"

/**
 *  K线图Y的View的宽度
 */
#define Y_StockChartKLinePriceViewWidth 47

/**
 *  K线图的X的View的高度
 */
#define Y_StockChartKLineTimeViewHeight 20

/**
 *  K线最大的宽度
 */
#define Y_StockChartKLineMaxWidth 20

/**
 *  K线图最小的宽度
 */
#define Y_StockChartKLineMinWidth 2

/**
 *  K线图缩放界限
 */
#define Y_StockChartScaleBound 0.03

/**
 *  K线的缩放因子
 */
#define Y_StockChartScaleFactor 0.03

/**
 *  UIScrollView的contentOffset属性
 */
#define Y_StockChartContentOffsetKey @"contentOffset"

/**
 *  时分线的宽度
 */
#define Y_StockChartTimeLineLineWidth 0.5

/**
 *  时分线图的Above上最小的X
 */
#define Y_StockChartTimeLineMainViewMinX 0.0

/**
 *  分时线的timeLabelView的高度
 */
#define Y_StockChartTimeLineTimeLabelViewHeight 19

/**
 *  时分线的成交量的线宽
 */
#define Y_StockChartTimeLineVolumeLineWidth 0.5

/**
 *  长按时的线的宽度
 */
#define Y_StockChartLongPressVerticalViewWidth 0.5

/**
 *  MA线的宽度
 */
#define Y_StockChartMALineWidth 0.8

/**
 *  上下影线宽度
 */
#define Y_StockChartShadowLineWidth 1
/**
 *  所有profileView的高度
 */
#define Y_StockChartProfileViewHeight 50

/**
 *  K线图上可画区域最小的Y
 */
#define Y_StockChartKLineMainViewMinY 20

/**
 *  K线图上可画区域最大的Y
 */
#define Y_StockChartKLineMainViewMaxY (self.frame.size.height - 15)

/**
 *  K线图的成交量上最小的Y
 */
#define Y_StockChartKLineVolumeViewMinY 20

/**
 *  K线图的成交量最大的Y
 */
#define Y_StockChartKLineVolumeViewMaxY (self.frame.size.height)

/**
 *  K线图的副图上最小的Y
 */
#define Y_StockChartKLineAccessoryViewMinY 20

/**
 *  K线图的副图最大的Y
 */
#define Y_StockChartKLineAccessoryViewMaxY (self.frame.size.height)

/**
 *  K线图的副图中间的Y
 */
//#define Y_StockChartKLineAccessoryViewMiddleY (self.frame.size.height-20)/2.f + 20
#define Y_StockChartKLineAccessoryViewMiddleY (maxY - (0.f-minValue)/unitValue)

/**
 *  时分线图的Above上最小的Y
 */
#define Y_StockChartTimeLineMainViewMinY 0

/**
 *  时分线图的Above上最大的Y
 */
#define Y_StockChartTimeLineMainViewMaxY (self.frame.size.height-Y_StockChartTimeLineTimeLabelViewHeight)


/**
 *  时分线图的Above上最大的Y
 */
#define Y_StockChartTimeLineMainViewMaxX (self.frame.size.width)

/**
 *  时分线图的Below上最小的Y
 */
#define Y_StockChartTimeLineVolumeViewMinY 0

/**
 *  时分线图的Below上最大的Y
 */
#define Y_StockChartTimeLineVolumeViewMaxY (self.frame.size.height)

/**
 *  时分线图的Below最大的X
 */
#define Y_StockChartTimeLineVolumeViewMaxX (self.frame.size.width)

/**
 * 时分线图的Below最小的X
 */
#define Y_StockChartTimeLineVolumeViewMinX 0





















