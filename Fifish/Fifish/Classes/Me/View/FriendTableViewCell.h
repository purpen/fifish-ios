//
//  FriendTableViewCell.h
//  Fiu
//
//  Created by THN-Dong on 16/4/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendTableViewCell : UITableViewCell

@property(nonatomic,strong) UIImageView *headImageView;
@property(nonatomic,strong) UILabel *nameLbael;
@property(nonatomic,strong) UILabel *userLevelLabel;
@property(nonatomic,strong) UIButton *follow;
@property(nonatomic,strong) UICollectionView *imageCollectionView;
@property(nonatomic,strong) NSArray *sceneAry;
/**  */
@property (nonatomic, strong) UINavigationController *navi;

@end
