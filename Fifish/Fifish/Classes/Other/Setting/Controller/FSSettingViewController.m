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
#import "ChanePwdViewController.h"
#import "GuidePageViewController.h"
#import "OptionViewController.h"
#import "AboutViewController.h"
#import "FSUserModel.h"
#import "FSTabBarController.h"

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

    NSString * cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    self.cacheLabel.text = [NSString stringWithFormat:@"%.1fM", [self folderSizeAtPath:cachesPath]];
}

#pragma mark - 计算缓存大小
//遍历文件夹获得文件夹大小，返回多少M
- (float)folderSizeAtPath:(NSString*) folderPath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) {
        return 0;
    }
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0 * 1024.0);
}

//单个文件的大小
- (long long)fileSizeAtPath:(NSString*) filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

- (IBAction)changePasswordBtn:(id)sender {
    ChanePwdViewController *vc = [[ChanePwdViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)pushSettingBtn:(id)sender {
    //推送设置
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}
- (IBAction)clearCacheBtn:(id)sender {
    //清空缓存
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *files = [manager subpathsAtPath:cachesPath];
    if (files.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"缓存已清空"];
        
        return;
    }
    //如果数组里有内容需要遍历清空
    for (NSString *fileName in files) {
        NSError *error = nil;
        NSString *filePath = [cachesPath stringByAppendingPathComponent:fileName];
        if ([manager fileExistsAtPath:filePath]) {
            [manager removeItemAtPath:filePath error:&error];
            if (error) {
                //本来就是空的
                [SVProgressHUD showInfoWithStatus:@"缓存已清空"];
            }else{
                //提示清空，改变显示的内存大小
                [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"清理缓存成功"]];
                
            }
        }
    }
    self.cacheLabel.text = @"0.0M";
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
    OptionViewController *vc = [[OptionViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)aboutBtn:(id)sender {
    AboutViewController *vc = [[AboutViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)shareBtn:(id)sender {
}

- (IBAction)quiteBtn:(id)sender {
    [FSUserModel clearTable];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"" forKey:@"token"];
    [defaults synchronize];
    [[FSTabBarController sharedManager] setSelectedIndex:3];
    [self.navigationController popViewControllerAnimated:YES];
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
