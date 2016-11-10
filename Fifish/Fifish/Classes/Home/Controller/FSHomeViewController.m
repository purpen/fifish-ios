//
//  FSHomeViewController.m
//  Fifish
//
//  Created by THN-Dong on 16/7/25.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSHomeViewController.h"
#import "UIBarButtonItem+FSExtension.h"
#import "FSConst.h"
#import "FSHomeViewCell.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "FSHomeDetailViewController.h"
#import "FBRequest.h"
#import "FBAPI.h"
#import "SVProgressHUD.h"
#import "FSZuoPin.h"
#import "FSSearchViewController.h"
#import "FSBigImageViewController.h"
#import "FSReleasePictureViewController.h"
#import "FSNavigationViewController.h"
#import "FSPlayViewController.h"
#import "FSReleasePictureViewController.h"
#import "FSProgressView.h"
#import "Masonry.h"
#import "FSUserModel.h"
#import "FSLoginViewController.h"
#import "FSTagSearchViewController.h"
#import "FSFileManager.h"
#import "FSMediaBrowseViewController.h"
#import "FSMcBaseNavViewController.h"

@interface FSHomeViewController ()<UITableViewDelegate,UITableViewDataSource,FSHomeDetailViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

/**  */
@property(nonatomic,assign) NSInteger current_page;
/**  */
@property(nonatomic,assign) NSInteger total_rows;
/**  */
@property (nonatomic, strong) UITableView *contenTableView;
/**  */
@property (nonatomic, strong) NSMutableArray *modelAry;
/**  */
@property (nonatomic, strong) FSProgressView *progressView;
/**  */
@property (nonatomic, strong) NSNotification *notification;
/**  */
@property (nonatomic, assign) BOOL repeatFlag;

@end

static NSString * const CellId = @"home";

@implementation FSHomeViewController

-(FSProgressView *)progressView{
    if (!_progressView) {
        _progressView = [FSProgressView viewFromXib];
    }
    return _progressView;
}

-(NSMutableArray *)modelAry{
    if (!_modelAry) {
        _modelAry = [NSMutableArray array];
    }
    return _modelAry;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self.view addSubview:self.contenTableView];
    [self.contenTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FSHomeViewCell class]) bundle:nil] forCellReuseIdentifier:CellId];
    // 添加刷新控件
    [self setupRefresh];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadVideo:) name:@"progress" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadPictuer:) name:@"pictuer" object:nil];
    [self.view addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.height.mas_equalTo(44);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.bottom.mas_equalTo(self.contenTableView.mas_top).offset(0);
    }];
}

-(void)uploadPictuer:(NSNotification*)not{
    NSDictionary *dict = not.userInfo;
    FSImageModel *model = dict[@"model"];
    FBRequest *request = [FBAPI getWithUrlString:@"/upload/photoToken" requestDictionary:nil delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSString *upload_url = result[@"data"][@"upload_url"];
        NSString *token = result[@"data"][@"token"];
        if (self.repeatFlag) {
            
        } else {
            [UIView animateWithDuration:0.25 animations:^{
                self.contenTableView.y += 44;
                [self.view layoutIfNeeded];
            }];
        }
        self.progressView.imageView.image = model.defaultImage;
        self.progressView.repeatBtn.hidden = YES;
        self.progressView.deleteBtn.hidden = YES;
        self.progressView.stateLabel.text = NSLocalizedString(@"uploading", nil);
        [FBAPI uploadFileWithURL:upload_url WithToken:token WithFileUrl:nil WithFileData:dict[@"iconData"] WihtProgressBlock:^(CGFloat progress) {
            self.progressView.progress.progress = progress;
        } WithSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *stuffId = responseObject[@"id"];
            FBRequest *request = [FBAPI postWithUrlString:@"/stuffs/store" requestDictionary:@{
                                                                                               @"content" : dict[@"content"],
                                                                                               @"asset_id" : stuffId,
                                                                                               @"address" :dict[@"address"],
                                                                                               @"kind" : dict[@"kind"],
                                                                                               @"tags" : dict[@"tags"],
                                                                                               @"lat" : dict[@"lat"],
                                                                                               @"lng" : dict[@"lng"]
                                                                                               } delegate:self];
            [request startRequestSuccess:^(FBRequest *request, id result) {
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Release success", nil)];
                [UIView animateWithDuration:0.25 animations:^{
                    self.contenTableView.y -= 44;
                    [self.view layoutIfNeeded];
                }];
                [self.contenTableView.mj_header beginRefreshing];
            } failure:^(FBRequest *request, NSError *error) {
            }];
        } WithFailureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            self.progressView.repeatBtn.hidden = NO;
            self.progressView.deleteBtn.hidden = NO;
            [self.progressView.repeatBtn addTarget:self action:@selector(repeat2) forControlEvents:UIControlEventTouchUpInside];
            [self.progressView.deleteBtn addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
            self.progressView.stateLabel.text = NSLocalizedString(@"Upload failed", nil);
        }];
        
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
}

-(void)uploadVideo:(NSNotification*)not{
    self.notification = not;
    NSDictionary *dict = not.userInfo;
    FSVideoModel *model = dict[@"model"];
    FBRequest *request = [FBAPI getWithUrlString:@"/upload/videoToken" requestDictionary:nil delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSString *upload_url = result[@"data"][@"upload_url"];
        NSString *token = result[@"data"][@"token"];
        if (self.repeatFlag) {
            
        } else {
            [UIView animateWithDuration:0.25 animations:^{
                self.contenTableView.y += 44;
                [self.view layoutIfNeeded];
            }];
        }
        self.progressView.imageView.image = model.VideoPicture;
        self.progressView.repeatBtn.hidden = YES;
        self.progressView.deleteBtn.hidden = YES;
        self.progressView.stateLabel.text = NSLocalizedString(@"uploading", nil);
        [FBAPI uploadFileWithURL:upload_url WithToken:token WithFileUrl:[NSURL fileURLWithPath:model.fileUrl] WithFileData:nil WihtProgressBlock:^(CGFloat progress) {
            self.progressView.progress.progress = progress;
        } WithSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *stuffId = responseObject[@"id"];
            FBRequest *request = [FBAPI postWithUrlString:@"/stuffs/store" requestDictionary:@{
                                                                                               @"content" : dict[@"content"],
                                                                                               @"asset_id" : stuffId,
                                                                                               @"address" :dict[@"address"],
                                                                                               @"kind" : dict[@"kind"],
                                                                                               @"tags" : dict[@"tags"],
                                                                                               @"lat" : dict[@"lat"],
                                                                                               @"lng" : dict[@"lng"]
                                                                                               } delegate:self];
            [request startRequestSuccess:^(FBRequest *request, id result) {
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Upload failed", nil)];
                [UIView animateWithDuration:0.25 animations:^{
                    self.contenTableView.y -= 44;
                    [self.view layoutIfNeeded];
                }];
                [self.contenTableView.mj_header beginRefreshing];
            } failure:^(FBRequest *request, NSError *error) {
                
            }];
        } WithFailureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            self.progressView.repeatBtn.hidden = NO;
            self.progressView.deleteBtn.hidden = NO;
            [self.progressView.repeatBtn addTarget:self action:@selector(repeat) forControlEvents:UIControlEventTouchUpInside];
            [self.progressView.deleteBtn addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
            self.progressView.stateLabel.text = NSLocalizedString(@"Upload failed", nil);
        }];
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
}

#pragma mark - 删除
-(void)delete{
    [UIView animateWithDuration:0.25 animations:^{
        self.contenTableView.y -= 44;
        [self.view layoutIfNeeded];
    }];
}

-(void)repeat2{
    self.repeatFlag = YES;
    [self uploadPictuer:self.notification];
}

#pragma mark - 重新上传
-(void)repeat{
    self.repeatFlag = YES;
    [self uploadVideo:self.notification];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:@"progress"];
}

-(void)setupRefresh{
    self.contenTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNew)];
    // 自动改变透明度
    self.contenTableView.mj_header.automaticallyChangeAlpha = YES;
    [self.contenTableView.mj_header beginRefreshing];
    self.contenTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}

-(void)loadNew{
    [self.contenTableView.mj_footer endRefreshing];
    self.current_page = 1;
    NSDictionary *params = @{
                             @"page" : @(self.current_page),
                             @"per_page" : @10
                             };
    FBRequest *request = [FBAPI getWithUrlString:@"/stuffs" requestDictionary:params delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        self.current_page = [result[@"meta"][@"pagination"][@"current_page"] integerValue];
        self.total_rows = [result[@"meta"][@"pagination"][@"total"] integerValue];
        NSArray *rows = result[@"data"];
         self.modelAry = [FSZuoPin mj_objectArrayWithKeyValuesArray:rows];
         [self.contenTableView reloadData];
         [self.contenTableView.mj_header endRefreshing];
         [self checkFooterState];
    } failure:^(FBRequest *request, NSError *error) {
        // 提醒
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Loading user data failed", nil)];
        // 让底部控件结束刷新
        [self.contenTableView.mj_header endRefreshing];
    }];
}

-(void)checkFooterState{
    self.contenTableView.mj_footer.hidden = self.modelAry.count == 0;
    if (self.modelAry.count == self.total_rows) {
        self.contenTableView.mj_footer.hidden = YES;
    }else{
        [self.contenTableView.mj_footer endRefreshing];
    }
}

-(void)loadMore{
    [self.contenTableView.mj_header endRefreshing];
    NSDictionary *params = @{
                             @"page" : @(++ self.current_page),
                             @"per_page" : @10
                             };
    FBRequest *request = [FBAPI getWithUrlString:@"/stuffs" requestDictionary:params delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        self.current_page = [result[@"meta"][@"pagination"][@"current_page"] integerValue];
        self.total_rows = [result[@"meta"][@"pagination"][@"total"] integerValue];
        NSArray *rows = result[@"data"];
        NSArray *ary = [FSZuoPin mj_objectArrayWithKeyValuesArray:rows];
        [self.modelAry addObjectsFromArray:ary];
        [self.contenTableView reloadData];
        [self.contenTableView.mj_footer endRefreshing];
        [self checkFooterState];
    } failure:^(FBRequest *request, NSError *error) {
        // 提醒
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Loading user data failed", nil)];
        // 让底部控件结束刷新
        [self.contenTableView.mj_footer endRefreshing];
    }];

}

-(UITableView *)contenTableView{
    if (!_contenTableView) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _contenTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 50) style:UITableViewStyleGrouped];
        _contenTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _contenTableView.showsVerticalScrollIndicator = NO;
        _contenTableView.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
        _contenTableView.delegate = self;
        _contenTableView.dataSource = self;
        _contenTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _contenTableView;
}

-(void)setupNav{
    UIBarButtonItem *searchItem = [UIBarButtonItem itemWithImage:@"home_search" highImage:nil title:nil target:self action:@selector(searchClick)];
    self.navigationItem.leftBarButtonItem = searchItem;
    UIBarButtonItem *quick_releaseItem = [UIBarButtonItem itemWithImage:@"quick_release" highImage:nil title:nil target:self action:@selector(quickReleaseClick:)];
    self.navigationItem.rightBarButtonItem = quick_releaseItem;
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_logo"]];
    image.y -= 10;
    self.navigationItem.titleView = image;
}

#pragma mark - 快捷发布
-(void)quickReleaseClick:(UIButton*)sender{
    UIImagePickerController * pickerVc = [[UIImagePickerController alloc] init];
    pickerVc.delegate = self;
    pickerVc.allowsEditing = YES;
    pickerVc.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeVideo,(NSString *)kUTTypeImage];
    pickerVc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:pickerVc animated:YES completion:nil];
}

#pragma mark imagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //如果是图片
        UIImage * image  = info[UIImagePickerControllerEditedImage];
        //保存图片至本地
        NSString * imageurlStr = [[FSFileManager defaultManager] SaveImageWithImage:image];
        //添加到本地
        FSImageModel * imageModel = [[FSImageModel alloc] initWithFilePath:imageurlStr];
        NSMutableArray *ary = [NSMutableArray arrayWithObject:imageModel];
        [self dismissViewControllerAnimated:YES completion:nil];
        FSMediaBrowseViewController * fsmbvc = [[FSMediaBrowseViewController alloc] init];
        fsmbvc.modelArr = ary;
        FSMcBaseNavViewController * nav = [[FSMcBaseNavViewController alloc] initWithRootViewController:fsmbvc];
        [self presentViewController:nav animated:YES completion:nil];
    } else {
        //如果是视频
        NSURL *url = info[UIImagePickerControllerMediaURL];
        //保存视频至相册（异步线程
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[FSFileManager defaultManager] SaveVideoWithFilePath:url.path];
            FSVideoModel * model = [[FSVideoModel alloc] initWithFilePath:url.path];
            NSMutableArray *ary = [NSMutableArray arrayWithObject:model];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
                FSMediaBrowseViewController * fsmbvc = [[FSMediaBrowseViewController alloc] init];
                fsmbvc.modelArr = ary;
                FSMcBaseNavViewController * nav = [[FSMcBaseNavViewController alloc] initWithRootViewController:fsmbvc];
                [self presentViewController:nav animated:YES completion:nil];
            });
        });
    }
}


-(void)searchClick{
    FSSearchViewController *vc = [[FSSearchViewController alloc] init];
    FSNavigationViewController *navi = [[FSNavigationViewController alloc] initWithRootViewController:vc];
    [self presentViewController:navi animated:YES completion:nil];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.modelAry.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000001f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FSHomeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    cell.navi = self.navigationController;
    cell.myViewController = self;
    cell.model = self.modelAry[indexPath.section];
    cell.likeBtn.tag = indexPath.section;
    cell.commendBtn.tag = indexPath.section;
    [cell.likeBtn addTarget:self action:@selector(likeClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.commendBtn addTarget:self action:@selector(commendClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.moreBtn addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.pictuerView.tapBTn.tag = indexPath.section;
    [cell.pictuerView.tapBTn addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.videoView.tapBtn.tag = indexPath.section;
    [cell.videoView.tapBtn addTarget:self action:@selector(videoClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.fucosBtn.tag = indexPath.section;
    [cell.fucosBtn addTarget:self action:@selector(fucosClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark - 关注
-(void)fucosClick:(UIButton*)sender{
    if ([self isLoginAndPresentLoginVc]) {
        if (sender.selected) {
            //取消关注
            FSZuoPin *model = self.modelAry[sender.tag];
            FBRequest *request = [FBAPI deleteWithUrlString:[NSString stringWithFormat:@"/user/%@/cancelFollow",model.user_id] requestDictionary:nil delegate:self];
            [request startRequestSuccess:^(FBRequest *request, id result) {
                for (int i = 0; i < self.modelAry.count; i ++) {
                    FSZuoPin *cellModel = self.modelAry[i];
                    if ([cellModel.user_id isEqualToString:model.user_id]) {
                        cellModel.is_follow = 0;
                    }
                    [self.contenTableView reloadData];
                }
            } failure:^(FBRequest *request, NSError *error) {
                
            }];
        } else {
            //关注
            FSZuoPin *model = self.modelAry[sender.tag];
            FBRequest *request = [FBAPI postWithUrlString:[NSString stringWithFormat:@"/user/%@/follow",model.user_id] requestDictionary:nil delegate:self];
            [request startRequestSuccess:^(FBRequest *request, id result) {
                for (int i = 0; i < self.modelAry.count; i ++) {
                    FSZuoPin *cellModel = self.modelAry[i];
                    if ([cellModel.user_id isEqualToString:model.user_id]) {
                        cellModel.is_follow = 1;
                    }
                    [self.contenTableView reloadData];
                }
            } failure:^(FBRequest *request, NSError *error) {
                
            }];
        }
    }
}


#pragma mark - 视频播放
-(void)videoClick:(UIButton*)sender{
    //开始播放视频
    FSZuoPin *model = self.modelAry[sender.tag];
    FSPlayViewController *mvPlayer = [[FSPlayViewController alloc] init];
    mvPlayer.videoUrl = [NSURL URLWithString:model.srcfile];
    [self presentViewController:mvPlayer animated:YES completion:nil];
}

#pragma mark - 点击图片
-(void)imageClick:(UIButton*)sender{
    FSBigImageViewController *vc = [[FSBigImageViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    FSZuoPin *model = self.modelAry[sender.tag];
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
        UIAlertAction *reportCancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
-(void)commendClick: (UIButton *) sender{
    FSHomeDetailViewController *vc = [[FSHomeDetailViewController alloc] init];
    vc.model = self.modelAry[sender.tag];
    vc.title = NSLocalizedString(@"comments", nil);
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 点击喜欢按钮
-(void)likeClick:(UIButton*)sender{
    FSUserModel *model = [[FSUserModel findAll] lastObject];
    if (model.isLogin) {
        //登录了，可以进行后续操作
        NSString *idStr = ((FSZuoPin*)self.modelAry[sender.tag]).idFeild;
        if (sender.selected) {
            FBRequest *request = [FBAPI postWithUrlString:[NSString stringWithFormat:@"/stuffs/%@/cancelike",idStr] requestDictionary:nil delegate:self];
            [request startRequestSuccess:^(FBRequest *request, id result) {
                sender.selected = NO;
                ((FSZuoPin*)self.modelAry[sender.tag]).is_love = 0;
            } failure:^(FBRequest *request, NSError *error) {
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Loading user data failed", nil)];
            }];
        } else {
            FBRequest *request = [FBAPI postWithUrlString:[NSString stringWithFormat:@"/stuffs/%@/dolike",idStr] requestDictionary:nil delegate:self];
            [request startRequestSuccess:^(FBRequest *request, id result) {
                sender.selected = YES;
                ((FSZuoPin*)self.modelAry[sender.tag]).is_love = 1;
            } failure:^(FBRequest *request, NSError *error) {
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Loading user data failed", nil)];
            }];
        }
    } else {
        FSLoginViewController *vc = [[FSLoginViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

#pragma mark - FSHomeDetailViewControllerDelegate
-(void)lickClick:(BOOL)btnState :(NSString *)idFiled{
    int n;
    for (int i = 0; i < self.modelAry.count; i ++) {
        NSString *idStr = ((FSZuoPin*)self.modelAry[i]).idFeild;
        if ([idStr isEqualToString:idFiled]) {
            n = i;
            break;
        }
    }
    FSHomeViewCell *cell = [self.contenTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:n]];
    cell.commendBtn.selected = btnState;
    cell.model.idFeild = idFiled;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    FSZuoPin *model = self.modelAry[indexPath.section];
    // 文字的最大尺寸
    CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width , MAXFLOAT);
    // 计算文字的高度
    CGFloat textH = [model.content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size.height;
    CGFloat gaoDu = textH + 374;
    return gaoDu;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FSHomeDetailViewController *vc = [[FSHomeDetailViewController alloc] init];
    vc.model = self.modelAry[indexPath.section];
    vc.title = NSLocalizedString(@"comments", nil);
    [self.navigationController pushViewController:vc animated:YES];
}

@end
