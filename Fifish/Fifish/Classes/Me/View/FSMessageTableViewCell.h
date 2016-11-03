//
//  FSMessageTableViewCell.h
//  Fifish
//
//  Created by THN-Dong on 2016/11/3.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSMessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goIcon;
@property (weak, nonatomic) IBOutlet UIView *lineView;
/**  */
@property (nonatomic, strong) NSDictionary *dict;

@end
