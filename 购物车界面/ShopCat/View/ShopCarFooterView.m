//
//  ShopCarFooterView.m
//  购物车界面
//
//  Created by 许明洋 on 2019/8/30.
//  Copyright © 2019 许明洋. All rights reserved.
//

#import "ShopCarFooterView.h"
#import "ShopCartModel.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface ShopCarFooterView()

@property (nonatomic,strong) UILabel *priceLabel;

@end

@implementation ShopCarFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    //初始化父类构造方法
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self initCartFooterView];
    }
    return self;
}

- (void)initCartFooterView {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.textAlignment = NSTextAlignmentRight;
    _priceLabel.text = @"小记:¥15.80";
    _priceLabel.textColor = [UIColor redColor];
    [self addSubview:_priceLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _priceLabel.frame = CGRectMake(10, 0.5, [[UIScreen mainScreen]bounds].size.width - 20, 30);
}

- (void)setShopGoodsArray:(NSMutableArray *)shopGoodsArray {
    _shopGoodsArray = shopGoodsArray;
    
    NSArray *priceArray = [[[_shopGoodsArray rac_sequence] map:^id _Nullable(ShopCartModel *model) {
        return @(model.p_quantity*model.p_price);
    }] array];
    float shopPrice = 0;
    for (NSNumber *prices in priceArray) {
        shopPrice += prices.floatValue;
    }
    _priceLabel.text = [NSString stringWithFormat:@"小记:¥%.2f",shopPrice];
}

+ (CGFloat)getCartFooterHeight {
    
    return 30;
}
@end
