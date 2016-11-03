//
//  FSListUserTableViewCell.h
//  Fifish
//
//  Created by THN-Dong on 16/9/20.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSUserModel.h"
#import "FSFansModel.h"
@class FSListUserModel;

@interface FSListUserTableViewCell : UITableViewCell

/**  */
@property (nonatomic, strong) FSListUserModel *model;
@property (weak, nonatomic) IBOutlet UIButton *fucosBtn;
/**  */
@property (nonatomic, strong) FSUserModel *userModel;
/**  */
@property (nonatomic, strong) FSFansModel *fansModel;

@end
