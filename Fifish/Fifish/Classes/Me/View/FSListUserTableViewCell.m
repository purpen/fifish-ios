//
//  FSListUserTableViewCell.m
//  Fifish
//
//  Created by THN-Dong on 16/9/20.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSListUserTableViewCell.h"
#import "FSListUserModel.h"
#import "UIColor+FSExtension.h"
#import "UIImageView+WebCache.h"

@interface FSListUserTableViewCell ()


@property (weak, nonatomic) IBOutlet UIImageView *headInageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;


@end

@implementation FSListUserTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.fucosBtn.layer.masksToBounds = YES;
        self.fucosBtn.layer.cornerRadius = 13;
        self.fucosBtn.layer.borderColor = [UIColor colorWithHexString:@"0995f8"].CGColor;
        self.fucosBtn.layer.borderWidth = 1;
        self.headInageView.layer.masksToBounds = YES;
        self.headInageView.layer.cornerRadius = 20;
    }
    return self;
}

-(void)setUserModel:(FSUserModel *)userModel{
    _userModel = userModel;
    self.userNameLabel.text = userModel.username;
    self.summaryLabel.text = userModel.summary;
    [self.headInageView sd_setImageWithURL:[NSURL URLWithString:userModel.large] placeholderImage:[UIImage imageNamed:@""]];
//    if (userModel.followFlag == 1) {
//        self.fucosBtn.selected = YES;
//        self.fucosBtn.layer.borderColor = [UIColor colorWithHexString:@"0995f8"].CGColor;
//    } else {
//        self.fucosBtn.selected = NO;
//        self.fucosBtn.layer.borderColor = [UIColor colorWithHexString:@"7F8FA2"].CGColor;
//    }
}

-(void)setModel:(FSListUserModel *)model{
    _model = model;
    self.userNameLabel.text = model.userName;
    self.summaryLabel.text = model.summary;
    [self.headInageView sd_setImageWithURL:[NSURL URLWithString:model.userHeadImage] placeholderImage:[UIImage imageNamed:@""]];
    if (model.followFlag == 1) {
        self.fucosBtn.selected = YES;
    } else {
        self.fucosBtn.selected = NO;
    }
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.fucosBtn.layer.masksToBounds = YES;
    self.fucosBtn.layer.cornerRadius = 13;
    self.fucosBtn.layer.borderColor = [UIColor colorWithHexString:@"0995f8"].CGColor;
    self.fucosBtn.layer.borderWidth = 1;
    self.headInageView.layer.masksToBounds = YES;
    self.headInageView.layer.cornerRadius = 20;
}

@end
