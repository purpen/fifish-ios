//
//  AddreesPickerViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/28.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "AddreesPickerViewController.h"
#import "FBAPI.h"
#import "FBRequest.h"
#import "AreaModel.h"

@interface AddreesPickerViewController ()<FBRequestDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSMutableArray *_provincesAry;
    NSMutableArray *_cityAry;
    BOOL _flag;
}


@property (nonatomic, assign) NSInteger provinceRow;

@end

@implementation AddreesPickerViewController


#pragma mark - UIPickerViewDataSource &Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            return _provincesAry.count;
        }
            break;
        case 1:
        {
            return [_cityAry[self.provinceRow] count];
        }
            break;
        default:
            return 0;
            break;
    }
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        pickerLabel.font = [UIFont systemFontOfSize:12];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}


- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    
    switch (component) {
        case 0:
        {
            AreaModel * area = _provincesAry[row];
            return area.name;
        }
            break;
        case 1:
        {
            AreaModel * area = _cityAry[self.provinceRow][row];
            return area.name;
        }
            break;
        default:
            return @"";
            break;
    }
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    switch (component) {
        case 0:
        {
            AreaModel * province = _provincesAry[row];
            self.provinceId = province.idField;
            self.provinceStr = province.name;
            
            self.provinceRow = [pickerView selectedRowInComponent:0];
            
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            AreaModel * city = _cityAry[row][0];
            self.cityId = city.idField;
            self.cityStr = city.name;
        }
            break;
        case 1:
        {
            AreaModel * city = _cityAry[self.provinceRow][row];
            self.cityId = city.idField;
            self.cityStr = city.name;
        }
            break;
        default:
            break;
    }
}


//-(void)requestSucess:(FBRequest *)request result:(id)result{
//    if ([request.flag isEqualToString:@"/shopping/fetch_areas"]) {
//        if ([result objectForKey:@"success"]) {
//            NSDictionary *dataDict = [result objectForKey:@"data"];
//            NSArray *rowsAry = [dataDict objectForKey:@"rows"];
//            for (NSDictionary *rowsDict in rowsAry) {
//                AddreesModel *model = [[AddreesModel alloc] init];
//                model.id = rowsDict[@"_id"];
//                model.city = rowsDict[@"city"];
//                
//                
//            }
//        }
//    }
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.addreesBtn.dataSource = self;
    self.addreesBtn.delegate = self;
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.3];
    _provincesAry = [NSMutableArray array];
    _cityAry = [NSMutableArray array];
    //        FBRequest *request = [FBAPI postWithUrlString:@"/shopping/fetch_areas" requestDictionary:nil delegate:self];
    //        request.flag = @"/shopping/fetch_areas";
    //        [request startRequest];
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"areas" ofType:@"plist"];
    NSArray * areaAry = [NSArray arrayWithContentsOfFile:filePath];
    for (NSDictionary * provinceDic in areaAry) {
        AreaModel * province = [[AreaModel alloc] initWithDictionary:provinceDic];
        [_provincesAry addObject:province];
        NSArray * citiesAry = [provinceDic objectForKey:@"children"];
        NSMutableArray * cityOfProAry = [NSMutableArray array];
        for (NSDictionary * cityDic in citiesAry) {
            AreaModel * city = [[AreaModel alloc] initWithDictionary:cityDic];
            [cityOfProAry addObject:city];
        }
        [_cityAry addObject:cityOfProAry];
    }
    
    [self.addreesBtn reloadAllComponents];
    self.provinceStr = @"北京";
    self.cityStr = @"东城区";
    self.provinceId = 1;
    self.cityId = 61;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
