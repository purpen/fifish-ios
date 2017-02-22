//
//  FSRovDirectionView.m
//  Fifish
//
//  Created by macpro on 16/11/11.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSRovDirectionView.h"

#import "FSdirectionManager.h"

//测试用
#import "UIView+Toast.h"

//rov消息
#import "RovInfo.h"
#define toRad(X) (X*M_PI/180.0)
@interface FSRovDirectionView ()

/**
 背景view
 */
@property (nonatomic,strong) UIView      * backGroundView;

/*方向imageview*/
@property (nonatomic,strong) UIButton * headingImageView;

/*ROV*/
@property (nonatomic,strong) UIImageView * RovImageView;

/**
 东西南北文字显示
 */
@property (nonatomic,strong) UIView      * directionLabView;


/**
 当前ROV不能获取真正的地磁值，过度用字段(用于手动记录rov初始值)   0位置
 */
@property (nonatomic)           CGFloat   initialRovAngleValue;

/**
 当前ROV不能获取真正的地磁值，过度用字段(当前Rov角度值)
 */
@property (nonatomic)           CGFloat   CurrentRovAngleValue;

/**
 当前ROV不能获取真正的地磁值，过度用字段(用于手动记录地磁初始值)
 */
@property (nonatomic)           CGFloat   initialMagneticFieldVale;

/**
 当前ROV不能获取真正的地磁值，过度用字段(当前地磁偏转值)
 */
@property (nonatomic)           CGFloat   CurrentMagneticFieldVale;

/**
 测试用    是否需要记重置位置
 */
@property (nonatomic)           BOOL      isResavePoint;

/*
 地磁方向管理器
 */
@property (nonatomic,strong)FSdirectionManager * directionManager ;


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
        
        [self addSubview:self.RovImageView];
        [self.RovImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.center);
            make.size.mas_equalTo(CGSizeMake(70, 70));
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
//        [self testMethed];
        
//        监听ROV 航向
        [self ObserverWithOSDCourse];
        
        //地磁指南针
        [self realAngel];
    }
    return self;
}

-(UIView *)backGroundView{
    if (!_backGroundView) {
        _backGroundView = [[UIView alloc] init];
    }
    return _backGroundView;
}

-(UIImageView *)RovImageView{
    if (!_RovImageView) {
        
        _RovImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Rov_direction_Logo"]];
        
    }
    
    return _RovImageView;
}

-(UIButton *)headingImageView{
    if (!_headingImageView) {
        _headingImageView = [UIButton buttonWithType:UIButtonTypeCustom];
//        _headingImageView.image= [UIImage imageNamed:@"Rov_direction_BG"];
        [_headingImageView setBackgroundImage:[UIImage imageNamed:@"Rov_direction_BG"] forState:UIControlStateNormal];
        [_headingImageView addTarget:self action:@selector(ResavePoint:) forControlEvents:UIControlEventTouchDownRepeat];
        
        //长按
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(restoreRodeMap:)];
        longPress.minimumPressDuration = 2; //定义按的时间
        [_headingImageView addGestureRecognizer:longPress];
    }
    return _headingImageView;
}
-(UIView *)directionLabView{
    
    if (!_directionLabView) {
        _directionLabView = [[UIView alloc] init];
        _directionLabView.userInteractionEnabled = NO;
    }
    
    return _directionLabView;
    
}


/*地磁方向管理器*/
-(FSdirectionManager *)directionManager{
    if (!_directionManager) {
        
        _directionManager = [FSdirectionManager shared];
        
    }
    return _directionManager;
}





/*
    监听地磁角度，在block里面一直调用、
 */
- (void)realAngel{
    __block FSRovDirectionView * blockSelf = self;
    self.directionManager.didUpdateHeadingBlock = ^(CLLocationDirection theHeading){
        NSLog(@"%f",theHeading);
        blockSelf.CurrentMagneticFieldVale = theHeading;
        
        CGFloat AngleOffset     = blockSelf.CurrentMagneticFieldVale-blockSelf.initialMagneticFieldVale;/*地磁偏移量*/
        CGFloat HeadImagAngle   = 0-theHeading-90;
        CGFloat RovAngle        = blockSelf.CurrentRovAngleValue-AngleOffset;
        
        NSLog(@"磁场 ====%f",RovAngle);
        [UIView animateWithDuration:0.6
                              delay:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             CGAffineTransform headingRotation;
                             headingRotation = CGAffineTransformRotate(CGAffineTransformIdentity,(CGFloat)toRad(HeadImagAngle));
                             
                             headingRotation = CGAffineTransformScale(headingRotation, 1, 1);
                             blockSelf.headingImageView.transform = headingRotation;
                             blockSelf.RovImageView.transform =CGAffineTransformRotate(CGAffineTransformIdentity, (CGFloat)toRad(RovAngle));
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    };
    [self.directionManager startSensor];
}

#pragma marke 通知中心
//监听ROV航向
- (void)ObserverWithOSDCourse{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changecourse:) name:@"RovInfoChange" object:nil];
    
    
}


#warning  转动测试！
- (void)testMethed{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
       
        
        while (1) {
            
            
            CGFloat randomNumber = arc4random()%70;
            CGFloat routa = (360.0-(randomNumber-self.initialRovAngleValue/*当前值减去初始值*/));/*硬件磁感器装反了所以都用360减一下*/
            self.CurrentRovAngleValue = routa;
            
            if (self.isResavePoint==YES) {
                self.initialRovAngleValue = randomNumber;/*手动记录rov初始值*/
                self.isResavePoint = NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [KEY_WINDOW makeToast:[NSString stringWithFormat:@"方向初始成功，初始角度为:%f",self.initialRovAngleValue]];
                });
            }
            
            /*
             算出当前地磁相对于手动初始的偏移量、Rov手动初始的偏移量。rov最终旋转的角度就等于rov偏移量减去地磁偏移量，从而
             保证rov方向固定
             */
            CGFloat AngleOffset = self.CurrentMagneticFieldVale-self.initialMagneticFieldVale;/*地磁偏移量*/
            dispatch_async(dispatch_get_main_queue(), ^{
                CGFloat currentRovValue = (routa-AngleOffset);
                NSLog(@"RSDVALUE ====%f",currentRovValue);
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    self.RovImageView.transform = CGAffineTransformMakeRotation((CGFloat)toRad(currentRovValue));
                } completion:nil];
                
            });
            
            sleep(1);
            
        }
        
    });
    
}

- (void)changecourse:(NSNotification *)notice{
    
    RovInfo *rovinfo = notice.userInfo[@"RVOINFO"];

    CGFloat routa = (360.0-(rovinfo.Heading_angle-self.initialRovAngleValue/*当前值减去初始值*/));/*硬件磁感器装反了所以都用360减一下*/
    self.CurrentRovAngleValue = routa;
    
    if (self.isResavePoint==YES) {
        self.initialRovAngleValue = rovinfo.Heading_angle;/*手动记录rov初始值*/
        self.isResavePoint = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [KEY_WINDOW makeToast:[NSString stringWithFormat:@"方向初始成功，初始角度为:%f",self.initialRovAngleValue]];
        });
    }
    
    /*
     算出当前地磁相对于手动初始的偏移量、Rov手动初始的偏移量。rov最终旋转的角度就等于rov偏移量减去地磁偏移量，从而
     保证rov方向固定
     */
    CGFloat AngleOffset = self.CurrentMagneticFieldVale-self.initialMagneticFieldVale;/*地磁偏移量*/
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat currentRovValue = (routa-AngleOffset);
        NSLog(@"RSDVALUE ====%f",currentRovValue);
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.RovImageView.transform = CGAffineTransformMakeRotation((CGFloat)toRad(currentRovValue));
        } completion:nil];
        
    });
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.directionManager stopSensor];

}

#pragma mark 初始化操作
//手动记录当前偏转角作为基准值
- (void)ResavePoint:(UIButton*)btn{
    NSLog(@"fafafaf");
    
    self.initialMagneticFieldVale = self.CurrentMagneticFieldVale;/*手动记录当前磁场值*/
    self.isResavePoint = YES;
}

#pragma mark 点击重置路径点，测试用
- (void)restoreRodeMap:(UILongPressGestureRecognizer *)Gesture{
    if ([Gesture state] == UIGestureRecognizerStateBegan) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [KEY_WINDOW makeToast:@"路径重置成功！"];
        });
        [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteRodeMap" object:nil];
    }
}
@end
