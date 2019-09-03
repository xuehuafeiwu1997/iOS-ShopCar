//
//  ShopCarHeaderView.m
//  购物车界面
//
//  Created by 许明洋 on 2019/8/30.
//  Copyright © 2019 许明洋. All rights reserved.
//

#import "ShopCarHeaderView.h"

@interface ShopCarHeaderView()

@property (nonatomic,strong) UIButton *storeNameButton;

@end

@implementation ShopCarHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setHeaderUI];
    }
    return self;
}

- (void)setHeaderUI {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.selectStoreGoodsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectStoreGoodsButton.frame = CGRectZero;
    [self.selectStoreGoodsButton setImage:[UIImage imageNamed:@"xn_circle_normal"] forState:UIControlStateNormal];
    [self.selectStoreGoodsButton setImage:[UIImage imageNamed:@"xn_circle_select"] forState:UIControlStateSelected];
    self.selectStoreGoodsButton.backgroundColor = [UIColor clearColor];
    [self addSubview:self.selectStoreGoodsButton];
    
    self.storeNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.storeNameButton.frame = CGRectZero;
    [self.storeNameButton setTitle:@"店铺名字"
                          forState:UIControlStateNormal];
    
    /**
     使用注释的这段代码的话，“店铺名字”这几个字仍然是白色的，只有指定状态的时候才可以改变button控件中字体的颜色
     */
  //[self.storeNameButton setTintColor:[UIColor yellowColor]];
    [self.storeNameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.storeNameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.storeNameButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.storeNameButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.storeNameButton];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.selectStoreGoodsButton.frame = CGRectMake(0, 0, 36, 30);
    self.storeNameButton.frame = CGRectMake(40, 0, [[UIScreen mainScreen] bounds].size.width-40, 30);
}

+ (CGFloat)getCartHeaderHeight {
    return 30;
}


@end
