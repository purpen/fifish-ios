//
//  FSEditInformationViewController.m
//  Fifish
//
//  Created by THN-Dong on 16/7/29.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSEditInformationViewController.h"
#import "UIImage+Helper.h"
#import "FBRequest.h"
#import "FBAPI.h"
#import "FSUserModel2.h"
#import "UIImageView+WebCache.h"
#import "FSUserNameViewController.h"
#import "AddreesPickerViewController.h"
#import "FSChangeSexViewController.h"
#import "FSSummaryViewController.h"

@interface FSEditInformationViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property(nonatomic,strong) AddreesPickerViewController *addreesPickerVC;
@property (weak, nonatomic) IBOutlet UILabel *zoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;

@end

@implementation FSEditInformationViewController

#pragma mark - 更改个性签名
- (IBAction)summaryClick:(id)sender {
    FSSummaryViewController *vc = [[FSSummaryViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(AddreesPickerViewController *)addreesPickerVC{
    if (!_addreesPickerVC) {
        _addreesPickerVC = [[AddreesPickerViewController alloc] init];
    }
    return _addreesPickerVC;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    FSUserModel2 *userModel = [[FSUserModel2 findAll] lastObject];
    self.summaryLabel.text = userModel.summary;
    self.zoneLabel.text = userModel.zone;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = NSLocalizedString(@"Personal information", nil);
    [self headImage];
}

- (IBAction)sexClick:(id)sender {
    FSChangeSexViewController *vc = [[FSChangeSexViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 更改地区
- (IBAction)zone:(id)sender {
    self.addreesPickerVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:_addreesPickerVC animated:NO completion:nil];
    [_addreesPickerVC.pickerBtn addTarget:self action:@selector(clickAddreesPickerBtn:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)clickAddreesPickerBtn:(UIButton*)sender{
    self.zoneLabel.text = [NSString stringWithFormat:@"%@ %@",self.addreesPickerVC.provinceStr,self.addreesPickerVC.cityStr];
    FBRequest *request = [FBAPI postWithUrlString:@"/me/settings" requestDictionary:@{
                                                                                        @"zone" : self.zoneLabel.text
                                                                                        } delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        FSUserModel2 *model = [[FSUserModel2 findAll] lastObject];
        model.zone = self.zoneLabel.text;
        model.isLogin = YES;
        [model saveOrUpdate];
        [self.addreesPickerVC dismissViewControllerAnimated:NO completion:nil];
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
}

#pragma mark - 更改用户名
- (IBAction)changeUserName:(id)sender {
    FSUserNameViewController *vc = [[FSUserNameViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)headImage{
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 15;
    self.headImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.headImageView.layer.borderWidth = 1;
    FSUserModel2 *userModel = [[FSUserModel2 findAll] lastObject];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:userModel.large] placeholderImage:[UIImage imageNamed:@"login_head_default"]];
}

- (IBAction)headClick:(UIButton *)sender {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"replaceHeadPortrait", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //判断是否支持相机。模拟器没有相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"takingPictures", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //调取相机xx
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
        }];
        [alertC addAction:cameraAction];
    }
    UIAlertAction *phontoAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"fromAlbumToChoose", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //调取相册
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertC addAction:phontoAction];
    [alertC addAction:cancelAction];
    [self presentViewController:alertC animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage * editedImg = [info objectForKey:UIImagePickerControllerEditedImage];
    NSData * iconData = UIImageJPEGRepresentation([UIImage fixOrientation:editedImg] , 0.5);
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"stuff.png"];
    [iconData writeToFile:fullPath atomically:NO];
    
    FBRequest *request = [FBAPI getWithUrlString:@"/upload/avatarToken" requestDictionary:nil delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSString *upload_url = result[@"data"][@"upload_url"];
        NSString *token = result[@"data"][@"token"];
        [FBAPI uploadFileWithURL:upload_url WithToken:token WithFileUrl:nil WithFileData:iconData WihtProgressBlock:^(CGFloat progress) {
            
        } WithSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
            FSUserModel2 *userModel = [[FSUserModel2 findAll] lastObject];
            userModel.large = responseObject[@"file"][@"large"];
            userModel.isLogin = YES;
            [userModel saveOrUpdate];
            [self.headImageView sd_setImageWithURL:[NSURL URLWithString:userModel.large]];
        } WithFailureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
