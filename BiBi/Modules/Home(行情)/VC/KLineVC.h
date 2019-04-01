//
//  KLineVC.h
//  BiBi
//
//  Created by frechai on 2018/4/3.
//  Copyright © 2018年 frechai. All rights reserved.
//

#import "RootViewController.h"

@interface KLineVC : RootViewController
/**
 * 顶部显示控件高占比 0.08
 */
@property (nonatomic, assign) CGFloat topViewRatio;

/**
 * k线类型控件高占比0.06
 */
@property (nonatomic, assign) CGFloat klineTypeViewRatio;

/**
 * k线图view的高所占比例0.7
 */
@property (nonatomic, assign) CGFloat klineViewRatio;


/**
 * 成交量图view的高所占比例0.3
 **/
@property (nonatomic, assign) CGFloat volumeViewRatio;

@end
