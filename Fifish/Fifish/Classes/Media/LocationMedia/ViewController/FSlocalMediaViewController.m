//
//  FSlocalMediaViewController.m
//  Fifish
//
//  Created by macpro on 16/8/25.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import <Photos/Photos.h>
#import <MediaPlayer/MediaPlayer.h>

#import "Masonry.h"
#import "FSBorswerImageCell.h"
#import "FSlocalMediaViewController.h"
#import "MJRefresh.h"

#import "FSFileManager.h"
#import "FSImageModel.h"
#import "FSVideoModel.h"

//资源管理器
#import "FSFileManager.h"

#import "FBAPI.h"
CGFloat const Cellspecace = 1;


@interface FSlocalMediaViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>


/**
 删除按钮
 */
@property (nonatomic ,strong) UIButton          * deletedBtn;

//浏览器
@property (nonatomic , strong) UICollectionView * BroswerCollection;

//cell大小
@property (nonatomic)          CGFloat            cellSize;

//资源
@property (nonatomic, strong) NSMutableArray    * sourceArr;
/**
 记录点击cell
 */
@property (nonatomic, strong) NSMutableIndexSet * seletedCellIndexSet;


@property (nonatomic ,strong)AVPlayer * player;


@end


@implementation FSlocalMediaViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setupUI];
    //读取视频数据
    [self GetMediaData];
}

- (void)GetMediaData{
    NSArray * dataArr =  [[FSFileManager defaultManager] GetMp4AndPngFileArr];
    self.sourceArr = [NSMutableArray array];
    for (NSString * str in dataArr) {
        FSMediaModel * mediaModel;
        if ([str hasSuffix:@"mp4"]) {
            mediaModel = [[FSVideoModel alloc] init];
            mediaModel.fileUrl = str;
        }
        if ([str hasSuffix:@"png"]) {
            mediaModel = [[FSImageModel alloc] init];
            mediaModel.fileUrl = str;
        }
        
        [self.sourceArr addObject:mediaModel];
    }
    [self.BroswerCollection reloadData];
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
    
    self.BroswerCollection.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.sourceArr removeAllObjects];
        [self GetMediaData];
        [self.BroswerCollection.mj_header endRefreshing];
    }];
    
    //添加删除按钮
    [self.view addSubview:self.deletedBtn];
    
    [self.deletedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(self.tabBarController.tabBar.frame.size.height);
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
   FSMediaModel * model = cell.mediaModel = self.sourceArr[indexPath.row];
   NSLog(@"%llu",[[[NSFileManager defaultManager] attributesOfItemAtPath:model.fileUrl error:nil] fileSize]);
    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.cellSize, self.cellSize);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    FSImageModel * model = self.sourceArr[indexPath.row];
//
//    if ([model isKindOfClass:[FSVideoModel class]]) {
//        MPMoviePlayerViewController * mvPlayer =  [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:model.fileUrl]];
//        [self.navigationController presentViewController:mvPlayer animated:YES completion:nil];
//    }
    [self.seletedCellIndexSet addIndex:indexPath.item];
    
    [self UpdateDeletedBtn];
}


- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.seletedCellIndexSet removeIndex:indexPath.item];
    
    [self UpdateDeletedBtn];
    
}

#pragma mark 刷新删除按钮
- (void)UpdateDeletedBtn{
    self.tabBarController.tabBar.hidden = self.seletedCellIndexSet.count;
    self.deletedBtn.hidden = !self.seletedCellIndexSet.count;
}

- (UIButton *)deletedBtn{
    
    if (!_deletedBtn) {
        _deletedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deletedBtn.hidden = YES;
        [_deletedBtn addTarget:self action:@selector(deleteMediaItem) forControlEvents:UIControlEventTouchUpInside];
        [_deletedBtn setBackgroundColor:[UIColor colorWithHexString:@"121F27"]];
        [_deletedBtn setImage:[UIImage imageNamed:@"media_delete_icon"] forState:UIControlStateNormal];
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
