//
//  FSRegulateCollectionviewCell.m
//  Fifish
//
//  Created by macpro on 16/10/12.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSRegulateCollectionviewCell.h"

@interface FSRegulateCollectionviewCell ()




@end

@implementation FSRegulateCollectionviewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.top.equalTo(self.contentView.mas_top);
            make.height.mas_equalTo(@30);
        }];
        
        [self.contentView addSubview:self.iconImageview];
        [self.iconImageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(24, 24));
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.centerY.equalTo(self.contentView.mas_centerY).offset(15);
        }];
        
        
    }
    return self;
}
- (UIImageView *)iconImageview{
    if (!_iconImageview) {
        _iconImageview = [[UIImageView alloc] init];
        _iconImageview.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImageview;
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.font = [UIFont systemFontOfSize:14];
    }
    return _titleLab;
}
@end
