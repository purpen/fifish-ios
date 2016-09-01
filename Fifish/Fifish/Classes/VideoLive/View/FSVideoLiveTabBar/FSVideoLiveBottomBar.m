//
//  FSVideoLiveBottomBar.m
//  Fifish
//
//  Created by macpro on 16/8/17.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSVideoLiveBottomBar.h"
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
            make.size.mas_equalTo(CGSizeMake(30, 30));
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
    }
    return _take_photoBtn;
}
- (void)recordViedeo:(UIButton *)sender{
    sender.selected =  self.isReciveVideo = !self.isReciveVideo;
    [self starRecordUpdataLabWithStatus:sender.selected];
    //录制通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SaveMp4File" object:nil userInfo:@{@"saveStatus":[NSNumber numberWithBool:self.isReciveVideo]}];
}
- (void)starRecordUpdataLabWithStatus:(BOOL)isrecord{
    if (isrecord) {
        __block  NSUInteger timeOutCount = 0;
        dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 1ull * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(self.timer, ^{
            timeOutCount++;
            NSString *str_hour = [NSString stringWithFormat:@"%02lu",timeOutCount/3600];

            NSString *str_minute = [NSString stringWithFormat:@"%02lu",(timeOutCount%3600)/60];
            NSString *str_second = [NSString stringWithFormat:@"%02lu",timeOutCount%60];
             NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
            self.record_TimeLab.text = format_time;
            
        });
        
        dispatch_source_set_cancel_handler(self.timer, ^{
            NSLog(@"timersource cancel handle block");
            
        });
        
        dispatch_resume(self.timer);
    }
    else{
        dispatch_source_cancel(self.timer);
        self.record_TimeLab.text = @"00:00:00";
    }
}
- (dispatch_source_t)timer{
    if (!_timer) {
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    }
    return _timer;
}
@end