//
//  FSAddressViewController.m
//  Fifish
//
//  Created by THN-Dong on 2016/10/9.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSAddressViewController.h"
#import "FSSearchBar.h"

@interface FSAddressViewController ()

@end

@implementation FSAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    FSSearchBar * searchBar = [[FSSearchBar alloc] initWithFrame:CGRectMake(10, 200, SCREEN_WIDTH - 20, 40) searchBarStyle:LGLSearchBarStyleDefault];
    [searchBar searchBarTextSearchTextBlock:^(NSString *searchText) {
        NSLog(@"%@", searchText);
    }];
    [self.view addSubview:searchBar];
}

@end
