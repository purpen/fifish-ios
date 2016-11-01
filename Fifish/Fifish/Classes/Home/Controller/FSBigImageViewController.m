//
//  FSBigImageViewController.m
//  Fifish
//
//  Created by THN-Dong on 2016/9/27.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSBigImageViewController.h"
#import "FSImageScrollView.h"
#import "AFNetworking.h"

@interface FSBigImageViewController ()

{
    UIImage *_sceneImage;
}
/**  */
@property (nonatomic, strong) FSImageScrollView *imageView;

@end

@implementation FSBigImageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:(UIStatusBarAnimationFade)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewUI];
}

- (void)setViewUI {
    self.view.backgroundColor = [UIColor blackColor];
    if (self.imageUrl.length != 0) {
        _sceneImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageUrl]]];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        NSURL *URL = [NSURL URLWithString:self.imageUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//        NSURLSessionDownloadTask *downloadTask
    } else {
        _sceneImage = self.showImage;
    }
    [self addGestureRecognizer];
    [self.view addSubview:self.imageView];
    [self.imageView displayImage:_sceneImage];
}

#pragma mark - 添加手势操作
- (void)addGestureRecognizer {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissVC:)];
    [self.view addGestureRecognizer:tap];
}

- (void)dismissVC:(UITapGestureRecognizer *)tap {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 情境大图
- (FSImageScrollView *)imageView {
    if (!_imageView) {
        _imageView = [[FSImageScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
}

@end
