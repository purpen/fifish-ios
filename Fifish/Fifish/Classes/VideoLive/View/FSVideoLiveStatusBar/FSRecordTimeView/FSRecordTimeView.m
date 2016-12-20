//
//  FSRecordTimeView.m
//  Fifish
//
//  Created by macpro on 16/12/20.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSRecordTimeView.h"

#import "FSliveVideoConst.h"

#import<libkern/OSAtomic.h>

@interface FSRecordTimeView ()

//录制时间
@property (nonatomic, strong) UILabel   * record_TimeLab;
//计时器
@property (nonatomic,strong)  dispatch_source_t timer;

//时间
@property (nonatomic)         __block  NSUInteger timeOutCount;

@end

@implementation FSRecordTimeView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.record_TimeLab];
        [self.record_TimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.centerX.equalTo(self.mas_centerX);
        }];
        
        //监听录制通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startRecordWithInfo:) name:FSNoticSaveMp4File object:nil];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UILabel *)record_TimeLab{
    if (!_record_TimeLab) {
        _record_TimeLab = [[UILabel alloc] init];
        _record_TimeLab.textColor = [UIColor whiteColor];
        _record_TimeLab.font = [UIFont systemFontOfSize:13];
        _record_TimeLab.text = @"00:00:00";
    }
    return _record_TimeLab;
}
-(void)startRecordWithInfo:(NSNotification *)info{
    /*开始录制*/
    if ([info.userInfo[FSNoticSaveMp4FileStatus] integerValue]==1) {
        self.timeOutCount = 0;
        
        dispatch_resume(self.timer);
    }
    /*结束录制*/
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
