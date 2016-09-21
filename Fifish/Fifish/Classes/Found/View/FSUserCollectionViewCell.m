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
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.small] placeholderImage:nil];
    self.nameLabel.text = model.username;
}

@end
