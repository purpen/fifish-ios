//
//  FSReleasePictureViewController.m
//  Fifish
//
//  Created by THN-Dong on 2016/10/8.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSReleasePictureViewController.h"
#import "UIBarButtonItem+FSExtension.h"
#import "FSReleaseView.h"
#import "UIView+FSExtension.h"
#import "FSAddTagViewController.h"
#import "FSAddressViewController.h"
#import "FSWatermarkViewController.h"
#import "UIImage+Helper.h"
#import "FishBlackNavViewController.h"
#import "FSPlayViewController.h"
#import "FSBigImageViewController.h"
#import "FSTabBarController.h"
#import "FSMediaViewController.h"
#import <UMSocialCore/UMSocialCore.h>

@interface FSReleasePictureViewController () <UITextViewDelegate, FSAddTagViewControllerDelegate, UITextFieldDelegate, FSAddressViewControllerDelegate, FSWatermarkViewControllerDelegate>

/**  */
@property (nonatomic, strong) UIScrollView *myScrollview;
/**  */
@property (nonatomic, strong) FSReleaseView *releaseView;
/**  */
@property(nonatomic,copy) NSString *str;
/**  */
@property (nonatomic, strong) NSMutableArray *tagsAry;
/**  */
@property (nonatomic, assign) CGFloat lat;
/**  */
@property (nonatomic, assign) CGFloat lon;
/**  */
@property(nonatomic,copy) NSString *kind;

@end

@implementation FSReleasePictureViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil]];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.barTintColor = FishBlackColor;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FishBlackColor,NSForegroundColorAttributeName,nil]];
}

-(NSMutableArray *)tagsAry{
    if (!_tagsAry) {
        _tagsAry = [NSMutableArray array];
    }
    return _tagsAry;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavi];
    [self.view addSubview:self.myScrollview];
    if ([self.type isEqualToNumber:@(1)]) {
        //图片
        [self.releaseView.smallBtn setImage:((FSImageModel*)self.mediaModel).defaultImage forState:UIControlStateNormal];
        self.bigImage = self.mediaModel.flietrImage;
    } else {
        // 视频
        [self.releaseView.smallBtn setImage:((FSVideoModel*)self.mediaModel).VideoPicture forState:UIControlStateNormal];
    }
}

-(UIScrollView *)myScrollview{
    if (!_myScrollview) {
        _myScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _myScrollview.contentSize = CGSizeMake(0, SCREEN_HEIGHT);
        _myScrollview.showsVerticalScrollIndicator = NO;
        [_myScrollview addSubview:self.releaseView];
    }
    return _myScrollview;
}

-(FSReleaseView *)releaseView{
    if (!_releaseView) {
        _releaseView = [FSReleaseView viewFromXib];
        _releaseView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
        _releaseView.instructionsTextView.delegate = self;
        [_releaseView.tagBtn addTarget:self action:@selector(tagClick) forControlEvents:UIControlEventTouchUpInside];
        _releaseView.tagTextFiled.delegate = self;
        [_releaseView.addressBtn addTarget:self action:@selector(addressClick) forControlEvents:UIControlEventTouchUpInside];
        [_releaseView.addWaterBtn addTarget:self action:@selector(waterClick) forControlEvents:UIControlEventTouchUpInside];
        if ([self.type isEqualToNumber:@(1)]) {
            //图片
            self.releaseView.playImageView.hidden = YES;
            [self.releaseView.smallBtn addTarget:self action:@selector(watchImage) forControlEvents:UIControlEventTouchUpInside];
        } else if ([self.type isEqualToNumber:@(2)]) {
            //视频
            self.releaseView.playImageView.hidden = NO;
            [self.releaseView.smallBtn addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
        }
        [_releaseView.weixinBtn addTarget:self action:@selector(weixinClick) forControlEvents:UIControlEventTouchUpInside];
        [_releaseView.weiboBtn addTarget:self action:@selector(weiboClick) forControlEvents:UIControlEventTouchUpInside];
        [_releaseView.qqBtn addTarget:self action:@selector(qqClick) forControlEvents:UIControlEventTouchUpInside];
        [_releaseView.facebookBtn addTarget:self action:@selector(facebookClick) forControlEvents:UIControlEventTouchUpInside];
        [_releaseView.instagramBtn addTarget:self action:@selector(instagramClick) forControlEvents:UIControlEventTouchUpInside];
        [_releaseView.teitterBtn addTarget:self action:@selector(twitterClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _releaseView;
}

-(void)weixinClick{
    if ([self.type isEqualToNumber:@(1)]) {
        //图片
        [self shareImageToPlatformType:UMSocialPlatformType_WechatSession];
    } else if ([self.type isEqualToNumber:@(2)]) {
        //视频
        [self shareVedioToPlatformType:UMSocialPlatformType_WechatSession];
    }
}

-(void)weiboClick{
    if ([self.type isEqualToNumber:@(1)]) {
        //图片
        [self shareImageToPlatformType:UMSocialPlatformType_Sina];
    } else if ([self.type isEqualToNumber:@(2)]) {
        //视频
        [self shareVedioToPlatformType:UMSocialPlatformType_Sina];
    }
}

-(void)qqClick{
    if ([self.type isEqualToNumber:@(1)]) {
        //图片
        [self shareImageToPlatformType:UMSocialPlatformType_QQ];
    } else if ([self.type isEqualToNumber:@(2)]) {
        //视频
        [self shareVedioToPlatformType:UMSocialPlatformType_QQ];
    }
}

-(void)facebookClick{
    if ([self.type isEqualToNumber:@(1)]) {
        //图片
        [self shareImageToPlatformType:UMSocialPlatformType_Facebook];
    } else if ([self.type isEqualToNumber:@(2)]) {
        //视频
        [self shareVedioToPlatformType:UMSocialPlatformType_Facebook];
    }
}

-(void)instagramClick{
    if ([self.type isEqualToNumber:@(1)]) {
        //图片
        [self shareImageToPlatformType:UMSocialPlatformType_Instagram];
    } else if ([self.type isEqualToNumber:@(2)]) {
        //视频
        [self shareVedioToPlatformType:UMSocialPlatformType_Instagram];
    }
}

-(void)twitterClick{
    if ([self.type isEqualToNumber:@(1)]) {
        //图片
        [self shareImageToPlatformType:UMSocialPlatformType_Twitter];
    } else if ([self.type isEqualToNumber:@(2)]) {
        //视频
        [self shareVedioToPlatformType:UMSocialPlatformType_Twitter];
    }
}

#pragma mark - 分享视频
- (void)shareVedioToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建视频内容对象
    UMShareVideoObject *shareObject = [UMShareVideoObject shareObjectWithTitle:@"FiFish" descr:self.releaseView.accordingLabel.text thumImage:((FSVideoModel*)self.mediaModel).VideoPicture];
    //设置视频网页播放地址
    shareObject.videoUrl = self.mediaModel.fileUrl;
    //            shareObject.videoStreamUrl = @"这里设置视频数据流地址（如果有的话，而且也要看所分享的平台支不支持）";
    
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

#pragma mark - 分享图片
- (void)shareImageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    messageObject.text = self.releaseView.accordingLabel.text;
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    shareObject.thumbImage = ((FSImageModel*)self.mediaModel).defaultImage;
    [shareObject setShareImage:((FSImageModel*)self.mediaModel).flietrImage];
    
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

-(void)watchImage{
    //查看大图
    FSBigImageViewController *vc = [[FSBigImageViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.showImage = self.bigImage;
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)play{
    //开始播放视频
    FSPlayViewController *mvPlayer = [[FSPlayViewController alloc] init];
    mvPlayer.videoUrl = [NSURL fileURLWithPath:self.mediaModel.fileUrl];
    [self presentViewController:mvPlayer animated:YES completion:nil];
}

-(void)waterClick{
    FSWatermarkViewController *vc = [[FSWatermarkViewController alloc] init];
    vc.waterDelegate = self;
    vc.str = self.str;
    if ([self.releaseView.flagLabel.text isEqualToString:NSLocalizedString(@"open", nil)]) {
        vc.switchSState = YES;
    } else {
        vc.switchSState = NO;
    }
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)saveName:(NSString *)str{
    self.str = str;
}

- (void)setMediaModel:(FSMediaModel *)mediaModel{
    _mediaModel = mediaModel;
}

-(void)switch:(BOOL)flag{
    if (flag) {
        self.releaseView.flagLabel.text = NSLocalizedString(@"open", nil);
    } else {
        self.releaseView.flagLabel.text = NSLocalizedString(@"close", nil);
    }
}

-(void)addressClick{
    FSAddressViewController *vc = [[FSAddressViewController alloc] init];
    vc.addressDelegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)getAddress:(NSString *)address andLat:(CGFloat)lat andLon:(CGFloat)lon{
    if (address.length != 0) {
        self.releaseView.accordingLabel.hidden = NO;
        self.releaseView.addressLabel.hidden = YES;
        self.releaseView.accordingLabel.text = address;
        self.lat = lat;
        self.lon = lon;
    } else {
        self.releaseView.accordingLabel.hidden = YES;
        self.releaseView.addressLabel.hidden = NO;
        self.lat = 0;
        self.lon = 0;
    }
}

-(void)tagClick{
    FSAddTagViewController *vc = [[FSAddTagViewController alloc] init];
    vc.addTagDelegate = self;
    vc.tags = self.releaseView.tagTextFiled.text;
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)getTagName:(NSString *)tag andTagId:(NSString *)tagId{
    if (tag.length == 0) {
        self.releaseView.tagTextFiled.text = @"";
    } else {
        NSMutableString *newTag = [NSMutableString stringWithString:tag];
        if ([tag rangeOfString:@"#"].location != NSNotFound) {
            [newTag deleteCharactersInRange:NSMakeRange(0, 2)];
        }
        if (self.releaseView.tagTextFiled.text.length != 0) {
            self.releaseView.tagTextFiled.text = [NSString stringWithFormat:@"%@, # %@", self.releaseView.tagTextFiled.text, newTag];
        } else {
            self.releaseView.tagTextFiled.text = [NSString stringWithFormat:@"# %@", newTag];
        }
        NSLog(@"tag  %@",tag);
        [self.tagsAry addObject:tag];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        self.releaseView.placeHolderLabel.hidden = NO;
    } else {
        self.releaseView.placeHolderLabel.hidden = YES;
    }
}

-(void)setUpNavi{
    self.navigationItem.title = NSLocalizedString(@"share", nil);
    UIBarButtonItem *releaseItem = [UIBarButtonItem itemWithTitle:NSLocalizedString(@"release", nil) target:self action:@selector(releaseClick)];
    UIBarButtonItem *backItem = [UIBarButtonItem itemWithImage:@"navi_back" highImage:nil title:nil target:self action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = backItem;
    self.navigationItem.rightBarButtonItem = releaseItem;
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)releaseClick{
    if ([self.type isEqualToNumber:@(1)]) {
        //图片
        if (self.releaseView.instructionsTextView.text.length < 5) {
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"Please add content", nil)];
        } else {
            self.kind = @"1";
            NSData * iconData = UIImageJPEGRepresentation([UIImage fixOrientation:self.bigImage] , 1);
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"kind"] = self.kind;
            dict[@"content"] = self.releaseView.instructionsTextView.text;
            dict[@"address"] = self.releaseView.accordingLabel.text;
            dict[@"tags"] = self.tagsAry;
            dict[@"lat"] = @(self.lat);
            dict[@"lng"] = @(self.lon);
            dict[@"model"] = self.mediaModel;
            dict[@"iconData"] = iconData;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"pictuer" object:self userInfo:dict];
            [self dismissViewControllerAnimated:YES completion:^{
                [[FSTabBarController sharedManager] setSelectedIndex:0];
            }];
        }
        //NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"stuff.png"];
        //[iconData writeToFile:fullPath atomically:NO];
    } else {
        //视频
        if (self.releaseView.instructionsTextView.text.length < 5) {
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"Please add content", nil)];
        } else {
            self.kind = @"2";
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"kind"] = self.kind;
            dict[@"content"] = self.releaseView.instructionsTextView.text;
            dict[@"address"] = self.releaseView.accordingLabel.text;
            dict[@"tags"] = self.tagsAry;
            dict[@"lat"] = @(self.lat);
            dict[@"lng"] = @(self.lon);
            dict[@"model"] = self.mediaModel;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"progress" object:self userInfo:dict];
            [self dismissViewControllerAnimated:YES completion:^{
                [[FSTabBarController sharedManager] setSelectedIndex:0];
            }];
        }
    }
}


@end
