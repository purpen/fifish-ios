//
//  FSRecordView.m
//  Fifish
//
//  Created by macpro on 16/12/20.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSRecordView.h"

#import "FSCameraManager.h"

#import "SVProgressHUD.h"

#import "FSliveVideoConst.h"

#import "RovInfo.h"

@interface FSRecordView ()

//录像按钮
@property (nonatomic, strong) UIButton  * record_btn;

//照相按钮
@property (nonatomic, strong) UIButton  * take_photoBtn;


//存储中状态记录

@property (nonatomic)         BOOL       isReciveVideo;
@end

@implementation FSRecordView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.record_btn];
        [self.record_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        [self addSubview:self.take_photoBtn];
        [self.take_photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.top.equalTo(self.mas_top);
            make.centerX.equalTo(self.mas_centerX);
        }];
        
        //监听当前camera状态
        [self addObserverCameraInfo];
    }
    return self;
}

//录制按钮
- (UIButton *)record_btn{
    if (!_record_btn) {
        _record_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_record_btn setImage:[UIImage imageNamed:@"record_btn_seleted"] forState:UIControlStateSelected];
        [_record_btn setImage:[UIImage imageNamed:@"record_btn"] forState:UIControlStateNormal];
        [_record_btn addTarget:self action:@selector(recordViedeo:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _record_btn;
}

//拍照按钮
- (UIButton *)take_photoBtn{
    if (!_take_photoBtn) {
        _take_photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_take_photoBtn setImage:[UIImage imageNamed:@"record_btn"] forState:UIControlStateNormal];
        [_take_photoBtn addTarget:self action:@selector(takePhotoClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _take_photoBtn;
}

#pragma mark EVENT
#pragma mark 拍照
- (void)takePhotoClick{
    
    ////    通知camera拍照
    //    FSCameraManager * CameraManager = [[FSCameraManager alloc] init];
    //    [CameraManager RovTakePhotoSuccess:^(NSDictionary *responseObject) {
    //        if ([responseObject[@"head"][@"code"] integerValue]==0) {
    //
    //            [KEY_WINDOW makeToast:@"拍照成功"];
    //        }
    //    } WithFailureBlock:^(NSError *error) {
    //        [KEY_WINDOW makeToast:error.localizedDescription];
    //    }];
    
    //  本地截取一帧图片
    [[NSNotificationCenter defaultCenter] postNotificationName:FSNoticeTakePhoto object:nil];
    [SVProgressHUD showSuccessWithStatus:@"拍照成功"];
    
}


#pragma mark 录制
- (void)recordViedeo:(UIButton *)sender{
    sender.selected =  self.isReciveVideo = !self.isReciveVideo;
    //录制通知
    [[NSNotificationCenter defaultCenter] postNotificationName:FSNoticSaveMp4File object:nil userInfo:@{FSNoticSaveMp4FileStatus:[NSNumber numberWithBool:self.isReciveVideo]}];
    //通知ROV录制
    FSCameraManager * CameraManager = [[FSCameraManager alloc] init];
    if(self.isReciveVideo){
        
        [CameraManager RovStarRecordSuccess:^(NSDictionary *responseObject) {
            if ([responseObject[@"head"][@"code"] integerValue]==0) {
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Synchronous recording", nil)];
            }
        } WithFailureBlock:^(NSError *error) {
            [SVProgressHUD showWithStatus:error.localizedDescription];
            [SVProgressHUD dismissWithDelay:2];
        }];
    }
    //停止录制
    else{
        [CameraManager RovstopRecordSuccess:^(NSDictionary *responseObject) {
            if ([responseObject[@"head"][@"code"] integerValue]==0) {
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Stop recording", nil)];
            }
        } WithFailureBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
    }
}

#pragma  mark cameraDelegate
- (void)addObserverCameraInfo{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CamerastatusChange:) name:@"RovInfoChange" object:nil];
}
- (void)CamerastatusChange:(NSNotification *)notice{
    RovInfo *rovinfo = notice.userInfo[@"RVOINFO"];
    if (self.isReciveVideo!=rovinfo.isRecored) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self recordViedeo:self.record_btn];
        });
    }
    if (rovinfo.isTakeAPicture) {
        [self takePhotoClick];
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
