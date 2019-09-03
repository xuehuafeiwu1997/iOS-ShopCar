//
//  ShopCartModel.h
//  购物车界面
//
//  Created by 许明洋 on 2019/8/30.
//  Copyright © 2019 许明洋. All rights reserved.
//

//modle主要用于记录商品的各个属性
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShopCartModel : NSObject

@property (nonatomic,strong) NSString *p_id;

@property (nonatomic,assign) float p_price;

@property (nonatomic,strong) NSString *p_name;

@property (nonatomic,strong) NSString *p_imageUrl;

@property (nonatomic,assign) NSInteger p_stock;

@property (nonatomic,assign) NSInteger p_quantity;

//商品是否被选中
@property (nonatomic,assign) BOOL isSelect;

@end

NS_ASSUME_NONNULL_END
