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
#import "CoreTextData.h"
@class FSZuoPin;
@class FSHomeViewCell;

@protocol FSHomeViewCellDelegate <NSObject>

/** 播放视频*/
- (void)homeTableViewCell:(FSHomeViewCell *)cell didClickVideoWithVideoUrl:(NSString *)videoUrl videoCover:(FSHomeVideoView *)baseImageView;

@end


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
/**  */
@property (nonatomic, strong) CoreTextData *ctData;
@property (weak, nonatomic) IBOutlet UIView *bottom_line_view;
/**  */
@property (nonatomic, strong) NSAttributedString *contentString;
/** 
 */
@property (nonatomic, assign) NSInteger hideFlag;
/**  */
@property (nonatomic, weak) id<FSHomeViewCellDelegate> fSHomeViewDelegate;

@end
