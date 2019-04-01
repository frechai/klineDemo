//
//  KlineModel.h
//  BiBi
//
//  Created by frechai on 2018/4/3.
//  Copyright © 2018年 frechai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KlineModel : NSObject

//接口现有字段
@property(nonatomic, assign)CGFloat OpenTime;//第一口价时间
@property(nonatomic, assign)CGFloat Open;//开盘价
@property(nonatomic, assign)CGFloat High;//最高价
@property(nonatomic, assign)CGFloat Low; //最低价
@property(nonatomic, assign)CGFloat Close;//收盘价
@property(nonatomic, assign)CGFloat Volume;//成交量
@property(nonatomic, assign)CGFloat CloseTime;//最后一口价时间

//拓展字段-----需经过计算------
@property(nonatomic, assign)CGFloat MA7;
@property(nonatomic, assign)CGFloat MA30;
@property(nonatomic, assign)CGFloat MAVOL7;
@property(nonatomic, assign)CGFloat MAVOL30;
//MACD
@property(nonatomic, assign)CGFloat DIF;
@property(nonatomic, assign)CGFloat DEA;
@property(nonatomic, assign)CGFloat MACD;
//KDJ
@property(nonatomic, assign)CGFloat KDJ_K;
@property(nonatomic, assign)CGFloat KDJ_D;
@property(nonatomic, assign)CGFloat KDJ_J;
//BOLL
@property(nonatomic, assign)CGFloat MB;
@property(nonatomic, assign)CGFloat UP;
@property(nonatomic, assign)CGFloat DN;


- (void)initwithArr:(NSArray *)arr;


@end
