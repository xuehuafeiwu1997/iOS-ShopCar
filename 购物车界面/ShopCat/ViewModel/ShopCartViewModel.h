//
//  ShopCartViewModel.h
//  购物车界面
//
//  Created by 许明洋 on 2019/8/30.
//  Copyright © 2019 许明洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopCarViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface ShopCartViewModel : NSObject

//为什么要用weak
@property (nonatomic,weak) ShopCarViewController *cartVC;

/**
 每个元素代表一个店铺
 */
@property (nonatomic,strong) NSMutableArray *cartData;

@property (nonatomic,weak) UITableView *cartTableView;

/**
 * 存放店铺选中
 */
@property (nonatomic,strong) NSMutableArray *shopSelectArray;

/**
 * carBar 观察的属性变化
 */
@property (nonatomic,assign) float allPrices;

/**
 *carBar 全选的状态
 */
@property (nonatomic,assign) BOOL isSelectAll;

/**
 *购物车商品数量
 */
@property (nonatomic,assign) NSInteger cartGoodsCount;

/**
 *当前所选商品数量
 */
@property (nonatomic,assign) NSInteger currentSelectCartGoodsCount;

//获取数据
- (void)getData;

//全选
- (void)selectAll:(BOOL)isSelect;

//row select
- (void)rowSelect:(BOOL)isSelect IndexPath:(NSIndexPath *)indexPath;

//row change quanity
-(void)rowChangeQuanity:(NSInteger)quantity indexPath:(NSIndexPath *)indexPath;

//获取价格
- (float)getAllPrices;

//左滑删除商品
- (void)deleteGoodsBySingleSlide:(NSIndexPath *)path;

//选中删除
- (void)deleteGoodsBySelect;
@end

NS_ASSUME_NONNULL_END
