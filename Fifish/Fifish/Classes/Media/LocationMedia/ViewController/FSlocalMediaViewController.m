//
//  FSlocalMediaViewController.m
//  Fifish
//
//  Created by macpro on 16/8/25.
//  Copyright © 2016年 Dong. All rights reserved.
//

//vc
#import "FSMediaBrowseViewController.h"


#import <Photos/Photos.h>
#import <MediaPlayer/MediaPlayer.h>

#import "Masonry.h"
#import "SVProgressHUD.h"
#import "FSBorswerImageCell.h"
#import "FSlocalMediaViewController.h"
#import "MJRefresh.h"

#import "FSFileManager.h"
#import "FSImageModel.h"
#import "FSVideoModel.h"


#import "FBAPI.h"
//资源管理器
#import "FSFileManager.h"

#import "FBAPI.h"
CGFloat const Cellspecace = 1;


@interface FSlocalMediaViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>

//导航右侧按钮
@property (nonatomic,strong)    UIButton * RigthNavBtn;

/**
 是否选择状态
 */
@property (nonatomic)           BOOL      isChooseState;
/**
 删除按钮
 */
@property (nonatomic ,strong)   UIButton          * deletedBtn;

//浏览器
@property (nonatomic , strong)  UICollectionView * BroswerCollection;

//cell大小
@property (nonatomic)           CGFloat            cellSize;

//资源
@property (nonatomic, strong)   NSMutableArray    * sourceArr;
/**
 记录点击cell
 */
@property (nonatomic, strong)   NSMutableIndexSet * seletedCellIndexSet;


@property (nonatomic ,strong)   AVPlayer * player;


@end


@implementation FSlocalMediaViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self setNav];
    
    [self setupUI];
    
    [SVProgressHUD show];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self GetMediaData];
    
    
}
- (void)GetMediaData{
    NSArray * dataArr =  [[FSFileManager defaultManager] GetMp4AndPngFileArr];
    [self.sourceArr removeAllObjects];
    [self.BroswerCollection reloadData];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    for (NSString * str in dataArr) {
        FSMediaModel * mediaModel;
        if ([str hasSuffix:@"mp4"]) {
            mediaModel = [[FSVideoModel alloc] init];
            mediaModel.fileUrl = str;
        }
        if ([str hasSuffix:@"png"]||[str hasSuffix:@"jpg"]) {
            mediaModel = [[FSImageModel alloc] init];
            mediaModel.fileUrl = str;
        }
        
        [self.sourceArr addObject:mediaModel];
        
    }
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.BroswerCollection reloadData];
            [SVProgressHUD dismiss];
        });
        });
    
    
    
}

- (void)setNav{
    
    [self.parentsVC setRightItem:self.RigthNavBtn];
}
- (NSMutableArray *)sourceArr{
    if (!_sourceArr) {
        _sourceArr = [NSMutableArray array];
    }
    return _sourceArr;
}
- (UIButton *)RigthNavBtn{
    if (!_RigthNavBtn) {
        _RigthNavBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _RigthNavBtn.frame = CGRectMake(0, 0, 60, 40);
        [_RigthNavBtn addTarget:self action:@selector(EditChoose:) forControlEvents:UIControlEventTouchUpInside];
        _RigthNavBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_RigthNavBtn setTitle:NSLocalizedString(@"Choose", nil) forState:UIControlStateNormal];
        [_RigthNavBtn setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateSelected];
        [_RigthNavBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _RigthNavBtn;
}

//选择
- (void)EditChoose:(UIButton *)sender{
    
    self.isChooseState = !self.isChooseState;
    sender.selected = !sender.selected;
    [self.BroswerCollection reloadData];
    
    //取消状态删除所有值钱记录的下标
    if (!sender.isSelected) {
        [self.seletedCellIndexSet removeAllIndexes];
    }
    
    //更新删除按钮
    [self UpdateDeletedBtn];
}


- (void)setupUI{

//    cell大小
    self.cellSize = (SCREEN_WIDTH-(Cellspecace*3.0))/4;
    //添加collectionview
    [self.view addSubview:self.BroswerCollection];
    [self.BroswerCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(Nav_Height);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-Tab_Height);
    }];

    
    //添加删除按钮
    [self.view addSubview:self.deletedBtn];
    
    [self.deletedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(Tab_Height+20);
    }];
}

- (UICollectionView *)BroswerCollection{
    if (!_BroswerCollection) {
        UICollectionViewFlowLayout * layOut = [[UICollectionViewFlowLayout alloc] init];
        layOut.minimumLineSpacing = 1;
        layOut.minimumInteritemSpacing = 1;
        [layOut setScrollDirection:UICollectionViewScrollDirectionVertical];
        _BroswerCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layOut];
        _BroswerCollection.delegate = self;
        _BroswerCollection.dataSource = self;
        _BroswerCollection.allowsMultipleSelection = YES;//允许多选
        _BroswerCollection.backgroundColor = [UIColor whiteColor];
        [_BroswerCollection registerNib:[UINib nibWithNibName:@"FSBorswerImageCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:FSBorswerImageCelliden];
    }
    return _BroswerCollection;
}

//选中的cell
- (NSMutableIndexSet *)seletedCellIndexSet{
    if (!_seletedCellIndexSet) {
        _seletedCellIndexSet = [NSMutableIndexSet indexSet];
    }
    return _seletedCellIndexSet;
}


#pragma mark collectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.sourceArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FSBorswerImageCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:FSBorswerImageCelliden forIndexPath:indexPath];
    cell.mediaModel = self.sourceArr[indexPath.row];
    cell.seletedBtn.hidden = !self.isChooseState;

    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.cellSize, self.cellSize);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    FSImageModel * model = self.sourceArr[indexPath.row];
//    [FBAPI uploadFileWithURL:@"http://up-z2.qiniu.com" WithToken:@"x9Ys5weZ-B6-qKywyX2N34bhFIT3XQLpxz0g9vZU:2MafOwgjdCj6t8F7l9T_ibXhUv0=:eyJzYXZlS2V5IjoidmlkZW9cLzE2MTAxM1wvYTA1OGUyNmMxNzUwMjljZTAyMTllYWM4MGQ0YmE4MmEkKGV4dCkiLCJjYWxsYmFja1VybCI6Imh0dHA6XC9cL2FwaS5xeXNlYS5jb21cL3VwbG9hZFwvcWluaXViYWNrIiwiY2FsbGJhY2tCb2R5Ijoie1wiZmlsZW5hbWVcIjpcIiQoZm5hbWUpXCIsIFwiZmlsZXBhdGhcIjpcIiQoa2V5KVwiLCBcInNpemVcIjpcIiQoZnNpemUpXCIsIFwid2lkdGhcIjpcIiQoaW1hZ2VJbmZvLndpZHRoKVwiLCBcImhlaWdodFwiOlwiJChpbWFnZUluZm8uaGVpZ2h0KVwiLFwibWltZVwiOlwiJChtaW1lVHlwZSlcIixcImhhc2hcIjpcIiQoZXRhZylcIixcImRlc2NcIjpcIiQoeDpkZXNjKVwiLFwiYXNzZXRhYmxlX2lkXCI6MCxcImFzc2V0YWJsZV90eXBlXCI6XCJTdHVmZlwiLCBcImtpbmRcIjoyLFwidXNlcl9pZFwiOjF9IiwicGVyc2lzdGVudE9wcyI6InZmcmFtZVwvanBnXC9vZmZzZXRcLzFcL3dcLzQ4MFwvaFwvMjcwfHZmcmFtZVwvanBnXC9vZmZzZXRcLzFcL3dcLzEyMFwvaFwvNjciLCJzY29wZSI6ImZpZmlzaCIsImRlYWRsaW5lIjoxNDc2MzU0MjE2fQ==" WithFileUrl:[NSURL fileURLWithPath:model.fileUrl] WihtProgressBlock:^(CGFloat progress) {
//        NSLog(@"%f",progress);
//    } WithSuccessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@",responseObject);
//    } WithFailureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@",error.localizedDescription);
//    }];
//
//    if ([model isKindOfClass:[FSVideoModel class]]) {
//        MPMoviePlayerViewController * mvPlayer =  [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:model.fileUrl]];
//        [self.navigationController presentViewController:mvPlayer animated:YES completion:nil];
//    }
    
    //选择状态下
    if (self.isChooseState) {
        [self.seletedCellIndexSet addIndex:indexPath.item];
        
        [self UpdateDeletedBtn];
    }
    //普通状态下
    else{
        FSMediaBrowseViewController * fsmbvc = [[FSMediaBrowseViewController alloc] init];
        fsmbvc.modelArr = self.sourceArr;
        fsmbvc.seletedIndex = indexPath.row;
        [self.navigationController pushViewController:fsmbvc animated:YES];
    }
   
}


- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.seletedCellIndexSet removeIndex:indexPath.item];
    
    [self UpdateDeletedBtn];
    
}

#pragma mark 刷新删除按钮
- (void)UpdateDeletedBtn{
    //更新删除按钮
    __block BOOL tabBarHidden = self.seletedCellIndexSet.count;
    
    self.tabBarController.tabBar.hidden = tabBarHidden;
    
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:10 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        [self.deletedBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_bottom).offset(-(tabBarHidden*Tab_Height));
        }];
        [self.view layoutIfNeeded];//强制绘制
    } completion:^(BOOL finished) {
        
    }];
}

- (UIButton *)deletedBtn{
    
    if (!_deletedBtn) {
        _deletedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deletedBtn.hidden = NO;
        [_deletedBtn addTarget:self action:@selector(deleteMediaItem) forControlEvents:UIControlEventTouchUpInside];
        [_deletedBtn setBackgroundColor:[UIColor colorWithHexString:@"121F27"]];
        [_deletedBtn setImage:[UIImage imageNamed:@"media_delete_icon"] forState:UIControlStateNormal];
        _deletedBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 20, 0);
    }
    
    return _deletedBtn;
}
- (void)deleteMediaItem{
    //删除操作！
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSUInteger currentIndex = [self.seletedCellIndexSet firstIndex];
        NSMutableArray * deleteArr = [NSMutableArray array];
        //遍历选中的index
        while (currentIndex != NSNotFound) {
            
            FSMediaModel * model = self.sourceArr[currentIndex];
            //1.根据文件地址删除文件
            [[FSFileManager defaultManager] RemoveFilePath:model.fileUrl];
            //2.删除数据源里的模型
            [self.sourceArr removeObjectAtIndex:currentIndex];
            //3.删除选中的状态
            [self.seletedCellIndexSet removeIndex:currentIndex];
            //4.添加到要删除的数组中
            [deleteArr addObject:[NSIndexPath indexPathForRow:currentIndex inSection:0]];
            //查找下一个元素
            currentIndex = [self.seletedCellIndexSet indexGreaterThanIndex:currentIndex];
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //UI界面删除
            [self.BroswerCollection deleteItemsAtIndexPaths:deleteArr];
            
            //更新删除按钮
            [self UpdateDeletedBtn];
        });
        
    });
    
}
@end
