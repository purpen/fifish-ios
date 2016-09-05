//
//  FindeFriendTableViewCell.h
//  Fiu
//
//  Created by THN-Dong on 16/4/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class InvitationModel;

@interface FindeFriendTableViewCell : UITableViewCell

@property(nonatomic,strong) UIImageView *headImage;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UILabel *sumLabel;
@property(nonatomic,strong) UIImageView *goImage;
@property(nonatomic,strong) UIView *lineView;

-(void)setUIWithModel:(InvitationModel*)model;

@end
