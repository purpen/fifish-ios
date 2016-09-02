//
//  AddreesPickerViewController.h
//  Fiu
//
//  Created by THN-Dong on 16/4/28.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddreesPickerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *pickerBtn;
@property (weak, nonatomic) IBOutlet UIPickerView *addreesBtn;

@property (nonatomic, assign) NSInteger provinceId;
@property (nonatomic, assign) NSInteger cityId;
@property (nonatomic, copy) NSString  * provinceStr;
@property (nonatomic, copy) NSString  * cityStr;


@end
