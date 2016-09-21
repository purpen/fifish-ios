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

@interface FSHomeDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UITextField *textTF;
@property (weak, nonatomic) IBOutlet UITableView *commendTableView;
/**  */
@property (nonatomic, strong) NSMutableArray *commentAry;

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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"评论";
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
}

-(void)setupHeader{
    // 文字的最大尺寸
    CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width , MAXFLOAT);
    // 计算文字的高度
    CGFloat textH = [self.model.content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size.height;
    CGFloat gaoDu = self.model.cellHeight + 59 + 44 + textH + 20 + 44;
    
    // 创建header
    UIView *header = [[UIView alloc] init];
    header.height = gaoDu;
    header.width = SCREEN_WIDTH;
    header.backgroundColor = [UIColor whiteColor];
    
    // 添加cell
    FSHomeViewCell *cell = [FSHomeViewCell viewFromXib];
    cell.model = self.model;
    cell.frame = CGRectMake(0, 0, SCREEN_WIDTH, gaoDu);
    [header addSubview:cell];
    
    // 设置header
    self.commendTableView.tableHeaderView = header;
}

- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    // 键盘显示\隐藏完毕的frame
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 修改底部约束
    self.bottomSpace.constant = SCREEN_HEIGHT - frame.origin.y;
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
    // 文字的最大尺寸
    CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width , MAXFLOAT);
    // 计算文字的高度
    CGFloat textH = [self.model.content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size.height;
    CGFloat gaoDu = self.model.cellHeight + 59 + 44 + textH + 20 + 44;
    return gaoDu;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    FSCommentModel *model = self.commentAry[indexPath.row];
    return model.cellHeghit;
}
- (IBAction)SendMessageClick:(UIButton *)sender {
    VideoLiveController * videoLiveVC = [[VideoLiveController alloc] init];
    [self presentViewController:videoLiveVC animated:YES completion:^{
       
    }];
    
}

@end
