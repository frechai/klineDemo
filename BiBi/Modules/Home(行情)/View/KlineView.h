//
//  KlineView.h
//  BiBi
//
//  Created by frechai on 2018/4/3.
//  Copyright © 2018年 frechai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KlinePositionModel.h"

@interface KlineView : UIView

@property (nonatomic, strong) NSArray *KlinePositonArray;
@property (nonatomic, assign) CGFloat highest;
@property (nonatomic, assign) CGFloat lowest;

- (void)showPriceWithHigh:(CGFloat)high low:(CGFloat)low;
@end
