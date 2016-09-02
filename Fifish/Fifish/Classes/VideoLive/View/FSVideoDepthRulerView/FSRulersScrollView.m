//
//  FSRulersScrollView.m
//  Fifish
//
//  Created by macpro on 16/9/2.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSRulersScrollView.h"

CGFloat const DISTANCELEFTANDRIGHT = 10.f;
CGFloat const DISTANCETOPANDBOTTOM = 5.f;

@interface FSRulersScrollView()

@property (nonatomic) CGFloat   MaxValue;
@property (nonatomic) CGFloat   MinValue;
@property (nonatomic) CGFloat   stpe;

@property (nonatomic) CGFloat   SelfWidth;
@property (nonatomic) CGFloat   SelfHei;

@property (nonatomic) CGFloat   DISTANCEVALUE;//间隔



@end
@implementation FSRulersScrollView
-(instancetype)initWithMinValue:(CGFloat)minvalue WithMaxValue:(CGFloat)maxvalue WithStpe:(CGFloat)stpe WithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.DISTANCEVALUE = 5.f;
        self.DISTANCEVALUE = stpe;
        
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator= NO;
        self.contentSize = CGSizeMake(0, (maxvalue-minvalue)*self.DISTANCEVALUE);
        self.MaxValue = maxvalue;
        self.MinValue = minvalue;
        self.stpe     = stpe;
        self.SelfHei = self.frame.size.height;
        self.SelfWidth= self.frame.size.width;
        [self setUpLayer];
    }
    return self;
}

- (void)setUpLayer{
    
    CGMutablePathRef pathRef1 = CGPathCreateMutable();
    CGMutablePathRef pathRef2 = CGPathCreateMutable();
    
    CAShapeLayer *shapeLayer1 = [CAShapeLayer layer];
    shapeLayer1.strokeColor = [UIColor blackColor].CGColor;
    shapeLayer1.fillColor = [UIColor blackColor].CGColor;
    shapeLayer1.lineWidth = 1.f;
    shapeLayer1.lineCap = kCALineCapButt;
    
    CAShapeLayer *shapeLayer2 = [CAShapeLayer layer];
    shapeLayer2.strokeColor = [UIColor blackColor].CGColor;
    shapeLayer2.fillColor = [UIColor blackColor].CGColor;
    shapeLayer2.lineWidth = 1.f;
    shapeLayer2.lineCap = kCALineCapButt;
    
    for (int i =0; i<=self.MaxValue-self.MinValue; i++) {
        if (i % 10 == 0) {
            CGPathMoveToPoint(pathRef2, NULL,_SelfWidth-14,  self.DISTANCEVALUE * i);
            CGPathAddLineToPoint(pathRef2, NULL,_SelfWidth,  self.DISTANCEVALUE * i);
        }
        
        else if (i % 5 == 0) {
            CGPathMoveToPoint(pathRef1, NULL, _SelfWidth, self.DISTANCEVALUE * i );
            CGPathAddLineToPoint(pathRef1, NULL, _SelfWidth-10,  self.DISTANCEVALUE * i);
        }
        else
        {
            CGPathMoveToPoint(pathRef1, NULL, _SelfWidth, self.DISTANCEVALUE * i );
            CGPathAddLineToPoint(pathRef1, NULL,_SelfWidth-6, self.DISTANCEVALUE * i);
        }
        shapeLayer1.path = pathRef1;
        shapeLayer2.path = pathRef2;
        
        [self.layer addSublayer:shapeLayer1];
        [self.layer addSublayer:shapeLayer2];
        
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
//- (void)drawRect:(CGRect)rect {
//    
//}


@end
