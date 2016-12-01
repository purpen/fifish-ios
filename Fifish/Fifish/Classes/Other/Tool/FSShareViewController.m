//
//  FSShareViewController.m
//  Fifish
//
//  Created by THN-Dong on 2016/11/8.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSShareViewController.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <UMSocialCore/UMSocialCore.h>

@interface FSShareViewController ()

@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;
@property (weak, nonatomic) IBOutlet UIButton *qqBtn;
@property (weak, nonatomic) IBOutlet UIButton *weiBoBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@end

@implementation FSShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self judge];
    self.cancelBtn.layer.masksToBounds = YES;
    self.cancelBtn.layer.cornerRadius = 22;
    self.cancelBtn.layer.borderColor = [UIColor colorWithHexString:@"#4398fb"].CGColor;
    self.cancelBtn.layer.borderWidth = 1;
}

-(void)judge{
    if ([WXApi isWXAppInstalled] == NO) {
        self.wechatBtn.hidden = YES;
    }else{
        self.wechatBtn.hidden = NO;
    }
    
    if ([WeiboSDK isWeiboAppInstalled] == NO) {
        self.weiBoBtn.hidden = YES;
    }else{
        self.weiBoBtn.hidden = NO;
    }
    
    if ([QQApiInterface isQQInstalled] == NO) {
        self.qqBtn.hidden = YES;
    }else{
        self.qqBtn.hidden = NO;
    }
}

-(void)setModel:(FSZuoPin *)model{
    _model = model;
}

#pragma mark - 分享图片
- (void)shareImageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    messageObject.text = self.model.content;
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    shareObject.thumbImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.file_large]]];
    [shareObject setShareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.srcfile]]]];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }else{
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Share success", nil)];
        }
    }];
}

#pragma mark - 分享视频
- (void)shareVedioToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建视频内容对象
    UMShareVideoObject *shareObject = [UMShareVideoObject shareObjectWithTitle:@"FiFish" descr:self.model.content thumImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.file_large]]]];
    //设置视频网页播放地址
//    shareObject.videoUrl = self.model.filepath;
    shareObject.videoUrl = @"https://m.qysea.com/stuff/36.html";
//    shareObject.videoLowBandUrl = self.model.filepath;
    NSLog(@"视频 %@", self.model.filepath);
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }else{
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Share success", nil)];
        }
    }];
}

- (IBAction)wechatClick:(id)sender {
    if ([self.model.kind isEqualToString:@"1"]) {
        //图片
        [self shareImageToPlatformType:UMSocialPlatformType_WechatSession];
    } else if ([self.model.kind isEqualToString:@"2"]) {
        //视频
        [self shareVedioToPlatformType:UMSocialPlatformType_WechatSession];
    }
}

- (IBAction)facebookClick:(id)sender {
    if ([self.model.kind isEqualToString:@"1"]) {
        //图片
        [self shareImageToPlatformType:UMSocialPlatformType_Facebook];
    } else if ([self.model.kind isEqualToString:@"2"]) {
        //视频
        [self shareVedioToPlatformType:UMSocialPlatformType_Facebook];
    }
}

- (IBAction)qqClick:(id)sender {
    if ([self.model.kind isEqualToString:@"1"]) {
        //图片
        [self shareImageToPlatformType:UMSocialPlatformType_QQ];
    } else if ([self.model.kind isEqualToString:@"2"]) {
        //视频
        [self shareVedioToPlatformType:UMSocialPlatformType_QQ];
    }
}

- (IBAction)instagramClick:(id)sender {
    if ([self.model.kind isEqualToString:@"1"]) {
        //图片
        [self shareImageToPlatformType:UMSocialPlatformType_Instagram];
    } else if ([self.model.kind isEqualToString:@"2"]) {
        //视频
        [self shareVedioToPlatformType:UMSocialPlatformType_Instagram];
    }
}

- (IBAction)weiboClick:(id)sender {
    if ([self.model.kind isEqualToString:@"1"]) {
        //图片
        [self shareImageToPlatformType:UMSocialPlatformType_Sina];
    } else if ([self.model.kind isEqualToString:@"2"]) {
        //视频
        [self shareVedioToPlatformType:UMSocialPlatformType_Sina];
    }
}

- (IBAction)cancelClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)otherClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
