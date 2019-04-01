//
//  QuotationCell.m
//  BiBi
//
//  Created by frechai on 2018/4/3.
//  Copyright © 2018年 frechai. All rights reserved.
//

#import "QuotationCell.h"

@implementation QuotationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#1A1F27"];
        [self setUpUI];
    }
    
    return self;
}

//行情cell
- (void)setUpUI
{
    UILabel *commodityLb = [[UILabel alloc] init];
    commodityLb.text = @"DNC";
    commodityLb.textColor = [UIColor whiteColor];
    commodityLb.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:commodityLb];
    [commodityLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(30);
    }];
    
    UILabel *submitLb = [[UILabel alloc] init];
    submitLb.text = @"/BTC";
    submitLb.textColor = [UIColor lightGrayColor];
    submitLb.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:submitLb];
    [submitLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(commodityLb.mas_centerY);
        make.left.equalTo(commodityLb.mas_right);
        make.left.lessThanOrEqualTo(commodityLb.mas_right);
    }];
    
    UILabel *priceLb = [[UILabel alloc] init];
    priceLb.text = @"0.02932";
    priceLb.textColor = [UIColor colorWithHexString:@"#1DD09B"];
    priceLb.font = [UIFont boldSystemFontOfSize:18];
    [self.contentView addSubview:priceLb];
    [priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(submitLb.mas_centerY);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    UILabel *rangeLb = [[UILabel alloc] init];
    rangeLb.text = @"+0.11%";
    rangeLb.textColor = [UIColor colorWithHexString:@"#1DD09B"];
    rangeLb.font = [UIFont boldSystemFontOfSize:18];
    [self.contentView addSubview:rangeLb];
    [rangeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(priceLb.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
 
}




@end
