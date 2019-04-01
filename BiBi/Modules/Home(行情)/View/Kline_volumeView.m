//
//  Kline_volumeView.m
//  BiBi
//
//  Created by frechai on 2018/4/3.
//  Copyright © 2018年 frechai. All rights reserved.
//

#import "Kline_volumeView.h"
#import "VolumePositionModel.h"

@interface Kline_volumeView ()

@property (nonatomic, assign) CGContextRef context;
@end

@implementation Kline_volumeView

- (instancetype)init
{
    self = [super init];
    if (self) {
        //self.layer.borderWidth = 0.5;
        //self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    return self;
}

#pragma mark 数据源
-(void)setVolumeArr:(NSMutableArray *)volumeArr
{
    _volumeArr = volumeArr;
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (self.context == nil) {
        self.context = UIGraphicsGetCurrentContext();
    }
    
    [self drawHorizontalLine];
    
    if (_volumeArr.count) {
        [self drawVolume];
        [self drawMa7];
        [self drawMa30];
    }
}

#pragma mark 背景水平虚线
- (void)drawHorizontalLine
{
    CGContextSetShouldAntialias(self.context, NO);
    CGMutablePathRef path = CGPathCreateMutable();
    int dashLineNumber = volumeviewHoritalLineCount;
    CGFloat interalValue = self.frame.size.height / dashLineNumber;
    
    CGFloat length[2] = {2,2};
    CGContextSaveGState(self.context);
    for (int i = 1; i < dashLineNumber; i++) {
        CGFloat y = interalValue * i;
        CGContextSetLineDash(self.context, 0, length, 2); // 虚线
        CGPathMoveToPoint(path, NULL, 0, y);
        CGPathAddLineToPoint(path, NULL, self.frame.size.width, y);
    }
    CGContextAddPath(self.context, path);
    
    CGContextSetLineWidth(self.context, 0.5);
    CGContextSetShouldAntialias(self.context, YES);  // 是否抗锯齿
    CGContextSetRGBStrokeColor(self.context, 150/255.0f, 150/255.0f, 150/255.0f, 0.5);
    
    CGContextDrawPath(self.context, kCGPathStroke);
    CGPathRelease(path);
    CGContextRestoreGState(self.context);
}

#pragma mark 成交量MA7线
- (void)drawMa7
{
    CGContextSetShouldAntialias(self.context, NO);
    CGMutablePathRef pathMA = CGPathCreateMutable();
    // CGContextRestoreGState(context);
    // MA5/MA10/MA20
    // search first MA != 0
    int skip = 0;
    NSArray *ma7arr = self.volumeArr[1];
    for (skip = 0 ; skip < ma7arr.count; skip++) {
        CGPoint ma7Point = [ma7arr[skip] CGPointValue];
        if (ma7Point.y < self.frame.size.height && ma7Point.y != 0) {
            CGPathMoveToPoint(pathMA, NULL, ma7Point.x, ma7Point.y);
            break;
        }
    }
    
    for (int i = skip + 1; i < ma7arr.count; i++) {
        CGPoint ma7Point = [ma7arr[i] CGPointValue];
        CGPathAddLineToPoint(pathMA, NULL, ma7Point.x, ma7Point.y);
    }
    CGContextSetLineWidth(self.context, 1);
    CGContextSetShouldAntialias(self.context, YES);  // 是否抗锯齿
    
    CGContextSetRGBStrokeColor(self.context, 254/255.0f, 165/255.0f, 0/255.0f, 1);//yellow
    CGContextAddPath(self.context, pathMA);
    CGContextDrawPath(self.context, kCGPathStroke);
    CGPathRelease(pathMA);
}

#pragma mark 成交量MA30
- (void)drawMa30
{
    CGContextSetShouldAntialias(self.context, NO);
    CGMutablePathRef pathMA = CGPathCreateMutable();
    // CGContextRestoreGState(context);
    // MA5/MA10/MA20
    // search first MA != 0
    int skip = 0;
    NSArray *ma30arr = self.volumeArr[2];
    for (skip = 0 ; skip < ma30arr.count; skip++) {
        CGPoint ma30Point = [ma30arr[skip] CGPointValue];
        if (ma30Point.y < self.frame.size.height && ma30Point.y != 0) {
            CGPathMoveToPoint(pathMA, NULL, ma30Point.x, ma30Point.y);
            break;
        }
    }
    
    for (int i = skip + 1; i < ma30arr.count; i++) {
        CGPoint ma30Point = [ma30arr[i] CGPointValue];
        CGPathAddLineToPoint(pathMA, NULL, ma30Point.x, ma30Point.y);
    }
    CGContextSetLineWidth(self.context, 1);
    CGContextSetShouldAntialias(self.context, YES);  // 是否抗锯齿
    
    CGContextSetRGBStrokeColor(self.context, 251/255.0f, 28/255.0f, 211/255.0f, 1);//yellow
    CGContextAddPath(self.context, pathMA);
    CGContextDrawPath(self.context, kCGPathStroke);
    CGPathRelease(pathMA);
    
}

#pragma mark 绘制成交量图
- (void)drawVolume
{
    CGFloat volumeWidth = [StockChartGlobalVariable kLineWidth];
    CGContextSetShouldAntialias(self.context, NO);
    
    NSArray *volumeArr = self.volumeArr[0];
    for (NSUInteger i = 0; i <volumeArr.count; i++) {
        VolumePositionModel *volumePoint = volumeArr[i];
        
        CGFloat x = volumePoint.endP.x - volumeWidth / 2;
        CGFloat y = volumePoint.endP.y;
        CGFloat width = volumeWidth;
        CGFloat height = self.frame.size.height - volumePoint.endP.y;;
        CGRect rect = CGRectMake(x, y, width, height);
        CGContextAddRect(self.context, rect);
        if (volumePoint.vStock.Open >= volumePoint.vStock.Close) { // 绿色
            // 1.先设置填充颜色，再填充颜色，否则是把当前设置填充颜色填到下一个矩形，导致右偏移bug
            // CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
            // 2.填充上下文指定的rect
            //CGContextFillRect(context, rect);
            [riseColor set]; //红色
            UIRectFrame(rect);
        }else{
            CGContextSetFillColorWithColor(self.context, fallColor.CGColor); //绿色
            CGContextFillRect(self.context, rect);
        }
        
        CGContextDrawPath(self.context, kCGPathStroke);
    }
}



@end
