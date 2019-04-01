//
//  Transition.h
//  BiBi
//
//  Created by frechai on 2018/4/3.
//  Copyright © 2018年 frechai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Transition : NSObject<UIViewControllerAnimatedTransitioning>

@property(nonatomic,assign) BOOL isPush;//是否是push，反之则是pop

@property (nonatomic, assign) NSTimeInterval animationDuration;//动画时长
@end
