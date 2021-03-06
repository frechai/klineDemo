//
//  TargetPositionModel.h
//  BiBi
//
//  Created by frechai on 2018/4/3.
//  Copyright © 2018年 frechai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KlineModel.h"

@interface TargetPositionModel : NSObject
@property (nonatomic, assign) CGPoint startposition; //起始点
@property (nonatomic, assign) CGPoint endposition;  //结束点
@property (nonatomic, strong) KlineModel *stock;

@end
