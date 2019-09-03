//
//  ShopCartUIService.h
//  购物车界面
//
//  Created by 许明洋 on 2019/8/30.
//  Copyright © 2019 许明洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopCartViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShopCartUIService : NSObject<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) ShopCartViewModel *viewModel;

@end

NS_ASSUME_NONNULL_END
