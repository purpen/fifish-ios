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

@interface FSListUserTableViewCell ()


@property (weak, nonatomic) IBOutlet UIImageView *headInageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;


@end

@implementation FSListUserTableViewCell

-(void)setModel:(FSListUserModel *)model{
    _model = model;
    self.userNameLabel.text = model.userName;
    self.summaryLabel.text = model.summary;
    
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.fucosBtn.layer.masksToBounds = YES;
    self.fucosBtn.layer.cornerRadius = 13;
    self.fucosBtn.layer.borderColor = [UIColor colorWithHexString:@"0995f8"].CGColor;
    self.fucosBtn.layer.borderWidth = 1;
}

@end
