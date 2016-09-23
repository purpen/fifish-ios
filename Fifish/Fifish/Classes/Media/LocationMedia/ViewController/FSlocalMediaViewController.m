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

#import "FSImageModel.h"
#import "FSVideoModel.h"

//资源管理器
#import "FSFileManager.h"

CGFloat const Cellspecace = 1;


@interface FSlocalMediaViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>
//浏览器
@property (nonatomic , strong) UICollectionView * BroswerCollection;

//cell大小
@property (nonatomic)          CGFloat            cellSize;

//资源
@property (nonatomic, strong) NSMutableArray    * sourceArr;

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
    [self.view addSubview:self.BroswerCollection];
    [self.BroswerCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0,0, 0, 0));
    }];
    
    self.BroswerCollection.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self GetMediaData];
        [self.BroswerCollection.mj_header endRefreshing];
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
        _BroswerCollection.backgroundColor = [UIColor whiteColor];
        [_BroswerCollection registerNib:[UINib nibWithNibName:@"FSBorswerImageCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:FSBorswerImageCelliden];
    }
    return _BroswerCollection;
}
#pragma mark collectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.sourceArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FSBorswerImageCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:FSBorswerImageCelliden forIndexPath:indexPath];
    cell.mediaModel = self.sourceArr[indexPath.row];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.cellSize, self.cellSize);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    FSImageModel * model = self.sourceArr[indexPath.row];
    
    if ([model isKindOfClass:[FSVideoModel class]]) {
        MPMoviePlayerViewController * mvPlayer =  [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:model.fileUrl]];
        [self.navigationController presentViewController:mvPlayer animated:YES completion:nil];
    }
}

@end
