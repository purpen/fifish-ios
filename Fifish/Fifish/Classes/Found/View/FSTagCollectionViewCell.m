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
    // Initialization code
}

-(void)setModel:(FSTageModel *)model{
    _model = model;
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:nil];
    self.titleLabel.text = model.name;
}

@end
