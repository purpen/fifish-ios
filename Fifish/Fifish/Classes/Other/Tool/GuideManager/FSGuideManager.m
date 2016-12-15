//
//  FSGuideManager.m
//  Fifish
//
//  Created by THN-Dong on 2016/12/14.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSGuideManager.h"

#define ScreenBounds [UIScreen mainScreen].bounds

static NSString *identifier = @"Cell";

#pragma mark - FSGuideCell
@interface FSGuideCell : UICollectionViewCell

/**  */
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation FSGuideCell

-(instancetype)init{
    if (self = [super init]) {
        [self myInit];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self myInit];
    }
    return self;
}

-(void)myInit{
    self.layer.masksToBounds = YES;
    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = ScreenBounds;
    self.imageView.center = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.5);
    [self.contentView addSubview:self.imageView];
}

@end

#pragma mark - FSGuideManager
@interface FSGuideManager () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *myCollectionView;
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation FSGuideManager

-(NSMutableArray *)images{
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

+(instancetype)shared{
    static id __staticObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __staticObject = [FSGuideManager new];
    });
    return __staticObject;
}

-(UICollectionView *)myCollectionView{
    if (!_myCollectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = ScreenBounds.size;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _myCollectionView = [[UICollectionView alloc] initWithFrame:ScreenBounds collectionViewLayout:layout];
        _myCollectionView.bounces = NO;
        _myCollectionView.backgroundColor = [UIColor whiteColor];
        _myCollectionView.showsVerticalScrollIndicator = NO;
        _myCollectionView.showsHorizontalScrollIndicator = NO;
        _myCollectionView.pagingEnabled = YES;
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        
        [_myCollectionView registerClass:[FSGuideCell class] forCellWithReuseIdentifier:identifier];
    }
    return _myCollectionView;
}

-(UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44.0f);
        _pageControl.center = CGPointMake(SCREEN_WIDTH * 0.5f, SCREEN_HEIGHT - 60.0f);
    }
    return _pageControl;
}

-(void)showGuideViewWithImages:(NSArray *)images{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *version = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    BOOL show = [ud boolForKey:[NSString stringWithFormat:@"Guide_%@", version]];
    if (!show && self.window == nil) {
        for (int i = 0; i < images.count; ++i) {
            NSString *path = [images objectAtIndex:i];
            UIImage *image = [UIImage imageWithContentsOfFile:path];
            [self.images addObject:image];
        }
        self.window = [UIApplication sharedApplication].keyWindow;
        [self.window addSubview:self.myCollectionView];
        
        [ud setBool:YES forKey:[NSString stringWithFormat:@"Guide_%@", version]];
        [ud synchronize];
        
        self.pageControl.numberOfPages = images.count;
        [self.window addSubview:self.pageControl];
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.images.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FSGuideCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    UIImage *image = [self.images objectAtIndex:indexPath.row];
    CGSize size = [self adapterSizeImageSize:image.size compareSize:ScreenBounds.size];
    cell.imageView.frame = CGRectMake(0, 0, size.width, size.height);
    cell.imageView.center = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.5);
    cell.imageView.image = image;
    return cell;
}

-(CGSize)adapterSizeImageSize:(CGSize)is compareSize:(CGSize)cs{
    CGFloat w = cs.width;
    CGFloat h = cs.width * is.height / is.width;
    if (h < cs.height) {
        w = cs.height * is.width / is.height;
        h = cs.height;
    }
    return CGSizeMake(w, h);
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.pageControl.currentPage = (scrollView.contentOffset.x / SCREEN_WIDTH);
    if (scrollView.contentOffset.x / SCREEN_WIDTH == 2) {
        [self performSelector:@selector(dismiss) withObject:self afterDelay:0.5];
    }
}

-(void)dismiss{
    [self.myCollectionView removeFromSuperview];
    [self setWindow:nil];
    [self setMyCollectionView:nil];
    [self.pageControl removeFromSuperview];
}

@end
