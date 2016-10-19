//
//  FSAddTagViewController.m
//  Fifish
//
//  Created by THN-Dong on 2016/10/8.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FSAddTagViewController.h"
#import "FSTagModel.h"

@interface FSAddTagViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

/**  */
@property (nonatomic, strong) UITextField *tagsTextField;
/**  */
@property (nonatomic, strong) UITableView *searchList;
/**  */
@property (nonatomic, strong) UITableView *tagsList;
/**  */
@property (nonatomic, strong) FBRequest *hotTagsRequest;
/**  */
@property (nonatomic, strong) NSMutableArray *hotTagsMarr;
/**  */
@property (nonatomic, strong) FBRequest *searchRequest;
/**  */
@property (nonatomic, strong) NSMutableArray *searchTagsMarr;

@end

static NSString *const hotTagsCellID = @"HotTagsCellID";

@implementation FSAddTagViewController

-(NSMutableArray *)searchTagsMarr{
    if (!_searchTagsMarr) {
        _searchTagsMarr = [NSMutableArray array];
    }
    return _searchTagsMarr;
}

-(NSMutableArray *)hotTagsMarr{
    if (!_hotTagsMarr) {
        _hotTagsMarr = [NSMutableArray array];
    }
    return _hotTagsMarr;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tagsTextField resignFirstResponder];
}

- (IBAction)cancelClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewUI];
    [self networkHotTagsData];
}

- (void)networkHotTagsData {
    self.hotTagsRequest = [FBAPI getWithUrlString:@"/tags/sticks" requestDictionary:nil delegate:self];
    [self.hotTagsRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *dataAry = result[@"data"];
        self.hotTagsMarr = [FSTagModel mj_objectArrayWithKeyValuesArray:dataAry];
        [self.tagsList reloadData];
    } failure:^(FBRequest *request, NSError *error) {
    }];
}

#pragma mark - setUI
- (void)setViewUI {
    [self.view addSubview:self.tagsTextField];
    [self.view addSubview:self.tagsList];
    [self.view addSubview:self.searchList];
}

- (UITableView *)tagsList {
    if (!_tagsList) {
        _tagsList = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 44, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 44) style:(UITableViewStyleGrouped)];
        _tagsList.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
        _tagsList.delegate = self;
        _tagsList.dataSource = self;
        _tagsList.showsVerticalScrollIndicator = NO;
    }
    return _tagsList;
}

- (UITableView *)searchList {
    if (!_searchList) {
        _searchList = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 44) style:(UITableViewStylePlain)];
        _searchList.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
        _searchList.delegate = self;
        _searchList.dataSource = self;
        _searchList.showsVerticalScrollIndicator = NO;
    }
    return _searchList;
}



-(UITextField *)tagsTextField{
    if (!_tagsTextField) {
        _tagsTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
        _tagsTextField.delegate = self;
        _tagsTextField.backgroundColor = [UIColor whiteColor];
        _tagsTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 44)];
        _tagsTextField.leftViewMode = UITextFieldViewModeAlways;
        _tagsTextField.clearButtonMode = UITextFieldViewModeUnlessEditing;
        _tagsTextField.placeholder = NSLocalizedString(@"WriteAddTag", nil);
        _tagsTextField.font = [UIFont systemFontOfSize:12];
        _tagsTextField.textColor = [UIColor blackColor];
        _tagsTextField.returnKeyType = UIReturnKeyDone;
        [_tagsTextField addTarget:self action:@selector(beginSearchTag:) forControlEvents:UIControlEventEditingChanged];
        if (self.tags.length != 0) {
            _tagsTextField.text = self.tags;
        }
    }
    return _tagsTextField;
}

- (void)beginSearchTag:(UITextField *)textField {
    CGRect searchFrame = CGRectMake(0, 64 + 44, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 44);
    [UIView animateWithDuration:.3
                          delay:0
         usingSpringWithDamping:10.0
          initialSpringVelocity:5.0
                        options:(UIViewAnimationOptionCurveEaseInOut)
                     animations:^{
                         self.searchList.frame = searchFrame;
                     } completion:^(BOOL finished) {
                         if ([textField.text isEqualToString:@""]) {
                             self.searchList.hidden = YES;
                         } else {
                             self.searchList.hidden = NO;
                         }
                     }];
    
    if (![textField.text isEqualToString:@""]) {
        [self networkSearchTag:textField.text];
    }
}

- (void)networkSearchTag:(NSString *)text {
    self.searchRequest = [FBAPI getWithUrlString:@"/search/expanded" requestDictionary:@{@"q":text, @"size":@"20"} delegate:self];
    [self.searchRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *tagsArr = [[result valueForKey:@"data"] valueForKey:@"swords"];
        self.searchTagsMarr = [NSMutableArray arrayWithArray:tagsArr];
        [self.searchList reloadData];
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.addTagDelegate respondsToSelector:@selector(getTagName:andTagId:)]) {
            [self.addTagDelegate getTagName:textField.text andTagId:@""];
        }
    }];
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.tagsList) {
        return 1;
    } else if (tableView == self.searchList) {
        return 1;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tagsList) {
        return self.hotTagsMarr.count;
    } else if (tableView == self.searchList) {
        return self.searchTagsMarr.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tagsList) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:hotTagsCellID];
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:hotTagsCellID];
        if (self.hotTagsMarr.count) {
            FSTagModel *model = self.hotTagsMarr[indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"#%@ ", model.name];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (tableView == self.searchList) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchListCellID"];
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"searchListCellID"];
        if (self.searchTagsMarr.count) {
            cell.textLabel.text = [NSString stringWithFormat:@"#%@ ", self.searchTagsMarr[indexPath.row]];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.tagsList) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        headerView.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
        UILabel *headerLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 44)];
        headerLab.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
        headerLab.font = [UIFont systemFontOfSize:12];
        headerLab.textColor = [UIColor colorWithHexString:@"#999999"];
        headerLab.text = NSLocalizedString(@"recommendTag", nil);
        [headerView addSubview:headerLab];
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.tagsList) {
        if (self.hotTagsMarr.count) {
            return 44;
        } else {
            return 0.01;
        }
    } else if (tableView == self.searchList) {
        return 0.01;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissViewControllerAnimated:YES completion:^{
        if (tableView == self.tagsList) {
            if (self.tagsTextField.text.length == 0) {
                if ([self.addTagDelegate respondsToSelector:@selector(getTagName:andTagId:)]) {
                    [self.addTagDelegate getTagName:self.tagsTextField.text andTagId:@""];
                }
            }
            FSTagModel *model = self.hotTagsMarr[indexPath.row];
            if ([self.addTagDelegate respondsToSelector:@selector(getTagName:andTagId:)]) {
                [self.addTagDelegate getTagName:model.name andTagId:model.tagId];
            }
        } else if (tableView == self.searchList) {
            if (self.tagsTextField.text.length == 0) {
                if ([self.addTagDelegate respondsToSelector:@selector(getTagName:andTagId:)]) {
                    [self.addTagDelegate getTagName:self.searchTagsMarr[indexPath.row] andTagId:@""];
                }
            }
        }
    }];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.tagsTextField resignFirstResponder];
}

@end
