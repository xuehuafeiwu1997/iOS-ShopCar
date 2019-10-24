//
//  ShopCartCell.m
//  购物车界面
//
//  Created by 许明洋 on 2019/8/30.
//  Copyright © 2019 许明洋. All rights reserved.
//

#import "ShopCartCell.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface ShopCartCell()

@property (nonatomic,strong) UILabel *goodsNameLabel;
@property (nonatomic,strong) UILabel *GoodsPricesLabel;
@property (nonatomic,strong) UIImageView *goodsImageView;

@end

@implementation ShopCartCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self=[super initWithStyle:style
         reuseIdentifier:reuseIdentifier];
    if (self == [super initWithStyle:style
                     reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        [self initView];
//    }
//    return self;
//}

- (void) initView{
    
    //单元格中选中商品按钮
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setImage:[UIImage imageNamed:@"xn_circle_normal"] forState:UIControlStateNormal];
    [button1 setImage:[UIImage imageNamed:@"xn_circle_select"] forState:UIControlStateSelected];
    //[button1 setFrame:CGRectMake(0, 0, 35, 100)];
    [self.contentView addSubview:button1];
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(button1.superview);
        make.width.equalTo(@35);
    }];
    _selectShopGoodsButtons = button1;
    
    
    //商品图片的设置
    UIImageView *imageView = [[UIImageView alloc] init];
    //imageView.frame = CGRectMake(37, 8, 84, 84);
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(button1.mas_right).offset(50);
        make.top.equalTo(button1.mas_top);
        make.bottom.equalTo(button1.mas_bottom);
        make.width.equalTo(@84);
    }];
    _goodsImageView = imageView;
    
    //商品名称标签设置
    UILabel *label = [[UILabel alloc] init];
    //label.frame = CGRectMake(129, 8, 183, 37);
    label.text = @"这是一款商品这是一款商品这是一款商品";
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(label.superview);
        make.left.equalTo(imageView.mas_right);
        make.height.equalTo(@37);
    }];
    _goodsNameLabel = label;
    
    //商品价格标签设置
    UILabel *label1 = [[UILabel alloc] init];
    //label1.frame = CGRectMake(129, 52, 68, 39);
    label1.text = @"¥99.00";
    label1.textColor = [UIColor redColor];
    label1.backgroundColor = [UIColor whiteColor];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(label1.superview);
        make.top.equalTo(label.mas_bottom);
        make.width.equalTo(@68);
        make.left.equalTo(imageView.mas_right);
    }];
    _GoodsPricesLabel = label1;
    
    //设置封装的NumberCount的位置
    //因为NumberCount继承自UIView,所以可以将其当成控件进行操作
    //self.numberCount.frame = CGRectMake(198, 60, 114, 31);
    
    self.numberCount = [[ShopNumberCount alloc] init];
    [self.contentView addSubview:self.numberCount];
    [self.numberCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.numberCount.superview);
        make.centerY.equalTo(label1.mas_centerY);
        make.width.equalTo(@114);
        make.height.equalTo(@31);
    }];
    
}

- (void)setModel:(ShopCartModel *)model {
    self.goodsNameLabel.text = model.p_name;
    self.GoodsPricesLabel.text = [NSString stringWithFormat:@"¥%.2f",model.p_price];
    self.numberCount.totalNum = model.p_stock; 
    self.numberCount.currentCountNumber = model.p_quantity;
    self.selectShopGoodsButtons.selected = model.isSelect;
}

+ (CGFloat)getCartCellHeight {
    return 100;
}

//模型渲染
- (void)renderWithModel:(ShopCartModel *)model {
//    if ([model isKindOfClass:[ShopCartModel class]]) {
//        ShopCartModel *CartModel = model;
//        [self.imageView sd_setImageWithURL:[NSURL URLWithString:CartModel.p_imageUrl]];
//    }
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.p_imageUrl]?:nil];
}


@end
