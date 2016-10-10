//
//  FSImageEditViewController.m
//  Fifish
//
//  Created by macpro on 16/10/10.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSImageEditViewController.h"

@interface FSImageEditViewController ()
@property (nonatomic,strong) UIImageView * imageView;

@end

@implementation FSImageEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)makeUserInterface{
    [self.view addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
    }];
}
@end
