//
//  ShopNumberCount.m
//  购物车界面
//
//  Created by 许明洋 on 2019/8/30.
//  Copyright © 2019 许明洋. All rights reserved.
//

#import "ShopNumberCount.h"
#import <ReactiveObjC/ReactiveObjC.h>

static CGFloat const Wd = 28;

@interface ShopNumberCount()
//加
@property (nonatomic,strong) UIButton *addButton;
//减
@property (nonatomic,strong) UIButton *subButton;
//数字按钮
@property (nonatomic,strong) UITextField *numberTT;

@end
@implementation ShopNumberCount

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

//这里少一部分awakeFromnib的代码

#pragma mark - setUI
- (void)setUI {
    self.backgroundColor = [UIColor clearColor];
    self.currentCountNumber = 0;
    self.totalNum = 0;
    @weakify(self)
    /*********************减***********************/
    _subButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _subButton.frame = CGRectMake(0, 0, Wd, Wd);
    [_subButton setBackgroundImage:[UIImage imageNamed:@"product_detail_sub_normal"] forState:UIControlStateNormal];
    [_subButton setBackgroundImage:[UIImage imageNamed:@"product_detail_sub_no"] forState:UIControlStateDisabled];
    _subButton.tag = 0;
    [[self.subButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
       @strongify(self)
        self.currentCountNumber --;
        if(self.NumberChangeBlock){
            self.NumberChangeBlock(self.currentCountNumber);
        }
    }];
    [self addSubview:_subButton];
    
    /***********************内容*************************************/
    self.numberTT = [[UITextField alloc] init];
    self.numberTT.frame = CGRectMake(CGRectGetMaxX(_subButton.frame), 0, Wd*1.5, _subButton.frame.size.height);
    self.numberTT.keyboardType = UIKeyboardTypeNumberPad;
    self.numberTT.text = [NSString stringWithFormat:@"%@",@(0)];
    self.numberTT.backgroundColor = [UIColor whiteColor];
    self.numberTT.textColor = [UIColor blackColor];
    self.numberTT.adjustsFontSizeToFitWidth = YES;
    self.numberTT.textAlignment = NSTextAlignmentCenter;
    self.numberTT.layer.borderColor = [UIColor colorWithRed:(201)/255.0 green:(201)/255.0 blue:(201)/255.0 alpha:(1)].CGColor;
    self.numberTT.layer.borderWidth = 1.3;
    self.numberTT.font = [UIFont systemFontOfSize:17];
    [self addSubview:self.numberTT];
    
    /***********************加*************************************/
    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addButton.frame = CGRectMake(CGRectGetMaxX(_numberTT.frame), 0, Wd, Wd);
    [_addButton setBackgroundImage:[UIImage imageNamed:@"product_detail_add_normal"] forState:UIControlStateNormal];
    [_addButton setBackgroundImage:[UIImage imageNamed:@"product_detail_add_no"] forState:UIControlStateDisabled];
    _addButton.tag = 1;
    [[self.addButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self)
        self.currentCountNumber++;
        if (self.NumberChangeBlock) {
            self.NumberChangeBlock(self.currentCountNumber);
        }
    }];
    [self addSubview:self.addButton];
    
    /***********************内容改变*************************************/
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"UITextFieldTextDidEndEditingNotification" object:self.numberTT] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        UITextField *t1 = [x object];
        NSString *text = t1.text;
        NSInteger changeNum = 0;
        if (text.integerValue > self.totalNum && self.totalNum != 0) {
            self.currentCountNumber = self.totalNum;
            self.numberTT.text = [NSString stringWithFormat:@"%@",@(self.totalNum)];
            changeNum = self.totalNum;
        } else if (text.integerValue < 1){
            self.numberTT.text = @"1";
            changeNum = 1;
        } else {
            self.currentCountNumber = text.integerValue;
            changeNum = self.currentCountNumber;
        }
        if (self.NumberChangeBlock) {
            self.NumberChangeBlock(self.currentCountNumber);
        }
    }];
    
    /*捆绑加减的enable*/
    RACSignal *subSignal = [RACObserve(self, currentCountNumber)map:^id _Nullable(NSNumber *subValue) {
        return @(subValue.integerValue>1);
    }];
    RACSignal *addSignal = [RACObserve(self, currentCountNumber)map:^id _Nullable(NSNumber *addValue) {
        return @(addValue.integerValue<self.totalNum);
    }];
    RAC(self.subButton,enabled)  = subSignal;
    RAC(self.addButton,enabled)  = addSignal;
    
    /*内容颜色显示*/
    RACSignal *numColorSignal = [RACObserve(self, totalNum)map:^id _Nullable(NSNumber  *totalValue) {
        return totalValue.integerValue ==0?[UIColor redColor]:[UIColor blackColor];
    }];
    RAC(self.numberTT,textColor) = numColorSignal;
    
    /*内容文本显示*/
    RACSignal *textSignal = [RACObserve(self, currentCountNumber)map:^id _Nullable(NSNumber *value) {
        return [NSString stringWithFormat:@"%@",value];
    }];
    RAC(self.numberTT,text) = textSignal;
}

@end
