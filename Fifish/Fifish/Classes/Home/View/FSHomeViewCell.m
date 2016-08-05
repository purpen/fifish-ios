//
//  FSHomeViewCell.m
//  Fifish
//
//  Created by THN-Dong on 16/8/4.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSHomeViewCell.h"
#import "FSHomeModel.h"
#import "FSHomePictuerView.h"
#import "UIView+FSExtension.h"
#import "FSHomeVideoView.h"

@interface FSHomeViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *labelLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *commendBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;


/** FSHomePictuerView */
@property (nonatomic, strong) FSHomePictuerView *pictuerView;
/**  */
@property (nonatomic, strong) FSHomeVideoView *videoView;

@end

@implementation FSHomeViewCell

-(FSHomePictuerView *)pictuerView{
    if (!_pictuerView) {
        _pictuerView = [FSHomePictuerView viewFromXib];
        [self.contentView addSubview:_pictuerView];
    }
    return _pictuerView;
}

-(FSHomeVideoView *)videoView{
    if (!_videoView) {
        _videoView = [FSHomeVideoView viewFromXib];
        [self.contentView addSubview:_videoView];
    }
    return _videoView;
}

-(void)setModel:(FSHomeModel *)model{
    _model = model;
    
    
    if (model.type == FSZuoPinTypePicture) {
        self.pictuerView.hidden = NO;
        self.pictuerView.model = model;
        self.pictuerView.frame = model.pictuerF;
        
        self.videoView.hidden = YES;
    }else if (model.type == FSZuoPinTypeVideo){
        self.videoView.hidden = NO;
        self.videoView.model = model;
        self.videoView.frame = model.videoF;
        
        self.pictuerView.hidden = NO;
    }
}

-(void)setFrame:(CGRect)frame{
    frame.size.height = self.model.cellHeghit - 10;
    [super setFrame:frame];
}

@end
