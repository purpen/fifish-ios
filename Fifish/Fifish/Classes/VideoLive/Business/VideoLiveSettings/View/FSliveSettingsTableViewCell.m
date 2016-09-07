//
//  FSliveSettingsTableViewCell.m
//  Fifish
//
//  Created by macpro on 16/9/6.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSliveSettingsTableViewCell.h"

@implementation FSliveSettingsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.textLabel.textColor = [UIColor whiteColor];
    }
    else{
        self.textLabel.textColor = SETTING_Gray_COLOR;
    }
    // Configure the view for the selected state
}
- (void)willshow{
    
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.backgroundColor = [UIColor blackColor];
    self.textLabel.textColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
@end
