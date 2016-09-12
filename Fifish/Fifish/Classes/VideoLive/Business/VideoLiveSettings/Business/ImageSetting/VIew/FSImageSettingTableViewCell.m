//
//  FSImageSettingTableViewCell.m
//  Fifish
//
//  Created by macpro on 16/9/7.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSImageSettingTableViewCell.h"
#import "FSCameraManager.h"
@interface FSImageSettingTableViewCell()




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
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
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
- (void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
}
- (void)setCameraModel:(FSCameraInfoModel *)cameraModel{
    _cameraModel = cameraModel;
    switch (self.indexPath.row) {
        case 0:
        {
            self.Cellswitch.on = _cameraModel.BackLight;
        }
            break;
        case 1:
        {
            self.Cellswitch.on = _cameraModel.LowLumEnable;
        }
            break;
        case 2:
        {
            
            switch (_cameraModel.DayToNightModel) {
                case 0:
                {
                    self.detailTextLabel.text = [NSString stringWithFormat:@"%@(%@%@%@)",NSLocalizedString(@"自动", nil),NSLocalizedString(@"日", nil),NSLocalizedString(@"夜", nil),NSLocalizedString(@"模式", nil)];
                    break;
                }
                case 1:
                {
                    self.detailTextLabel.text = NSLocalizedString(@"彩色", nil);
                    break;
                }
                case 2:
                {
                    self.detailTextLabel.text = NSLocalizedString(@"黑白", nil);
                    break;
                }
                default:
                    break;
            }
            self.Cellswitch.hidden = YES;
        }
            break;
        default:
            break;
    }
}
- (void)switchStatusChange:(UISwitch *)sender{
    FSCameraManager * manager = [[FSCameraManager alloc] init];

    if (self.indexPath.row == 0) {
        [manager RovSetCameraBackLightWithON:sender.on Success:^(NSDictionary *responseObject) {
            NSLog(@"%@",responseObject);
        } WithFailureBlock:^(NSError *error) {
            NSLog(@"%@",error.localizedDescription);
        }];
    }
    if (self.indexPath.row == 1) {
        [manager RovSetCameraLowLumEnableWithON:sender.on Success:^(NSDictionary *responseObject) {
            NSLog(@"%@",responseObject);
        } WithFailureBlock:^(NSError *error) {
            NSLog(@"%@",error.localizedDescription);
        }];
    }
    
}
@end
