//
//  Kline_headDisplayView.h
//  BiBi
//
//  Created by frechai on 2018/4/3.
//  Copyright © 2018年 frechai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KlineModel.h"

@interface Kline_headDisplayView : UIView

+ (instancetype)shareInstance;
- (void)headViewDisplayWithModel:(KlineModel *)model;
@end
