//
//  MenuBtnView.h
//  BiBi
//
//  Created by frechai on 2018/4/3.
//  Copyright © 2018年 frechai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MenuSelectedBlock)(NSInteger index);

@interface MenuBtnView : UIView
@property (nonatomic, strong) UIColor *selectColor;
@property (nonatomic, strong) UIColor *defaultColor;
@property (nonatomic, strong) UIColor *bgColor;
@property(nonatomic, strong) UIView *indicatorView;
@property(nonatomic, strong) MASConstraint *indHorConstraint;
@property (nonatomic, strong) NSMutableArray<NSString *> *btnTitleArr;
@property (nonatomic, copy) MenuSelectedBlock menuBlock;

- (instancetype)initWithFrame:(CGRect)frame bgColor:(UIColor *)bgColor  selectColor:(UIColor *)selectcolor defaultColor:(UIColor *)color titles:(NSArray <NSString *>*)titles block:(MenuSelectedBlock)block;
- (void)btnTypeClick:(UIButton *)btn;
@end
