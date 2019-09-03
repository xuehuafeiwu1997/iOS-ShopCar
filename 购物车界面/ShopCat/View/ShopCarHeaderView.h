//
//  ShopCarHeaderView.h
//  购物车界面
//
//  Created by 许明洋 on 2019/8/30.
//  Copyright © 2019 许明洋. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShopCarHeaderView : UITableViewHeaderFooterView

@property (nonatomic,strong) UIButton *selectStoreGoodsButton;

+ (CGFloat)getCartHeaderHeight;

@end

NS_ASSUME_NONNULL_END
