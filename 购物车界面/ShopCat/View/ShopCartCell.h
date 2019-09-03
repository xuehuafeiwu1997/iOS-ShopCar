//
//  ShopCartCell.h
//  购物车界面
//
//  Created by 许明洋 on 2019/8/30.
//  Copyright © 2019 许明洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopNumberCount.h"
#import "shopCartModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShopCartCell : UITableViewCell

@property (nonatomic,strong) UIButton *selectShopGoodsButtons;
@property (nonatomic,strong) ShopCartModel *model;
@property (nonatomic,strong) ShopNumberCount *numberCount;

+ (CGFloat)getCartCellHeight;

@end

NS_ASSUME_NONNULL_END
