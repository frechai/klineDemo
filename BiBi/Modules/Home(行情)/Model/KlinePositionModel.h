//
//  KlinePositionModel.h
//  BiBi
//
//  Created by frechai on 2018/4/3.
//  Copyright © 2018年 frechai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KlineModel.h"

@interface KlinePositionModel : NSObject

@property (nonatomic, assign) CGPoint OpenPoint;  //开盘价坐标点
@property (nonatomic, assign) CGPoint ClosePoint; //收盘价坐标点
@property (nonatomic, assign) CGPoint HighPoint;  //高点
@property (nonatomic, assign) CGPoint LowPoint;   //低点
@property (nonatomic, assign) CGFloat Highest;    //最高价坐标点
@property (nonatomic, assign) CGFloat Lowest;     //最低价坐标点
@property (nonatomic, strong) KlineModel *Stock;

@end
