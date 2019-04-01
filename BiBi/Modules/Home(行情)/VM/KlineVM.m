//
//  KlineVM.m
//  BiBi
//
//  Created by frechai on 2018/4/3.
//  Copyright © 2018年 frechai. All rights reserved.
//

#import "KlineVM.h"
#import "KlineModelCalculation.h"
#import "KlinePositionCalculation.h"

@implementation KlineVM

+ (instancetype)shareInstance
{
    static KlineVM *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[KlineVM alloc] init];
    });
    return instance;
}

#pragma mark 数据处理逻辑
//1、请求接口，拿到原始数据
- (void)requestKlineDataWithType:(NSString *)type
{
//    self.type = type;
//    NSString *url = @"https://www.btc123.com/kline/klineapi";
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    param[@"type"] = type;
//    param[@"symbol"] = @"huobibtccny";
//    param[@"size"] = @"300";
//
//    [[NetManager shareInstance] requestWithUrl:url parameter:param success:^(id responseObject, NSError *err) {
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//
//            if ([responseObject isKindOfClass:[NSDictionary class]]) {
//                NSDictionary *dic = (NSDictionary *)responseObject;
//                NSArray *dataArr = [dic objectForKey:@"datas"];
//                if (dataArr.count) {
//                    [self.dataMutDic setObject:dataArr forKey:type];
//                }else{
//                    id saveData = [self.dataMutDic objectForKey:type];
//                    if ([saveData isKindOfClass:[NSArray class]]) {
//                        dataArr = saveData;
//                    }
//                }
//
//                if (dataArr.count == 0) return;
//                KLineGroupModel *groupModel = [KLineGroupModel modelWithArray:dataArr];
//                NSArray *stockArr = groupModel.models;
//                if (self.delegate && [self.delegate respondsToSelector:@selector(delegateAcceptArr:)]) {
//                    [self.delegate delegateAcceptArr:stockArr];
//                }
//            }
//        });
//    }fail:^(id responseObject, NSError *err) {
//        //代理
//    }];
//    KLineGroupModel *groupModel = [KLineGroupModel modelWithArray:dataArr];
//    NSArray *stockArr = groupModel.models;
//    [self delegateAcceptArr:stockArr];
    //本地数据
    NSString *file = [[NSBundle mainBundle] pathForResource:@"klineData" ofType:@"plist"];
    NSDictionary *dataDic = [[NSDictionary alloc] initWithContentsOfFile:file];
    NSArray *dataArr = [dataDic objectForKey:@"datas"];
    if (dataArr.count == 0) return;
    
    //2、原始数组数据--->转换股票模型数组
    NSArray *stockArr = [self convertKlineModelArrWithOriginArr:dataArr];
    //3、股票模型数组--->MA、JDK、MACD、BOLL算法转换
    NSMutableArray *caculateArr = [[KlineModelCalculation shareInstance] convertStockWithArr:stockArr];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(delegateAcceptStockArr:)]) {
        [self.delegate delegateAcceptStockArr:caculateArr];
    }
}

#pragma mark 原始数据转换
- (NSMutableArray <KlineModel *> *)convertKlineModelArrWithOriginArr:(NSArray *)arr
{
    NSMutableArray *stockArr = [[NSMutableArray alloc] init];
    if ([arr isKindOfClass:[NSArray class]]){
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSArray class]]) {
                KlineModel *stock = [[KlineModel alloc] init];
                [stock initwithArr:obj];
                [stockArr addObject:stock];
            }
        }];
    }

    return stockArr;
}

#pragma mark 转为坐标点数据
- (NSMutableArray *)convertPositionWithStockArr:(NSArray *)stockArr mainHeight:(CGFloat)MainHeight volumeHeight:(CGFloat)VolumeHeight targetHeight:(CGFloat)TargetHeight isLeft:(klinedirection)isleft
{
    NSMutableArray *positionsArr = [[NSMutableArray alloc] init];
    positionsArr = [[KlinePositionCalculation shareInstance] convertPositionWithStockArr:stockArr mainviewHeight:MainHeight volumeviewHeight:VolumeHeight targetviewHeight:TargetHeight isLeft:isleft];
    
    return positionsArr;
}


@end
