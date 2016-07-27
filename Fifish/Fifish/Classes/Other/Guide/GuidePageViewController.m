//
//  GuidePageViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "GuidePageViewController.h"
#import "FSConst.h"
#import "Masonry.h"
#import "FSTabBarController.h"

@interface GuidePageViewController ()<UIScrollViewDelegate>
{
    NSArray *_pictureArr;
    UIViewController *_mainController;
    UIScrollView *_guideScrollView;
    UIImageView *_guideImageView;
    UIPageControl *_guidePageController;
}
@property (nonatomic,strong) UIButton *enterBtn;

@end

@implementation GuidePageViewController

-(instancetype)initWithPicArr:(NSArray *)picArr andRootVC:(UIViewController *)controller{
    if (self == [super init]) {
        _pictureArr = picArr;
        _mainController = controller;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self startRollImg];

    //设置页码控制器
//    [self setPageController];
}


- (void)startRollImg {
    //设置scrollview
    [self setScrollView];
    //设置ImageView
    [self setImageView];
}

//设置页码控制器
//-(void)setPageController{
//    _guidePageController = [[UIPageControl alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-40, 50, 20)];
//    CGPoint center = _guidePageController.center;
//    center.x = self.view.center.x;
//    _guidePageController.center = center;
//    _guidePageController.numberOfPages = _pictureArr.count;
//    _guidePageController.currentPage = 0;
//    [self.view addSubview:_guidePageController];
//}

//设置scrollview
-(void)setScrollView{
    _guideScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _guideScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*_pictureArr.count, SCREEN_HEIGHT);
    _guideScrollView.pagingEnabled = YES;
    _guideScrollView.showsVerticalScrollIndicator = NO;
    _guideScrollView.showsHorizontalScrollIndicator = NO;
    _guideScrollView.alwaysBounceVertical = NO;
    _guideScrollView.alwaysBounceHorizontal = NO;
    _guideScrollView.bounces = NO;
    _guideScrollView.delegate = self;
    [self.view addSubview:_guideScrollView];
}

//设置ImageView
-(void)setImageView{
    for (int i = 0; i<_pictureArr.count; i++) {
        _guideImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_pictureArr[i]]];
        _guideImageView.userInteractionEnabled = YES;
        _guideImageView.frame = CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [_guideScrollView addSubview:_guideImageView];
        if (i == _pictureArr.count - 1) {
            [_guideImageView addSubview:self.enterBtn];
            [_enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(300/667.0*SCREEN_HEIGHT, 40/667.0*SCREEN_HEIGHT));
                make.centerX.mas_equalTo(_guideImageView.mas_centerX);
                make.bottom.mas_equalTo(_guideImageView.mas_bottom).with.offset(-50/667.0*SCREEN_HEIGHT);
            }];
        }
    }
}

-(UIButton *)enterBtn{
    if (!_enterBtn) {
        _enterBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _enterBtn.backgroundColor = [UIColor clearColor];
        [_enterBtn addTarget:self action:@selector(clickSkips:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterBtn;
}

//点击『立即使用』按钮
-(void)clickSkips:(UIButton*)sender{
    FSTabBarController *tab = [[FSTabBarController alloc] init];
    [tab setSelectedIndex:0];
    [self presentViewController:tab animated:YES completion:nil];
}

//UIScrollViewDelegate
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    int index = fabs(scrollView.contentOffset.x/SCREEN_WIDTH);
//    _guidePageController.currentPage = index;
//    //如果是最后一个页面UIPageControl隐藏
//    if (index == _pictureArr.count-1) {
//        _guidePageController.hidden = YES;
//    }//如果不是显示
//    else{
//       _guidePageController.hidden = NO;
//    }
//    
//}


@end
