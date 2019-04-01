//
//  Kline_menuView.m
//  BiBi
//
//  Created by frechai on 2018/4/3.
//  Copyright © 2018年 frechai. All rights reserved.
//

#import "Kline_menuView.h"

@interface Kline_menuView ()
@property(nonatomic, strong)UIButton *previousBtn; //前一个点击的按钮
@property(nonatomic, strong)UIButton *currentBtn;  //当前点击的按钮
@property(nonatomic, strong)UIButton *defaultBtn;  //默认点击的按钮
@property(nonatomic, strong)UIView *indicatorView; //底部指示条
@property(nonatomic, strong)UIScrollView *scrollview;
@property(nonatomic, strong)MASConstraint *indHorConstraint; //指示条水平约束
@end

@implementation Kline_menuView

+ (instancetype)menuBtnView
{
    Kline_menuView *menuBtnView = [[Kline_menuView alloc] init];
    return menuBtnView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray *titleArr = [NSArray arrayWithObjects:@"分时",@"k线",@"深度",@"全屏", nil];
        self.scrollview = [[UIScrollView alloc] init];
        self.scrollview.backgroundColor = NormalColor;
        self.scrollview.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.scrollview.showsHorizontalScrollIndicator = NO;
        self.scrollview.contentSize  = CGSizeMake(ScreenWidth, CGRectGetHeight(self.scrollview.frame));
        [self addSubview:self.scrollview];
        [self.scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        //分时 k线 深度 全屏
        for (NSInteger i = 0 ;i < titleArr.count;i++) {
            UIButton *btn =  [self createBtnWithTitle:titleArr[i]];
            btn.tag = i+1;
            btn.frame = CGRectMake(i*ScreenWidth/titleArr.count, 0, ScreenWidth/titleArr.count, 40);
            [self.scrollview addSubview:btn];
            
            //首次进入,默认选择1分线
            if (i == 0) {
                [btn setSelected:YES];
                [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
                self.defaultBtn = btn;
                kWeakSelf(self);
                self.menuBlock = ^{
                    if (weakself.delegate) {
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
                            [weakself.delegate clickBtnIndex:btn.tag];
                        });
                    }
                };
            }
        }
        
        //底部显示条
        self.indicatorView = [[UIView alloc] init];
        self.indicatorView.backgroundColor = SelectedColor;
        [self addSubview:self.indicatorView];
        [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            self.indHorConstraint = make.centerX.equalTo(self.defaultBtn.mas_centerX);
            make.bottom.equalTo(self.mas_bottom);
            make.height.offset(2);
            make.width.equalTo(self.defaultBtn.mas_width);
        }];
    }
    return self;
}

//生成button
- (UIButton *)createBtnWithTitle:(NSString *)title
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:KWhiteColor forState:UIControlStateNormal];
    [btn setTitleColor:SelectedColor forState:UIControlStateSelected];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [btn addTarget:self action:@selector(klineTypeClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

//k线类型按钮点击事件
- (void)klineTypeClick:(UIButton *)btn
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
    
    //代理
    if ([self.delegate respondsToSelector:@selector(clickBtnIndex:)]) {
        [self.delegate clickBtnIndex:btn.tag];
    }
}

@end
