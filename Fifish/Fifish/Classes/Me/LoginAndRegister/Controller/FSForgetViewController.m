//
//  FSForgetViewController.m
//  Fifish
//
//  Created by THN-Dong on 16/7/26.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSForgetViewController.h"
#import "NSString+Helper.h"
#import "SVProgressHUD.h"
#import "UIColor+FSExtension.h"

@interface FSForgetViewController ()

@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *timeView;

@end

@implementation FSForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"忘记密码";
    
    [self.getCodeBtn.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [self.getCodeBtn.layer setCornerRadius:5];
    [self.getCodeBtn.layer setBorderWidth:1];//设置边界的宽度
    [self.getCodeBtn.layer setBorderColor:[UIColor colorWithHexString:@"#4388D7"].CGColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}


- (IBAction)clickGetCodeBtn:(UIButton *)sender {
    if ([_phoneTF.text checkTel]) {
        [self.getCodeBtn.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        self.timeView.hidden = NO;
        sender.enabled = NO;
        [self startTime];
    }else{
        [SVProgressHUD showErrorWithStatus:@"手机号不正确"];
    }
}

//开始倒计时准备重新发送
-(void)startTime{
    __block int timeout = 30;//倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);//每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        //倒计时结束，关闭
        if (timeout <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //时间到了后重新发送view消失
                self.getCodeBtn.enabled = YES;
                [self.getCodeBtn.layer setBorderColor:[UIColor colorWithHexString:@"#4388D7"].CGColor];
                self.timeView.hidden = YES;
            });
        }//按钮显示剩余时间
        else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d",seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                self.timeLabel.text = strTime;
                [UIView commitAnimations];
            });
            timeout --;
        }
    });
    dispatch_resume(_timer);
}


@end
