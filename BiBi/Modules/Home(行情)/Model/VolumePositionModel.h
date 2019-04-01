//
//  VolumePositionModel.h
//  BiBi
//
//  Created by frechai on 2018/4/3.
//  Copyright © 2018年 frechai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KlineModel.h"

@interface VolumePositionModel : NSObject

@property (nonatomic, assign)CGPoint startP; //起始点
@property (nonatomic, assign)CGPoint endP;  //结束点
@property (nonatomic, strong)KlineModel *vStock;
@end
