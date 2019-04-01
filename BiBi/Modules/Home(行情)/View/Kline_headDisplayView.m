//
//  Kline_headDisplayView.m
//  BiBi
//
//  Created by frechai on 2018/4/3.
//  Copyright © 2018年 frechai. All rights reserved.
//

#import "Kline_headDisplayView.h"

@interface Kline_headDisplayView()

@property (nonatomic, strong) UILabel *DollarNewPrice; //最新美元报价
@property (nonatomic, strong) UILabel *RMBNewPrice;    //最新人民币报价
@property (nonatomic, strong) UILabel *RiseFallValue;  //升降幅度
@property (nonatomic, assign) BOOL isRise; //是否涨势
@property (nonatomic, strong) UIImageView *arrowImageView; //涨跌指示图标
@property (nonatomic, strong) UILabel *SubRiseFall;  //涨跌幅副值

@property (nonatomic, strong) UILabel *Highest;   //最高价
@property (nonatomic, strong) UILabel *Lowest;    //最低价
@property (nonatomic, strong) UILabel *Amount;    //24小时成交额
@property (nonatomic, strong) UILabel *Volume;    //24小时成交量
@property (nonatomic, strong) UILabel *OpenPrice; //开盘价
@property (nonatomic, strong) UILabel *ClosePrice;//收盘价

@end

@implementation Kline_headDisplayView

+ (instancetype)shareInstance
{
    static Kline_headDisplayView *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[Kline_headDisplayView alloc] init];
    });
    
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = NormalColor;
        [self configureView];
    }
    return self;
}

#pragma mark 布局
- (void)configureView
{
    self.RiseFallValue = [self creatLabelWithFont:31 textColor:NewFallColor  textAlignment:NSTextAlignmentRight text:@"0.005586"]; //涨跌幅
    self.arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    self.RMBNewPrice = [self creatLabelWithFont:13 textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft text:@"￥140.00"]; //人民币最新报价
    self.DollarNewPrice = [self creatLabelWithFont:13 textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft text:@"$16.00"]; //美元最新报价
    self.SubRiseFall = [self creatLabelWithFont:11 textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft text:@"0.001862  0.92%"];
    self.Highest = [self creatLabelWithFont:13 textColor:[UIColor yellowColor] textAlignment:NSTextAlignmentLeft text:@"0.005586"];
    self.Lowest = [self creatLabelWithFont:13 textColor:[UIColor yellowColor] textAlignment:NSTextAlignmentLeft text:@"0.005586"];
    self.Amount = [self creatLabelWithFont:13 textColor:[UIColor yellowColor] textAlignment:NSTextAlignmentLeft text:@"245"];
    self.Volume = [self creatLabelWithFont:13 textColor:[UIColor yellowColor] textAlignment:NSTextAlignmentLeft text:@"35462.050"];
    UILabel *VolumeLabel = [self creatLabelWithFont:13 textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentRight text:@"24H成交量"];
    UILabel *AmountLabel = [self creatLabelWithFont:13 textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft text:@"24H成交额"];
    UILabel *lowLabel = [self creatLabelWithFont:13 textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft text:@"24H最低价"];
    UILabel *highLabel = [self creatLabelWithFont:13 textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft text:@"24H最高价"];
    [self addSubview:AmountLabel];
    [self addSubview:VolumeLabel];
    [self addSubview:lowLabel];
    [self addSubview:highLabel];
    [self addSubview:self.arrowImageView];
    //主涨跌幅
    [self.RiseFallValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(98*ScreenWidth/375);
        make.top.equalTo(self.mas_top).offset(24);
        make.width.equalTo(@131);
        make.height.equalTo(@24);
    }];
    
    //指示图标
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.RiseFallValue.mas_right).offset(3);
        make.bottom.equalTo(self.RiseFallValue.mas_bottom);
        make.width.equalTo(@10);
        make.top.equalTo(self.RiseFallValue.mas_top).offset(5);
    }];
    
    //人民币最新报价
    [self.RMBNewPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.RiseFallValue.mas_right).offset(16);
        make.top.equalTo(self.RiseFallValue.mas_top).offset(-3);
        make.height.equalTo(self.RiseFallValue.mas_height).multipliedBy(0.6);
        make.width.equalTo(@100);
    }];
    
    //美元最新报价
    [self.DollarNewPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.RMBNewPrice.mas_left);
        make.top.equalTo(self.RMBNewPrice.mas_bottom).offset(3);
        make.width.height.equalTo(self.RMBNewPrice);
    }];
    
    //涨跌幅副值
    [self.SubRiseFall mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.RiseFallValue.mas_left);
        make.top.equalTo(self.RiseFallValue.mas_bottom).offset(2);
        make.width.equalTo(self.RiseFallValue.mas_width);
        make.height.equalTo(@11);
    }];
    
    
    [VolumeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.bottom.equalTo(self.mas_bottom).offset(-44);
        make.width.equalTo(@71);
        make.height.equalTo(@13);
    }];
    
    [AmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(VolumeLabel.mas_left);
        make.top.equalTo(VolumeLabel.mas_bottom).offset(11);
        make.width.height.mas_equalTo(VolumeLabel);
    }];
    
    [lowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(VolumeLabel.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-86);
        make.width.height.mas_equalTo(VolumeLabel);
    }];
    
    [highLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.width.height.mas_equalTo(lowLabel);
        make.centerY.equalTo(AmountLabel.mas_centerY);
    }];
    
    //24H成交量
    [self.Volume mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(VolumeLabel.mas_right).offset(13);
        make.centerY.equalTo(VolumeLabel.mas_centerY);
        make.height.equalTo(VolumeLabel.mas_height);
    }];
    
    //24H成交额
    [self.Amount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(AmountLabel.mas_centerY);
        make.left.equalTo(self.Volume.mas_left);
        make.height.equalTo(AmountLabel.mas_height);
    }];
    
    //24H最低价
    [self.Lowest mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lowLabel.mas_right).offset(13);
        make.centerY.equalTo(lowLabel.mas_centerY);
        make.height.equalTo(lowLabel.mas_height);
    }];
    
    //24H最高价
    [self.Highest mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(highLabel.mas_right).offset(13);
        make.centerY.equalTo(highLabel.mas_centerY);
        make.height.equalTo(highLabel.mas_height);
    }];
  
}

- (UILabel *)creatLabelWithFont:(CGFloat)font textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)alignment text:(NSString *)text
{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:font];
    label.text = text;
    label.textColor = textColor;
    label.textAlignment = NSTextAlignmentLeft;
    label.adjustsFontSizeToFitWidth = YES;
    [self addSubview:label];
    return label;
}

#pragma mark 刷新头部数据
- (void)headViewDisplayWithModel:(KlineModel *)model
{
//    @property (nonatomic, strong) UILabel *DollarNewPrice; //最新美元报价
//    @property (nonatomic, strong) UILabel *RMBNewPrice;    //最新人民币报价
//    @property (nonatomic, strong) UILabel *RiseFallValue;  //升降幅度
//    @property (nonatomic, assign) BOOL isRise; //是否涨势
//    @property (nonatomic, strong) UIImageView *arrowImageView; //涨跌指示图标
//    @property (nonatomic, strong) UILabel *SubRiseFall;  //涨跌幅副值
//
//    @property (nonatomic, strong) UILabel *Highest;   //最高价
//    @property (nonatomic, strong) UILabel *Lowest;    //最低价
//    @property (nonatomic, strong) UILabel *Amount;    //24小时成交额
//    @property (nonatomic, strong) UILabel *Volume;    //24小时成交量
//    @property (nonatomic, strong) UILabel *OpenPrice; //开盘价
//    @property (nonatomic, strong) UILabel *ClosePrice;//收盘价
    self.Highest.text = [NSString stringWithFormat:@"%.f",model.High];
    self.Lowest.text = [NSString stringWithFormat:@"%.f",model.Low];
    self.Volume.text = [NSString stringWithFormat:@"%.f",model.Volume];
    self.Amount.text = [NSString stringWithFormat:@"%.f",model.Close];
    
    
  
}



@end
