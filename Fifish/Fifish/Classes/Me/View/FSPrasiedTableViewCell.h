//
//  FSPrasiedTableViewCell.h
//  Fifish
//
//  Created by THN-Dong on 2016/11/4.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSRecivedPrasiedModel.h"

@interface FSPrasiedTableViewCell : UITableViewCell

/**  */
@property (nonatomic, strong) FSRecivedPrasiedModel *model;
/**  */
@property (nonatomic, strong) UIViewController *myVC;

@end
