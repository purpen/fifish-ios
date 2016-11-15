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

@interface FSHomeDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

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
    FSHomeViewCell *cell = [FSHomeViewCell viewFromXib];
    cell.bottom_line_view.hidden = YES;
    cell.navi = self.navigationController;
    cell.myViewController = self;
    cell.contentLabel_height.constant = 10000;
    [cell.moreBtn addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.likeBtn addTarget:self action:@selector(lickClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.commendBtn addTarget:self action:@selector(commentClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.pictuerView.tapBTn addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.videoView.tapBtn addTarget:self action:@selector(videoClick:) forControlEvents:UIControlEventTouchUpInside];
    if (self.stuffId.length == 0) {
        cell.model = self.model;
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
        } else {
        }
        CoreTextData *data = [CTFrameParser parseTemplateFile:filename config:config];
        cell.ctData = data;
        // 文字的最大尺寸
        CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width , MAXFLOAT);
        // 计算文字的高度
        CGFloat textH = [self.model.content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size.height;
        CGFloat gaoDu = textH + 374;
        
        cell.frame = CGRectMake(0, 0, SCREEN_WIDTH, gaoDu);
        cell.bottomViewHegiht = 0;
        [cell.contentView layoutIfNeeded];
        
        
        // 创建header
        UIView *header = [[UIView alloc] init];
        header.height = gaoDu;
        header.width = SCREEN_WIDTH;
        header.backgroundColor = [UIColor whiteColor];
        
        [header addSubview:cell];
        
        // 设置header
        self.commendTableView.tableHeaderView = header;
    } else {
        FBRequest *request = [FBAPI getWithUrlString:[NSString stringWithFormat:@"/stuffs/%@", self.stuffId] requestDictionary:nil delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            NSDictionary *dataDict = result[@"data"];
            self.model = [FSZuoPin mj_objectWithKeyValues:dataDict];
            cell.model = self.model;
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
            } else {
            }
            CoreTextData *data = [CTFrameParser parseTemplateFile:filename config:config];
            cell.ctData = data;
            // 文字的最大尺寸
            CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width , MAXFLOAT);
            // 计算文字的高度
            CGFloat textH = [self.model.content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size.height;
            CGFloat gaoDu = (textH + 374) / 667.0 * SCREEN_HEIGHT;
            
            cell.frame = CGRectMake(0, 0, SCREEN_WIDTH, gaoDu);
            cell.bottomViewHegiht = 0;
            [cell.contentView layoutIfNeeded];
            
            
            // 创建header
            UIView *header = [[UIView alloc] init];
            header.height = gaoDu;
            header.width = SCREEN_WIDTH;
            header.backgroundColor = [UIColor whiteColor];
            
            [header addSubview:cell];
            
            // 设置header
            self.commendTableView.tableHeaderView = header;
        } failure:^(FBRequest *request, NSError *error) {
            
        }];
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
        FBRequest *request = [FBAPI postWithUrlString:[NSString stringWithFormat:@"/stuffs/%@/cancelike",idStr] requestDictionary:nil delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            sender.selected = NO;
            if ([self.homeDetailDelegate respondsToSelector:@selector(lickClick::)]) {
                [self.homeDetailDelegate lickClick:sender.selected :idStr];
            }
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"操作失败"];
        }];
    } else {
        FBRequest *request = [FBAPI postWithUrlString:[NSString stringWithFormat:@"/stuffs/%@/dolike",idStr] requestDictionary:nil delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            sender.selected = YES;
            if ([self.homeDetailDelegate respondsToSelector:@selector(lickClick::)]) {
                [self.homeDetailDelegate lickClick:sender.selected :idStr];
            }
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"操作失败"];
        }];
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
    FSCommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FSCommentId];
    cell.model = self.commentAry[indexPath.row];
    return cell;
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

@end
