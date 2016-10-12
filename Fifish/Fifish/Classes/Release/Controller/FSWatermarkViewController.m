//
//  FSWatermarkViewController.m
//  Fifish
//
//  Created by THN-Dong on 2016/10/11.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSWatermarkViewController.h"
#import "UIImage+FSWatermark.h"

@interface FSWatermarkViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
/**  */
@property (nonatomic, strong) UIImage *waterImage;


@end

@implementation FSWatermarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bigImage = [UIImage imageNamed:@"release_default"];
    [self.watermarkSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    self.nameTF.delegate = self;
    self.watermarkSwitch.on = self.switchSState;
    self.nameTF.enabled = self.switchSState;
    if (self.switchSState) {
        self.waterImage = [self.bigImage watermarkImage:[NSString stringWithFormat:@"©%@", self.str]];
        self.nameTF.text = self.str;
        self.showImageView.image = self.waterImage;
    } else {
        self.showImageView.image = self.bigImage;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([self.waterDelegate respondsToSelector:@selector(saveName:)]) {
        [self.waterDelegate saveName:textField.text];
        self.str = textField.text;
    }
    self.waterImage = [self.bigImage watermarkImage:[NSString stringWithFormat:@"©%@", textField.text]];
    self.showImageView.image = self.waterImage;
    return [textField resignFirstResponder];
}

-(void)switchAction:(UISwitch*)sender{
    if (sender.isOn) {
        sender.on = NO;
        //取消水印
        if ([self.waterDelegate respondsToSelector:@selector(switch:)]) {
            [self.waterDelegate switch:NO];
        }
        self.nameTF.enabled = NO;
        self.showImageView.image = self.bigImage;
    } else {
        sender.on = YES;
        //开启水印
        if ([self.waterDelegate respondsToSelector:@selector(switch:)]) {
            [self.waterDelegate switch:YES];
        }
        self.nameTF.enabled = YES;
        if (self.str.length == 0) {
            self.showImageView.image = self.bigImage;
        } else {
            self.showImageView.image = self.waterImage;
        }
    }
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
