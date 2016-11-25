//
//  FSHomeDetailViewController.m
//  Fifish
//
//  Created by THN-Dong on 16/8/5.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSHomeDetailViewController.h"
#import "VideoLiveController.h"
#import "FSConst.h"
#import "FSCommendTableViewCell.h"
#import "FSCommentModel.h"
#import "FSHomeViewCell.h"
#import "UIView+FSExtension.h"
#import "FSZuoPin.h"
#import "FBRequest.h"
#import "FBAPI.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "FSUserModel.h"
#import "FSBigImageViewController.h"
#import "FSPlayViewController.h"
#import "FSReportViewController.h"
#import "CTFrameParserConfig.h"
#import "CoreTextData.h"
#import "CTFrameParser.h"
#import "NSString+FSAttributedString.h"
#import "WMPlayer.h"

@interface FSHomeDetailViewController ()<UITableViewDelegate, UITableViewDataSource, FSHomeViewCellDelegate, WMPlayerDelegate>
{
    WMPlayer *wmPlayer;
    FSHomeViewCell *_cell;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UITextField *textTF;
@property (weak, nonatomic) IBOutlet UITableView *commendTableView;
/**  */
@property (nonatomic, strong) NSMutableArray *commentAry;
/**  */
@property (nonatomic, assign) NSInteger current_page;
/**  */
@property (nonatomic, assign) NSInteger total_rows;
/**  */
@property (nonatomic, strong) NSMutableArray *tagMAry;
@property (nonatomic, strong) NSIndexPath *indexPath;
/**  */
@property (nonatomic, strong) UIView *imageView;
@property (nonatomic, assign) BOOL isSmallScreen;

@end

static NSString * const FSCommentId = @"comment";

@implementation FSHomeDetailViewController

-(NSMutableArray *)tagMAry{
    if (!_tagMAry) {
        _tagMAry = [NSMutableArray array];
    }
    return _tagMAry;
}

-(NSMutableArray *)commentAry{
    if (!_commentAry) {
        _commentAry = [NSMutableArray array];
    }
    return _commentAry;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = self.title;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    // cell的高度设置
    self.commendTableView.estimatedRowHeight = 44;
    self.commendTableView.rowHeight = UITableViewAutomaticDimension;
    self.commendTableView.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    // 注册
    [self.commendTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FSCommendTableViewCell class]) bundle:nil] forCellReuseIdentifier:FSCommentId];
    // 内边距
    self.commendTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    // 去掉分割线
    self.commendTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.sendBtn.layer.masksToBounds = YES;
    self.sendBtn.layer.cornerRadius = 4;
    
    [self setupHeader];
    [self setupRefresh];
}

#pragma mark - 设置刷新加载
-(void)setupRefresh{
    self.commendTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNew)];
    self.commendTableView.mj_header.automaticallyChangeAlpha = YES;
    [self.commendTableView.mj_header beginRefreshing];
    self.commendTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    self.commendTableView.mj_footer.hidden = YES;
}

-(void)loadNew{
    [self.commendTableView.mj_footer endRefreshing];
    self.current_page = 1;
    FBRequest *request = [FBAPI getWithUrlString:[NSString stringWithFormat:@"/stuffs/%@/comments",self.model.idFeild] requestDictionary:@{@"page" : @(self.current_page) , @"per_page" : @(20)} delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *dataAry = result[@"data"];
        self.commentAry = [FSCommentModel mj_objectArrayWithKeyValuesArray:dataAry];
        [self.commendTableView reloadData];
        self.current_page = [result[@"meta"][@"pagination"][@"current_page"] integerValue];
        self.total_rows = [result[@"meta"][@"pagination"][@"total"] integerValue];
        [self checkFooterState];
        [self.commendTableView.mj_header endRefreshing];
    } failure:^(FBRequest *request, NSError *error) {
        [self.commendTableView.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"The request failed", nil)];
    }];
}

-(void)loadMore{
    [self.commendTableView.mj_header endRefreshing];
    FBRequest *request = [FBAPI getWithUrlString:[NSString stringWithFormat:@"/stuffs/%@/comments",self.model.idFeild]  requestDictionary:@{@"page" : @(++ self.current_page) , @"per_page" : @(20)} delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *dataAry = result[@"data"];
        NSArray *ary = [FSCommentModel mj_objectArrayWithKeyValuesArray:dataAry];
        [self.commentAry addObjectsFromArray:ary];
        [self.commendTableView reloadData];
        self.current_page = [result[@"meta"][@"pagination"][@"current_page"] integerValue];
        self.total_rows = [result[@"meta"][@"pagination"][@"total"] integerValue];
        [self checkFooterState];
        [self.commendTableView.mj_footer endRefreshing];
    } failure:^(FBRequest *request, NSError *error) {
        [self.commendTableView.mj_footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"The request failed", nil)];
    }];
}

-(void)checkFooterState{
    if (self.commentAry.count == self.total_rows) {
        self.commendTableView.mj_footer.hidden = YES;
    }else{
        [self.commendTableView.mj_footer endRefreshing];
    }
}

-(void)setupHeader{
    // 添加cell
    _cell = [FSHomeViewCell viewFromXib];
    _cell.fSHomeViewDelegate = self;
    _cell.bottom_line_view.hidden = YES;
    _cell.navi = self.navigationController;
    _cell.myViewController = self;
    _cell.contentLabel_height.constant = 10000;
    [_cell.moreBtn addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
    [_cell.likeBtn addTarget:self action:@selector(lickClick:) forControlEvents:UIControlEventTouchUpInside];
    [_cell.commendBtn addTarget:self action:@selector(commentClick:) forControlEvents:UIControlEventTouchUpInside];
    [_cell.pictuerView.tapBTn addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
    [_cell.fucosBtn addTarget:self action:@selector(fucosClick:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat gaoDu = 0;
    if (self.stuffId.length == 0) {
        _cell.model = self.model;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *path = [paths objectAtIndex:0];
        NSString *filename = [path stringByAppendingPathComponent:@"tag.plist"];
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm createFileAtPath:filename contents:nil attributes:nil];
        CTFrameParserConfig *config = [[CTFrameParserConfig alloc] init];
        [self.tagMAry removeAllObjects];
        if (self.model.tags.count > 0) {
            for (int i = 0; i < self.model.tags.count; i ++) {
                NSDictionary *dict = self.model.tags[i];
                NSDictionary *cellDict = @{
                                           @"color" : @"blue",
                                           @"content" : [NSString stringWithFormat:@" %@",dict[@"name"]],
                                           @"url" : @"hh",
                                           @"type" : @"link"
                                           };
                [self.tagMAry addObject:cellDict];
            }
            config.width = SCREEN_WIDTH;
            [self.tagMAry writeToFile:filename atomically:YES];
            
            CGFloat textH = [self.model.content getSpaceLabelHeightWithSpeace:5 withFont:[UIFont systemFontOfSize:14] withWidth:(SCREEN_WIDTH - 30)];
            if (SCREEN_HEIGHT == 568.0) {
                gaoDu = (textH + 375 - 40);
            } else if (SCREEN_HEIGHT == 667.0) {
                gaoDu = (textH + 375 - 12);
            } else {
                gaoDu = (textH + 375 + 12);
            }
        } else {
            CGFloat textH = [self.model.content getSpaceLabelHeightWithSpeace:5 withFont:[UIFont systemFontOfSize:14] withWidth:(SCREEN_WIDTH - 30)];
            if (SCREEN_HEIGHT == 568.0) {
                gaoDu = (textH + 347 - 38);
            } else if (SCREEN_HEIGHT == 667.0) {
                gaoDu = (textH + 347 - 15);
            } else {
                if (self.model.content.length <= 96) {
                    gaoDu = (textH + 347 + 4);
                } else {
                    gaoDu = (textH + 347 + 10);
                }
            }
        }
        CoreTextData *data = [CTFrameParser parseTemplateFile:filename config:config];
        _cell.ctData = data;
        NSAttributedString  *setString = [self.model.content stringWithParagraphlineSpeace:5 textColor:[UIColor colorWithHexString:@"#222222"] textFont:[UIFont systemFontOfSize:14]];
        _cell.contentString = setString;
        _cell.hideFlag = 1;
        _cell.frame = CGRectMake(0, 0, SCREEN_WIDTH, gaoDu);
        _cell.bottomViewHegiht = 0;
        [_cell.contentView layoutIfNeeded];
        
        
        // 创建header
        UIView *header = [[UIView alloc] init];
        header.height = gaoDu;
        header.width = SCREEN_WIDTH;
        header.backgroundColor = [UIColor whiteColor];
        
        [header addSubview:_cell];
        
        // 设置header
        self.commendTableView.tableHeaderView = header;
    } else {
        FBRequest *request = [FBAPI getWithUrlString:[NSString stringWithFormat:@"/stuffs/%@", self.stuffId] requestDictionary:nil delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            NSDictionary *dataDict = result[@"data"];
            self.model = [FSZuoPin mj_objectWithKeyValues:dataDict];
            _cell.model = self.model;
            CGFloat gaoDu = 0;
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            NSString *path = [paths objectAtIndex:0];
            NSString *filename = [path stringByAppendingPathComponent:@"tag.plist"];
            NSFileManager *fm = [NSFileManager defaultManager];
            [fm createFileAtPath:filename contents:nil attributes:nil];
            CTFrameParserConfig *config = [[CTFrameParserConfig alloc] init];
            [self.tagMAry removeAllObjects];
            if (self.model.tags.count > 0) {
                for (int i = 0; i < self.model.tags.count; i ++) {
                    NSDictionary *dict = self.model.tags[i];
                    NSDictionary *cellDict = @{
                                               @"color" : @"blue",
                                               @"content" : [NSString stringWithFormat:@" %@",dict[@"name"]],
                                               @"url" : @"hh",
                                               @"type" : @"link"
                                               };
                    [self.tagMAry addObject:cellDict];
                }
                config.width = SCREEN_WIDTH;
                [self.tagMAry writeToFile:filename atomically:YES];
                
                CGFloat textH = [self.model.content getSpaceLabelHeightWithSpeace:5 withFont:[UIFont systemFontOfSize:14] withWidth:(SCREEN_WIDTH - 30)];
                if (SCREEN_HEIGHT == 568.0) {
                    gaoDu = (textH + 375 - 40);
                } else if (SCREEN_HEIGHT == 667.0) {
                    gaoDu = (textH + 375 - 12);
                } else {
                    gaoDu = (textH + 375 + 12);
                }
            } else {
                CGFloat textH = [self.model.content getSpaceLabelHeightWithSpeace:5 withFont:[UIFont systemFontOfSize:14] withWidth:(SCREEN_WIDTH - 30)];
                if (SCREEN_HEIGHT == 568.0) {
                    gaoDu = (textH + 347 - 38);
                } else if (SCREEN_HEIGHT == 667.0) {
                    gaoDu = (textH + 347 - 15);
                } else {
                    if (self.model.content.length <= 96) {
                        gaoDu = (textH + 347 + 4);
                    } else {
                        gaoDu = (textH + 347 + 10);
                    }
                }
            }
            CoreTextData *data = [CTFrameParser parseTemplateFile:filename config:config];
            _cell.ctData = data;
            NSAttributedString  *setString = [self.model.content stringWithParagraphlineSpeace:5 textColor:[UIColor colorWithHexString:@"#222222"] textFont:[UIFont systemFontOfSize:14]];
            _cell.contentString = setString;
            _cell.hideFlag = 1;
            _cell.frame = CGRectMake(0, 0, SCREEN_WIDTH, gaoDu);
            _cell.bottomViewHegiht = 0;
            [_cell.contentView layoutIfNeeded];
            
            
            // 创建header
            UIView *header = [[UIView alloc] init];
            header.height = gaoDu;
            header.width = SCREEN_WIDTH;
            header.backgroundColor = [UIColor whiteColor];
            
            [header addSubview:_cell];
            
            // 设置header
            self.commendTableView.tableHeaderView = header;
        } failure:^(FBRequest *request, NSError *error) {
            
        }];
    }
}

#pragma mark - 关注
-(void)fucosClick:(UIButton*)sender{
    if ([self isLoginAndPresentLoginVc]) {
        if (sender.selected) {
            //取消关注
            FBRequest *request = [FBAPI deleteWithUrlString:[NSString stringWithFormat:@"/user/%@/cancelFollow",self.model.user_id] requestDictionary:nil delegate:self];
            [request startRequestSuccess:^(FBRequest *request, id result) {
                self.model.is_follow = 0;
                sender.layer.borderColor = [UIColor colorWithHexString:@"#7F8FA2"].CGColor;
                sender.selected = NO;
                if ([self.homeDetailDelegate respondsToSelector:@selector(fucosDelegateClick:andId:)]) {
                    [self.homeDetailDelegate fucosDelegateClick:NO andId:self.model.idFeild];
                }
            } failure:^(FBRequest *request, NSError *error) {
                
            }];
        } else {
            //关注
            FBRequest *request = [FBAPI postWithUrlString:[NSString stringWithFormat:@"/user/%@/follow",self.model.user_id] requestDictionary:nil delegate:self];
            [request startRequestSuccess:^(FBRequest *request, id result) {
                self.model.is_follow = 1;
                sender.layer.borderColor = [UIColor colorWithHexString:@"#2288FF"].CGColor;
                sender.selected = YES;
                if ([self.homeDetailDelegate respondsToSelector:@selector(fucosDelegateClick:andId:)]) {
                    [self.homeDetailDelegate fucosDelegateClick:YES andId:self.model.idFeild];
                }
            } failure:^(FBRequest *request, NSError *error) {
                
            }];
        }
    }
}

#pragma mark - 视频播放
-(void)videoClick:(UIButton*)sender{
    //开始播放视频
    FSZuoPin *model = self.model;
    FSPlayViewController *mvPlayer = [[FSPlayViewController alloc] init];
    mvPlayer.videoUrl = [NSURL URLWithString:model.srcfile];
    [self presentViewController:mvPlayer animated:YES completion:nil];
}

#pragma mark - 点击图片
-(void)imageClick:(UIButton*)sender{
    FSBigImageViewController *vc = [[FSBigImageViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    FSZuoPin *model = self.model;
    vc.imageUrl = model.srcfile;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - 更多按钮
-(void)moreClick:(UIButton*)sender{
    FSReportViewController *vc = [[FSReportViewController alloc] init];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:^{
        [UIView animateWithDuration:0.25 animations:^{
            vc.firstViewBottomSapce.constant = 0;
            [vc.view layoutIfNeeded];
        } completion:nil];
    }];
}


#pragma mark - 评论按钮
-(void)commentClick :(UIButton *)sender{
    [self.textTF becomeFirstResponder];
    self.textTF.placeholder = NSLocalizedString(@"Comment on", nil);
}

#pragma mark - 点赞按钮
-(void)lickClick:(UIButton *)sender{
    NSString *idStr = self.model.idFeild;
    if (sender.selected) {
        if ([self.homeDetailDelegate respondsToSelector:@selector(lickClick::andlikeCount:)]) {
            [self.homeDetailDelegate lickClick:NO :idStr andlikeCount:[_cell.like_count_label.text integerValue] - 1];
        }
    } else {
        if ([self.homeDetailDelegate respondsToSelector:@selector(lickClick::andlikeCount:)]) {
            [self.homeDetailDelegate lickClick:YES :idStr andlikeCount:[_cell.like_count_label.text integerValue] + 1];
        }
    }
}

- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    // 键盘显示\隐藏完毕的frame
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 修改底部约束
    self.bottomSpace.constant = SCREEN_HEIGHT - frame.origin.y;
    if (frame.origin.y == SCREEN_HEIGHT) {
        self.textTF.placeholder = NSLocalizedString(@"Comment on", nil);
    }
    // 动画时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 动画
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - <UITableViewDelegate>
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentAry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FSCommendTableViewCell *onecell = [tableView dequeueReusableCellWithIdentifier:FSCommentId];
    onecell.model = self.commentAry[indexPath.row];
    return onecell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    FSCommentModel *model = self.commentAry[indexPath.row];
    return model.cellHeghit;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.textTF becomeFirstResponder];
    FSCommentModel *model = self.commentAry[indexPath.row];
    self.textTF.placeholder = [NSString stringWithFormat:@"%@：%@",NSLocalizedString(@"reply", nil) ,model.username];
    self.sendBtn.tag = [model.userId integerValue];
}

#pragma mark - 发送按钮
- (IBAction)SendMessageClick:(UIButton *)sender {
    if ([self isLoginAndPresentLoginVc]) {
        if (self.textTF.text.length == 0) {
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"Comment is empty", nil)];
            return;
        }
        
        if ([self.textTF.placeholder isEqualToString:NSLocalizedString(@"Comment on", nil)]) {
            //评论
            FBRequest *request = [FBAPI postWithUrlString:[NSString stringWithFormat:@"/stuffs/%@/postComment",self.model.idFeild] requestDictionary:@{@"content" : self.textTF.text} delegate:self];
            [request startRequestSuccess:^(FBRequest *request, id result) {
                self.textTF.text = @"";
                [self.textTF resignFirstResponder];
                [self.commendTableView.mj_header beginRefreshing];
            } failure:^(FBRequest *request, NSError *error) {
                
            }];
        } else {
            //回复某人
            FSUserModel *userModel = [[FSUserModel findAll] lastObject];
            FBRequest *request = [FBAPI postWithUrlString:[NSString stringWithFormat:@"/stuffs/%@/postComment",self.model.idFeild] requestDictionary:@{@"content" : self.textTF.text , @"reply_user_id" : [NSString stringWithFormat:@"%ld",sender.tag] , @"parent_id" : userModel.userId} delegate:self];
            [request startRequestSuccess:^(FBRequest *request, id result) {
                self.textTF.text = @"";
                [self.textTF resignFirstResponder];
                [self.commendTableView.mj_header beginRefreshing];
            } failure:^(FBRequest *request, NSError *error) {
                
            }];
        }
    }
}

-(void)homeTableViewCell:(FSHomeViewCell *)cell didClickVideoWithVideoUrl:(NSString *)videoUrl videoCover:(FSHomeVideoView *)baseImageView{
    self.indexPath = [self.commendTableView indexPathForCell:cell];
    self.imageView = baseImageView;
    
    wmPlayer = [[WMPlayer alloc]initWithFrame:baseImageView.bounds];
    wmPlayer.delegate = self;
    wmPlayer.closeBtnStyle = CloseBtnStylePop;
    wmPlayer.URLString = videoUrl;
    [baseImageView addSubview:wmPlayer];
    [wmPlayer play];
}

#pragma mark - WMPlayerDelegate
- (BOOL)prefersStatusBarHidden {
    if (wmPlayer) {
        if (wmPlayer.isFullscreen) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

- (void)toCell {
    [wmPlayer removeFromSuperview];
    [UIView animateWithDuration:0.5f animations:^{
        wmPlayer.transform = CGAffineTransformIdentity;
        wmPlayer.frame = self.imageView.bounds;
        wmPlayer.playerLayer.frame =  wmPlayer.bounds;
        [self.imageView addSubview:wmPlayer];
        [self.imageView bringSubviewToFront:wmPlayer];
        [wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(0);
            make.right.equalTo(wmPlayer).with.offset(0);
            make.height.mas_equalTo(40);
            make.bottom.equalTo(wmPlayer).with.offset(0);
        }];
        [wmPlayer.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(0);
            make.right.equalTo(wmPlayer).with.offset(0);
            make.height.mas_equalTo(40);
            make.top.equalTo(wmPlayer).with.offset(0);
        }];
        [wmPlayer.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer.topView).with.offset(45);
            make.right.equalTo(wmPlayer.topView).with.offset(-45);
            make.center.equalTo(wmPlayer.topView);
            make.top.equalTo(wmPlayer.topView).with.offset(0);
        }];
        [wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(5);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
            make.top.equalTo(wmPlayer).with.offset(5);
        }];
        [wmPlayer.loadFailedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(wmPlayer);
            make.width.equalTo(wmPlayer);
            make.height.equalTo(@30);
        }];
    }completion:^(BOOL finished) {
        wmPlayer.isFullscreen = NO;
        [self setNeedsStatusBarAppearanceUpdate];
        self.isSmallScreen = NO;
        wmPlayer.fullScreenBtn.selected = NO;
        
    }];
    
    
}

- (void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation )interfaceOrientation {
    [wmPlayer removeFromSuperview];
    wmPlayer.transform = CGAffineTransformIdentity;
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft) {
        wmPlayer.transform = CGAffineTransformMakeRotation(-M_PI_2);
    } else if(interfaceOrientation==UIInterfaceOrientationLandscapeRight){
        wmPlayer.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    wmPlayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    wmPlayer.playerLayer.frame =  CGRectMake(0,0, SCREEN_HEIGHT,SCREEN_WIDTH);
    
    [wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(SCREEN_WIDTH-40);
        make.width.mas_equalTo(SCREEN_HEIGHT);
    }];
    
    [wmPlayer.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.left.equalTo(wmPlayer).with.offset(0);
        make.width.mas_equalTo(SCREEN_HEIGHT);
    }];
    
    [wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wmPlayer).with.offset((-SCREEN_HEIGHT/2));
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
        make.top.equalTo(wmPlayer).with.offset(5);
        
    }];
    
    [wmPlayer.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wmPlayer.topView).with.offset(45);
        make.right.equalTo(wmPlayer.topView).with.offset(-45);
        make.center.equalTo(wmPlayer.topView);
        make.top.equalTo(wmPlayer.topView).with.offset(0);
    }];
    
    [wmPlayer.loadFailedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_HEIGHT);
        make.center.mas_equalTo(CGPointMake(SCREEN_WIDTH/2-36, -(SCREEN_WIDTH/2)));
        make.height.equalTo(@30);
    }];
    
    [wmPlayer.loadingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(CGPointMake(SCREEN_WIDTH/2-37, -(SCREEN_WIDTH/2-37)));
    }];
    [wmPlayer.loadFailedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_HEIGHT);
        make.center.mas_equalTo(CGPointMake(SCREEN_WIDTH/2-36, -(SCREEN_HEIGHT/2)+36));
        make.height.equalTo(@30);
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:wmPlayer];
    
    wmPlayer.fullScreenBtn.selected = YES;
    [wmPlayer bringSubviewToFront:wmPlayer.bottomView];
    
}

- (void)toSmallScreen {
    // 放widow上
    [wmPlayer removeFromSuperview];
    [UIView animateWithDuration:0.3f animations:^{
        wmPlayer.transform = CGAffineTransformIdentity;
        wmPlayer.frame = CGRectMake(SCREEN_WIDTH/2,SCREEN_HEIGHT-kTabBarHeight-(SCREEN_WIDTH/2)*0.75, SCREEN_WIDTH/2, (SCREEN_WIDTH/2)*0.75);
        wmPlayer.playerLayer.frame = wmPlayer.bounds;
        [[UIApplication sharedApplication].keyWindow addSubview:wmPlayer];
        [wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(0);
            make.right.equalTo(wmPlayer).with.offset(0);
            make.height.mas_equalTo(40);
            make.bottom.equalTo(wmPlayer).with.offset(0);
        }];
        [wmPlayer.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(0);
            make.right.equalTo(wmPlayer).with.offset(0);
            make.height.mas_equalTo(40);
            make.top.equalTo(wmPlayer).with.offset(0);
        }];
        [wmPlayer.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer.topView).with.offset(45);
            make.right.equalTo(wmPlayer.topView).with.offset(-45);
            make.center.equalTo(wmPlayer.topView);
            make.top.equalTo(wmPlayer.topView).with.offset(0);
        }];
        [wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(5);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
            make.top.equalTo(wmPlayer).with.offset(5);
            
        }];
        [wmPlayer.loadFailedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(wmPlayer);
            make.width.equalTo(wmPlayer);
            make.height.equalTo(@30);
        }];
        
    } completion:^(BOOL finished) {
        wmPlayer.isFullscreen = NO;
        [self setNeedsStatusBarAppearanceUpdate];
        wmPlayer.fullScreenBtn.selected = NO;
        self.isSmallScreen = YES;
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:wmPlayer];
    }];
}

- (void)wmplayer:(WMPlayer *)wmplayer clickedCloseButton:(UIButton *)closeBtn {
    if (wmplayer.isFullscreen) {
        wmplayer.isFullscreen = NO;
        [UIApplication sharedApplication].statusBarHidden = NO;
        [self toCell];
    } else {
        [self releaseWMPlayer];
    }
    
}

- (void)wmplayer:(WMPlayer *)wmplayer clickedFullScreenButton:(UIButton *)fullScreenBtn {
    if (fullScreenBtn.isSelected) {//全屏显示
        wmPlayer.isFullscreen = YES;
        [self setNeedsStatusBarAppearanceUpdate];
        [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeRight];
        [UIApplication sharedApplication].statusBarHidden = YES;
    } else {
        [UIApplication sharedApplication].statusBarHidden = NO;
        if (self.isSmallScreen) {
            // 放widow上,小屏显示
            [self toSmallScreen];
        } else {
            [self toCell];
        }
    }
}

- (void)wmplayer:(WMPlayer *)wmplayer singleTaped:(UITapGestureRecognizer *)singleTap{
    NSLog(@"didSingleTaped");
}

- (void)wmplayer:(WMPlayer *)wmplayer doubleTaped:(UITapGestureRecognizer *)doubleTap{
    NSLog(@"didDoubleTaped");
}

- (void)wmplayerFailedPlay:(WMPlayer *)wmplayer WMPlayerStatus:(WMPlayerState)state {
    NSLog(@"wmplayerDidFailedPlay");
}

- (void)wmplayerReadyToPlay:(WMPlayer *)wmplayer WMPlayerStatus:(WMPlayerState)state {
    NSLog(@"wmplayerDidReadyToPlay");
}

- (void)wmplayerFinishedPlay:(WMPlayer *)wmplayer {
    [self releaseWMPlayer];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)releaseWMPlayer {
    [wmPlayer pause];
    [wmPlayer removeFromSuperview];
    [wmPlayer.playerLayer removeFromSuperlayer];
    [wmPlayer.player replaceCurrentItemWithPlayerItem:nil];
    wmPlayer.player = nil;
    wmPlayer.currentItem = nil;
    //释放定时器，否侧不会调用WMPlayer中的dealloc方法
    [wmPlayer.autoDismissTimer invalidate];
    wmPlayer.autoDismissTimer = nil;
    wmPlayer.playOrPauseBtn = nil;
    wmPlayer.playerLayer = nil;
    wmPlayer = nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (wmPlayer.superview) {
        CGRect rectInTableView = [self.commendTableView rectForRowAtIndexPath:self.indexPath];
        CGRect rectInSuperview = [self.commendTableView convertRect:rectInTableView toView:[self.commendTableView superview]];
        if (rectInSuperview.origin.y < -self.imageView.frame.size.height || rectInSuperview.origin.y>SCREEN_HEIGHT-kTopBarHeight-kTabBarHeight) {//往上拖动
            
            if ([[UIApplication sharedApplication].keyWindow.subviews containsObject:wmPlayer]&&self.isSmallScreen) {
                self.isSmallScreen = YES;
            } else {
                [self releaseWMPlayer];
            }
        } else {
            if ([self.imageView.subviews containsObject:wmPlayer]) {
                
            } else {
                [self releaseWMPlayer];
            }
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self releaseWMPlayer];
}


@end
