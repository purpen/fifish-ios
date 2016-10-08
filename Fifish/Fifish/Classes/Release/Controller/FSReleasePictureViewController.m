//
//  FSReleasePictureViewController.m
//  Fifish
//
//  Created by THN-Dong on 2016/10/8.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSReleasePictureViewController.h"
#import "UIBarButtonItem+FSExtension.h"

@interface FSReleasePictureViewController ()

@end

@implementation FSReleasePictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavi];
}

-(void)setUpNavi{
    UIBarButtonItem *releaseItem = [UIBarButtonItem itemWithTitle:@"发布" target:self action:@selector(releaseClick)];
    self.navigationItem.rightBarButtonItem = releaseItem;
    self.navigationItem.title = @"分享";
}

-(void)releaseClick{
    
}

@end
