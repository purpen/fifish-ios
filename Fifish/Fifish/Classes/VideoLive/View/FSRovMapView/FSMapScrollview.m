//
//  FSMapScrollview.m
//  Fifish
//
//  Created by macpro on 16/12/27.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSMapScrollview.h"
#import "LiveVideoMacro.h"
#import "Masonry.h"

@interface FSMapScrollview()
@property (nonatomic)       NSInteger   testNumber;
@property (nonatomic,strong)UIImageView * centerImageview;

/**
 ROV图标
 */
@property (nonatomic,strong)UIImageView * LogoImageView;

/**
 格子间隔
 */
@property (nonatomic)       CGFloat      boxSpace;

@end


@implementation FSMapScrollview

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        
        
        self.contentSize =CGSizeMake(4000, 4000);
        
        //画格子
        [self drawBox];
        
        //添加中心点和ROVlogo
        [self addCenterPointAndRovLogo];
        
        
        NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [self Addpoints:[self LastPoitn:[self.pointArrs[self.pointArrs.count-1] CGPointValue] currentAngel:arc4random()%360 distence:0.1]];
        }];
        [timer fire];
        
    }
    return self;
}

- (CGPoint)LastPoitn:(CGPoint)lastpoin currentAngel:(CGFloat)currentAngle distence:(CGFloat)distence{
    
    CGFloat RecultAngle = 0.0;
    CGFloat distenceX = 0.0;/*根据勾股定理计算来的X轴变化量*/
    CGFloat distenceY = 0.0;/*根据勾股定理计算来的Y轴变化量*/
    
    CGFloat currentX  = 0.0;
    CGFloat currentY  = 0.0;
    
    if (currentAngle<90) {
        RecultAngle = currentAngle*M_PI/180.0;
        distenceX = distence * sin(RecultAngle);
        distenceY = distence * cos(RecultAngle);
        
        currentX  = lastpoin.x + distenceX;
        currentY  = lastpoin.y + distenceY;
    }
    
    if (currentAngle>90&&currentAngle<180) {
        RecultAngle = (currentAngle-90.0)*M_PI/180.0;
        distenceX = distence * cos(RecultAngle);
        distenceY = distence * sin(RecultAngle);
        
        currentX  = lastpoin.x+distenceX;
        currentY  = lastpoin.y-distenceY;
    }
    
    if (currentAngle>180&&currentAngle<270) {
        RecultAngle = (currentAngle-180.0)*M_PI/180.0;
        distenceX = distence * sin(RecultAngle);
        distenceY = distence * cos(RecultAngle);
        
        currentX  = lastpoin.x-distenceX;
        currentY  = lastpoin.y-distenceY;
    }
    
    if (currentAngle>270&currentAngle<360.0) {
        RecultAngle = (currentAngle-270.0)*M_PI/180.0;
        distenceX = distence * cos(RecultAngle);
        distenceY = distence * sin(RecultAngle);
        
        currentX  = lastpoin.x-distenceX;
        currentY  = lastpoin.y+distenceY;
    }
    if (currentAngle == 0||currentAngle ==360) {
        currentX = lastpoin.x;currentY = lastpoin.y+distence;
    }
    if (currentAngle == 90) {
        currentX = lastpoin.x+distence;currentY = lastpoin.y;
    }
    if (currentAngle==180) {
        currentX = lastpoin.x;currentY = lastpoin.y-distence;
    }
    if (currentAngle==270) {
        currentX = lastpoin.x-distence;currentY=lastpoin.y;
    }
    
    return CGPointMake(currentX, currentY);
    
}


- (void)test{
   
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self test];
}
- (void)addCenterPointAndRovLogo{
    [self addSubview:self.centerImageview];
    [self addSubview:self.LogoImageView];

}

-(UIImageView *)centerImageview{
    if (!_centerImageview) {
        _centerImageview = [[UIImageView alloc] initWithFrame:CGRectMake((self.contentSize.width-10)/2, (self.contentSize.height-10)/2, 10, 10)];
        _centerImageview.image = [UIImage imageNamed:@"Rov_centerpoint_icon"];
    }
    return _centerImageview;
}
-(UIImageView *)LogoImageView{
    if (!_LogoImageView) {
        _LogoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.contentSize.width-15)/2, (self.contentSize.height-15)/2, 15, 15)];
        _LogoImageView.image = [UIImage imageNamed:@"P4_logo"];
        
    }
    return _LogoImageView;
}

- (void)drawBox{
    CGMutablePathRef pathRef = CGPathCreateMutable();
    
    CAShapeLayer  * LineLayer = [CAShapeLayer layer];
    LineLayer.strokeColor = LIVEVIDEO_WHITE_COLOR.CGColor;
    LineLayer.lineWidth = 1.f;
    LineLayer.lineCap = kCALineCapButt;
    
    NSInteger boxCount = 200;
    CGFloat Space = self.contentSize.width/boxCount;
    self.boxSpace = Space;
    
    CGFloat BigBoxCenter= boxCount/2.0;
    
    
    for (int i = 0; i<=boxCount; i++) {
        if (i!=BigBoxCenter) {
            
            CGPathMoveToPoint(pathRef, NULL, 0, Space * i );
            CGPathAddLineToPoint(pathRef, NULL, self.contentSize.width,  Space * i);
            
            CGPathMoveToPoint(pathRef, NULL, Space * i, 0 );
            CGPathAddLineToPoint(pathRef, NULL,Space * i, self.contentSize.height );
            
            LineLayer.path = pathRef;
            
            [self.layer addSublayer:LineLayer];
            
        }
    }
    CAShapeLayer  * LineLayerTen = [CAShapeLayer layer];
    CGMutablePathRef pathRefTen = CGPathCreateMutable();
    LineLayerTen.strokeColor = LIVEVIDEO_WHITE_COLOR.CGColor;
    LineLayerTen.lineWidth = 2.f;
    LineLayerTen.lineCap = kCALineCapButt;
    
    CGPathMoveToPoint(pathRefTen, NULL, 0, Space *BigBoxCenter );
    CGPathAddLineToPoint(pathRefTen, NULL, self.contentSize.width,  Space *BigBoxCenter);
    
    CGPathMoveToPoint(pathRefTen, NULL, Space *BigBoxCenter, 0 );
    CGPathAddLineToPoint(pathRefTen, NULL,Space *BigBoxCenter, self.contentSize.height );
    
    LineLayerTen.path = pathRefTen;
    
    [self.layer addSublayer:LineLayerTen];
    
    CGPathRelease(pathRef);
    CGPathRelease(pathRefTen);
}

-(void)Addpoints:(CGPoint)point{
    [self.pointArrs addObject:[NSValue valueWithCGPoint:point]];
    
    [self drawLineOntheLayer];
}

- (NSMutableArray *)pointArrs{
    if (!_pointArrs) {
        
        _pointArrs = [NSMutableArray array];
        [_pointArrs addObject:[NSValue valueWithCGPoint:CGPointMake(0, 0)]];
        
    }
    return _pointArrs;
    
}



- (void)drawLineOntheLayer{
    
    CAShapeLayer            *  lineLayer = [CAShapeLayer layer];
    lineLayer.lineWidth     = 1.f;
    lineLayer.lineCap       = @"round";
    lineLayer.strokeColor   = [UIColor cyanColor].CGColor;
    
    CGMutablePathRef linePath = CGPathCreateMutable();
    
    
    CGPoint  lastPoint      =[self PointChange:[self.pointArrs[self.pointArrs.count-2] CGPointValue]] ;//上一个点
    
    CGPoint  currentPoint   = [self PointChange:[self.pointArrs[self.pointArrs.count-1] CGPointValue]];//当前点
    
    CGPathMoveToPoint(linePath, NULL,lastPoint.x, lastPoint.y);
    CGPathAddLineToPoint(linePath, NULL, currentPoint.x, currentPoint.y);
    lineLayer.path = linePath;
    
//    NSLog(@"last:-----%@\n",NSStringFromCGPoint(lastPoint));
//    
//    NSLog(@"current:=====%@\n",NSStringFromCGPoint(currentPoint));
    [self.layer addSublayer:lineLayer];
    
//    rov跟随轨迹点运动
    self.LogoImageView.center = currentPoint;
    
//    让当前点始终处于屏幕中心
    self.contentOffset = CGPointMake(currentPoint.x-(self.frame.size.width/2), currentPoint.y-(self.frame.size.height/2));
    
    CGPathRelease(linePath);
    
}

//坐标转换
- (CGPoint)PointChange:(CGPoint)point{
    return CGPointMake(point.x*self.boxSpace+self.contentSize.width/2.0, self.contentSize.height/2.0-point.y*self.boxSpace);
}












































// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
// UIBezierPath * path;
// CGFloat lineSpace = rect.size.width/10.0;
// [[UIColor whiteColor] set];
// for (int i = 0; i<10; i++) {
// 
// path = [UIBezierPath bezierPath];
// [path setLineWidth:1];
// if (i==5) {
// [path setLineWidth:2];
// }
// else{
// [path setLineWidth:1];
// }
// 
// [path moveToPoint:CGPointMake(0, i*lineSpace)];
// [path  addLineToPoint:CGPointMake(rect.size.width, i*lineSpace)];
// 
// [path moveToPoint:CGPointMake(i*lineSpace, 0)];
// [path  addLineToPoint:CGPointMake(i*lineSpace,rect.size.height)];
// 
// [path stroke];
// 
// }
// 
// UIImage * pointImage = [UIImage imageNamed:@"Rov_centerpoint_icon"];
// [pointImage drawAtPoint:CGPointMake(((rect.size.width-pointImage.size.width)/2.0), ((rect.size.height-pointImage.size.height)/2.0))];
// 
// UIImage * logoImage = [UIImage imageNamed:@"P4_logo"];
// [logoImage drawInRect:CGRectMake(43, 76, 15, 15)];
// 
// 
//}


@end