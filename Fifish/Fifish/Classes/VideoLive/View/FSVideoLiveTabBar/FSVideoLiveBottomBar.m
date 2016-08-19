//
//  FSVideoLiveBottomBar.m
//  Fifish
//
//  Created by macpro on 16/8/17.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSVideoLiveBottomBar.h"

@interface FSVideoLiveBottomBar ()

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
        [_record_btn setImage:[UIImage imageNamed:@"record_btn"] forState:UIControlStateNormal];
        [_record_btn addTarget:self action:@selector(recordViedeo:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _record_btn;
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
    
    //录制通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SaveMp4File" object:nil userInfo:@{@"saveStatus":[NSNumber numberWithBool:self.isReciveVideo]}];
}
@end
//record_btn