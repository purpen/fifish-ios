//
//  AboutViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "AboutViewController.h"
#import  "SVProgressHUD.h"

@interface AboutViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *aboutWebView;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.aboutWebView.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"about Fifish", nil);
    
    //地址
    NSURL *url = [NSURL URLWithString:@"https://api.qysea.com/h5/about"];
    //在网页上加载
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.aboutWebView loadRequest:request];
    self.aboutWebView.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

//UIWebViewDelegate
//网页开始加载时出现进度条
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [SVProgressHUD show];
}
//网页加载完成进度条消失
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [SVProgressHUD dismiss];
}
//网页加载失败，提示加载失败原因
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [SVProgressHUD showInfoWithStatus:error.localizedDescription];
}


@end
