//
//  FSSearchViewController.m
//  Fifish
//
//  Created by THN-Dong on 16/9/23.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSSearchViewController.h"
#import "SGTopTitleView.h"
#import "UIColor+FSExtension.h"
#import "UIView+FSExtension.h"

@interface FSSearchViewController () <UISearchBarDelegate, SGTopTitleViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *cancelBTn;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
/**  */
@property (nonatomic, strong) SGTopTitleView *segmentedControl;
/**
    1、视频
    2、图片
    3、用户 
 */
@property (nonatomic, strong) NSNumber *type;
/**  */
@property (nonatomic, strong) NSMutableArray *modelAry;
/**  */
@property (nonatomic, strong) UITableView *myTableView;

@end

@implementation FSSearchViewController

-(NSMutableArray *)modelAry{
    if (!_modelAry) {
        _modelAry = [NSMutableArray array];
    }
    return _modelAry;
}

-(UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.segmentedControl.y + self.segmentedControl.height, SCREEN_WIDTH, SCREEN_HEIGHT - _myTableView.y)];
    }
    return _myTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.delegate = self;
    self.type = @(1);
}

-(SGTopTitleView *)segmentedControl{
    if (!_segmentedControl) {
        _segmentedControl = [[SGTopTitleView alloc] initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH, 44)];
        _segmentedControl.staticTitleArr = @[NSLocalizedString(@"video", nil), NSLocalizedString(@"picture", nil), NSLocalizedString(@"user", nil)];
        _segmentedControl.backgroundColor = [UIColor whiteColor];
        _segmentedControl.delegate_SG = self;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 65 + 44, SCREEN_WIDTH, 1)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
        [self.view addSubview:lineView];
    }
    return _segmentedControl;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (searchBar.text.length == 0) {
        
    } else {
        [self.view addSubview:self.segmentedControl];
        [self.view endEditing:YES];
    }
}

#pragma mark - - - SGTopScrollMenu代理方法
- (void)SGTopTitleView:(SGTopTitleView *)topTitleView didSelectTitleAtIndex:(NSInteger)index {
    self.type = [NSNumber numberWithInteger:index];
    if (index == 5) {
        self.type = [NSNumber numberWithInteger:8];
    }
    [self.modelAry removeAllObjects];
    //进行网络请求
    
}

- (IBAction)cancelClick:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
