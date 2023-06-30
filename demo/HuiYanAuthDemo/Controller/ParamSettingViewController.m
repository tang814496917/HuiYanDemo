//
//  ParamSettingViewController.m
//  HuiYanAuthDemo
//
//  Created by Jack T on 2023/6/13.
//  Copyright © 2023 tencent. All rights reserved.
//

#import "ParamSettingViewController.h"
#import "Masonry.h"
#import "SettingSelectedCell.h"
#import "SettingHeaderView.h"
#import "AlgorithmHeaderView.h"
#import "HYConfigManager.h"
#import "HYCommonToast.h"
@interface ParamSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) NSArray *sectionTitleArray;

@property (nonatomic, strong) NSArray *rowTitleArray;

@property (nonatomic ,strong) UITextField * successTF;

@property (nonatomic ,strong) UITextField * failureTF;

@property (nonatomic ,strong) UITextField * hostUrlTF;

@end

@implementation ParamSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"参数设置";
    self.view.backgroundColor = [UIColor colorWithRed:247/255.f green:247/255.f blue:247/255.f alpha:1];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(12, 12, 113, 12));
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.height.offset(113);
    }];
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"nav_back_black.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)backItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headerViewId = @"SettingHeaderView";
    if (section == 13){
        AlgorithmHeaderView *lastHeaderView = [[AlgorithmHeaderView alloc]initWithFrame:CGRectMake(12,0,self.view.bounds.size.width-24, 44)];
        lastHeaderView.titleLab.text = self.sectionTitleArray[section];
        return lastHeaderView;
    }else{
        SettingHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewId];
        if (!headerView){
            headerView = [[SettingHeaderView alloc]initWithFrame:CGRectMake(0,0,self.view.bounds.size.width, 44)];
        }
        [self updateDataWith:headerView section:section];
        headerView.bottomLineView.hidden = section == 8?YES:NO;
        headerView.titleLab.text = self.sectionTitleArray[section];
        __weak ParamSettingViewController *weakSelf = self;
        headerView.switchChangedCalledBack = ^(BOOL isOn) {
            [weakSelf headerViewWithSection:section switchChanged:isOn];
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
        };
        headerView.increaseBtnCalledBack = ^{
            if (section == 0){
                NSInteger num = [HYConfigManager shareInstance].restartCount;
                num = num + 1;
                [HYConfigManager shareInstance].restartCount = num;
            }else if (section == 3){
                NSInteger num = [HYConfigManager shareInstance].prepareTimeOut;
                num = num + 1000;
                [HYConfigManager shareInstance].prepareTimeOut = num;
            }else if (section == 6){
                NSInteger num = [HYConfigManager shareInstance].actionTimeoutMs;
                num = num + 1000;
                [HYConfigManager shareInstance].actionTimeoutMs = num;
            }
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
        };
        headerView.reduceBtnCalledBack = ^{
            if (section == 0){
                NSInteger  num = [HYConfigManager shareInstance].restartCount;
                num = num - 1;
                if (num <= 1) num = 1;
                [HYConfigManager shareInstance].restartCount = num;

            }else if (section == 3){
                NSInteger  num = [HYConfigManager shareInstance].prepareTimeOut;
                num = num - 1000;
                if (num <= 1000) num = 1000;
                [HYConfigManager shareInstance].prepareTimeOut = num;
            }else if (section == 6){
                NSInteger num = [HYConfigManager shareInstance].actionTimeoutMs;
                num = num - 1000;
                if (num <= 1000) num = 1000;
                [HYConfigManager shareInstance].actionTimeoutMs = num;
            }
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
        };
        headerView.circleSelectedCalledBack = ^(BOOL isSelected) {
            [HYConfigManager shareInstance].isNeverTimeOut = section == 2?YES:NO;
            [weakSelf.tableView reloadData];
        };
        return headerView;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionTitleArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 13) {
        return 240;
    } else if (section == 9 ){
        if ([HYConfigManager shareInstance].successPage){
            return 85;
        }
        return 50;
    } else if (section == 10){
        if ([HYConfigManager shareInstance].failurePage){
            return 85;
        }
        return 50;
    }else if (section == 12){
        return 85;
    }else{
        return 50;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 7 && [HYConfigManager shareInstance].action_data.count != 0){
        return self.rowTitleArray.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingSelectedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingSelectedCell" forIndexPath:indexPath];
    cell.titleLab.textColor = [UIColor colorWithRed:38/255.f green:40/255.f blue:46/255.f alpha:1];
    cell.bottomLineView.hidden = NO;
    if (indexPath.row == 0) {
        cell.switchBtn.hidden = NO;
        cell.selectedBtn.hidden = YES;
        cell.contentlab.hidden = YES;
       [cell.switchBtn setOn:[HYConfigManager shareInstance].action_random];
        __weak ParamSettingViewController *weakSelf = self;
        cell.switchChangedCalledBack = ^(BOOL isOn) {
            [HYConfigManager shareInstance].action_random = isOn;
            if (isOn){
                [HYConfigManager shareInstance].action_data = @[@1,@2,@3,@4];
            }
            [weakSelf.tableView reloadData];
        };
    } else if (indexPath.row == 1) {
        cell.switchBtn.hidden = YES;
        cell.selectedBtn.hidden = YES;
        cell.contentlab.hidden = YES;
    }else if (indexPath.row>1&&indexPath.row<=5){
        cell.switchBtn.hidden = YES;
        cell.selectedBtn.hidden = NO;
        cell.contentlab.hidden = YES;
        cell.titleLab.textColor = [UIColor colorWithRed:97/255.f green:103/255.f blue:117/255.f alpha:1];
        if(indexPath.row != 5)cell.bottomLineView.hidden = YES;
        if ([HYConfigManager shareInstance].action_random == YES){
            cell.selectedBtn.enabled = NO;
            cell.selectedBtn.type = HYButtonTypeEnable;
        }else{
            cell.selectedBtn.enabled = YES;
            cell.selectedBtn.selected = [[HYConfigManager shareInstance].action_data containsObject:@(indexPath.row-1)];
            cell.selectedBtn.type = [[HYConfigManager shareInstance].action_data containsObject:@(indexPath.row-1)];
        }
        __weak ParamSettingViewController *weakSelf = self;
        cell.selectedCalledBack = ^(BOOL isSelected) {
            NSMutableArray *dataArray = [HYConfigManager shareInstance].action_data.mutableCopy;
            if (isSelected) {
                [dataArray addObject:@(indexPath.row-1)];
            } else {
                [dataArray removeObject:@(indexPath.row-1)];
            }
            [HYConfigManager shareInstance].action_data = dataArray.count!=0?dataArray:@[];
            if (dataArray.count == 0){
                [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
            }else{
                [weakSelf.tableView reloadData];
            }
        };
    }else{
        cell.switchBtn.hidden = YES;
        cell.selectedBtn.hidden = YES;
        cell.contentlab.hidden = NO;
        if (indexPath.row == 6){
            cell.contentlab.text = [NSString stringWithFormat:@"%ld",[HYConfigManager shareInstance].action_data.count];
        }else if (indexPath.row == 7){
            NSMutableArray *strArray = [NSMutableArray array];
            NSDictionary *strDic = [self action_dataTranform];
            for (NSNumber *num in [HYConfigManager shareInstance].action_data) {
                if ([strDic valueForKey:num.stringValue]){
                    [strArray addObject:[strDic valueForKey:num.stringValue]];
                }
            }
            cell.contentlab.text = [strArray componentsJoinedByString:@","];
        }
    }
    cell.titleLab.text = self.rowTitleArray[indexPath.row];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (void)saveSetting{
    if ([HYConfigManager shareInstance].successPage){
        NSString *successPage = self.successTF?self.successTF.text:[HYConfigManager shareInstance].successPageStr;
        if (successPage.length<=0){
            [HYCommonToast showHudWithText:@"成功页面网址不能为空"];
            return;
        }
        if ([successPage hasPrefix:@"http://"]||[successPage hasPrefix:@"https://"]){
           
        }else{
            [HYCommonToast showHudWithText:@"成功页面网址不合法"];
            return;
        }
    }
    if ([HYConfigManager shareInstance].failurePage){
        NSString *failurePage = self.failureTF?self.failureTF.text:[HYConfigManager shareInstance].failurePageStr;
        if (failurePage.length<=0){
            [HYCommonToast showHudWithText:@"失败页面网址不能为空"];
            return;
        }
        if ([failurePage hasPrefix:@"http://"]||[failurePage hasPrefix:@"https://"]){
         
        }else{
            [HYCommonToast showHudWithText:@"失败页面网址不合法"];
            return;
        }
    }
    NSString *hostUrl = self.hostUrlTF?self.hostUrlTF.text:[HYConfigManager shareInstance].hostUrl;
    if (hostUrl.length<=0){
        [HYCommonToast showHudWithText:@"接口地址不能为空"];
        return;
    }
    if ([hostUrl hasPrefix:@"http://"]||[hostUrl hasPrefix:@"https://"]){
    }else{
        [HYCommonToast showHudWithText:@"接口地址不合法"];
        return;
    }
    [HYConfigManager shareInstance].successPageStr = self.successTF.text;
    [HYConfigManager shareInstance].failurePageStr = self.failureTF.text;
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)updateDataWith:(SettingHeaderView *)headerView section:(NSInteger)section{
    switch (section) {
        case 0:
            {
                headerView.type = SettingHeaderViewTypeIncreaseAndReduce;
                headerView.titleLab.textColor = [UIColor colorWithRed:38/255.f green:40/255.f blue:46/255.f alpha:1];
                headerView.contentlab.text = [NSString stringWithFormat:@"%ld",[HYConfigManager shareInstance].restartCount];
            }
            break;
        case 1:
            {
                headerView.type = SettingHeaderViewTypeText;
            }
            break;
        case 2:
            {
                headerView.type = SettingHeaderViewTypeCircleSelected;
                [headerView.circleBtn setSelected:[HYConfigManager shareInstance].isNeverTimeOut];
                headerView.contentlab.text = [NSString stringWithFormat:@"%ld",[HYConfigManager shareInstance].restartCount];

            }
            break;
        case 3:
            {
                headerView.type = SettingHeaderViewTypeCircleSelectedIncreaseAndReduce;
                [headerView.circleBtn setSelected:![HYConfigManager shareInstance].isNeverTimeOut];
                headerView.contentlab.text = [NSString stringWithFormat:@"%lds",[HYConfigManager shareInstance].prepareTimeOut/1000];
            }
            break;
        case 4:
            {
                headerView.type = SettingHeaderViewTypeSwitch;
                [headerView.switchBtn setOn:[HYConfigManager shareInstance].actref_ux_mode == 2?NO:YES];
            }
            break;
        case 5:
            {
                headerView.type = SettingHeaderViewTypeText;
            }
            break;
     
        case 6:
            {
                headerView.contentlab.text = [NSString stringWithFormat:@"%lds",[HYConfigManager shareInstance].actionTimeoutMs/1000];
                headerView.type = SettingHeaderViewTypeIncreaseAndReduce;
            }
            break;
        case 7:
            {
                headerView.type = SettingHeaderViewTypeSwitch;
                [headerView.switchBtn setOn:[HYConfigManager shareInstance].action_data.count==0?YES:NO animated:NO];
            }
            break;
        case 8:
            {
                headerView.type = SettingHeaderViewTypeSwitch;
                [headerView.switchBtn setOn:[HYConfigManager shareInstance].isNotMute];
            }
            break;
        case 9:
            {
                if([HYConfigManager shareInstance].successPage == YES){
                    headerView.type = SettingHeaderViewTypeSwitchAndText;
                    headerView.contentlab.text = [HYConfigManager shareInstance].successPageStr;
                }else{
                    headerView.type = SettingHeaderViewTypeSwitch;
                }
                self.successTF = headerView.contentlab;
                [headerView.switchBtn setOn:[HYConfigManager shareInstance].successPage];
            }
            break;
        case 10:
            {
                if([HYConfigManager shareInstance].failurePage == YES){
                    headerView.type = SettingHeaderViewTypeSwitchAndText;
                    headerView.contentlab.text = [HYConfigManager shareInstance].failurePageStr;
                }else{
                    headerView.type = SettingHeaderViewTypeSwitch;
                }
                self.failureTF = headerView.contentlab;
                [headerView.switchBtn setOn:[HYConfigManager shareInstance].failurePage];
            }
            break;
        case 11:
            {
                headerView.type = SettingHeaderViewTypeSwitch;
                [headerView.switchBtn setOn:[HYConfigManager shareInstance].isUseBestFaceImage];
            }
            break;
        case 12:
            {
                headerView.type = SettingHeaderViewTypeSwitchAndText;
                headerView.contentlab.text = [HYConfigManager shareInstance].hostUrl;
                self.hostUrlTF = headerView.contentlab;
                [headerView.switchBtn setHidden:YES];
            }
            break;
            
        default:
            break;
    }
}
- (void)headerViewWithSection:(NSInteger)section switchChanged:(BOOL )isOn{
    switch (section) {
        case 4:
        {
            [HYConfigManager shareInstance].actref_ux_mode = isOn?0:2;
        }
            break;
        case 7:
        {
            if (isOn){
                [HYConfigManager shareInstance].action_data = @[];
            }else{
                [HYConfigManager shareInstance].action_data = @[@1,@2,@3,@4];
            }
        }
            break;
        case 8:
        {
            [HYConfigManager shareInstance].isNotMute = isOn;
        }
            break;
        case 9:
        {
            [HYConfigManager shareInstance].successPage = isOn;
        }
            break;
        case 10:
        {
            [HYConfigManager shareInstance].failurePage = isOn;
        }
            break;
        case 11:
        {
            [HYConfigManager shareInstance].isUseBestFaceImage = isOn;
        }
            break;
            
            
        default:
            break;
    }
}
- (UITableView *)tableView
{
    if (!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        [_tableView registerClass:[SettingSelectedCell class] forCellReuseIdentifier:@"SettingSelectedCell"];
    }
    return _tableView;
}
- (UIView *)bottomView
{
    if (!_bottomView){
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.clipsToBounds = YES;
        _bottomView.layer.borderWidth = 1;
        _bottomView.layer.borderColor = [UIColor colorWithRed:233/255.f green:233/255.f blue:233/255.f alpha:1].CGColor;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor colorWithRed:207/255.f green:50/255.f blue:57/255.f alpha:1];
        button.clipsToBounds = YES;
        button.layer.cornerRadius = 4;
        [button setTitle:@"保存设置" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [button addTarget:self action:@selector(saveSetting) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_offset(0);
            make.left.mas_offset(16);
            make.height.offset(48);
            make.top.offset(20);
        }];
    }
    return _bottomView;
}
- (NSArray *)sectionTitleArray
{
    if(!_sectionTitleArray){
        _sectionTitleArray = @[@"允许重试次数",@"动作准备阶段设置",@"永不超时",@"自定义超时时间",@"炫光活体",@"每组动作时间设置",@"动作时长",@"默认检测动作",@"提示声音",@"成功结果页面",@"失败结果页面",@"最佳人脸压缩",@"接口地址",@"算法版本号："];
    }
    return _sectionTitleArray;
}
- (NSArray *)rowTitleArray
{
    if (!_rowTitleArray){
        _rowTitleArray = @[@"随机动作",@"动作选择",@"眨眼",@"张嘴",@"点头",@"摇头",@"动作个数",@"动作顺序"];
    }
    return _rowTitleArray;
}

- (NSDictionary *)action_dataTranform{
    return  @{
        @"1":@"眨眼",
        @"2":@"张嘴",
        @"3":@"点头",
        @"4":@"摇头",
    };
}
@end
