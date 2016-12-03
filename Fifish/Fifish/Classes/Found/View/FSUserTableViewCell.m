//
//  FSUserTableViewCell.m
//  Fifish
//
//  Created by THN-Dong on 16/9/21.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSUserTableViewCell.h"
#import "FSUserCollectionViewCell.h"
#import "UIColor+FSExtension.h"
#import "FSHomePageViewController.h"
#import "FSUserModel.h"
#import "Masonry.h"

@interface FSUserTableViewCell () <UICollectionViewDelegate,UICollectionViewDataSource>

/**  */
@property (nonatomic, strong) UICollectionView *myCollectionView;
/**  */
@property (nonatomic, strong) UIView *lineView;

@end

@implementation FSUserTableViewCell

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#aaaaaa" alpha:0.67];
    }
    return _lineView;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.myCollectionView];
        [self.contentView addSubview:self.lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(1));
            make.left.bottom.right.equalTo(@(0));
        }];
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
        flowLayout.minimumLineSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 8, 0, 8);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)
                                               collectionViewLayout:flowLayout];
        _myCollectionView.backgroundColor = [UIColor whiteColor];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        _myCollectionView.showsHorizontalScrollIndicator = NO;
        [_myCollectionView registerNib:[UINib nibWithNibName:@"FSUserCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"FSUserCollectionViewCell"];
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
    return CGSizeMake(70, 80);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FSUserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FSUserCollectionViewCell"
                                                                              forIndexPath:indexPath];
    cell.model = self.modelAry[indexPath.row];
    cell.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    FSHomePageViewController *vc = [[FSHomePageViewController alloc] init];
    FSUserModel *userModel = self.modelAry[indexPath.row];
    vc.userId = userModel.userId;
    [self.navi pushViewController:vc animated:YES];
}

@end
