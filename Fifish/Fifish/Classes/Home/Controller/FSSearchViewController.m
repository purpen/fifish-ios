//
//  FSSearchViewController.m
//  Fifish
//
//  Created by THN-Dong on 16/9/23.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSSearchViewController.h"

@interface FSSearchViewController ()

@property (weak, nonatomic) IBOutlet UIButton *cancelBTn;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation FSSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)cancelClick:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
