//
//  FSTagCollectionViewCell.m
//  Fifish
//
//  Created by THN-Dong on 16/9/21.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSTagCollectionViewCell.h"
#import "FSTageModel.h"
#import "UIImageView+WebCache.h"

@interface FSTagCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation FSTagCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgImageView.layer.masksToBounds = YES;
    self.bgImageView.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
}

-(void)setModel:(FSTageModel *)model{
    _model = model;
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:nil];
    self.titleLabel.text = model.name;
}

@end
