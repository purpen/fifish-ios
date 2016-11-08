//
//  FSFoundStuffTableViewCell.h
//  Fifish
//
//  Created by THN-Dong on 16/9/22.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSHomeVideoView.h"
#import "FSHomePictuerView.h"
@class FSZuoPin;

@interface FSFoundStuffTableViewCell : UITableViewCell

/**  */
@property (nonatomic, strong) FSZuoPin *model;
/**  */
@property (nonatomic, strong) UINavigationController *navi;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *commendBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
/** FSHomePictuerView */
@property (nonatomic, strong) FSHomePictuerView *pictuerView;
/**  */
@property (nonatomic, strong) FSHomeVideoView *videoView;
@property (weak, nonatomic) IBOutlet UIButton *fucosBtn;
/**  */
@property (nonatomic, strong) UINavigationController *navc;
/**  */
@property (nonatomic, strong) UIViewController *myViewController;

@end
