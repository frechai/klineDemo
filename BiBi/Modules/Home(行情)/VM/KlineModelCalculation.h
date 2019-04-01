//
//  KlineModelCalculation.h
//  BiBi
//
//  Created by frechai on 2018/4/3.
//  Copyright © 2018年 frechai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KlineModelCalculation : NSObject

+ (KlineModelCalculation *)shareInstance;

- (NSMutableArray *)convertStockWithArr:(NSArray *)stockArr;


@end
