//
//  FSAddTagViewController.m
//  Fifish
//
//  Created by THN-Dong on 2016/10/8.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSAddTagViewController.h"

@interface FSAddTagViewController ()

/**  */
@property (nonatomic, strong) UIView *naviView;
/**  */
@property (nonatomic, strong) UITextField *tagsTextField;

@end

@implementation FSAddTagViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavViewUI];
}

-(UIView *)naviView{
    if (!_naviView) {
        _naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64 + 20)];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 63, SCREEN_WIDTH, 1)];
        view.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(15, 0, 30, 30);
        [btn setImage:[UIImage imageNamed:@"eq_cancel"] forState:UIControlStateNormal];
        btn.centerY = _naviView.centerY;
        [_naviView addSubview:view];
        [_naviView addSubview:btn];
    }
    return _naviView;
}

-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -  设置导航栏
- (void)setNavViewUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.view addSubview:self.naviView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewUI];
}

#pragma mark - setUI
- (void)setViewUI {
    [self.view addSubview:self.tagsTextField];
    //[self.view addSubview:self.tagsList];
    //[self.view addSubview:self.searchList];
}

@end
