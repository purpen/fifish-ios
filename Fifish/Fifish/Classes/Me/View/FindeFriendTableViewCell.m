//
//  FindeFriendTableViewCell.m
//  Fiu
//
//  Created by THN-Dong on 16/4/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FindeFriendTableViewCell.h"
#import "InvitationModel.h"
#import "Masonry.h"

@implementation FindeFriendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setUIWithModel:(InvitationModel *)model{
    self.headImage.image = [UIImage imageNamed:model.headImageStr];
    self.nameLabel.text = model.titleStr;
    self.sumLabel.text = model.sumStr;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-10, 0.5));
            make.left.mas_equalTo(self.mas_left).with.offset(5);
            make.bottom.mas_equalTo(self.mas_bottom).with.offset(0);
        }];
        
        [self.contentView addSubview:self.headImage];
        [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(76*0.5/667.0*SCREEN_HEIGHT, 76*0.5/667.0*SCREEN_HEIGHT));
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(self.mas_left).with.offset(16/667.0*SCREEN_HEIGHT);
        }];
        
        [self.contentView addSubview:self.nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImage.mas_right).with.offset(7/667.0*SCREEN_HEIGHT);
            make.top.mas_equalTo(self.mas_top).with.offset(10/667.0*SCREEN_HEIGHT);
            make.right.mas_equalTo(self.mas_right).with.offset(-30);
            make.height.mas_equalTo(20);
        }];
        
        [self.contentView addSubview:self.sumLabel];
        [_sumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImage.mas_right).with.offset(7/667.0*SCREEN_HEIGHT);
            make.top.mas_equalTo(_nameLabel.mas_bottom).with.offset(3/667.0*SCREEN_HEIGHT);
            make.right.mas_equalTo(self.mas_right).with.offset(-30);
            make.height.mas_equalTo(16);
        }];
        
        [self.contentView addSubview:self.goImage];
        [_goImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(8, 15));
            make.centerY.mas_equalTo(self.mas_centerY);
            make.right.mas_equalTo(self.mas_right).with.offset(-16/667.0*SCREEN_HEIGHT);
        }];
        
    }
    return self;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    }
    return _lineView;
}

-(UIImageView *)goImage{
    if (!_goImage) {
        _goImage = [[UIImageView alloc] init];
        _goImage.image = [UIImage imageNamed:@"go"];
    }
    return _goImage;
}

-(UIImageView *)headImage{
    if (!_headImage) {
        _headImage = [[UIImageView alloc] init];
        _headImage.layer.masksToBounds = YES;
        _headImage.layer.cornerRadius = 3;
    }
    return _headImage;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:13];
    }
    return _nameLabel;
}

-(UILabel *)sumLabel{
    if (!_sumLabel) {
        _sumLabel = [[UILabel alloc] init];
        _sumLabel.font = [UIFont systemFontOfSize:10];
    }
    return _sumLabel;
}

@end
