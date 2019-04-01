//
//  KlineVM.h
//  BiBi
//
//  Created by frechai on 2018/4/3.
//  Copyright © 2018年 frechai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KlineModel.h"

@protocol VMStocksArrDelegate <NSObject>
@required
- (void)delegateAcceptStockArr:(NSMutableArray *)arr;
@end

@interface KlineVM : NSObject

@property (nonatomic, weak) id<VMStocksArrDelegate>delegate;

+ (instancetype)shareInstance;
- (void)requestKlineDataWithType:(NSString *)type;
- (NSMutableArray *)convertPositionWithStockArr:(NSArray *)stockArr mainHeight:(CGFloat)MainHeight volumeHeight:(CGFloat)VolumeHeight targetHeight:(CGFloat)TargetHeight isLeft:(klinedirection)left;
@end
