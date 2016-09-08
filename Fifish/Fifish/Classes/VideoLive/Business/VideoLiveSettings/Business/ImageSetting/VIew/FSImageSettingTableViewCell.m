//
//  FSImageSettingTableViewCell.m
//  Fifish
//
//  Created by macpro on 16/9/7.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSImageSettingTableViewCell.h"

@interface FSImageSettingTableViewCell()

@property (nonatomic, strong)UISwitch * Cellswitch;//开关


@end
@implementation FSImageSettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.Cellswitch];
        [self.Cellswitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor blackColor];
        self.textLabel.textColor = SETTING_Gray_COLOR;
    }
    return  self;
}

- (UISwitch *)Cellswitch{
    if (!_Cellswitch) {
        _Cellswitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        [_Cellswitch addTarget:self action:@selector(switchStatusChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _Cellswitch;
}
- (void)switchStatusChange:(UISwitch *)sender{
    
}
@end
