//
//  FSMediaBrowseViewController.m
//  Fifish
//
//  Created by macpro on 16/10/9.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSImageModel.h"

#import "FSMediaBrowseViewController.h"
#import "FSMediaBrowCollectionViewCell.h"

@interface FSMediaBrowseViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
/**
 浏览器
 */
@property (nonatomic,strong)UICollectionView * BrowseCollectionView;

@end

@implementation FSMediaBrowseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}
- (void)setUpUI{
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.BrowseCollectionView];
    [self.BrowseCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(Nav_Height, 0, Nav_Height, 0));
    }];
    
    //滚动到点击位置
    [self.BrowseCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.seletedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (UICollectionView *)BrowseCollectionView{
    if (!_BrowseCollectionView) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        _BrowseCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _BrowseCollectionView.pagingEnabled = YES;
        _BrowseCollectionView.delegate = self;
        _BrowseCollectionView.dataSource = self;
        _BrowseCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
        [_BrowseCollectionView registerClass:[FSMediaBrowCollectionViewCell class] forCellWithReuseIdentifier:BrowCellIden];
    }
    return _BrowseCollectionView;
}
#pragma mark UIcollectionviewdelegate

//个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.modelArr.count;
}

//单元大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.view.frame.size.width, self.view.frame.size.width);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FSMediaBrowCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:BrowCellIden forIndexPath:indexPath];
    
    FSImageModel * model = self.modelArr[indexPath.row];
    
    cell.model = model;
    
    return cell;
    
}
@end
