//
//  FSFilterCollectionViewCell.m
//  Fifish
//
//  Created by macpro on 16/10/11.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSFilterCollectionViewCell.h"

@interface FSFilterCollectionViewCell ()





@end

@implementation FSFilterCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.FilterImageView];
        [self.FilterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.contentView.mas_width);
            make.width.equalTo(self.contentView.mas_width);
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
        
        [self.contentView addSubview:self.FilterNameLab];
        [self.FilterNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.FilterImageView.mas_left);
            make.right.equalTo(self.FilterImageView.mas_right);
            make.top.equalTo(self.contentView.mas_top);
            make.bottom.equalTo(self.FilterImageView.mas_top);
        }];
    }
    return self;
}
-(UIImageView *)FilterImageView{
    if (!_FilterImageView) {
        _FilterImageView = [[UIImageView alloc] init];
        _FilterImageView.backgroundColor = [UIColor whiteColor];
        _FilterImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _FilterImageView;
}
-(UILabel *)FilterNameLab{
    if (!_FilterNameLab) {
        _FilterNameLab = [[UILabel alloc] init];
        _FilterNameLab.textColor = [UIColor whiteColor];
        _FilterNameLab.textAlignment = NSTextAlignmentCenter;
        _FilterNameLab.font = [UIFont systemFontOfSize:12];
    }
    return _FilterNameLab;
}
- (void)setIndex:(NSInteger )index{
    _index = index;
//    self.FilterNameLab.text = [NSString stringWithFormat:@"%lu",(long)index];
}
@end
