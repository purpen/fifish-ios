//
//  FSBatteryView.m
//  Fifish
//
//  Created by macpro on 16/8/16.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSBatteryView.h"

@interface FSBatteryView()

//电量
@property (nonatomic ,assign) float BatteryValue;

@end


@implementation FSBatteryView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkBattery) name:UIDeviceBatteryLevelDidChangeNotification object:nil];
        
    }
    return self;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//电量改变
- (void)checkBattery{
    [self setNeedsDisplay];
}

- (float)BatteryValue{
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    return [UIDevice currentDevice].batteryLevel;
    
}
- (void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
    
    float   _currentNum = self.BatteryValue;
    
    CGContextRef bgContextRef = UIGraphicsGetCurrentContext();
    
    CGRect edgeframe = CGRectMake(0, 0, 20, self.frame.size.height);
    
    CGContextAddRect(bgContextRef, edgeframe);
    
    CGContextSetLineWidth(bgContextRef, 0.5);
    
    [[UIColor blackColor] setStroke];
    
    CGContextStrokePath(bgContextRef);
    
    
    
    CGFloat pointWidth  = 2.0;
    CGFloat pointHeight = 1.0;
    CGContextMoveToPoint(bgContextRef, edgeframe.size.width+1, (edgeframe.size.height-pointHeight)/2);
    
    CGContextAddLineToPoint(bgContextRef, edgeframe.size.width+1+pointWidth, (edgeframe.size.height-pointHeight)/2);
    
    CGContextSetLineWidth(bgContextRef, pointWidth);
    
    CGContextStrokePath(bgContextRef);
    
    
    [[UIColor yellowColor] setStroke];
    CGContextFillRect(bgContextRef,CGRectMake(1, 1,(edgeframe.size.width-2)*_currentNum, edgeframe.size.height-2));//填充框
    
    CGContextDrawPath(bgContextRef, kCGPathFillStroke);//绘画路径
    
    NSString * ste = [NSString stringWithFormat:@"%.f％",_currentNum*100];
    
    //    [ste drawAtPoint:CGPointMake(edgeframe.size.width+5,0) withAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:10]}];
    [ste drawInRect:CGRectMake(edgeframe.size.width+5,-1.5, 40, edgeframe.size.height) withAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:10]}];
}
@end
