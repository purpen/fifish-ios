//
//  FSBatteryView.m
//  Fifish
//
//  Created by macpro on 16/8/16.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSBatteryView.h"

#import "LiveVideoMacro.h"

#import "RovInfo.h"

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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkBattery:) name:@"RovInfoChange" object:nil];
        
    }
    return self;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//电量改变
- (void)checkBattery:(NSNotification *)notice{
    RovInfo *rovinfo = notice.userInfo[@"RVOINFO"];
    self.BatteryValue = rovinfo.Remain_battery;
    
    [self setNeedsDisplay];
}

- (float)BatteryValue{
    return _BatteryValue;
    
}
- (void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
    
    float   _currentNum = _BatteryValue;
    
    CGContextRef bgContextRef = UIGraphicsGetCurrentContext();
    
    CGRect edgeframe = CGRectMake(0, 2, 10, self.frame.size.height-2);
    
    CGContextAddRect(bgContextRef, edgeframe);
    
    CGContextSetLineWidth(bgContextRef, 0.5);
    
    [LIVEVIDEO_DEFAULT_COLOR setStroke];
    
    CGContextStrokePath(bgContextRef);
    
    
   [LIVEVIDEO_DEFAULT_COLOR setFill];
    CGFloat pointWidth  = 3.0;
    CGFloat pointHeight = 2.0;
    CGContextMoveToPoint(bgContextRef, (edgeframe.size.width-pointWidth)/2, edgeframe.origin.y-pointHeight);
    
    CGContextAddLineToPoint(bgContextRef, (edgeframe.size.width-pointWidth)/2+pointWidth, edgeframe.origin.y-pointHeight);
    
    CGContextSetLineWidth(bgContextRef, pointHeight);
    
    CGContextStrokePath(bgContextRef);
    
    
    if (_currentNum <=0.2&&_currentNum>0.1) {
        [[UIColor orangeColor] set];
    }
    else if (_currentNum<=0.1&&_currentNum>0){
        [[UIColor redColor] set];
    }
    else if (_currentNum<=0.5&&_currentNum>0.2){
        [[UIColor yellowColor] set];
    }
    else{
        [LIVEVIDEO_DEFAULT_COLOR setFill];
    }
    CGContextFillRect(bgContextRef,CGRectMake(1, edgeframe.size.height*(1-_currentNum)+2+1,edgeframe.size.width-2,edgeframe.size.height*_currentNum-2));//填充框
    
    CGContextDrawPath(bgContextRef, kCGPathFillStroke);//绘画路径
    
    NSString * ste = [NSString stringWithFormat:@"%.f％",_currentNum*100];

    [ste drawInRect:CGRectMake(edgeframe.size.width+5,4/*一点一点试出来的*/, 40, edgeframe.size.height) withAttributes:@{NSForegroundColorAttributeName:LIVEVIDEO_DEFAULT_COLOR,NSFontAttributeName:[UIFont systemFontOfSize:10]}];
}
@end
