//
//  FSHomeViewCell.m
//  Fifish
//
//  Created by THN-Dong on 16/8/4.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSHomeViewCell.h"
#import "FSZuoPin.h"
#import "UIView+FSExtension.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "FSHomePageViewController.h"
#import "CTDisplayView.h"
#import "CTFrameParser.h"
#import "CTFrameParserConfig.h"
#import "CoreTextLinkData.h"
#import "FSTagSearchViewController.h"
#import "FSUserModel.h"
#import "FSShareViewController.h"
#import "FSLoginViewController.h"
#import <pop/POP.h>
#import "FSUserModel2.h"
#import "UILabel+MultipleLines.h"

@interface FSHomeViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagTag;


@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIView *neiRongView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;
@property (weak, nonatomic) IBOutlet UIButton *headTapBtn;
@property (weak, nonatomic) IBOutlet CTDisplayView *tagView;
/**  */
@property (nonatomic, strong) NSMutableArray *tagMAry;
@property (weak, nonatomic) IBOutlet UIImageView *addressIcon;
/**  */
@property (nonatomic, strong) FSUserModel *userModel;
@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (weak, nonatomic) IBOutlet UIView *hideView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabel_bottomSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagView_height;

@end

@implementation FSHomeViewCell

-(void)awakeFromNib{
    [super awakeFromNib];
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 20;
    self.fucosBtn.layer.masksToBounds = YES;
    self.fucosBtn.layer.cornerRadius = 13;
    self.fucosBtn.layer.borderWidth = 1;
    self.fucosBtn.layer.borderColor = [UIColor colorWithHexString:@"#7F8FA2"].CGColor;
    [self.contentView addSubview:self.pictuerView];
    [_pictuerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(0);
        make.top.mas_equalTo(self.headImageView.mas_bottom).offset(8);
        make.right.mas_equalTo(self.contentView.mas_right).offset(0);
        make.height.mas_equalTo(211 / 667.0 * SCREEN_HEIGHT);
        make.bottom.mas_equalTo(self.toolView.mas_top).offset(-3);
    }];
    [self.contentView addSubview:self.videoView];
    [_videoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(0);
        make.top.mas_equalTo(self.headImageView.mas_bottom).offset(8);
        make.right.mas_equalTo(self.contentView.mas_right).offset(0);
        make.height.mas_equalTo(211 / 667.0 * SCREEN_HEIGHT);
        make.bottom.mas_equalTo(self.toolView.mas_top).offset(-3);
    }];
    [self.likeBtn addTarget:self action:@selector(likeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.videoView.tapBtn addTarget:self action:@selector(video:) forControlEvents:UIControlEventTouchUpInside];
}


-(NSMutableArray *)tagMAry{
    if (!_tagMAry) {
        _tagMAry = [NSMutableArray array];
    }
    return _tagMAry;
}

- (IBAction)headBtnClick:(UIButton *)sender {
    FSHomePageViewController *vc = [[FSHomePageViewController alloc] init];
    vc.userId = self.model.user_id;
    [self.navi pushViewController:vc animated:YES];
}

-(FSHomePictuerView *)pictuerView{
    if (!_pictuerView) {
        _pictuerView = [FSHomePictuerView viewFromXib];
    }
    return _pictuerView;
}

- (IBAction)shareClick:(id)sender {
    FSShareViewController *vc = [[FSShareViewController alloc] init];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.model = self.model;
    [self.myViewController presentViewController:vc animated:YES completion:nil];
}

-(FSHomeVideoView *)videoView{
    if (!_videoView) {
        _videoView = [FSHomeVideoView viewFromXib];
    }
    return _videoView;
}

-(FSUserModel *)userModel{
    if (!_userModel) {
        _userModel = [[FSUserModel2 findAll] lastObject];
    }
    return _userModel;
}

-(void)setModel:(FSZuoPin *)model{
    _model = model;
    if ([model.like_count integerValue] > 0) {
        self.like_count_label.text = model.like_count;
    } else {
        self.like_count_label.text = @"";
    }
    if ([self.userModel.userId isEqualToString:_model.user_id]) {
        self.fucosBtn.hidden = YES;
    } else {
        self.fucosBtn.hidden = NO;
    }
    self.tagView.navc = self.navi;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar_large] placeholderImage:[UIImage imageNamed:@"me_defult"]];
    self.nameLabel.text = model.username;
    self.timeLabel.text = model.created_at;
    self.addressLabel.text = model.address;
    if (model.address.length == 0) {
        self.addressIcon.hidden = YES;
        self.nameLabel_bottomSpace.constant = 7;
    } else {
        self.addressIcon.hidden = NO;
        self.nameLabel_bottomSpace.constant = -2.5;
    }
    if ([model.kind intValue] == 1) {
        self.videoView.hidden = YES;
        self.pictuerView.hidden = NO;
        self.pictuerView.model = model;
    }else if ([model.kind intValue] == 2){
        self.pictuerView.hidden = YES;
        self.videoView.hidden = NO;
        self.videoView.model = model;
    }
    
    if (model.is_love == 0) {
        self.likeBtn.selected = NO;
        self.like_count_label.textColor = [UIColor colorWithHexString:@"#7F8FA2"];
    } else if (model.is_love == 1) {
        self.likeBtn.selected = YES;
        self.like_count_label.textColor = [UIColor colorWithHexString:@"#2288ff"];
    }
    
    if (model.is_follow == 0) {
        self.fucosBtn.layer.borderColor = [UIColor colorWithHexString:@"#7F8FA2"].CGColor;
        self.fucosBtn.selected = NO;
    } else {
        self.fucosBtn.layer.borderColor = [UIColor colorWithHexString:@"#2288FF"].CGColor;
        self.fucosBtn.selected = YES;
    }
    
    if (model.tags.count == 0) {
        self.tagView_height.constant = 0;
    } else {
        self.tagView_height.constant = 33;
    }
    [self layoutIfNeeded];
    CGSize textSzie = [self.contentLabel setText:model.content lines:3 andLineSpacing:5 constrainedToSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT) andWordsSpace:0.5f];
    self.contentLabel.frame = CGRectMake(15, 10, textSzie.width, textSzie.height);
}


-(void)video:(UIButton*)sender{
    WeakSelf(weakSelf);
    if ([weakSelf.fSHomeViewDelegate respondsToSelector:@selector(homeTableViewCell:didClickVideoWithVideoUrl:videoCover:)]) {
        [weakSelf.fSHomeViewDelegate homeTableViewCell:weakSelf didClickVideoWithVideoUrl:self.model.srcfile videoCover:self.videoView];
    }
}


-(void)setCtData:(CoreTextData *)ctData{
    if (self.model.tags.count > 0) {
        self.tagView.hidden = NO;
        _ctData = ctData;
        CTDisplayView *view = [[CTDisplayView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.tagView.height)];
        view.userInteractionEnabled = YES;
        view.navc = self.navi;
        view.backgroundColor = [UIColor whiteColor];
        [self.tagView addSubview:view];
        view.data = ctData;
    } else {
        self.tagView.hidden = YES;
    }
}

#pragma mark - 点击喜欢按钮
-(void)likeClick:(UIButton*)sender{
    FSUserModel2 *model = [[FSUserModel2 findAll] lastObject];
    if (model.isLogin) {
        //登录了，可以进行后续操作
        NSString *idStr = self.model.idFeild;
        if (sender.selected) {
            FBRequest *request = [FBAPI postWithUrlString:[NSString stringWithFormat:@"/stuffs/%@/cancelike",idStr] requestDictionary:nil delegate:self];
            [request startRequestSuccess:^(FBRequest *request, id result) {
                sender.selected = NO;
                self.like_count_label.textColor = [UIColor colorWithHexString:@"#7F8FA2"];
                NSInteger n = [self.model.like_count integerValue] - 1;
                NSString *str = [NSString stringWithFormat:@"%ld",  n];
                self.model.is_love = 0;
                if (n <= 0) {
                    self.model.like_count = @"0";
                    self.like_count_label.text = @"";
                    return;
                }
                self.like_count_label.text = str;
            } failure:^(FBRequest *request, NSError *error) {
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Network error", nil)];
            }];
        } else {
            FBRequest *request = [FBAPI postWithUrlString:[NSString stringWithFormat:@"/stuffs/%@/dolike",idStr] requestDictionary:nil delegate:self];
            [request startRequestSuccess:^(FBRequest *request, id result) {
                POPSpringAnimation *likeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerSubscaleXY];
                likeAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.5, 0.5)];
                likeAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
                likeAnimation.springSpeed = 10;
                likeAnimation.springBounciness = 10;
                [sender.layer pop_addAnimation:likeAnimation forKey:@"like"];
                sender.selected = YES;
                self.like_count_label.textColor = [UIColor colorWithHexString:@"#2288ff"];
                NSInteger n = [self.model.like_count integerValue] + 1;
                NSString *str = [NSString stringWithFormat:@"%ld",  n];
                self.model.like_count = str;
                self.like_count_label.text = str;
                self.model.is_love = 1;
            } failure:^(FBRequest *request, NSError *error) {
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Network error", nil)];
            }];
        }
    } else {
        FSLoginViewController *vc = [[FSLoginViewController alloc] init];
        [self.myViewController presentViewController:vc animated:YES completion:nil];
    }
}

@end
