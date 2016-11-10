//
//  FSImproveViewController.m
//  Fifish
//
//  Created by THN-Dong on 16/7/27.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSImproveViewController.h"
#import "UIImage+Helper.h"
#import "FBRequest.h"
#import "FBAPI.h"
#import "SVProgressHUD.h"
#import "FSUserModel.h"
#import "AddreesPickerViewController.h"
#import "UIImageView+WebCache.h"

@interface FSImproveViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *head_bg_view;
@property (weak, nonatomic) IBOutlet UIImageView *head_bg_imageView;
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *professionalTF;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property(nonatomic,strong) AddreesPickerViewController *addreesPickerVC;

@end

@implementation FSImproveViewController

-(AddreesPickerViewController *)addreesPickerVC{
    if (!_addreesPickerVC) {
        _addreesPickerVC = [[AddreesPickerViewController alloc] init];
    }
    return _addreesPickerVC;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.head_bg_view.layer.masksToBounds = YES;
    self.head_bg_view.layer.cornerRadius = 50;
    self.head_bg_imageView.layer.masksToBounds = YES;
    self.head_bg_imageView.layer.cornerRadius = 48;
    
    FSUserModel *usermodel = [[FSUserModel findAll] lastObject];
    [self.head_bg_imageView sd_setImageWithURL:[NSURL URLWithString:usermodel.large] placeholderImage:[UIImage imageNamed:@"login_head_default"]];
    self.userNameTF.text = usermodel.username;
    
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
    singleRecognizer.numberOfTapsRequired = 1;
    singleRecognizer.numberOfTouchesRequired = 1;
    [self.head_bg_imageView addGestureRecognizer:singleRecognizer];
    self.head_bg_imageView.userInteractionEnabled = YES;
    
    [self.sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.userNameTF.delegate = self;
}
- (IBAction)clickAdreesBtn:(id)sender {
    self.addreesPickerVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    [self presentViewController:_addreesPickerVC animated:NO completion:nil];
    [_addreesPickerVC.pickerBtn addTarget:self action:@selector(clickAddreesPickerBtn:) forControlEvents:UIControlEventTouchUpInside];
}


-(void)clickAddreesPickerBtn:(UIButton*)sender{
    self.addressTF.text = [NSString stringWithFormat:@"%@ %@",self.addreesPickerVC.provinceStr,self.addreesPickerVC.cityStr];
    [self.addreesPickerVC dismissViewControllerAnimated:NO completion:nil];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (string.length == 0) {
        self.sureBtn.selected = NO;
        self.sureBtn.enabled = NO;
    }else{
        self.sureBtn.selected = YES;
        self.sureBtn.enabled = YES;
    }
    return YES;
}


-(void)sureBtnClick:(UIButton*)sender{
    //网络请求
    FBRequest *request = [FBAPI postWithUrlString:@"/me/settings" requestDictionary:@{
                                                                                        @"username" : self.userNameTF.text,
                                                                                        @"job" : self.professionalTF.text,
                                                                                        @"zone" : self.addressTF.text
                                                                                        } delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        [SVProgressHUD dismiss];
        FSUserModel *model = [[FSUserModel findAll] lastObject];
        model.username = self.userNameTF.text;
        model.job = self.professionalTF.text;
        model.zone = self.addressTF.text;
        [model saveOrUpdate];
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
}

-(void)singleTap:(UITapGestureRecognizer*)recognizer{
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Replace the picture", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //判断是否支持相机。模拟器没有相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Taking pictures", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //调取相机
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
        }];
        [alertC addAction:cameraAction];
    }
    UIAlertAction *phontoAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"From the album to choose", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //调取相册
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertC dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertC addAction:phontoAction];
    [alertC addAction:cancelAction];
    [self presentViewController:alertC animated:YES completion:nil];
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage * editedImg = [info objectForKey:UIImagePickerControllerEditedImage];
    NSData * iconData = UIImageJPEGRepresentation([UIImage fixOrientation:editedImg] , 0.5);
//            NSData * iconData = UIImageJPEGRepresentation(editedImg , 0.5);
    [self uploadIconWithData:iconData];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

//上传头像
- (void)uploadIconWithData:(NSData *)iconData
{
    [SVProgressHUD show];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    NSString * icon64Str = [iconData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSDictionary * params = @{@"avatar" : icon64Str};
    FBRequest * request = [FBAPI postWithUrlString:@"/upload/avatar" requestDictionary:params delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        [SVProgressHUD dismiss];
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}


@end
