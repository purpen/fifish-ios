//
//  FSRovMapView.m
//  Fifish
//
//  Created by macpro on 16/12/23.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSRovMapView.h"
#import "FSMapScrollview.h"

#import "FSdirectionManager.h"


#import "Masonry.h"


#define toRad(X) (X*M_PI/180.0)
@interface FSRovMapView ()
/**
 指南针
 */
@property (nonatomic,strong)UIImageView     * copassImageView;

@property (nonatomic,strong)FSMapScrollview * mapScrollview;

@property (nonatomic,strong)FSdirectionManager * directionManager ;

@end


@implementation FSRovMapView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        
        [self addSubview:self.mapScrollview];
        [self.mapScrollview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.mas_top);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
        }];
    
        [self addSubview:self.copassImageView];
        [self.copassImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.mas_top);
        }];
        
        //设置表格中心显示在视图中心
        _mapScrollview.contentOffset = CGPointMake((_mapScrollview.contentSize.width-120)/2, (_mapScrollview.contentSize.height-120)/2);
        
        //监听rov信息
        [self registerNotice];
        
        
        //地磁指南针
        [self compassViewAngleChange];
        
    }
    
    
    return self;
}

-(FSMapScrollview *)mapScrollview{
    if (!_mapScrollview) {
        _mapScrollview = [[FSMapScrollview alloc] init];
        _mapScrollview.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
    }
    return _mapScrollview;
}

-(FSdirectionManager *)directionManager{
    if (!_directionManager) {
        
        _directionManager = [FSdirectionManager shared];
        
    }
    return _directionManager;
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

//地磁指南针方向
- (void)compassViewAngleChange{
    __block FSRovMapView * blockSelf = self;
    self.directionManager.didUpdateHeadingBlock = ^(CLLocationDirection theHeading){
        NSLog(@"%f",theHeading);
        [UIView animateWithDuration:0.6
                              delay:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             CGAffineTransform headingRotation;
                             headingRotation = CGAffineTransformRotate(CGAffineTransformIdentity, (CGFloat)toRad(0)-toRad(theHeading)-(CGFloat)toRad(90));
                             
                             headingRotation = CGAffineTransformScale(headingRotation, 1, 1);
                             blockSelf.copassImageView.transform = headingRotation;
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    };
    [self.directionManager startSensor];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.directionManager stopSensor];
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
    
   
    
    
}


@end
