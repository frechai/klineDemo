//
//  MenuBtnView.m
//  BiBi
//
//  Created by frechai on 2018/4/3.
//  Copyright © 2018年 frechai. All rights reserved.
//

#import "MenuBtnView.h"

#define BtnMaxCount 4

@interface MenuBtnView()
@property(nonatomic, strong) UIButton *previousBtn;
@property(nonatomic, strong) UIButton *currentBtn;
@property(nonatomic, strong) UIButton *defaultBtn;
@property(nonatomic, strong) UIScrollView *scrollview;

@end

@implementation MenuBtnView

- (instancetype)initWithFrame:(CGRect)frame bgColor:(UIColor *)bgColor  selectColor:(UIColor *)selectcolor defaultColor:(UIColor *)color titles:(NSArray <NSString *>*)titles block:(MenuSelectedBlock)block
{
    self = [super initWithFrame:frame];
    if (self) {
        _selectColor = selectcolor;
        _defaultColor = color;
        _menuBlock = block;
        
        if (titles.count) {
            NSArray *titleArr = [NSArray arrayWithArray:titles];
            self.frame = frame;
            self.scrollview = [[UIScrollView alloc] init];
            self.scrollview.backgroundColor = bgColor;
            self.scrollview.contentInset = UIEdgeInsetsZero;
            self.scrollview.showsHorizontalScrollIndicator = NO;
            
            self.scrollview.contentSize = (titleArr.count < BtnMaxCount || titleArr.count == BtnMaxCount) ? CGSizeMake(ScreenWidth, CGRectGetHeight(frame)) :  CGSizeMake(titleArr.count*ScreenWidth/BtnMaxCount, CGRectGetHeight(frame));
            [self addSubview:self.scrollview];
            [self.scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self).insets(UIEdgeInsetsZero);
            }];
            
            CGFloat btnWidth = (titleArr.count < BtnMaxCount || titleArr.count == BtnMaxCount) ? ScreenWidth/titleArr.count : ScreenWidth/BtnMaxCount *titleArr.count;
            for (NSInteger i = 0; i < titleArr.count; i++) {
                UIButton *btn = [self generateBtnWithTitle:titleArr[i]];
                btn.tag = 200 + i;
                btn.frame = CGRectMake(i *btnWidth, 0, btnWidth, CGRectGetHeight(frame)-3);
                [self.scrollview addSubview:btn];
                
                //首次进入，默认选择第一个
                if (i == 0) {
                    self.defaultBtn = btn;
                    [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
                }
            }
            
            //底部指示条
            self.indicatorView = [[UIView alloc] init];
            self.indicatorView.backgroundColor = selectcolor;
            [self addSubview:self.indicatorView];
            [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
                self.indHorConstraint = make.centerX.equalTo(self.defaultBtn.mas_centerX);
                make.bottom.equalTo(self.mas_bottom);
                make.height.offset(2);
                make.width.equalTo(self.defaultBtn.mas_width);
            }];
        }
        
    }
    return self;
}

#pragma mark 生成菜单按钮控件
- (UIButton *)generateBtnWithTitle:(NSString *)title
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:_defaultColor forState:UIControlStateNormal];
    [btn setTitleColor:_selectColor forState:UIControlStateSelected];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [btn addTarget:self action:@selector(btnTypeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

#pragma mark 按钮点击事件
- (void)btnTypeClick:(UIButton *)btn
{
    //此段代码实现点击以后，菜单栏UI方面的调整
    self.currentBtn = btn;
    [btn setSelected:YES];
    
    if ([self.currentBtn isEqual:self.previousBtn]) {
        return;
    }
    
    if (self.previousBtn) {
        [self.previousBtn setSelected:NO];
    }
    self.previousBtn = btn;
    
    //更新指示条水平约束
    [self.indHorConstraint uninstall];
    [self.indicatorView mas_updateConstraints:^(MASConstraintMaker *make) {
        self.indHorConstraint = make.centerX.equalTo(btn.mas_centerX);
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self layoutIfNeeded];
    }];
    
    //block
    if (self.menuBlock) {
        self.menuBlock(btn.tag-200);
    }
}


@end
