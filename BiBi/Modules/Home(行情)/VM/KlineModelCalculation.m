//
//  KlineModelCalculation.m
//  BiBi
//
//  Created by frechai on 2018/4/3.
//  Copyright © 2018年 frechai. All rights reserved.
//

#import "KlineModelCalculation.h"
#import "KlineModel.h"

@interface KlineModelCalculation()

@property(nonatomic, strong)NSMutableArray *dataSource;
@end

@implementation KlineModelCalculation

+ (KlineModelCalculation *)shareInstance
{
    static KlineModelCalculation *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[KlineModelCalculation alloc] init];
        instance.dataSource = [[NSMutableArray alloc] init];
    });
    
    return instance;
}

- (NSMutableArray *)convertStockWithArr:(NSArray *)stockArr
{
    if (self.dataSource.count) {
        [self.dataSource removeAllObjects];
    }
    [self.dataSource addObjectsFromArray:stockArr];
    
    [self convertMACalculateArr];
    [self convertJDKCalculateArray];
    [self convertMACDCalculateArray];
    [self convertBOLLCalculateArray];
    
    return self.dataSource;
}

#pragma mark MA算法
- (void)convertMACalculateArr
{
    for (int i = 0; i < self.dataSource.count; i++) {
        KlineModel *stock = self.dataSource[i];
        if (i > 6 && i < 30) {//MA7
            NSArray *subArr = [self.dataSource subarrayWithRange:NSMakeRange(i - 7, 7)];
            stock.MA7 = [self getMAWithArr:subArr parameter:7];
            stock.MAVOL7 = [self getVolumeMAWithArr:subArr parameter:7];
        }else if (i > 30 || i == 30){//MA30
            NSArray *subArr1 = [self.dataSource subarrayWithRange:NSMakeRange(i - 7, 7)];
            NSArray *subArr2 = [self.dataSource subarrayWithRange:NSMakeRange(i - 30, 30)];
            stock.MA7 = [self getMAWithArr:subArr1 parameter:7];
            stock.MAVOL7 = [self getVolumeMAWithArr:subArr1 parameter:7];
            stock.MA30 = [self getMAWithArr:subArr2 parameter:30];
            stock.MAVOL30 = [self getVolumeMAWithArr:subArr2 parameter:30];
        }
    }
}

#pragma mark MA辅助算法------
- (CGFloat)getMAWithArr:(NSArray *)arr parameter:(NSInteger)para
{
    CGFloat sumClose = 0.0;
    CGFloat MA;
    for (int i = 0; i < arr.count; i++) {
        KlineModel *stock = arr[i];
        sumClose += stock.Close;
    }
    MA = sumClose/para;
    
    return MA;
}

- (CGFloat)getVolumeMAWithArr:(NSArray *)arr parameter:(NSInteger)para
{
    CGFloat sumClose = 0.0;
    CGFloat VolumeMA;
    for (int i = 0; i < arr.count; i++) {
        KlineModel *stock = arr[i];
        sumClose += stock.Volume;
    }
    VolumeMA = sumClose/para;
    
    return VolumeMA;
}

#pragma mark JDK算法------
- (void)convertJDKCalculateArray
{
    //9个周期内的最低价PL9
    //CGFloat PL9;
    //9个周期内的最高价PH9
    //CGFloat PH9;
    
    //9个周期内的最低价角标PL9Index
    //CGFloat PL9Index;
    //9个周期内的最高价角标PH9Index
    //CGFloat PH9Index;
    //第八个周期的默认初始k值
    CGFloat Eightk = 50;
    //第八个周期的默认初始D值
    CGFloat EightD = 50;
    
    //if (stockArr.count < 8 ) return modelArr;
    for (int i = 0; i < self.dataSource.count; i++) {
        KlineModel *stock = self.dataSource[i];
        if (i < 8 ) {
            continue;
        }else{
            //在i处向前截取9个数据，计算最大收盘价和最小收盘价
            NSArray *SubArr = [self.dataSource subarrayWithRange:NSMakeRange(i-8, 9)];
            //获取9个周期内最小收盘价
            CGFloat MinClosePrice = [self getLowestClosePriceWithArr:SubArr];
            //获取9个周期内最大收盘价
            CGFloat MaxClosePrice = [self getHighestClosePriceWithArr:SubArr];
            //第9个周期RSA = (C - L9)/(H9-L9)*100
            CGFloat RSA;
            if (MinClosePrice == MaxClosePrice) {
                RSA = stock.Close/MinClosePrice;
            }else{
                RSA = (stock.Close/1000.0 - MinClosePrice/1000.0)/(MaxClosePrice/1000.0 - MinClosePrice/1000.0) *100;
            }
            
            //K值=2/3.0*第8个周期K值 +1/3.0*第9个周期RSA值
            CGFloat K = 2/3.0*Eightk +1/3.0*RSA;
            Eightk = K;
            //D值=2/3.0*第8个周期D值 + 1/3*第9个周期K值
            CGFloat D = 2/3.0*EightD +1/3.0*K;
            EightD = D;
            //J值=3*第9个周期K值 - 2*第9个周期D值
            CGFloat J = 3*K -2*D;
            
            stock.KDJ_K = K;
            stock.KDJ_D = D;
            stock.KDJ_J = J;
        }
    }
}

#pragma mark MACD算法
/**
 12日EMA的计算：
 EMA（12） = 前一日EMA（12） X 11/13 + 今日收盘价 X 2/13
 26日EMA的计算：
 EMA（26） = 前一日EMA（26） X 25/27 + 今日收盘价 X 2/27  **(若无前一日EMA(26)\EMA(12),则其初始值为当个周期的收盘价)
 差离值（DIF）的计算：
 DIF = EMA（12） - EMA（26） 。
 根据差离值计算其9日的EMA，即离差平均值，是所求的DEA值。为了不与指标原名相混淆，此值又名DEA或DEM。
 今日DEA = （前一日DEA X 8/10 + 今日DIF X 2/10）
 用（DIF-DEA）*2即为MACD柱状图。
 */
- (void)convertMACDCalculateArray
{
    CGFloat preEMA12 = 0;//前一日EMA12
    CGFloat preEMA26 = 0;//前一日EMA26
    CGFloat preDEA = 0;//前一日DEA;
    
    CGFloat EMA12 = 0;//EMA12
    CGFloat EMA26 = 0;//EMA26
    CGFloat DIF = 0;//差离值
    CGFloat DEA = 0;//离差平均值
    CGFloat MACD = 0;//MACD值
    
    for (int i = 0; i < self.dataSource.count; i++) {
        KlineModel *stock = self.dataSource[i];
        if (i == 0) {
            EMA12 = stock.Close;//EMA12初始值
            EMA26 = stock.Close;//EMA26初始值
            DIF = EMA12 - EMA26;//差离值
            DEA = DIF;
            MACD = (DIF - DEA)*2;//MACD值
        }else{
            EMA12 = preEMA12 *11/13.0 +stock.Close*2/13;
            EMA26 = preEMA26 *25/27.0 +stock.Close*2/27;
            DIF = EMA12 - EMA26;//差离值
            DEA = preDEA *8/10.0 +DIF*2/10.0;
            MACD = (DIF - DEA)*2; //MACD值
        }
     
        preEMA12 = EMA12;
        preEMA26 = EMA26;
        preDEA = DEA;
        
        stock.DIF = DIF;
        stock.DEA = DEA;
        stock.MACD = MACD;
    }
}

#pragma mark BOLL算法
/**
 *
 以日BOLL指标计算为例，其计算方法如下。
 计算公式:
 中轨线=N日的移动平均线
 上轨线=中轨线+两倍的标准差
 下轨线=中轨线－两倍的标准差
 
 计算过程:
 （1）计算MA
 MA=N日内的收盘价之和÷N
 
 （2）计算标准差MD:
 MD=平方根N日的（C－MA）的两次方之和除以N
 sum += Math.sqrt(((double)array[i] -getAverage()) * (array[i] -getAverage()));
 
 （3）计算MB、UP、DN线:
 MB=（N－1)日的MA:  SumClose/(n-1)
 UP=MB+k×MD
 DN=MB－k×MD
 （K为参数，可根据股票的特性来做相应的调整，一般默认为2）
 *
 **/
- (void)convertBOLLCalculateArray
{
    CGFloat SumClose = 0;//n日收盘价之和
    CGFloat preSumClose = 0;//n-1日收盘价之和
    CGFloat SumSqrtClose = 0;//(n日收盘价-n日平均值)*(n日收盘价-n日平均值)/n
    
    CGFloat MA = 0;//n日收盘价平均值
    CGFloat MD = 0;//n日标准差
    CGFloat MB = 0;//(n-1)日收盘价平均值
    CGFloat UP = 0;
    CGFloat DN = 0;
    
    for (int i = 0; i < self.dataSource.count; i++) {
        KlineModel *stock = self.dataSource[i];
        
        //n-1日
        if (i>0) {
            MB = preSumClose/i;//n-1日收盘价平均值
        }
        
        //n日
        SumClose += stock.Close;//n日收盘价之和
        preSumClose = SumClose;//n-1日收盘价之和
        MA = SumClose/(i+1);//n日收盘价平均值
        SumSqrtClose += (stock.Close - MA)*(stock.Close - MA);
        MD = sqrtf(SumSqrtClose/(i+1));//n日标准差
        UP = MB + 2*MD;
        DN = MB - 2*MD;
        
        stock.MB = MB;
        stock.UP = UP;
        stock.DN = DN;
    }
}


#pragma mark 辅助算法------
#pragma mark 计算9个周期内的收盘价最高值
- (CGFloat)getHighestClosePriceWithArr:(NSArray *)arr
{
    CGFloat highestP = 0;
    for (int i = 0; i < arr.count; i++) {
        KlineModel *stock = arr[i];
        if (highestP <= stock.Close) {
            highestP = stock.Close;
        }
    }
    
    return highestP;
}
#pragma mark 计算9个周期内的收盘价最低值
- (CGFloat)getLowestClosePriceWithArr:(NSArray *)arr
{
    CGFloat lowestP = MAXFLOAT;
    for (int i = 0; i<arr.count; i++) {
        KlineModel *stock = arr[i];
        if (stock.Close <= lowestP) {
            lowestP = stock.Close;
        }
    }
    
    return lowestP;
}


@end
