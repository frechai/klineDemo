//
//  KlineView.m
//  BiBi
//
//  Created by frechai on 2018/4/3.
//  Copyright © 2018年 frechai. All rights reserved.
//

#import "KlineView.h"

@interface KlineView ()

@property (nonatomic, assign) CGContextRef context;
@property (nonatomic, assign) BOOL isCreatPrice;
@end

@implementation KlineView

- (instancetype)init
{
    self = [super init];
    if (self) {
        //self.layer.borderWidth = 0.5;
        //self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    return self;
}

#pragma mark 生成价格显示控件
- (void)initPriceLabels
{
    self.isCreatPrice = YES;
    CGFloat x = self.x + 2;
    CGFloat h = 10;
    CGFloat y = 0;
    CGFloat constH = self.frame.size.height/klineviewHoritalLineCount;
    for (int i = 0; i < klineviewHoritalLineCount+1; i++) {
        UILabel *priceLb = [[UILabel alloc] init];
        if (i == 0) {
            y = 0;
        }else{
            y = constH*i - h;
        }
        
        priceLb.frame = CGRectMake(x, y, 100, h);
        priceLb.font = [UIFont systemFontOfSize:10];
        priceLb.textColor = [UIColor grayColor];
        priceLb.tag = 100+i;
        [self addSubview:priceLb];
    }
    
    [self showPriceWithHigh:self.highest low:self.lowest];
}

#pragma mark 传入坐标数组绘图
-(void)setKlinePositonArray:(NSMutableArray *)KlinePositonArray
{
    _KlinePositonArray = KlinePositonArray;
    [self setNeedsDisplay];
    //[self layoutIfNeeded];
}

#pragma mark 价格指示控件赋值
- (void)showPriceWithHigh:(CGFloat)high low:(CGFloat)low
{
    CGFloat avePrice = (high - low)/klineviewHoritalLineCount;
    for (int i = 0; i <= klineviewHoritalLineCount; i++) {
        UILabel *lb = (UILabel *)[self viewWithTag:100+i];
        lb.textColor = [UIColor whiteColor];
        CGFloat p = high - i*avePrice;
        lb.text = [NSString stringWithFormat:@"%.2f",p];
    }
}

#pragma mark 绘图
-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (self.context == nil) {
        self.context = UIGraphicsGetCurrentContext();
    }
    
    [self drawHorizontalLine];
    if (!self.isCreatPrice) {
        //[self initPriceLabels];
    }
    if (_KlinePositonArray.count) {
        [self drawKline];
        [self drawMa7];
        [self drawMa30];
    }
}

#pragma mark 水平背景虚线、价格指示
- (void)drawHorizontalLine
{
    CGContextSetShouldAntialias(self.context, NO);
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat interalValue = self.frame.size.height / klineviewHoritalLineCount;
    
    CGFloat length[2] = {2,2};
    CGContextSaveGState(self.context);
    for (int i = 1; i < klineviewHoritalLineCount; i++) {
        CGFloat y = interalValue * i;
        CGContextSetLineDash(self.context, 0, length, 2); //虚线
        CGPathMoveToPoint(path, NULL, 0, y);
        CGPathAddLineToPoint(path, NULL, self.frame.size.width, y);
    }
    CGContextAddPath(self.context, path);
    CGContextSetLineWidth(self.context, 0.5);
    CGContextSetShouldAntialias(self.context, YES);  //是否抗锯齿
    CGContextSetRGBStrokeColor(self.context, 150/255.0f, 150/255.0f, 150/255.0f, 0.5); // 虚线颜色
    
    CGContextDrawPath(self.context, kCGPathStroke);
    CGPathRelease(path);
    CGContextRestoreGState(self.context);
}

#pragma mark 绘制MA7
- (void)drawMa7
{
    CGContextSetShouldAntialias(self.context, NO);
    CGMutablePathRef pathMA = CGPathCreateMutable();
    
    int skip = 0;
    NSArray *ma7arr = self.KlinePositonArray[1];
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

#pragma mark 绘制MA30
- (void)drawMa30
{
    CGContextSetShouldAntialias(self.context, NO);
    CGMutablePathRef pathMA = CGPathCreateMutable();
    // CGContextRestoreGState(context);
    // MA5/MA10/MA20
    // search first MA != 0
    int skip = 0;
    NSArray *ma30arr = self.KlinePositonArray[2];
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



#pragma mark 绘制k线
- (void)drawKline
{
    CGFloat klinewidth = [StockChartGlobalVariable kLineWidth];
    CGContextSetShouldAntialias(self.context, NO);
    NSArray *klinearr = self.KlinePositonArray[0];
    
    for (NSUInteger i = 0; i < klinearr.count; i++) {
        KlinePositionModel *klinePoint = klinearr[i];
        
        if (klinePoint.OpenPoint.y >= klinePoint.ClosePoint.y) { // 红色
            [self addLineFrom:klinePoint.HighPoint toPoint:klinePoint.ClosePoint color:224 :0 :0];
            [self addLineFrom:klinePoint.OpenPoint toPoint:klinePoint.LowPoint color:224 :0 :0];
        }else{                                                              // 绿色
            [self addLineFrom:klinePoint.HighPoint toPoint:klinePoint.OpenPoint color:36 :186 :79];
            [self addLineFrom:klinePoint.ClosePoint toPoint:klinePoint.LowPoint color:36 :186 :79];
        }
        
        if (klinePoint.OpenPoint.y >= klinePoint.ClosePoint.y) { // 红色
            CGFloat x = klinePoint.ClosePoint.x - klinewidth / 2;
            CGFloat y = klinePoint.ClosePoint.y;
            CGFloat width = klinewidth;
            CGFloat height = klinePoint.OpenPoint.y - klinePoint.ClosePoint.y;
            if (height == 0) height = 1;
            CGRect rect = CGRectMake(x, y, width, height);
            
            CGContextAddRect(self.context, rect);
            //CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
            [riseColor set]; //红色
            //CGContextFillRect(context, rect);
            UIRectFrame(rect);
        }else{
            CGFloat x = klinePoint.OpenPoint.x - klinewidth / 2;
            CGFloat y = klinePoint.OpenPoint.y;
            CGFloat width = klinewidth;
            CGFloat height = klinePoint.ClosePoint.y - klinePoint.OpenPoint.y;
            if (height == 0) height = 1;
            CGRect rect = CGRectMake(x, y, width, height);
            CGContextAddRect(self.context, rect);
            //1.先设置填充颜色，再填充颜色，否则是把当前设置填充颜色填到下一个矩形，导致右偏移bug
            CGContextSetFillColorWithColor(self.context, fallColor.CGColor); //绿色
            //2.填充上下文指定的rect
            CGContextFillRect(self.context, rect);
        }
        
        CGContextDrawPath(self.context, kCGPathStroke);
    }
}

- (void)addLineFrom:(CGPoint)srcPoint toPoint:(CGPoint)desPoint color:(CGFloat)R :(CGFloat)G :(CGFloat)B
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(context, NO);
    CGMutablePathRef path = CGPathCreateMutable();
    CGContextSetRGBStrokeColor(context, R/255.0f, G/255.0f, B/255.0f, 1);
    CGPathMoveToPoint(path, NULL, srcPoint.x, srcPoint.y);
    CGPathAddLineToPoint(path, NULL, desPoint.x, desPoint.y);
    
    CGContextSetLineWidth(context, 1);
    CGContextSetShouldAntialias(context, YES);  // 是否抗锯齿
    
    CGContextAddPath(context, path);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(path);
}











@end
