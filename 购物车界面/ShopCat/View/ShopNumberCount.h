//
//  ShopNumberCount.h
//  购物车界面
//
//  Created by 许明洋 on 2019/8/30.
//  Copyright © 2019 许明洋. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ShopNumberChangeBlock)(NSInteger count);

@interface ShopNumberCount : UIView
/**
 总数
 */
@property (nonatomic,assign) NSInteger totalNum;
/**
 当前显示价格
 */
@property (nonatomic,assign) NSInteger currentCountNumber;
/**
 数量改变回调
 */
@property (nonatomic,copy) ShopNumberChangeBlock NumberChangeBlock;

@end

NS_ASSUME_NONNULL_END
