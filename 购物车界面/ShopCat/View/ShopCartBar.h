//
//  ShopCartBar.h
//  购物车界面
//
//  Created by 许明洋 on 2019/8/30.
//  Copyright © 2019 许明洋. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShopCartBar : UIView

//结算
@property (nonatomic,strong) UIButton *balanceButton;

//全选
@property (nonatomic,strong) UIButton *selectAllButton;

//价格
@property (nonatomic,strong) UILabel *allMoneyLabel;

//删除
@property (nonatomic,strong) UIButton *deleteButton;

@property (nonatomic,assign) BOOL isNormalState;
@property (nonatomic,assign) float money;
@end

NS_ASSUME_NONNULL_END
