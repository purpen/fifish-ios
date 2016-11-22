//
//  FSRovDirectionView.m
//  Fifish
//
//  Created by macpro on 16/11/11.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSRovDirectionView.h"

//测试用
#import "UIView+Toast.h"

//rov消息
#import "RovInfo.h"
@interface FSRovDirectionView ()

/**
 背景view
 */
@property (nonatomic,strong) UIView      * backGroundView;

//方向imageview
@property (nonatomic,strong) UIButton * headingImageView;

/**
 东西南北文字显示
 */
@property (nonatomic,strong) UIView      * directionLabView;


/**
 测试用   0位置
 */
@property (nonatomic)           CGFloat   testOrgrPoint;

/**
 测试用    是否需要记重置位置
 */
@property (nonatomic)           BOOL      isResavePoint;

@end


@implementation FSRovDirectionView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.backGroundView];
        [self.backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(self);
//            make.center.mas_equalTo(self.center);
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        [self addSubview:self.headingImageView];
        [self.headingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(self.backGroundView);
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        [self addSubview:self.directionLabView];
        [self.directionLabView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(self.backGroundView);
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        
//        测试旋转方法
        [self testMethed];
        
//        监听ROV 航向
//        [self ObserverWithOSDCourse];
    }
    return self;
}

-(UIView *)backGroundView{
    if (!_backGroundView) {
        _backGroundView = [[UIView alloc] init];
    }
    return _backGroundView;
}
-(UIButton *)headingImageView{
    if (!_headingImageView) {
        _headingImageView = [UIButton buttonWithType:UIButtonTypeCustom];
//        _headingImageView.image= [UIImage imageNamed:@"Rov_direction_BG"];
        [_headingImageView setBackgroundImage:[UIImage imageNamed:@"Rov_direction_BG"] forState:UIControlStateNormal];
        [_headingImageView addTarget:self action:@selector(ResavePoint:) forControlEvents:UIControlEventTouchDownRepeat];
    }
    return _headingImageView;
}
-(UIView *)directionLabView{
    
    if (!_directionLabView) {
        _directionLabView = [[UIView alloc] init];
        _directionLabView.userInteractionEnabled = NO;
        
#warning 我感觉这个渣渣写法肯定不对，肯定有简便布局方法
        UILabel * Nlab =[[UILabel alloc] init];
        Nlab.textColor = [UIColor whiteColor];
        Nlab.font = [UIFont systemFontOfSize:10];
        Nlab.text = @"N";
        [_directionLabView addSubview:Nlab];
        [Nlab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_directionLabView.mas_top).offset(5);
            make.centerX.equalTo(_directionLabView.mas_centerX);
        }];
        UILabel * Elab =[[UILabel alloc] init];
        Elab.textColor = [UIColor whiteColor];
        Elab.font = [UIFont systemFontOfSize:10];
        Elab.text = @"E";
        [_directionLabView addSubview:Elab];
        [Elab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_directionLabView.mas_right).offset(-5);
            make.centerY.equalTo(_directionLabView.mas_centerY);
        }];

        UILabel * Slab =[[UILabel alloc] init];
        Slab.textColor = [UIColor whiteColor];
        Slab.font = [UIFont systemFontOfSize:10];
        Slab.text = @"S";
        [_directionLabView addSubview:Slab];
        [Slab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_directionLabView.mas_bottom).offset(-5);
            make.centerX.equalTo(_directionLabView.mas_centerX);
        }];
        
        UILabel * Wlab =[[UILabel alloc] init];
        Wlab.textColor = [UIColor whiteColor];
        Wlab.font = [UIFont systemFontOfSize:10];
        Wlab.text = @"W";
        [_directionLabView addSubview:Wlab];
        [Wlab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_directionLabView.mas_left).offset(5);
            make.centerY.equalTo(_directionLabView.mas_centerY);
        }];
    }
    
    return _directionLabView;
    
}

#warning  转动测试！
- (void)testMethed{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (1) {
            CGFloat randomNumber = arc4random()%360-self.testOrgrPoint;
            CGFloat routa = randomNumber*M_PI/180.0;
            
            if (self.isResavePoint==YES) {
                self.testOrgrPoint = randomNumber;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [KEY_WINDOW makeToast:[NSString stringWithFormat:@"方向初始成功，初始角度为:%f",self.testOrgrPoint]];
                });
                
                self.isResavePoint = NO;
            }
            
            NSLog(@"%f",self.testOrgrPoint);
            NSLog(@"%f",randomNumber);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    self.headingImageView.transform = CGAffineTransformMakeRotation(routa);
                } completion:nil];
                
            });
            
            sleep(2);
        
        }
        
    });
    
}

#pragma marke 通知中心
//监听ROV航向
- (void)ObserverWithOSDCourse{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changecourse:) name:@"RovInfoChange" object:nil];
}
- (void)changecourse:(NSNotification *)notice{
    RovInfo *rovinfo = notice.userInfo[@"RVOINFO"];
    
    CGFloat routa = (rovinfo.Heading_angle-self.testOrgrPoint)*M_PI/180.0;
    
    if (self.isResavePoint==YES) {
        self.testOrgrPoint = rovinfo.Heading_angle;
        
        self.isResavePoint = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [KEY_WINDOW makeToast:[NSString stringWithFormat:@"方向初始成功，初始角度为:%f",self.testOrgrPoint]];
        });
    }
    
    NSLog(@"%f",self.testOrgrPoint);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.headingImageView.transform = CGAffineTransformMakeRotation(routa);
        } completion:nil];
        
    });
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

#pragma mark test
- (void)ResavePoint:(UIButton*)btn{
    NSLog(@"fafafaf");
    self.isResavePoint = YES;
}
@end
