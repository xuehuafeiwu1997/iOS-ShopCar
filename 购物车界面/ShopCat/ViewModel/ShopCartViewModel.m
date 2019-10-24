//
//  ShopCartViewModel.m
//  购物车界面
//
//  Created by 许明洋 on 2019/8/30.
//  Copyright © 2019 许明洋. All rights reserved.
//

#import "ShopCartViewModel.h"
#import "ShopCartModel.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface ShopCartViewModel(){
    
    NSArray *_shopGoodsCount;
    NSArray *_goodsPicArray;
    NSArray *_goodsPriceArray;
    NSArray *_goodsQuantityArray;
}

//随机获取店铺下商品数
@property (nonatomic,assign) NSInteger random;

@end

@implementation ShopCartViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _shopGoodsCount = @[@(1),@(8),@(5),@(2),@(4),@(4)];
        _goodsPicArray = @[@"http://pic.5tu.cn/uploads/allimg/1606/pic_5tu_big_2016052901023305535.jpg",
                           @"http://pic.5tu.cn/uploads/allimg/1605/pic_5tu_big_2016052901023303745.jpg",
                           @"http://pic.5tu.cn/uploads/allimg/1605/pic_5tu_big_201605291711245481.jpg",
                           @"http://pic.5tu.cn/uploads/allimg/1605/pic_5tu_big_2016052901023285762.jpg",
                           @"http://pic.5tu.cn/uploads/allimg/1506/091630516760.jpg",
                           @"http://pic.5tu.cn/uploads/allimg/1506/091630516760.jpg"];
        _goodsPriceArray = @[@(30.45),@(120.09),@(7.8),@(11.11),@(56.1),@(12)];
        _goodsQuantityArray = @[@(12),@(21),@(1),@(10),@(3),@(5)];
    }
    return self;
}

//这是写的一个随机函数
- (NSInteger)random {
    NSInteger from = 0;
    NSInteger to = 5;
    return (NSInteger)(from + (arc4random() % (to - from + 1)));
}

#pragma mark - make data

- (void)getData {
    //数据个数
    NSInteger allCount = 20;
    NSInteger allGoodsCount = 0;
    NSMutableArray *storeArray = [NSMutableArray arrayWithCapacity:allCount];
    NSMutableArray *shopSelectArray = [NSMutableArray arrayWithCapacity:allCount];
    
    //创造店铺数据
    for (int i = 0; i < allCount; i++) {
        //创造店铺下商品数据
        NSInteger goodsCount = [_shopGoodsCount[self.random] intValue];
        NSMutableArray *goodsArray = [NSMutableArray arrayWithCapacity:goodsCount];
        for (int x = 0; x < goodsCount; x++) {
            ShopCartModel *cartModel = [[ShopCartModel alloc] init];
            cartModel.p_id = @"122115465400";
            cartModel.p_price = [_goodsPriceArray[self.random] floatValue];
            cartModel.p_name = [NSString stringWithFormat:@"%@这是一个很长很长的名字呀",@(x)];
            cartModel.p_stock = 22;
            cartModel.p_imageUrl = _goodsPicArray[self.random];
            cartModel.p_quantity = [_goodsQuantityArray[self.random] integerValue];
            [goodsArray addObject:cartModel];
            allGoodsCount++;
        }
        [storeArray addObject:goodsArray];
        //初始化时都没有被选中
        [shopSelectArray addObject:@(NO)];
    }
    self.cartData = storeArray;
    self.shopSelectArray = shopSelectArray;
    self.cartGoodsCount = allGoodsCount;
}

- (float)getAllPrices {
    __block float allPrices = 0;
    //店铺的数量
    NSInteger shopCount = self.cartData.count;
    NSInteger shopSelectCount = self.shopSelectArray.count;
    //如果店铺选中的数量等于店铺的数量
    if (shopSelectCount == shopCount && shopCount != 0) {
        self.isSelectAll = YES;
    }
    NSArray *priceArray = [[[self.cartData rac_sequence] map:^id _Nullable(NSMutableArray *value) {
        return [[[value rac_sequence] filter:^BOOL(ShopCartModel *model) {
            if (!model.isSelect) {
                self.isSelectAll = NO;
            }
            return model.isSelect;
        }] map:^id _Nullable(ShopCartModel *model) {
            return @(model.p_quantity * model.p_price);
        }];
    }] array];
    for (NSArray *priceA in priceArray) {
        for (NSNumber *price in priceA) {
            allPrices += price.floatValue;
        }
    }
    
    return allPrices;
}

- (void)selectAll:(BOOL)isSelect {
    __block float allPrices = 0;
    self.shopSelectArray = [[[[self.shopSelectArray rac_sequence]map:^id _Nullable(NSNumber *value) {
        return @(isSelect);
    }] array]mutableCopy];
    self.cartData = [[[[self.cartData rac_sequence] map:^id _Nullable(NSMutableArray *value) {
        return [[[[value rac_sequence] map:^id _Nullable(ShopCartModel *model) {
            [model setValue:@(isSelect) forKey:@"isSelect"];
            if (model.isSelect) {
                allPrices += model.p_quantity * model.p_price;
            }
            return model;
        }] array] mutableCopy];
    }] array] mutableCopy];
    self.allPrices = allPrices;
    [self.cartTableView reloadData];
}

- (void)rowSelect:(BOOL)isSelect IndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    NSMutableArray *goodsArray = self.cartData[section];
    NSInteger shopCount = goodsArray.count;
    ShopCartModel *model = goodsArray[row];
    [model setValue:@(isSelect) forKey:@"isSelect"];
    //判断是否都到达足够数量
    NSInteger isSelectShopCount = 0;
    for (ShopCartModel *model in goodsArray) {
        if (model.isSelect) {
            isSelectShopCount ++;
        }
    }
    [self.shopSelectArray replaceObjectAtIndex:section withObject:@(isSelectShopCount==shopCount?YES:NO)];
    [self.cartTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    
    /*重新计算价格*/
    self.allPrices = [self getAllPrices];
}

- (void)rowChangeQuanity:(NSInteger)quantity indexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    ShopCartModel *model = self.cartData[section][row];
    
    [model setValue:@(quantity) forKey:@"p_quantity"];
    
    [self.cartTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    
    /*重新计算价格*/
    self.allPrices = [self getAllPrices];
    
}

//左滑删除商品
- (void)deleteGoodsBySingleSlide:(NSIndexPath *)path {
    NSInteger section = path.section;
    NSInteger row = path.row;
    
    NSMutableArray *shopArray = self.cartData[section];
    [shopArray removeObjectAtIndex:row];
    if (shopArray.count == 0) {
        /*1.删除数据*/
        [self.cartData removeObjectAtIndex:section];
        /*2 删除shopSelectArray*/
        [self.shopSelectArray removeObjectAtIndex:section];
        [self.cartTableView reloadData];
    } else {
        //判断是否都到达足够数量
        NSInteger isSelectShopCount = 0;
        NSInteger shopCount = shopArray.count;
        for (ShopCartModel *model in shopArray) {
            if (model.isSelect) {
                isSelectShopCount++;
            }
        }
        [self.shopSelectArray replaceObjectAtIndex:section withObject:@(isSelectShopCount==shopCount?YES:NO)];
        [self.cartTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    }
    self.cartGoodsCount -= 1;
    /*重新计算价格*/
    self.allPrices = [self getAllPrices];
}

//选中删除
- (void)deleteGoodsBySelect {
    
    /*1 删除数据*/
    NSInteger index1 = -1;
    //选中的商店数量
    NSMutableIndexSet *shopSelectIndex = [NSMutableIndexSet indexSet];
    
    //cartData代表所有的数据，是一个二维数组，self.cartData[indexPath.section][indexPath.row]
    for (NSMutableArray *shopArray in self.cartData) {
        index1++;
        NSInteger index2 = -1;
        NSMutableIndexSet *selectIndexSet = [NSMutableIndexSet indexSet];
        for(ShopCartModel *model in shopArray){
            index2++;
            if (model.isSelect) {
                [selectIndexSet addIndex:index2];
            }
        }
        NSInteger shopCount = shopArray.count;
        NSInteger selectCount = selectIndexSet.count;
        //当一个店铺下所有的商品都被选中时
        if (selectCount == shopCount) {
            [shopSelectIndex addIndex:index1];
            self.cartGoodsCount -= selectCount;
        }
        [shopArray removeObjectsAtIndexes:selectIndexSet];
    }
    [self.cartData removeObjectsAtIndexes:shopSelectIndex];
    /*2 删除 shopSelectArray*/
    [self.shopSelectArray removeObjectsAtIndexes:shopSelectIndex];
    [self.cartTableView reloadData];
    /*3 carbar 恢复默认*/
    self.allPrices = 0;
    /*重新计算价格*/
    self.allPrices = [self getAllPrices];
    
}
@end


