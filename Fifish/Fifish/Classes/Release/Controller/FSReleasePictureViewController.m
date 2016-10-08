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

@interface FSReleasePictureViewController () <UITextViewDelegate>

/**  */
@property (nonatomic, strong) UIScrollView *myScrollview;
/**  */
@property (nonatomic, strong) FSReleaseView *releaseView;

@end

@implementation FSReleasePictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavi];
    [self.view addSubview:self.myScrollview];
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
    }
    return _releaseView;
}

-(void)tagClick{
    FSAddTagViewController *vc = [[FSAddTagViewController alloc] init];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
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
    
}


@end
