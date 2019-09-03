//
//  ShopCartUIService.m
//  购物车界面
//
//  Created by 许明洋 on 2019/8/30.
//  Copyright © 2019 许明洋. All rights reserved.
//

#import "ShopCartUIService.h"
#import "ShopCarHeaderView.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "ShopCartModel.h"
#import "ShopCarFooterView.h"
#import "ShopCartCell.h"

@implementation ShopCartUIService

#pragma mark - UITableViewDelegate/UITableViewDataSource

//组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.cartData.count;
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.cartData[section] count];
}

#pragma mark - header View
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [ShopCarHeaderView getCartHeaderHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSMutableArray *shopArray = self.viewModel.cartData[section];
    ShopCarHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ShopCartHeaderView"];
    //店铺全选
    [[[headerView.selectStoreGoodsButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:headerView.rac_prepareForReuseSignal] subscribeNext:^(UIButton * xx) {
        xx.selected = !xx.selected;
        BOOL isSelect = xx.selected;
        [self.viewModel.shopSelectArray replaceObjectAtIndex:section withObject:@(isSelect)];
        for (ShopCartModel *model in shopArray) {
            [model setValue:@(isSelect) forKey:@"isSelect"];
        }
        [self.viewModel.cartTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
        self.viewModel.allPrices = [self.viewModel getAllPrices];
    }];
    //店铺选中状态
    headerView.selectStoreGoodsButton.selected = [self.viewModel.shopSelectArray[section] boolValue];
    
    return headerView;
    
}

#pragma mark - footer view
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [ShopCarFooterView getCartFooterHeight];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    NSMutableArray *shopArray = self.viewModel.cartData[section];
    ShopCarFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ShopCartFooterView"];
    //在这里已经调用了shopGoodsArray的set方法，在set方法中已经对priceLabel进行了赋值
    footerView.shopGoodsArray = shopArray;
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ShopCartCell getCartCellHeight];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopCartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopCartCell"];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}
- (void)configureCell:(ShopCartCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    ShopCartModel *model = self.viewModel.cartData[section][row];
    //cell选中
    @weakify(self)
    
             [[[cell.selectShopGoodsButtons rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(UIButton  *x) {
                 @strongify(self)
                 x.selected = !x.selected;
                 [self.viewModel rowSelect:x.selected IndexPath:indexPath];
                 
             }];
    //数量改变
    cell.numberCount.NumberChangeBlock = ^(NSInteger changeCount) {
        @strongify(self)
        [self.viewModel rowChangeQuanity:changeCount indexPath:indexPath];
    };
    cell.model = model;
}

#pragma mark - delegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.viewModel deleteGoodsBySingleSlide:indexPath];
    }
}

@end
