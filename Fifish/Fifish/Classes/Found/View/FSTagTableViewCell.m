//
//  FSTagTableViewCell.m
//  Fifish
//
//  Created by THN-Dong on 16/9/21.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSTagTableViewCell.h"
#import "FSTagCollectionViewCell.h"
#import "FSTagSearchViewController.h"
#import "FSTageModel.h"

@interface FSTagTableViewCell () <UICollectionViewDelegate,UICollectionViewDataSource>

/**  */
@property (nonatomic, strong) UICollectionView *myCollectionView;

@end

@implementation FSTagTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       [self.contentView addSubview:self.myCollectionView];
    }
    return self;
}

-(void)setModelAry:(NSArray *)modelAry{
    _modelAry = modelAry;
    [self.myCollectionView reloadData];
}

-(UICollectionView *)myCollectionView{
    if (!_myCollectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)
                                                  collectionViewLayout:flowLayout];
        _myCollectionView.backgroundColor = [UIColor whiteColor];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        _myCollectionView.showsHorizontalScrollIndicator = NO;
        [_myCollectionView registerNib:[UINib nibWithNibName:@"FSTagCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"FSTagCollectionViewCell"];
    }
    return _myCollectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.modelAry.count == 0) {
        return 0;
    } else {
        return self.modelAry.count;
    }
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(70, 70);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FSTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FSTagCollectionViewCell"
                                                                                  forIndexPath:indexPath];
    cell.model = self.modelAry[indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    FSTageModel *model = self.modelAry[indexPath.row];
    FSTagSearchViewController *vc = [[FSTagSearchViewController alloc] init];
    vc.placeString = model.name;
    [self.navc pushViewController:vc animated:YES];
}

@end
