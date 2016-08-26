//
//  FSlocalMediaViewController.m
//  Fifish
//
//  Created by macpro on 16/8/25.
//  Copyright © 2016年 Dong. All rights reserved.
//
#import "Masonry.h"
#import "FSBorswerImageCell.h"
#import "FSlocalMediaViewController.h"

CGFloat const Cellspecace = 1;


@interface FSlocalMediaViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>
//浏览器
@property (nonatomic , strong) UICollectionView * BroswerCollection;

//cell大小
@property (nonatomic)          CGFloat            cellSize;


@end


@implementation FSlocalMediaViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setupUI];
    
    //读取视频数据
    [self GetMediaData];
}

- (void)GetMediaData{
    
}

- (void)setupUI{
//    cell大小
    self.cellSize = (SCREEN_WIDTH-(Cellspecace*3.0))/4;
    [self.view addSubview:self.BroswerCollection];
    [self.BroswerCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0,0, 0, 0));
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
    return 100;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FSBorswerImageCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:FSBorswerImageCelliden forIndexPath:indexPath];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.cellSize, self.cellSize);
}

@end
