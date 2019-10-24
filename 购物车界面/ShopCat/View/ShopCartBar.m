//
//  ShopCartBar.m
//  购物车界面
//
//  Created by 许明洋 on 2019/8/30.
//  Copyright © 2019 许明洋. All rights reserved.
//


#import "ShopCartBar.h"
#import <ReactiveObjC/ReactiveObjC.h>

static NSInteger const BalanceButtonTag = 120;
static NSInteger const DeleteButtonTag = 121;
static NSInteger const SelectButtonTag = 122;

@interface UIImage (JS)
+ (UIImage *)imageWithColor : (UIColor *)color;

@end

@implementation UIImage(JS)

+ (UIImage *)imageWithColor : (UIColor *)color{
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

@interface ShopCartBar()

@end

@implementation ShopCartBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBarUI];
    }
    return self;
}

- (void)setBarUI {
    self.backgroundColor = [UIColor clearColor];
    /*背景*/
    UIVisualEffectView *effictView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    effictView.userInteractionEnabled = NO;
    effictView.frame = self.bounds;
    [self addSubview:effictView];
    
    CGFloat wd = [[UIScreen mainScreen] bounds].size.width * 2/7;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:(210)/255.0 green:(210)/255.0 blue:(210)/255.0 alpha:(1)];
    [self addSubview:lineView];
    
    /*结算*/
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
    [button setTitle:@"结算" forState:UIControlStateNormal];
    [button setFrame:CGRectMake([[UIScreen mainScreen]bounds].size.width - wd, 0, wd, self.frame.size.height)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    button.enabled = NO;
    button.tag = BalanceButtonTag;
    [self addSubview:button];
    _balanceButton = button;
    
    /*删除*/
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
    [button1 setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
    [button1 setTitle:@"删除" forState:UIControlStateNormal];
    [button1 setFrame:CGRectMake([[UIScreen mainScreen]bounds].size.width - wd, 0, wd, self.frame.size.height)];
    button1.enabled = NO;
    button1.hidden = YES;
    button1.tag = DeleteButtonTag;
    [self addSubview:button1];
    _deleteButton = button1;
    
    /*全选*/
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button3 setTitle:@"全选" forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button3 setImage:[UIImage imageNamed:@"xn_circle_normal"] forState:UIControlStateNormal];
    [button3 setImage:[UIImage imageNamed:@"xn_circle_select"] forState:UIControlStateSelected];
    [button3 setFrame:CGRectMake(0, 0, 78, self.frame.size.height)];
    [button3 setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    button3.tag = SelectButtonTag;
    [self addSubview:button3];
    _selectAllButton = button3;
    
    /*价格*/
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(wd, 0, [[UIScreen mainScreen] bounds].size.width - wd*2 - 5, self.frame.size.height)];
    label1.text = [NSString stringWithFormat:@"总计¥：%@",@(00.00)];
    label1.textColor = [UIColor blackColor];
    label1.font = [UIFont systemFontOfSize:15];
    label1.textAlignment = NSTextAlignmentRight;
    [self addSubview:label1];
    _allMoneyLabel = label1;
    
    /* assign value*/
    @weakify(self)
    [RACObserve(self, money) subscribeNext:^(NSNumber *x) {
        @strongify(self)
        self.allMoneyLabel.text = [NSString stringWithFormat:@"总计￥:%.2f",x.floatValue];
    }];
    
    /*RAC BLIND*/
    RACSignal *comBineSingal = [RACSignal combineLatest:@[RACObserve(self, money)] reduce:^id (NSNumber *money){
        if (money.floatValue == 0) {
            self.selectAllButton.selected = NO;
        }
        return @(money.floatValue > 0);
    }];
    RAC(self.balanceButton,enabled) = comBineSingal;
    RAC(self.deleteButton,enabled) = comBineSingal;
    
    [RACObserve(self, isNormalState) subscribeNext:^(NSNumber *x) {
        @strongify(self)
        BOOL isNormal = x.boolValue;
        self.balanceButton.hidden = !isNormal;
        self.allMoneyLabel.hidden = !isNormal;
        self.deleteButton.hidden = isNormal;
    }];
    
}


@end
