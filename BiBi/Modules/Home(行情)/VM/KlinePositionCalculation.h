//
//  KlinePositionCalculation.h
//  BiBi
//
//  Created by frechai on 2018/4/3.
//  Copyright © 2018年 frechai. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KlinePositionCalculation : NSObject

+ (KlinePositionCalculation *)shareInstance;
- (NSMutableArray *)convertPositionWithStockArr:(NSArray *)stockArr mainviewHeight:(CGFloat)MainHeight volumeviewHeight:(CGFloat)VolumeHeight targetviewHeight:(CGFloat)TargetHeight isLeft:(klinedirection)isLeft;

@end
