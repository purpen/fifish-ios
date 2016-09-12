//
//  FSImageSettingTableViewCell.h
//  Fifish
//
//  Created by macpro on 16/9/7.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSBaseTableViewCell.h"

#import "FSCameraInfoModel.h"

static NSString * const ImageSettingTableViewCellIden = @"ImageSettingTableViewCell";
@interface FSImageSettingTableViewCell : FSBaseTableViewCell

@property (nonatomic, strong)UISwitch * Cellswitch;//开关


@property (nonatomic, assign)FSCameraInfoModel * cameraModel;//相机信息

@property (nonatomic, assign)NSIndexPath*           indexPath;//位置


@end
