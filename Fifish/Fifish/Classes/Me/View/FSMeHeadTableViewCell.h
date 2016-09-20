//
//  FSMeHeadTableViewCell.h
//  Fifish
//
//  Created by THN-Dong on 16/7/28.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FSUserModel;

@interface FSMeHeadTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bg_imageView;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *zuoPinShu;
@property (weak, nonatomic) IBOutlet UILabel *zuoPinLabel;
@property (weak, nonatomic) IBOutlet UIButton *zuoPinBtn;
@property (weak, nonatomic) IBOutlet UILabel *guanZhuShuLabel;
@property (weak, nonatomic) IBOutlet UILabel *guanZhuLabel;
@property (weak, nonatomic) IBOutlet UIButton *guanZhuBtn;

@property (weak, nonatomic) IBOutlet UILabel *fenSiShuLabel;
@property (weak, nonatomic) IBOutlet UILabel *fenSiLabel;
@property (weak, nonatomic) IBOutlet UIButton *fenSiBtn;
/** 数据模型 */
@property (nonatomic, strong) FSUserModel *model;

@end
