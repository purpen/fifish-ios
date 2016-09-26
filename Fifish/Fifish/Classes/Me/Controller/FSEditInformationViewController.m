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
#import "FSUserModel.h"
#import "UIImageView+WebCache.h"

@interface FSEditInformationViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@end

@implementation FSEditInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"个人信息";
    [self headImage];
}

-(void)headImage{
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 15;
    self.headImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.headImageView.layer.borderWidth = 1;
    FSUserModel *userModel = [[FSUserModel findAll] lastObject];
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
    
    FBRequest *request = [FBAPI getWithUrlString:@"/upload/qiniuToken" requestDictionary:@{
                                                                                           @"assetable_type" : @"Stuff"
                                                                                           } delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSString *upload_url = result[@"data"][@"upload_url"];
        NSString *token = result[@"data"][@"token"];
        
        NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Docments"] stringByAppendingPathComponent:@"stuff.png"];
        UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
        
        FBRequest *stufRequest = [FBAPI requestWithUrlString:upload_url
                                           requestDictionary:nil
                                                    delegate:self
                                             timeoutInterval:nil
                                                        flag:nil
                                               requestMethod:POST_METHOD
                                                 requestType:HTTPRequestType
                                                responseType:JSONResponseType]
        
        
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
