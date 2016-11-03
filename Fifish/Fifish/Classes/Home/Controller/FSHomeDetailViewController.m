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

@end

static NSString * const FSCommentId = @"comment";

@implementation FSHomeDetailViewController

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
    // 文字的最大尺寸
    CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width , MAXFLOAT);
    // 计算文字的高度
    CGFloat textH = [self.model.content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size.height;
    CGFloat gaoDu = textH + 368;
    
    // 创建header
    UIView *header = [[UIView alloc] init];
    header.height = gaoDu;
    header.width = SCREEN_WIDTH;
    header.backgroundColor = [UIColor whiteColor];
    
    // 添加cell
    FSHomeViewCell *cell = [FSHomeViewCell viewFromXib];
    cell.navi = self.navigationController;
    cell.contentLabel_height.constant = 10000;
    [cell.moreBtn addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.likeBtn addTarget:self action:@selector(lickClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.commendBtn addTarget:self action:@selector(commentClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.pictuerView.tapBTn addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.videoView.tapBtn addTarget:self action:@selector(videoClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.model = self.model;
    cell.frame = CGRectMake(0, 0, SCREEN_WIDTH, gaoDu);
    cell.bottomViewHegiht = 0;
    [cell.contentView layoutIfNeeded];
    [header addSubview:cell];
    
    // 设置header
    self.commendTableView.tableHeaderView = header;
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
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *reportAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"report", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击举报
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        
        UIAlertController *reportAlertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *garbageAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"garbage content", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //垃圾内容的网络请求
            
        }];
        UIAlertAction *indecentAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"inelegant content", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //内容不雅举报
            
        }];
        UIAlertAction *reportCancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [reportAlertC addAction:garbageAction];
        [reportAlertC addAction:indecentAction];
        [reportAlertC addAction:reportCancelAction];
        [self presentViewController:reportAlertC animated:YES completion:nil];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertC addAction:reportAction];
    [alertC addAction:cancelAction];
    [self presentViewController:alertC animated:YES completion:nil];
}


#pragma mark - 评论按钮
-(void)commentClick :(UIButton *)sender{
    [self.textTF becomeFirstResponder];
    self.textTF.placeholder = @"评论一下";
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
        self.textTF.placeholder = @"评论一下";
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
    self.textTF.placeholder = [NSString stringWithFormat:@"回复：%@",model.username];
    self.sendBtn.tag = [model.userId integerValue];
}

#pragma mark - 发送按钮
- (IBAction)SendMessageClick:(UIButton *)sender {
    if ([self isLoginAndPresentLoginVc]) {
        if (self.textTF.text.length == 0) {
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"Comment is empty", nil)];
            return;
        }
        
        if ([self.textTF.placeholder isEqualToString:@"评论一下"]) {
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
