//
//  FSRovMapView.m
//  Fifish
//
//  Created by macpro on 16/12/23.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSRovMapView.h"

#import "Masonry.h"
@interface FSRovMapView ()
/**
 指南针
 */
@property (nonatomic,strong)UIImageView * copassImageView;

@end


@implementation FSRovMapView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        
        [self addSubview:self.copassImageView];
        [self.copassImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.mas_top);
        }];
    
        
        //监听rov信息
        [self registerNotice];
    }
    
    
    return self;
}

/**
 监听ROV数据通知.
 */
- (void)registerNotice{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RovLocationChange:) name:@"RovInfoChange" object:nil];
}

- (void)RovLocationChange:(NSNotification *)info{
    NSLog(@"%@",info.userInfo);
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (UIImageView *)copassImageView{
    if (!_copassImageView) {
        _copassImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rov_compass_icon"]];
        
    }
    return _copassImageView;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    UIBezierPath * path;
    CGFloat lineSpace = rect.size.width/20.0;
    [[UIColor whiteColor] set];
    for (int i = 0; i<20; i++) {
        
        path = [UIBezierPath bezierPath];
        [path setLineWidth:1];
        if (i==10) {
            [path setLineWidth:2];
        }
        else{
            [path setLineWidth:1];
        }
        
        [path moveToPoint:CGPointMake(0, i*lineSpace)];
        [path  addLineToPoint:CGPointMake(rect.size.width, i*lineSpace)];
        
        [path moveToPoint:CGPointMake(i*lineSpace, 0)];
        [path  addLineToPoint:CGPointMake(i*lineSpace,rect.size.height)];
        
        [path stroke];
        
    }
    
    UIImage * pointImage = [UIImage imageNamed:@"Rov_centerpoint_icon"];
    [pointImage drawAtPoint:CGPointMake(((rect.size.width-pointImage.size.width)/2.0), ((rect.size.height-pointImage.size.height)/2.0))];

    UIImage * logoImage = [UIImage imageNamed:@"P4_logo"];
    [logoImage drawInRect:CGRectMake(43, 76, 20, 20)];
    
    
}


@end
