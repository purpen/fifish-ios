//
//  FSMeHeadTableViewCell.m
//  Fifish
//
//  Created by THN-Dong on 16/7/28.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSMeHeadTableViewCell.h"
#import "FSConst.h"
#import "UIImageView+WebCache.h"
#import "FSUserModel.h"

@implementation FSMeHeadTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
        self.headImageView.layer.masksToBounds = YES;
        self.headImageView.layer.cornerRadius = 40;
        self.headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.headImageView.layer.borderWidth = 1;
        
        CAGradientLayer *downShadow = [CAGradientLayer layer];
        downShadow.startPoint = CGPointMake(0, 0);
        downShadow.endPoint = CGPointMake(0, 1);
        downShadow.opacity = 0.5;
        downShadow.colors = @[(__bridge id)[UIColor clearColor].CGColor,
                            (__bridge id)[UIColor blackColor].CGColor];
        downShadow.frame = CGRectMake(0, 284 - 200 , SCREEN_WIDTH, 200);
        [self.bg_imageView.layer addSublayer:downShadow];
    }
    return self;
}

-(void)setModel:(FSUserModel *)model{
    _model = model;
    [self.bg_imageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"me_bg_large"]];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.large] placeholderImage:[UIImage imageNamed:@"login_head_default"]];
    self.nickName.text = model.username;
    self.addressLabel.text = model.zone;
    self.signatureLabel.text = model.summary;
    self.zuoPinShu.text = model.stuff_count;
    self.guanZhuShuLabel.text = model.follow_count;
    self.fenSiShuLabel.text = model.fans_count;
}


@end
