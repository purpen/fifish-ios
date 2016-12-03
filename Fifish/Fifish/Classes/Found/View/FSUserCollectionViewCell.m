//
//  FSUserCollectionViewCell.m
//  Fifish
//
//  Created by THN-Dong on 16/9/21.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSUserCollectionViewCell.h"
#import "FSUserModel.h"
#import "UIImageView+WebCache.h"

@interface FSUserCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation FSUserCollectionViewCell

-(void)setModel:(FSUserModel *)model{
    _model = model;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.large] placeholderImage:[UIImage imageNamed:@"me_defult"]];
    self.nameLabel.text = model.username;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 25;
}

@end
