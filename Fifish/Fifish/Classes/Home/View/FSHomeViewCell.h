//
//  FSHomeViewCell.h
//  Fifish
//
//  Created by THN-Dong on 16/8/4.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSHomePictuerView.h"
#import "FSHomeVideoView.h"

@class FSZuoPin;


@interface FSHomeViewCell : UITableViewCell

/**  */
@property (nonatomic, strong) FSZuoPin *model;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *commendBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
/** FSHomePictuerView */
@property (nonatomic, strong) FSHomePictuerView *pictuerView;
/**  */
@property (nonatomic, strong) FSHomeVideoView *videoView;
/**  */
@property (nonatomic, strong) UINavigationController *navi;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHegiht;
@property (weak, nonatomic) IBOutlet UIButton *tagBtn;
@property (weak, nonatomic) IBOutlet UIButton *fucosBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomView_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagView_bottom_distance;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabel_height;
/**  */
@property (nonatomic, strong) UIViewController *myViewController;

@end
