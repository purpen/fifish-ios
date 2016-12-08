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
#import "CoreTextData.h"
@class FSZuoPin;
@class FSFoundStuffTableViewCell;

@protocol FSFoundStuffTableViewCellDelegate <NSObject>

/** 播放视频*/
- (void)homeTableViewCell:(FSFoundStuffTableViewCell *)cell didClickVideoWithVideoUrl:(NSString *)videoUrl videoCover:(FSHomeVideoView *)baseImageView;

@end

@interface FSFoundStuffTableViewCell : UITableViewCell

/**  */
@property (nonatomic, strong) FSZuoPin *model;
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
/**  */
@property (nonatomic, strong) CoreTextData *ctData;
/**  */
@property (nonatomic, strong) NSAttributedString *contentString;
/**
 */
@property (nonatomic, assign) NSInteger hideFlag;
@property (weak, nonatomic) IBOutlet UILabel *like_count_label;
/**  */
@property (nonatomic, weak) id<FSFoundStuffTableViewCellDelegate> fSHomeViewDelegate;

@end
