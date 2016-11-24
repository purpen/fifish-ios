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
#import "FSReportViewController.h"
#import "UINavigationBar+FSExtension.h"
#import "CTFrameParserConfig.h"
#import "CoreTextData.h"
#import "CTFrameParser.h"
#import "NSString+FSAttributedString.h"
#import "WMPlayer.h"

@interface FSHomeViewController ()<UITableViewDelegate,UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, FSHomeViewCellDelegate, WMPlayerDelegate, FSHomeDetailViewControllerDelegate>

{
    WMPlayer *wmPlayer;
}

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
/**  */
@property (nonatomic, strong) NSMutableArray *cellHeightAry;
/**  */
@property (nonatomic, strong) NSMutableArray *ctDataAry;
/**  */
@property (nonatomic, strong) NSMutableArray *tagMAry;
/**  */
@property (nonatomic, strong) NSMutableArray *contentStringAry;
/**  */
@property (nonatomic, strong) NSMutableArray *hideAry;
@property (nonatomic, strong) NSIndexPath *indexPath;
/**  */
@property (nonatomic, strong) UIView *imageView;
@property (nonatomic, assign) BOOL isSmallScreen;

@end

static NSString * const CellId = @"home";

@implementation FSHomeViewController

-(NSMutableArray *)hideAry{
    if (!_hideAry) {
        _hideAry = [NSMutableArray array];
    }
    return _hideAry;
}

-(NSMutableArray *)contentStringAry{
    if (!_contentStringAry) {
        _contentStringAry = [NSMutableArray array];
    }
    return _contentStringAry;
}

-(NSMutableArray *)ctDataAry{
    if (!_ctDataAry) {
        _ctDataAry = [NSMutableArray array];
    }
    return _ctDataAry;
}

-(NSMutableArray *)tagMAry{
    if (!_tagMAry) {
        _tagMAry = [NSMutableArray array];
    }
    return _tagMAry;
}

-(NSMutableArray *)cellHeightAry{
    if (!_cellHeightAry) {
        _cellHeightAry = [NSMutableArray array];
    }
    return _cellHeightAry;
}

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
        [self.cellHeightAry removeAllObjects];
        [self.hideAry removeAllObjects];
        [self.ctDataAry removeAllObjects];
        [self.contentStringAry removeAllObjects];
        for (int i = 0; i < self.modelAry.count; i++) {
            FSZuoPin *model = self.modelAry[i];
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            NSString *path = [paths objectAtIndex:0];
            NSString *filename = [path stringByAppendingPathComponent:@"tag.plist"];
            NSFileManager *fm = [NSFileManager defaultManager];
            [fm createFileAtPath:filename contents:nil attributes:nil];
            CTFrameParserConfig *config = [[CTFrameParserConfig alloc] init];
            [self.tagMAry removeAllObjects];
            if (model.tags.count > 0) {
                for (int i = 0; i < model.tags.count; i ++) {
                    NSDictionary *dict = model.tags[i];
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
                
                
                
                CGFloat textH = [model.content getSpaceLabelHeightWithSpeace:5 withFont:[UIFont systemFontOfSize:14] withWidth:(SCREEN_WIDTH - 30)];
                if (SCREEN_HEIGHT == 568.0) {
                    CGFloat gaoDu = 0;
                    if (model.content.length <= 53) {
                        [self.hideAry addObject:@(1)];
                        gaoDu = (textH + 375 + 20) / 667.0 * SCREEN_HEIGHT;
                    } else {
                        [self.hideAry addObject:@(0)];
                        gaoDu = (85 + 375) / 667.0 * SCREEN_HEIGHT;
                    }
                    [self.cellHeightAry addObject:[NSString stringWithFormat:@"%f",gaoDu]];
                } else if (SCREEN_HEIGHT == 667.0) {
                    CGFloat gaoDu = 0;
                    if (model.content.length <= 65) {
                        [self.hideAry addObject:@(1)];
                        gaoDu = (textH + 375 - 12) / 667.0 * SCREEN_HEIGHT;
                    } else {
                        [self.hideAry addObject:@(0)];
                        gaoDu = (53 + 375) / 667.0 * SCREEN_HEIGHT;
                    }
                    [self.cellHeightAry addObject:[NSString stringWithFormat:@"%f",gaoDu]];
                } else {
                    CGFloat gaoDu = 0;
                    if (model.content.length <= 96) {
                        [self.hideAry addObject:@(1)];
                        gaoDu = (textH + 375 + 12);
                    } else {
                        [self.hideAry addObject:@(0)];
                        gaoDu = (53 + 375);
                    }
                    [self.cellHeightAry addObject:[NSString stringWithFormat:@"%f",gaoDu]];
                }
            } else {
                CGFloat textH = [model.content getSpaceLabelHeightWithSpeace:5 withFont:[UIFont systemFontOfSize:14] withWidth:(SCREEN_WIDTH - 30)];
                if (SCREEN_HEIGHT == 568.0) {
                    CGFloat gaoDu = 0;
                    if (model.content.length <= 53) {
                        [self.hideAry addObject:@(1)];
                        gaoDu = (textH + 347 + 20) / 667.0 * SCREEN_HEIGHT;
                    } else {
                        [self.hideAry addObject:@(0)];
                        gaoDu = (85 + 347) / 667.0 * SCREEN_HEIGHT;
                    }
                    [self.cellHeightAry addObject:[NSString stringWithFormat:@"%f",gaoDu]];
                } else if (SCREEN_HEIGHT == 667.0) {
                    CGFloat gaoDu = 0;
                    if (model.content.length <= 65) {
                        [self.hideAry addObject:@(1)];
                        gaoDu = (textH + 347 - 12) / 667.0 * SCREEN_HEIGHT;
                    } else {
                        [self.hideAry addObject:@(0)];
                        gaoDu = (53 + 347) / 667.0 * SCREEN_HEIGHT;
                    }
                    [self.cellHeightAry addObject:[NSString stringWithFormat:@"%f",gaoDu]];
                } else {
                    CGFloat gaoDu = 0;
                    if (model.content.length <= 96) {
                        [self.hideAry addObject:@(1)];
                        gaoDu = (textH + 347 - 30) / 667.0 * SCREEN_HEIGHT;
                    } else {
                        [self.hideAry addObject:@(0)];
                        gaoDu = (53 + 347) / 667.0 * SCREEN_HEIGHT;
                    }
                    [self.cellHeightAry addObject:[NSString stringWithFormat:@"%f",gaoDu]];
                }
            }
            CoreTextData *data = [CTFrameParser parseTemplateFile:filename config:config];
            [self.ctDataAry addObject:data];
            
            NSInteger flag = [self.hideAry[i] integerValue];
            if (flag) {
                NSAttributedString  *setString = [model.content stringWithParagraphlineSpeace:5 textColor:[UIColor colorWithHexString:@"#222222"] textFont:[UIFont systemFontOfSize:14]];
                [self.contentStringAry addObject:setString];
            } else {
                NSAttributedString  *setString = [model.content stringHideLastFourWithParagraphlineSpeace:5 textColor:[UIColor colorWithHexString:@"#222222"] textFont:[UIFont systemFontOfSize:14]];
                [self.contentStringAry addObject:setString];
            }
        }
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
        [self.cellHeightAry removeAllObjects];
        [self.hideAry removeAllObjects];
        [self.ctDataAry removeAllObjects];
        [self.contentStringAry removeAllObjects];
        for (int i = 0; i < self.modelAry.count; i++) {
            FSZuoPin *model = self.modelAry[i];
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            NSString *path = [paths objectAtIndex:0];
            NSString *filename = [path stringByAppendingPathComponent:@"tag.plist"];
            NSFileManager *fm = [NSFileManager defaultManager];
            [fm createFileAtPath:filename contents:nil attributes:nil];
            CTFrameParserConfig *config = [[CTFrameParserConfig alloc] init];
            [self.tagMAry removeAllObjects];
            if (model.tags.count > 0) {
                for (int i = 0; i < model.tags.count; i ++) {
                    NSDictionary *dict = model.tags[i];
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
                
                
                
                CGFloat textH = [model.content getSpaceLabelHeightWithSpeace:5 withFont:[UIFont systemFontOfSize:14] withWidth:(SCREEN_WIDTH - 30)];
                if (SCREEN_HEIGHT == 568.0) {
                    CGFloat gaoDu = 0;
                    if (model.content.length <= 53) {
                        [self.hideAry addObject:@(1)];
                        gaoDu = (textH + 375 + 20) / 667.0 * SCREEN_HEIGHT;
                    } else {
                        [self.hideAry addObject:@(0)];
                        gaoDu = (85 + 375) / 667.0 * SCREEN_HEIGHT;
                    }
                    [self.cellHeightAry addObject:[NSString stringWithFormat:@"%f",gaoDu]];
                } else if (SCREEN_HEIGHT == 667.0) {
                    CGFloat gaoDu = 0;
                    if (model.content.length <= 65) {
                        [self.hideAry addObject:@(1)];
                        gaoDu = (textH + 375 - 12) / 667.0 * SCREEN_HEIGHT;
                    } else {
                        [self.hideAry addObject:@(0)];
                        gaoDu = (53 + 375) / 667.0 * SCREEN_HEIGHT;
                    }
                    [self.cellHeightAry addObject:[NSString stringWithFormat:@"%f",gaoDu]];
                } else {
                    CGFloat gaoDu = 0;
                    if (model.content.length <= 96) {
                        [self.hideAry addObject:@(1)];
                        gaoDu = (textH + 375 + 12);
                    } else {
                        [self.hideAry addObject:@(0)];
                        gaoDu = (53 + 375);
                    }
                    [self.cellHeightAry addObject:[NSString stringWithFormat:@"%f",gaoDu]];
                }
            } else {
                CGFloat textH = [model.content getSpaceLabelHeightWithSpeace:5 withFont:[UIFont systemFontOfSize:14] withWidth:(SCREEN_WIDTH - 30)];
                if (SCREEN_HEIGHT == 568.0) {
                    CGFloat gaoDu = 0;
                    if (model.content.length <= 53) {
                        [self.hideAry addObject:@(1)];
                        gaoDu = (textH + 347 + 20) / 667.0 * SCREEN_HEIGHT;
                    } else {
                        [self.hideAry addObject:@(0)];
                        gaoDu = (85 + 347) / 667.0 * SCREEN_HEIGHT;
                    }
                    [self.cellHeightAry addObject:[NSString stringWithFormat:@"%f",gaoDu]];
                } else if (SCREEN_HEIGHT == 667.0) {
                    CGFloat gaoDu = 0;
                    if (model.content.length <= 65) {
                        [self.hideAry addObject:@(1)];
                        gaoDu = (textH + 347 - 12) / 667.0 * SCREEN_HEIGHT;
                    } else {
                        [self.hideAry addObject:@(0)];
                        gaoDu = (53 + 347) / 667.0 * SCREEN_HEIGHT;
                    }
                    [self.cellHeightAry addObject:[NSString stringWithFormat:@"%f",gaoDu]];
                } else {
                    CGFloat gaoDu = 0;
                    if (model.content.length <= 96) {
                        [self.hideAry addObject:@(1)];
                        gaoDu = (textH + 347 - 30) / 667.0 * SCREEN_HEIGHT;
                    } else {
                        [self.hideAry addObject:@(0)];
                        gaoDu = (53 + 347) / 667.0 * SCREEN_HEIGHT;
                    }
                    [self.cellHeightAry addObject:[NSString stringWithFormat:@"%f",gaoDu]];
                }
            }
            CoreTextData *data = [CTFrameParser parseTemplateFile:filename config:config];
            [self.ctDataAry addObject:data];
            
            NSInteger flag = [self.hideAry[i] integerValue];
            if (flag) {
                NSAttributedString  *setString = [model.content stringWithParagraphlineSpeace:5 textColor:[UIColor colorWithHexString:@"#222222"] textFont:[UIFont systemFontOfSize:14]];
                [self.contentStringAry addObject:setString];
            } else {
                NSAttributedString  *setString = [model.content stringHideLastFourWithParagraphlineSpeace:5 textColor:[UIColor colorWithHexString:@"#222222"] textFont:[UIFont systemFontOfSize:14]];
                [self.contentStringAry addObject:setString];
            }
        }
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
    cell.fSHomeViewDelegate = self;
    cell.navi = self.navigationController;
    cell.contentString = self.contentStringAry[indexPath.section];
    cell.myViewController = self;
    cell.model = self.modelAry[indexPath.section];
    cell.ctData = self.ctDataAry[indexPath.section];
    cell.hideFlag = [self.hideAry[indexPath.section] integerValue];
    cell.commendBtn.tag = indexPath.section;
    [cell.commendBtn addTarget:self action:@selector(commendClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.moreBtn addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.pictuerView.tapBTn.tag = indexPath.section;
    [cell.pictuerView.tapBTn addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
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
-(void)commendClick: (UIButton *) sender{
    FSHomeDetailViewController *vc = [[FSHomeDetailViewController alloc] init];
    vc.homeDetailDelegate = self;
    vc.model = self.modelAry[sender.tag];
    vc.title = NSLocalizedString(@"comments", nil);
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - FSHomeDetailViewControllerDelegate
-(void)lickClick:(BOOL)btnState :(NSString *)idFiled andlikeCount:(NSInteger)likecount{
    int n;
    for (int i = 0; i < self.modelAry.count; i ++) {
        NSString *idStr = ((FSZuoPin*)self.modelAry[i]).idFeild;
        if ([idStr isEqualToString:idFiled]) {
            n = i;
            break;
        }
    }
    FSHomeViewCell *cell = [self.contenTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:n]];
    cell.likeBtn.selected = btnState;
    if (btnState) {
        cell.like_count_label.textColor = [UIColor colorWithHexString:@"#2288ff"];
    } else {
        cell.like_count_label.textColor = [UIColor colorWithHexString:@"#7F8FA2"];
    }
    cell.like_count_label.text = [NSString stringWithFormat:@"%ld", likecount];
}

-(void)fucosDelegateClick:(BOOL)senderState andId:(NSString *)idFiled{
    int n;
    for (int i = 0; i < self.modelAry.count; i ++) {
        NSString *idStr = ((FSZuoPin*)self.modelAry[i]).idFeild;
        if ([idStr isEqualToString:idFiled]) {
            n = i;
            FSHomeViewCell *cell = [self.contenTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:n]];
            cell.model.is_follow = senderState ? 1 : 0;
            cell.likeBtn.selected = senderState;
            cell.model.idFeild = idFiled;
        }
    }
    [self.contenTableView reloadData];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellHeightStr = self.cellHeightAry[indexPath.section];
    CGFloat gaoDu = [cellHeightStr floatValue];
    return gaoDu;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FSHomeDetailViewController *vc = [[FSHomeDetailViewController alloc] init];
    vc.homeDetailDelegate = self;
    vc.model = self.modelAry[indexPath.section];
    vc.title = NSLocalizedString(@"comments", nil);
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)homeTableViewCell:(FSHomeViewCell *)cell didClickVideoWithVideoUrl:(NSString *)videoUrl videoCover:(FSHomeVideoView *)baseImageView{
    self.indexPath = [self.contenTableView indexPathForCell:cell];
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
        CGRect rectInTableView = [self.contenTableView rectForRowAtIndexPath:self.indexPath];
        CGRect rectInSuperview = [self.contenTableView convertRect:rectInTableView toView:[self.contenTableView superview]];
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
