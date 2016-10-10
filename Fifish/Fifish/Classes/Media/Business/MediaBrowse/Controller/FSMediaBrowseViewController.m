//
//  FSMediaBrowseViewController.m
//  Fifish
//
//  Created by macpro on 16/10/9.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSImageModel.h"
//view
#import "FSMediaBrowBottomEditView.h"


#import "FSMediaBrowseViewController.h"
#import "FSMediaBrowCollectionViewCell.h"

@interface FSMediaBrowseViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>
/**
 浏览器
 */
@property (nonatomic,strong)UICollectionView                        * BrowseCollectionView;

/**
 当前张数
 */
@property (nonatomic,strong)UILabel                                 * offsetLab;

/**
 编辑分享view
 */
@property (nonatomic,strong)FSMediaBrowBottomEditView              * editView;


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
    
    [self.view addSubview:self.editView];
    [self.editView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(@44);
    }];
    
    [self.view addSubview:self.offsetLab];
    [self.offsetLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.editView.mas_centerX);
        make.bottom.mas_equalTo(self.editView.mas_top).offset(-30);
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.BrowseCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.seletedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        self.offsetLab.text = [NSString stringWithFormat:@"%lu/%lu",self.seletedIndex+1,self.modelArr.count];
    });
    
    
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
- (UILabel *)offsetLab{
    if (!_offsetLab) {
        _offsetLab = [[UILabel alloc] init];
        _offsetLab.textColor = [UIColor whiteColor];
        _offsetLab.font = [UIFont systemFontOfSize:14];
    }
    return _offsetLab;
}
- (FSMediaBrowBottomEditView *)editView{
    if (!_editView) {
        _editView = [[FSMediaBrowBottomEditView alloc] init];
        return _editView;
    }
    return _editView;
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

#pragma mark ScrollviewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    self.seletedIndex = offset.x/SCREEN_WIDTH;
    self.offsetLab.text = [NSString stringWithFormat:@"%lu/%lu",self.seletedIndex+1,self.modelArr.count];
}

/**
 * 手指松开scrollView后，scrollView停止减速完毕就会调用这个
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}
@end
