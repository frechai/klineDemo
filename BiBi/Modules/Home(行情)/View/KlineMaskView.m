//
//  KlineMaskView.m
//  YM_KLineDemo
//
//  Created by frechai on 2018/4/3.
//  Copyright © 2018年 frechai. All rights reserved.
//

#import "KlineMaskView.h"

#define IndicatorBackgroud [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1.0]

@implementation KlineMaskView

- (void)setSelectedKlineModel:(KlinePositionModel *)selectedKlineModel
{
    _selectedKlineModel = selectedKlineModel;
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    画虚线
//    CGFloat lengths[] = {3,3};
//    CGContextSetLineDash(ctx, 0, lengths, 2);
    CGContextSetStrokeColorWithColor(ctx, [UIColor grayColor].CGColor);
    CGContextSetLineWidth(ctx, 0.5);
    
    CGFloat x = self.selectedKlineModel.ClosePoint.x;
    
    //绘制横线
    CGContextMoveToPoint(ctx, self.frame.origin.x, self.frame.origin.y + self.selectedKlineModel.ClosePoint.y);
    CGContextAddLineToPoint(ctx, self.frame.origin.x + self.frame.size.width, self.frame.origin.y + self.selectedKlineModel.ClosePoint.y);
    
    //绘制竖线
    CGContextMoveToPoint(ctx, x, self.frame.origin.y);
    CGContextAddLineToPoint(ctx, x, self.frame.origin.y + self.bounds.size.height - StockLineDayHeight/2.f);
    CGContextStrokePath(ctx);
    
    //绘制交叉圆点
//    CGContextSetStrokeColorWithColor(ctx, [UIColor orangeColor].CGColor);
//    CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
//    CGContextSetLineWidth(ctx, 1.5);
//    CGContextSetLineDash(ctx, 0, NULL, 0);
//    CGContextAddArc(ctx, x, self.frame.origin.y + self.selectedKlineModel.closePoint.y, StockPointRadius, 0, 2 * M_PI, 0);
//    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    //绘制选中日期
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:9],NSForegroundColorAttributeName:[UIColor blackColor]};
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.selectedKlineModel.Stock.OpenTime/1000];
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateStr = [formatter stringFromDate:date];
    NSString *dayText = dateStr;
    CGRect textRect = [self rectOfNSString:dayText attribute:attribute];
    
    if (x + textRect.size.width/2.f + 2 > CGRectGetMaxX(self.frame)) {
        CGContextSetFillColorWithColor(ctx, IndicatorBackgroud.CGColor);
        CGContextFillRect(ctx, CGRectMake(CGRectGetMaxX(self.frame) - 4 - textRect.size.width, self.frame.origin.y + self.bounds.size.height - StockLineDayHeight, textRect.size.width + 4, textRect.size.height + 4));
        [dayText drawInRect:CGRectMake(CGRectGetMaxX(self.frame) - 4 - textRect.size.width + 2, self.frame.origin.y + self.bounds.size.height - StockLineDayHeight + 2, textRect.size.width, textRect.size.height) withAttributes:attribute];
    } else {
        CGContextSetFillColorWithColor(ctx, IndicatorBackgroud.CGColor);
        CGContextFillRect(ctx, CGRectMake(x-textRect.size.width/2.f, self.frame.origin.y + self.bounds.size.height - StockLineDayHeight, textRect.size.width + 4, textRect.size.height + 4));
        [dayText drawInRect:CGRectMake(x-textRect.size.width/2.f + 2, self.frame.origin.y + self.bounds.size.height - StockLineDayHeight + 2, textRect.size.width, textRect.size.height) withAttributes:attribute];
    }
    
    //绘制选中价格
    NSString *priceText = [NSString stringWithFormat:@"%.2f",self.selectedKlineModel.Stock.Close];
    CGRect priceRect = [self rectOfNSString:priceText attribute:attribute];
    CGContextSetFillColorWithColor(ctx, IndicatorBackgroud.CGColor);
    CGContextFillRect(ctx, CGRectMake(StockScrollViewLeftGap - priceRect.size.width - 4, self.frame.origin.y + self.selectedKlineModel.ClosePoint.y - priceRect.size.height/2.f - 2, priceRect.size.width + 4, priceRect.size.height + 4));
    [priceText drawInRect:CGRectMake(StockScrollViewLeftGap - priceRect.size.width - 4, self.frame.origin.y + self.selectedKlineModel.ClosePoint.y - priceRect.size.height/2.f, priceRect.size.width, priceRect.size.height) withAttributes:attribute];

}

- (CGRect)rectOfNSString:(NSString *)string attribute:(NSDictionary *)attribute {
    CGRect rect = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                       options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil];
    return rect;
}

@end
