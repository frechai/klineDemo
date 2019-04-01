//
//  StockChartGlobalVariable.h
//  BiBi
//
//  Created by frechai on 2018/4/3.
//  Copyright © 2018年 frechai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StockChartGlobalVariable : NSObject

/**
 *  K线图的宽度，默认4
 */
+(CGFloat)kLineWidth;
+(void)setkLineWith:(CGFloat)kLineWidth;
+(void)ressetKlineWidth;
/**
 *  K线图的间隔，默认1
 */
+(CGFloat)kLineGap;
+(void)setkLineGap:(CGFloat)kLineGap;


/**
 *  顶部显示控件高度占比，默认0.08
 */
+ (CGFloat)topViewRatio;
+ (void)setTopViewRatio:(CGFloat)Ratio;

/**
 *  类型选择控件高度占比，默认0.06
 */
+ (CGFloat)klineTypeViewRatio;
+ (void)setklineTypeViewRatio:(CGFloat)Ratio;

/**
 *  MainView的高度占比,默认为0.5
 */
+ (CGFloat)kLineMainViewRatio;
+ (void)setkLineMainViewRatio:(CGFloat)Ratio;

/**
 *  VolumeView的高度占比,默认为0.2
 */
+ (CGFloat)kLineVolumeViewRatio;
+ (void)setkLineVolumeViewRatio:(CGFloat)Ratio;


/**
 *  isEMA线
 */
+ (CGFloat)isEMALine;
+ (void)setisEMALine:(Y_StockChartTargetLineStatus)type;


/**
 *指标线类型 是否为MACD
 */
+ (CGFloat)isMACD;
+ (void)setisMACDLine:(Y_StockChartTargetLineStatus)type;

/**
 *是否进入详情页
 */
+ (BOOL)isDetailView;
+ (void)setisDetailView:(BOOL)isDetailView;


/**
 *k线滑动在x轴位移
 */
+ (NSInteger)offsetX;
+ (void)setoffsetX:(NSInteger)offsetX;
+ (void)ressetoffset;

+ (NSInteger)startIndex;
+ (void)setStartIndex:(NSInteger)startX;





@end

