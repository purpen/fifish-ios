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
#import <MediaPlayer/MediaPlayer.h>
#import "FSBigImageViewController.h"

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
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
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
        self.mediaModel = ((FSImageModel*)self.mediaModel);
    } else {
        // 视频
        self.mediaModel = ((FSVideoModel*)self.mediaModel);
    }
    self.bigImage = self.mediaModel.flietrImage;
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
    }
    return _releaseView;
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
    MPMoviePlayerViewController *mvPlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:self.mediaModel.fileUrl]];
    [self.navigationController presentViewController:mvPlayer animated:YES completion:nil];
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
        [self.tagsAry addObject:tagId];
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
    self.navigationItem.title = @"分享";
    UIBarButtonItem *releaseItem = [UIBarButtonItem itemWithTitle:@"发布" target:self action:@selector(releaseClick)];
    self.navigationItem.rightBarButtonItem = releaseItem;
}

-(void)releaseClick{
    [SVProgressHUD show];
    if ([self.type isEqualToNumber:@(1)]) {
        //图片
        NSData * iconData = UIImageJPEGRepresentation([UIImage fixOrientation:self.bigImage] , 0.5);
        NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"stuff.png"];
        [iconData writeToFile:fullPath atomically:NO];
        FBRequest *request = [FBAPI getWithUrlString:@"/upload/photoToken" requestDictionary:nil delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            NSString *upload_url = result[@"data"][@"upload_url"];
            NSString *token = result[@"data"][@"token"];
            [FBAPI uploadFileWithURL:upload_url WithToken:token WithFileUrl:nil WithFileData:iconData WihtProgressBlock:^(CGFloat progress) {
                
            } WithSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *stuffId = responseObject[@"id"];
                self.kind = @"1";
                [self newStuff:stuffId];
            } WithFailureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
//            [FBAPI uploadFileWithURL:upload_url WithToken:token WithFileUrl:[NSURL fileURLWithPath:fullPath] WihtProgressBlock:^(CGFloat progress) {
//                
//            } WithSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
//                NSString *stuffId = responseObject[@"id"];
//                self.kind = @"1";
//                [self newStuff:stuffId];
//            } WithFailureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//                
//            }];
            
            
        } failure:^(FBRequest *request, NSError *error) {
            
        }];
    } else {
        //视频
        FBRequest *request = [FBAPI getWithUrlString:@"/upload/videoToken" requestDictionary:nil delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            NSString *upload_url = result[@"data"][@"upload_url"];
            NSString *token = result[@"data"][@"token"];
            [FBAPI uploadFileWithURL:upload_url WithToken:token WithFileUrl:[NSURL fileURLWithPath:self.mediaModel.fileUrl] WithFileData:nil WihtProgressBlock:^(CGFloat progress) {
                
            } WithSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *stuffId = responseObject[@"id"];
                self.kind = @"2";
                [self newStuff:stuffId];
            } WithFailureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
//            [FBAPI uploadFileWithURL:upload_url WithToken:token WithFileUrl:[NSURL fileURLWithPath:self.mediaModel.fileUrl] WihtProgressBlock:^(CGFloat progress) {
//                
//            } WithSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
//                NSString *stuffId = responseObject[@"id"];
//                self.kind = @"2";
//                [self newStuff:stuffId];
//            } WithFailureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//                
//            }];
            
            
        } failure:^(FBRequest *request, NSError *error) {
            
        }];
    }
}

-(void)newStuff:(NSString *)stuffId{
    FBRequest *request = [FBAPI postWithUrlString:@"/stuffs/store" requestDictionary:@{
                                                                                       @"content" : self.releaseView.instructionsTextView.text,
                                                                                       @"asset_id" : stuffId,
                                                                                       @"address" : self.releaseView.accordingLabel.text,
                                                                                       @"kind" : self.kind,
                                                                                       @"tags" : self.tagsAry,
                                                                                       @"lat" : @(self.lat),
                                                                                       @"lng" : @(self.lon)
                                                                                       } delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        [SVProgressHUD showSuccessWithStatus:@"发布成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
}

@end
