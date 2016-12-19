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
#import "FSUserModel2.h"
#import "ReactiveCocoa.h"

@interface FSImproveViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
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
    
    FSUserModel2 *usermodel = [[FSUserModel2 findAll] lastObject];
    [self.head_bg_imageView sd_setImageWithURL:[NSURL URLWithString:usermodel.large] placeholderImage:[UIImage imageNamed:@"login_head_default"]];
    self.userNameTF.text = usermodel.username;
    [self.head_bg_imageView sd_setImageWithURL:[NSURL URLWithString:usermodel.large] placeholderImage:[UIImage imageNamed:@"login_head_default"]];
    
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
    singleRecognizer.numberOfTapsRequired = 1;
    singleRecognizer.numberOfTouchesRequired = 1;
    [self.head_bg_imageView addGestureRecognizer:singleRecognizer];
    self.head_bg_imageView.userInteractionEnabled = YES;
    

    [[[self.sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside] flattenMap:^RACStream *(id value) {
        return [self signInSignal];
    }] subscribeNext:^(NSNumber *x) {
        BOOL success = [x boolValue];
        if (success) {
            [SVProgressHUD dismiss];
            FSUserModel2 *model = [[FSUserModel2 findAll] lastObject];
            model.username = self.userNameTF.text;
            model.job = self.professionalTF.text;
            model.zone = self.addressTF.text;
            model.isLogin = YES;
            [model saveOrUpdate];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
    [[self.userNameTF.rac_textSignal filter:^BOOL(NSString *value) {
        self.sureBtn.enabled = NO;
        return value.length > 0;
    }] subscribeNext:^(id x) {
        self.sureBtn.enabled = YES;
    }];
}

-(RACSignal*)signInSignal{
    [SVProgressHUD show];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        FBRequest *request = [FBAPI postWithUrlString:@"/me/settings" requestDictionary:@{
                                                                                          @"username" : self.userNameTF.text,
                                                                                          @"job" : self.professionalTF.text,
                                                                                          @"zone" : self.addressTF.text
                                                                                          } delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            [subscriber sendNext:@(YES)];
            [subscriber sendCompleted];
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD dismiss];
        }];
        return nil;
    }];
}

-(BOOL)isValidUserText:(NSString*)text{
    return text.length > 0;
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
    NSData * iconData = UIImageJPEGRepresentation([UIImage fixOrientation:editedImg] , 1);
    FBRequest *request = [FBAPI getWithUrlString:@"/upload/avatarToken" requestDictionary:nil delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSString *upload_url = result[@"data"][@"upload_url"];
        NSString *token = result[@"data"][@"token"];
        [FBAPI uploadFileWithURL:upload_url WithToken:token WithFileUrl:nil WithFileData:iconData WihtProgressBlock:^(CGFloat progress) {
            
        } WithSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self.head_bg_imageView setImage:editedImg];
        } WithFailureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}



@end
