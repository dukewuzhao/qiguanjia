//
//  CFSettingTableViewController.m
//  TableViewSettingList
//
//  Created by wangchangfei on 15/9/24.
//  Copyright (c) 2015年 wangchangfei. All rights reserved.
//

#import "CFSettingTableViewController.h"

#import "CFSettingCell.h"
#import "CFSettingItem.h"
#import "CFSettingArrowItem.h"
#import "CFSettingSwitchItem.h"
#import "CFSettingLabelArrowItem.h"
#import "CFSettingIconArrowItem.h"
#import "CFSettingGroup.h"
#import "Const.h"


const CGFloat sectionHeight = 20;

@interface CFSettingTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *table;

@end

@implementation CFSettingTableViewController

- (NSMutableArray *)dataList {
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    
    return _dataList;
}

// 初始化方法
//- (instancetype)init {
//    return [super initWithStyle:UITableViewStyleGrouped];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置tableView的背景颜色
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, navHeight, self.view.frame.size.width, ScreenHeight - navHeight +20) style:UITableViewStyleGrouped];
    table.dataSource = self;
    table.delegate = self;
    //table.bounces = NO;
    // 设置tableView的背景颜色
    table.backgroundView = nil;
    table.backgroundColor = [QFTools colorWithHexString:@"#ebecf2"];
    [self.view addSubview:table];
    self.table = table;
    // 适配iOS7的组间距
    if (iOS7) {
        self.table.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CFSettingGroup *group = self.dataList[section];
    
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 创建cell
    CFSettingCell *cell = [[CFSettingCell class] cellWithTableView:tableView];
    
    // 设置参数
    cell.backgroundColor_Normal = self.backgroundColor_Normal;
    cell.backgroundColor_Selected = self.backgroundColor_Selected;
    cell.iconArrow = self.icon_arrow;
    cell.rightLabelFont = self.rightLabelFont;
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        cell.rightLabelFontColor = [QFTools colorWithHexString:MainColor];
    }else{
        cell.rightLabelFontColor = self.rightLabelFontColor;
    }
    
    // 取出模型
    CFSettingGroup *group = self.dataList[indexPath.section];
    CFSettingItem  *item = group.items[indexPath.row];
    
    // 传递模型
    cell.item = item;
    cell.indexPath = indexPath;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath :(NSIndexPath *)indexPath {
    CFSettingGroup *group = self.dataList[indexPath.section];
    CFSettingItem  *item = group.items[indexPath.row];
    return item.cellHeight > 0 ? item.cellHeight : 50;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CFSettingGroup *group = self.dataList[section];
    if(group.headerHeight > 0){
        return group.headerHeight;
    }
    else {
        return sectionHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CFSettingGroup *group = self.dataList[section];
    if(group.footerHeight > 0){
        return group.footerHeight;
    }
    else {
        return 0.01;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    CFSettingGroup *group = self.dataList[section];
    return group.header;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    CFSettingGroup *group = self.dataList[section];
    return group.footer;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CFSettingGroup *group = self.dataList[section];
    return group.headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    CFSettingGroup *group = self.dataList[section];
    return group.footerrView;
}

/**
 *  点击某一行cell
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 取出模型
    CFSettingGroup *group = self.dataList[indexPath.section];
    CFSettingItem  *item = group.items[indexPath.row];
    
    // 执行操作
    if (item.opration) {
        item.opration();
        return;
    }
    
    if ([item isKindOfClass:[CFSettingArrowItem class]]) { // 需要跳转控制器
        CFSettingArrowItem *arrowItem = (CFSettingArrowItem *)item;
        
        // 创建跳转的控制器
        if (arrowItem.destVcClass) {
            UIViewController *vc = [[arrowItem.destVcClass alloc] init];
            vc.title = item.title;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if ([item isKindOfClass:[CFSettingLabelArrowItem class]]) { // 需要跳转控制器
        CFSettingLabelArrowItem *arrowItem = (CFSettingLabelArrowItem *)item;
        
        // 创建跳转的控制器
        if (arrowItem.destVcClass) {
            UIViewController *vc = [[arrowItem.destVcClass alloc] init];
            vc.title = item.title;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if ([item isKindOfClass:[CFSettingIconArrowItem class]]) { // 需要跳转控制器
        CFSettingIconArrowItem *iconArrowItem = (CFSettingIconArrowItem *)item;
        
        // 创建跳转的控制器
        if (iconArrowItem.destVcClass) {
            UIViewController *vc = [[iconArrowItem.destVcClass alloc] init];
            vc.title = item.title;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}


@end
