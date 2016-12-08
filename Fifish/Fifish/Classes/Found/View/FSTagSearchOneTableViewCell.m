//
//  FSTagSearchOneTableViewCell.m
//  Fifish
//
//  Created by THN-Dong on 2016/10/20.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSTagSearchOneTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "FSTagSearchCollectionViewCell.h"
#import "FBRequest.h"
#import "FBAPI.h"

@interface FSTagSearchOneTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UIImageView *defaultImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
/**  */
@property (nonatomic, strong) UICollectionView *myCollectionView;
/**  */
@property (nonatomic, strong) NSArray *tagAry;

@end

@implementation FSTagSearchOneTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 5;
    self.shadowView.layer.masksToBounds = YES;
    self.shadowView.layer.cornerRadius = 5;
}

-(void)setPlaceString:(NSString *)placeString{
    if ([placeString rangeOfString:@"#"].location != NSNotFound) {
        _placeString = [placeString substringFromIndex:1];
    } else {
        _placeString = placeString;
    }
    self.tagLabel.text = [NSString stringWithFormat:@"# %@", self.placeString];
    [self tagRequest];
}

-(void)tagRequest{
    
    NSString *encodedString = [[NSString stringWithFormat:@"/tags/%@",self.placeString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    FBRequest *request = [FBAPI getWithUrlString:encodedString requestDictionary:nil delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:result[@"data"][@"cover"][@"file"][@"thumb"]] placeholderImage:[UIImage imageNamed:@""]];
        self.countLabel.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"Use the number", nil) , result[@"data"][@"total_count"]];
        if ([result[@"data"][@"related_words"] isKindOfClass:[NSArray class]]) {
            self.tagAry = result[@"data"][@"related_words"];
        }
        [self.contentView addSubview:self.myCollectionView];
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
    
}

-(UICollectionView *)myCollectionView{
    if (!_myCollectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 10);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 130, SCREEN_WIDTH, 22) collectionViewLayout:flowLayout];
        _myCollectionView.backgroundColor = [UIColor clearColor];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        _myCollectionView.showsHorizontalScrollIndicator = NO;
        [_myCollectionView registerNib:[UINib nibWithNibName:@"FSTagSearchCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"FSTagSearchCollectionViewCell"];
    }
    return _myCollectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tagAry.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *str = self.tagAry[indexPath.row];
    // 文字的最大尺寸
    CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width , MAXFLOAT);
    // 计算文字的高度
    CGFloat textW = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.width;
    return CGSizeMake(textW + 20, 22);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FSTagSearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FSTagSearchCollectionViewCell" forIndexPath:indexPath];
    NSString *str = self.tagAry[indexPath.row];
    cell.tagText = str;
    cell.navc = self.navc;
    return cell;
}


@end
