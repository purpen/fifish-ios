//
//  FSSettingViewController.m
//  Fifish
//
//  Created by THN-Dong on 16/7/27.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSSettingViewController.h"
#import "AppDelegate.h"
#import "SDImageCache.h"
#import "SVProgressHUD.h"
#import "GuidePageViewController.h"

@interface FSSettingViewController ()<NotificationDelege>

@property (weak, nonatomic) IBOutlet UIButton *changePasswordBtn;
@property (weak, nonatomic) IBOutlet UIButton *pushSettingsBtn;
@property (weak, nonatomic) IBOutlet UIButton *clearCacheBtn;
@property (weak, nonatomic) IBOutlet UIButton *evaluationBtn;
@property (weak, nonatomic) IBOutlet UIButton *welcomeBtn;
@property (weak, nonatomic) IBOutlet UIButton *feedbackBtn;
@property (weak, nonatomic) IBOutlet UIButton *aboutBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *quiteBtn;
@property (weak, nonatomic) IBOutlet UILabel *pushStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *cacheLabel;
@end

@implementation FSSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"系统设置";
    
    //更改通知状态的代理
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.notiDelegate = self;
    //第一次进入界面时判断推送状态
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (setting.types == UIUserNotificationTypeNone) {
        self.pushStateLabel.text = @"已关闭";
    }else{
        self.pushStateLabel.text = @"已开启";
    }

    CGFloat size = [SDImageCache sharedImageCache].getSize / 1000.0 / 1000;
    self.cacheLabel.text = [NSString stringWithFormat:@"%.2fMB", size];
}

- (void)getSize
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *cachePath = [caches stringByAppendingPathComponent:@"default/com.hackemist.SDWebImageCache.default"];
    
    NSDirectoryEnumerator *fileEnumerator = [manager enumeratorAtPath:cachePath];
    NSInteger totalSize = 0;
    for (NSString *fileName in fileEnumerator) {
        NSString *filepath = [cachePath stringByAppendingPathComponent:fileName];
        
        //        BOOL dir = NO;
        // 判断文件的类型：文件\文件夹
        //        [manager fileExistsAtPath:filepath isDirectory:&dir];
        //        if (dir) continue;
        NSDictionary *attrs = [manager attributesOfItemAtPath:filepath error:nil];
        if ([attrs[NSFileType] isEqualToString:NSFileTypeDirectory]) continue;
        
        totalSize += [attrs[NSFileSize] integerValue];
    }
}

- (IBAction)changePasswordBtn:(id)sender {
}
- (IBAction)pushSettingBtn:(id)sender {
    //推送设置
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}
- (IBAction)clearCacheBtn:(id)sender {
    [[SDImageCache sharedImageCache] clearDisk];
    [SVProgressHUD showInfoWithStatus:@"缓存已清空"];
}
- (IBAction)evaluationBtn:(id)sender {
    NSString *urlStr = @"itms-apps://itunes.apple.com/app/id1089442815";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
}
- (IBAction)welcomeBtn:(id)sender {
    NSArray *arr = [NSArray arrayWithObjects:@"guide_one",@"guide_two",@"guide_three", nil];
    GuidePageViewController *vc = [[GuidePageViewController alloc] initWithPicArr:arr andRootVC:self];
    vc.flag = welcomePage;
    [self presentViewController:vc animated:YES completion:nil];
}
- (IBAction)feedbackBtn:(id)sender {
}
- (IBAction)aboutBtn:(id)sender {
}
- (IBAction)shareBtn:(id)sender {
}
- (IBAction)quiteBtn:(id)sender {
}

-(void)resetNotificationState{
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (setting.types == UIUserNotificationTypeNone) {
        self.pushStateLabel.text = @"已关闭";
    } else {
        self.pushStateLabel.text = @"已开启";
    }
}

@end
