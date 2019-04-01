//
//  KlineModel.m
//  BiBi
//
//  Created by frechai on 2018/4/3.
//  Copyright © 2018年 frechai. All rights reserved.
//

#import "KlineModel.h"

@implementation KlineModel

//赋值第一口价、开盘价、收盘价、最高价、最低价、最后一口价
- (void)initwithArr:(NSArray *)arr
{
    NSAssert(arr.count == 6, @"k线模型返回结构体属性个数不为6！");
    
    if (self) {
        self.OpenTime = [arr[0] floatValue];
        self.Open = [arr[1] floatValue];
        self.High = [arr[2] floatValue];
        self.Low = [arr[3] floatValue];
        self.Close = [arr[4] floatValue];
        self.Volume = [arr[5] floatValue];
        //self.CloseTime = [arr[6] floatValue];
//        //拓展字段-----
//        self.MA7 = 0.0;
//        self.MA30 = 0.0;
//        self.MAVOL7 = 0.0;
//        self.MAVOL30 = 0.0;
//        //MACD
//        self.DIF = 0.0;
//        self.DEA = 0.0;
//        self.MACD = 0.0;
//        //KDJ
//        self.KDJ_K = 0.0;
//        self.KDJ_D = 0.0;
//        self.KDJ_J = 0.0;
//        //BOLL
//        self.MB = 0.0;
//        self.UP = 0.0;
//        self.DN = 0.0;
    }
}






@end
