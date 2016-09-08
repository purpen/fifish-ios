//
//  FSVideoLiveBottomBar.m
//  Fifish
//
//  Created by macpro on 16/8/17.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSVideoLiveBottomBar.h"

#import "FSCameraManager.h"

#import "UIView+Toast.h"

#import<libkern/OSAtomic.h>
@interface FSVideoLiveBottomBar ()

//录制时间
@property (nonatomic, strong) UILabel   * record_TimeLab;
//计时器
@property (nonatomic,strong)  dispatch_source_t timer;

//录像按钮
@property (nonatomic, strong) UIButton  * record_btn;

//照相按钮
@property (nonatomic, strong) UIButton  * take_photoBtn;

//标题
@property (nonatomic, strong) UILabel   * TitleLab;

//存储中

@property (nonatomic)         BOOL       isReciveVideo;

@property (nonatomic)         __block  NSUInteger timeOutCount;

@end

@implementation FSVideoLiveBottomBar
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.TitleLab];
        [self.TitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.centerX.equalTo(self.mas_centerX);
        }];
        
        [self addSubview:self.record_btn];
        [self.record_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        [self addSubview:self.record_TimeLab];
        [self.record_TimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.record_btn.mas_left).offset(-10);
        }];
        
        [self addSubview:self.take_photoBtn];
        [self.take_photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.left.equalTo(self.record_btn.mas_right).offset(10);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    return self;
}
- (UILabel *)TitleLab{
    if (!_TitleLab) {
        _TitleLab = [[UILabel alloc] init];
        _TitleLab.textColor = [UIColor whiteColor];
        _TitleLab.font = [UIFont systemFontOfSize:13];
        _TitleLab.text = NSLocalizedString(@"Video", nil);
    }
    return _TitleLab;
}
- (UIButton *)record_btn{
    if (!_record_btn) {
        _record_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_record_btn setImage:[UIImage imageNamed:@"record_btn_seleted"] forState:UIControlStateSelected];
        [_record_btn setImage:[UIImage imageNamed:@"record_btn"] forState:UIControlStateNormal];
        [_record_btn addTarget:self action:@selector(recordViedeo:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _record_btn;
}
- (UILabel *)record_TimeLab{
    if (!_record_TimeLab) {
        _record_TimeLab = [[UILabel alloc] init];
        _record_TimeLab.textColor = [UIColor whiteColor];
        _record_TimeLab.font = [UIFont systemFontOfSize:13];
        _record_TimeLab.text = @"00:00:00";
    }
    return _record_TimeLab;
}
- (UIButton *)take_photoBtn{
    if (!_take_photoBtn) {
        _take_photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_take_photoBtn setImage:[UIImage imageNamed:@"record_btn"] forState:UIControlStateNormal];
        [_take_photoBtn addTarget:self action:@selector(takePhotoClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _take_photoBtn;
}

//拍照
- (void)takePhotoClick{
    FSCameraManager * CameraManager = [[FSCameraManager alloc] init];
    [CameraManager RovTakePhotoSuccess:^(NSDictionary *responseObject) {
        if ([responseObject[@"head"][@"code"] integerValue]==0) {
            
            [KEY_WINDOW makeToast:@"拍照成功"];
        }
    } WithFailureBlock:^(NSError *error) {
        [KEY_WINDOW makeToast:error.localizedDescription];
    }];
}


//录制
- (void)recordViedeo:(UIButton *)sender{
    sender.selected =  self.isReciveVideo = !self.isReciveVideo;
    [self starRecordUpdataLabWithStatus:sender.selected];
    //录制通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SaveMp4File" object:nil userInfo:@{@"saveStatus":[NSNumber numberWithBool:self.isReciveVideo]}];
    
    
    
    //通知ROV录制
    FSCameraManager * CameraManager = [[FSCameraManager alloc] init];
    if(self.isReciveVideo){
    
    [CameraManager RovStarRecordSuccess:^(NSDictionary *responseObject) {
        if ([responseObject[@"head"][@"code"] integerValue]==0) {
            
            [KEY_WINDOW makeToast:@"同步录制中"];
        }
    } WithFailureBlock:^(NSError *error) {
        [KEY_WINDOW makeToast:error.localizedDescription];
    }];
    }
    //停止录制
    else{
        [CameraManager RovstopRecordSuccess:^(NSDictionary *responseObject) {
            if ([responseObject[@"head"][@"code"] integerValue]==0) {
                [KEY_WINDOW makeToast:@"停止录制"];
            }
        } WithFailureBlock:^(NSError *error) {
            [KEY_WINDOW makeToast:error.localizedDescription];
        }];
    }
    
}

//刷新录制时间
- (void)starRecordUpdataLabWithStatus:(BOOL)isrecord{
    if (isrecord) {
        self.timeOutCount = 0;
        dispatch_resume(self.timer);
    }
    else{
        if (dispatch_source_testcancel(self.timer)==0) {
           dispatch_suspend(self.timer);
        }
        self.record_TimeLab.text = @"00:00:00";
    }
}
- (dispatch_source_t)timer{
    if (!_timer) {
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 1ull * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(self.timer, ^{
            self.timeOutCount++;
            NSString *str_hour = [NSString stringWithFormat:@"%02lu",self.timeOutCount/3600];
            
            NSString *str_minute = [NSString stringWithFormat:@"%02lu",(self.timeOutCount%3600)/60];
            NSString *str_second = [NSString stringWithFormat:@"%02lu",self.timeOutCount%60];
            NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
            self.record_TimeLab.text = format_time;
            
        });
        
        dispatch_source_set_cancel_handler(self.timer, ^{
            NSLog(@"timersource cancel handle block");
            
        });
    }
    return _timer;
}
- (void)dealloc{
    dispatch_source_set_cancel_handler(self.timer, nil);
    
}
@end