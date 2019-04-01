//
//  KlinePositionCalculation.m
//  BiBi
//
//  Created by frechai on 2018/4/3.
//  Copyright © 2018年 frechai. All rights reserved.
//

#import "KlinePositionCalculation.h"
#import "KlineModel.h"
#import "KlinePositionModel.h"
#import "VolumePositionModel.h"
#import "TargetPositionModel.h"

@interface KlinePositionCalculation()

@property (nonatomic, assign) CGFloat mainViewHeight;   //主图view高
@property (nonatomic, assign) CGFloat volumeViewHeight; //成交量图view高
@property (nonatomic, assign) CGFloat targetViewHeight; //指标量图view高
@property (nonatomic, strong) NSMutableArray *klinePostionArr;

@end

@implementation KlinePositionCalculation

+ (KlinePositionCalculation *)shareInstance
{
    static KlinePositionCalculation *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[KlinePositionCalculation alloc] init];
    });
    
    return instance;
}

-(NSMutableArray *)klinePostionArr
{
    if (_klinePostionArr == nil) {
        _klinePostionArr = [[NSMutableArray alloc] init];
    }
    return _klinePostionArr;
}

#pragma mark 股票模型转换坐标点入口
- (NSMutableArray *)convertPositionWithStockArr:(NSArray *)stockArr mainviewHeight:(CGFloat)MainHeight volumeviewHeight:(CGFloat)VolumeHeight targetviewHeight:(CGFloat)TargetHeight isLeft:(klinedirection)isLeft
{
    self.mainViewHeight = MainHeight;     //主图高度
    self.volumeViewHeight = VolumeHeight; //成交量图高度
    self.targetViewHeight = TargetHeight; //指标量图高度
    
    NSMutableArray *positionMutArr = [[NSMutableArray alloc] init];
    CGFloat lineWidth = [StockChartGlobalVariable kLineWidth]; //k线宽度
    CGFloat lineGap = [StockChartGlobalVariable kLineGap]; //k线间隔宽度
    //一屏宽可以显示的k线数量
    NSInteger maxShowCount = (ScreenWidth - lineGap)/(lineWidth + lineGap);
    NSArray *tempArr = [[NSArray alloc] init];
    
    //k线数据不够一屏,不能滑动
    if (stockArr.count <= maxShowCount) {
        tempArr = [NSArray arrayWithArray:stockArr];
    }else{
        //[StockChartGlobalVariable offsetX]; 正数向左，负数向右
        NSInteger px = stockArr.count - maxShowCount - [StockChartGlobalVariable offsetX];
        if (px < 0) {
            [StockChartGlobalVariable setStartIndex:0];
        }else if (px > stockArr.count - maxShowCount){
            [StockChartGlobalVariable setStartIndex:stockArr.count - maxShowCount];
        }else{
            [StockChartGlobalVariable setStartIndex:px];
        }
        
        NSInteger startX = [StockChartGlobalVariable startIndex];
        
        if (isLeft == isleftpan) {//左
            if (startX >= 0) {
                tempArr = [NSArray arrayWithArray:[stockArr subarrayWithRange:NSMakeRange(startX, maxShowCount)]];
            }
        }else if(isLeft == isrightpan){//右
            if (startX  < stockArr.count - maxShowCount || startX  == stockArr.count - maxShowCount) {
                tempArr = [NSArray arrayWithArray:[stockArr subarrayWithRange:NSMakeRange(startX, maxShowCount)]];
            }
        }else{//没有手势
            tempArr = [NSArray arrayWithArray:[stockArr subarrayWithRange:NSMakeRange(startX, maxShowCount)]];
        }
    }
    
    NSMutableArray *klinePositions = [self convertKlinePositonsWithArr:tempArr];
    NSMutableArray *volumePositions = [self convertVolumePositionsWithArr:tempArr];
    NSMutableArray *quotaPositions = [self convertQuotaPositionsWithArr:tempArr];
    [positionMutArr addObject:klinePositions]; //k线坐标数组
    [positionMutArr addObject:volumePositions]; //成交量数组
    [positionMutArr addObject:quotaPositions]; //指标数组
    
    return positionMutArr;
}

#pragma mark k线坐标点
- (NSMutableArray *)convertKlinePositonsWithArr:(NSArray *)klineArr
{
    NSMutableArray *klinePositions = [[NSMutableArray alloc] init];
    KlineModel *firstModel = klineArr.firstObject;
    __block CGFloat minValue = firstModel.Low;
    __block CGFloat maxValue = firstModel.High;
    
    [klineArr enumerateObjectsUsingBlock:^(KlineModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (model.High > maxValue) {
            maxValue = model.High;
        }
        if (model.Low < minValue) {
            minValue = model.Low;
        }
        
        if (model.MA7) {
            if (model.MA7 < minValue) {
                minValue = model.MA7;
            }
            if (model.MA7 > maxValue) {
                maxValue = model.MA7;
            }
        }
        
        if (model.MA30) {
            if (model.MA30 < minValue) {
                minValue = model.MA30;
            }
            if (model.MA30 > maxValue) {
                maxValue = model.MA30;
            }
        }
 
    }];
    
    CGFloat minMainviewY = 0;   //view最小值
    CGFloat maxMainviewY = self.mainViewHeight; //view最大值
    //每单位y坐标代表单位数值
    CGFloat unitValue = (maxValue -  minValue)/(maxMainviewY - minMainviewY);
    if (self.klinePostionArr.count) {
        [self.klinePostionArr removeAllObjects];
    }
    
    NSMutableArray *ma7SubArr = [[NSMutableArray alloc] init];
    NSMutableArray *ma30SubArr = [[NSMutableArray alloc] init];
    for (NSInteger idx = 0; idx < klineArr.count; idx++) {
        KlineModel *model = klineArr[idx];
        KlinePositionModel *klinePoint = [[KlinePositionModel alloc] init];
        
        //转换kline坐标
        CGFloat xCenter = [StockChartGlobalVariable kLineWidth]/2;
        CGFloat unitWidth = [StockChartGlobalVariable kLineWidth]+[StockChartGlobalVariable kLineGap];
        CGFloat xPosition = unitWidth*idx + xCenter;
        klinePoint.OpenPoint = CGPointMake(xPosition, ABS(maxMainviewY - (model.Open - minValue)/unitValue));
        klinePoint.ClosePoint = CGPointMake(xPosition, ABS(maxMainviewY - (model.Close - minValue)/unitValue));
        klinePoint.HighPoint = CGPointMake(xPosition, ABS(maxMainviewY - (model.High - minValue)/unitValue));
        klinePoint.LowPoint = CGPointMake(xPosition, ABS(maxMainviewY - (model.Low - minValue)/unitValue));
        klinePoint.Stock = model;
        klinePoint.Highest = maxValue;
        klinePoint.Lowest = minValue;
        [self.klinePostionArr addObject:klinePoint];
    
        //转换MA7、MA30坐标
        CGPoint ma7Point = CGPointMake(xPosition, ABS(maxMainviewY - (model.MA7 - minValue)/unitValue));
        [ma7SubArr addObject:[NSValue valueWithCGPoint:ma7Point]];
        CGPoint ma30Point = CGPointMake(xPosition, ABS(maxMainviewY - (model.MA30 - minValue)/unitValue));
        [ma30SubArr addObject:[NSValue valueWithCGPoint:ma30Point]];
    }
    
    [klinePositions addObject:self.klinePostionArr];
    [klinePositions addObject:ma7SubArr];
    [klinePositions addObject:ma30SubArr];
    
    return klinePositions;
}

#pragma mark 成交量坐标点
- (NSMutableArray *)convertVolumePositionsWithArr:(NSArray *)klineArr
{
    NSMutableArray *volumePositions = [[NSMutableArray alloc] init];
    //计算成交量最大最小值
    KlineModel *firstModel = klineArr.firstObject;
    __block CGFloat minValue = firstModel.Volume;
    __block CGFloat maxValue = firstModel.Volume;
    
     [klineArr enumerateObjectsUsingBlock:^(KlineModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
         if (model.Volume < minValue) {
             minValue = model.Volume;
         }
         
         if (model.Volume > maxValue) {
             maxValue = model.Volume;
         }
         
         if (model.MAVOL7) {
             if (model.MAVOL7 < minValue) {
                 minValue = model.MAVOL7;
             }
             if (model.MAVOL7 > maxValue) {
                 maxValue = model.MAVOL7;
             }
         }
         
         if (model.MAVOL30) {
             if (model.MAVOL30 < minValue) {
                 minValue = model.MAVOL30;
             }
             if (model.MAVOL30 > maxValue) {
                 maxValue = model.MAVOL30;
             }
         }
     }];
    
    CGFloat minVolumeviewY = 0;   //view最小值
    CGFloat maxVolumeviewY = self.volumeViewHeight *0.95; //view最大值
    
    //每单位y坐标代表单位数值
    CGFloat unitValue = (maxValue -  minValue)/(maxVolumeviewY - minVolumeviewY);
    NSMutableArray *volumeSubArr = [[NSMutableArray alloc] init];
    NSMutableArray *volume_MA7SubArr = [[NSMutableArray alloc] init];
    NSMutableArray *volume_MA30SubArr = [[NSMutableArray alloc] init];
    [klineArr enumerateObjectsUsingBlock:^(KlineModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        KlineModel *kModel = klineArr[idx];
        KlinePositionModel *positionModel = self.klinePostionArr[idx];
        CGFloat xPosition = positionModel.OpenPoint.x;
        CGPoint end = CGPointMake(xPosition,ABS(maxVolumeviewY - (model.Volume - minValue)/unitValue)) ;
        CGPoint start = CGPointMake(xPosition,maxVolumeviewY);
        
        VolumePositionModel *volumePosition = [[VolumePositionModel alloc] init];
        volumePosition.startP = start;
        volumePosition.endP = end;
        volumePosition.vStock = kModel;
        [volumeSubArr addObject:volumePosition];
        
        //volume_ma7、volume_ma30
        CGFloat volume_ma7 = maxVolumeviewY - (model.MAVOL7 - minValue)/unitValue;
        CGFloat volume_ma30 = maxVolumeviewY - (model.MAVOL30 - minValue)/unitValue;
        
        CGPoint ma7Point = CGPointMake(xPosition, volume_ma7);
        CGPoint ma30Point = CGPointMake(xPosition, volume_ma30);
        
        [volume_MA7SubArr addObject:[NSValue valueWithCGPoint:ma7Point]];
        [volume_MA30SubArr addObject:[NSValue valueWithCGPoint:ma30Point]];
    }];
    
    [volumePositions addObject:volumeSubArr]; //柱状图点坐标数组
    [volumePositions addObject:volume_MA7SubArr]; //ma7点坐标数组
    [volumePositions addObject:volume_MA30SubArr]; //ma30点坐标数组
    
    return volumePositions;
}

#pragma mark 指标线坐标点
- (NSMutableArray *)convertQuotaPositionsWithArr:(NSArray *)klineArr
{
    NSMutableArray *quotaPositions = [[NSMutableArray alloc] init];
    CGFloat minviewHeight = 5;
    CGFloat maxviewHeight = self.targetViewHeight-5;
    
    if ([StockChartGlobalVariable isMACD] == Y_StockChartTargetLineStatusMACD){
        
        /////////MACD
        __block CGFloat minMACD = CGFLOAT_MAX;
        __block CGFloat maxMACD = CGFLOAT_MIN;
        //MACD最大、最小值
        [klineArr enumerateObjectsUsingBlock:^(KlineModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            if (model.DIF) {
                if (model.DIF < minMACD) {
                    minMACD = model.DIF;
                }
                if (model.DIF > maxMACD) {
                    maxMACD = model.DIF;
                }
            }
            if (model.DEA) {
                if (model.DEA < minMACD) {
                    minMACD = model.DEA;
                }
                if (model.DEA > maxMACD) {
                    maxMACD = model.DEA;
                }
            }
            if (model.MACD) {
                if (model.MACD < minMACD) {
                    minMACD = model.MACD;
                }
                if (model.MACD > maxMACD) {
                    maxMACD = model.MACD;
                }
            }
        }];
        
        CGFloat unitValue = (maxMACD - minMACD)/(maxviewHeight - minviewHeight);
        NSMutableArray *MACDArr = [[NSMutableArray alloc] init];
        NSMutableArray *DIFArr = [[NSMutableArray alloc] init];
        NSMutableArray *DEAArr = [[NSMutableArray alloc] init];
        
        [klineArr enumerateObjectsUsingBlock:^(KlineModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            
            KlinePositionModel *positionModel = self.klinePostionArr[idx];
            CGFloat xPosition = positionModel.OpenPoint.x;
            CGFloat yPosition = -(model.MACD - 0)/unitValue + (maxviewHeight - (0.f-minMACD)/unitValue);
            
            CGPoint startPoint = CGPointMake(xPosition, yPosition); //起点
            CGPoint endPoint = CGPointMake(xPosition,(maxviewHeight - (0.f-minMACD)/unitValue)); //结束点
            
            TargetPositionModel *TargetPostion = [[TargetPositionModel alloc] init]; //模型
            TargetPostion.startposition = startPoint;
            TargetPostion.endposition = endPoint;
            TargetPostion.stock = model;
            [MACDArr addObject:TargetPostion];
            
            //DIF、DEA
            CGFloat DIFY = -(model.DIF - 0)/unitValue + (maxviewHeight - (0.f-minMACD)/unitValue);
            CGFloat DEAY = -(model.DEA - 0)/unitValue + (maxviewHeight - (0.f-minMACD)/unitValue);
            CGPoint DIF = CGPointMake(xPosition, DIFY);
            CGPoint DEA = CGPointMake(xPosition, DEAY);
            
            [DIFArr addObject:[NSValue valueWithCGPoint:DIF]];
            [DEAArr addObject:[NSValue valueWithCGPoint:DEA]];
        }];
        
        [quotaPositions addObject:MACDArr]; //MACD点坐标
        [quotaPositions addObject:DIFArr];  //DIF点坐标
        [quotaPositions addObject:DEAArr];  //DEA点坐标
    }else{
        
        ///////////KDJ
        __block CGFloat minKDJ = CGFLOAT_MAX;
        __block CGFloat maxKDJ = CGFLOAT_MIN;
        //KDJ最大最小值,外部赋值指标类型
        [klineArr enumerateObjectsUsingBlock:^(KlineModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            if (model.KDJ_K) {
                if (model.KDJ_K < minKDJ) {
                    minKDJ = model.KDJ_K;
                }
                if (model.KDJ_K > maxKDJ) {
                    maxKDJ = model.KDJ_K;
                }
            }
            if (model.KDJ_D) {
                if (model.KDJ_D < minKDJ) {
                    minKDJ = model.KDJ_D;
                }
                if (model.KDJ_D > maxKDJ) {
                    maxKDJ = model.KDJ_D;
                }
            }
            if (model.KDJ_J) {
                if (model.KDJ_J < minKDJ) {
                    minKDJ = model.KDJ_J;
                }
                if (model.KDJ_J > maxKDJ) {
                    maxKDJ = model.KDJ_J;
                }
            }
        }];
        
        minKDJ *= 1.001; //最小值
        maxKDJ *= 0.999; //最大值
        CGFloat unitValue = (maxKDJ - minKDJ)/(maxviewHeight - minviewHeight);
        NSMutableArray *kArr = [[NSMutableArray alloc] init];
        NSMutableArray *DArr = [[NSMutableArray alloc] init];
        NSMutableArray *JArr = [[NSMutableArray alloc] init];
        
        [klineArr enumerateObjectsUsingBlock:^(KlineModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            KlinePositionModel *positionModel = self.klinePostionArr[idx];
            CGFloat xPosition = positionModel.OpenPoint.x;
            
            CGFloat K_Y = maxviewHeight - (model.KDJ_K - minKDJ)/unitValue;
            CGFloat D_Y = maxviewHeight - (model.KDJ_D - minKDJ)/unitValue;
            CGFloat J_Y = maxviewHeight - (model.KDJ_J - minKDJ)/unitValue;
            
            CGPoint kPoint = CGPointMake(xPosition, K_Y);
            CGPoint dPoint = CGPointMake(xPosition, D_Y);
            CGPoint jPoint = CGPointMake(xPosition, J_Y);
            
            [kArr addObject:[NSValue valueWithCGPoint:kPoint]];
            [DArr addObject:[NSValue valueWithCGPoint:dPoint]];
            [JArr addObject:[NSValue valueWithCGPoint:jPoint]];
        }];
        
        [quotaPositions addObject:kArr];
        [quotaPositions addObject:DArr];
        [quotaPositions addObject:JArr];
    }

    return quotaPositions;
}




@end
