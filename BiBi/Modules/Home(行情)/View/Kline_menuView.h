//
//  Kline_menuView.h
//  BiBi
//
//  Created by frechai on 2018/4/3.
//  Copyright © 2018年 frechai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KLineMenuDelegate <NSObject>
//点击按钮
- (void)clickBtnIndex:(NSInteger)index;
@end

typedef void(^delegateBlock)();

@interface Kline_menuView : UIView

@property(nonatomic, assign) id<KLineMenuDelegate>delegate;
@property(nonatomic, copy) delegateBlock menuBlock;
+ (instancetype)menuBtnView;

@end
