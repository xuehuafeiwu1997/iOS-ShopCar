//
//  ShopCarViewController.m
//  购物车界面
//
//  Created by 许明洋 on 2019/8/30.
//  Copyright © 2019 许明洋. All rights reserved.
//

#import "ShopCarViewController.h"
#import "ShopCartUIService.h"
#import "ShopCartViewModel.h"
#import "ShopCartBar.h"
#import "ShopCartCell.h"
#import "ShopCarHeaderView.h"
#import "ShopCarFooterView.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface ShopCarViewController () {
    BOOL _isEdit;
    UIBarButtonItem *_editItem;
    UIBarButtonItem *_makeDataItem;
}
@property (nonatomic,strong) ShopCartUIService *service;

@property (nonatomic,strong) ShopCartViewModel *viewModel;

@property (nonatomic,strong) UITableView *cartTableView;

@property (nonatomic,strong) ShopCartBar *cartBar;

@end

@implementation ShopCarViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getNewData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /*setting up*/
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.title = @"购物车";
    /*edit button*/
    _isEdit = NO;
    _makeDataItem = [[UIBarButtonItem alloc] initWithTitle:@"新数据" style:UIBarButtonItemStyleDone target:self action:@selector(makeNewData:)];
    _makeDataItem.tintColor = [UIColor redColor];
    self.navigationItem.leftBarButtonItem = _makeDataItem;
    
    _editItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(editClick:)];
    _editItem.tintColor = [UIColor colorWithRed:(170)/255.0 green:(170)/255.0 blue:(170)/255.0 alpha:(1)];
    self.navigationItem.rightBarButtonItem = _editItem;
    /*add view*/
    [self.view addSubview:self.cartTableView];
    [self.view addSubview:self.cartBar];
    
    /*RAC*/
    //全选
    [[self.cartBar.selectAllButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
        x.selected = !x.selected;
        [self.viewModel selectAll:x.selected];
    }];
    //删除
    [[self.cartBar.deleteButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
        [self.viewModel deleteGoodsBySelect];
    }];
    //结算
    [[self.cartBar.balanceButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
        
    }];
    /*观察价格属性*/
    @weakify(self)
    [RACObserve(self.viewModel, allPrices) subscribeNext:^(NSNumber *x) {
        @strongify(self)
        self.cartBar.money = x.floatValue;
    }];
    
    /*全选状态*/
    RAC(self.cartBar.selectAllButton,selected) = RACObserve(self.viewModel, isSelectAll);
    
    /*购物车数量*/
    [RACObserve(self.viewModel, cartGoodsCount)subscribeNext:^(NSNumber *x) {
        @strongify(self)
        if (x.integerValue == 0) {
            self.title = [NSString stringWithFormat:@"购物车"];
        } else {
            self.title = [NSString stringWithFormat:@"购物车%@",x];
        }
    }];
}

#pragma mark - lazy load

- (ShopCartViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ShopCartViewModel alloc] init];
        _viewModel.cartVC = self;
        _viewModel.cartTableView = self.cartTableView;
    }
    return _viewModel;
}

- (ShopCartUIService *)service {
    if (!_service) {
        _service = [[ShopCartUIService alloc] init];
        _service.viewModel = self.viewModel;
    }
    return _service;
}

- (UITableView *)cartTableView {
    if (!_cartTableView) {
        _cartTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        /**
         这部分是UITableViewCell注册的写法
         */
        [_cartTableView registerClass:[ShopCartCell class] forCellReuseIdentifier:@"ShopCartCell"];
        [_cartTableView registerClass:[ShopCarFooterView class] forHeaderFooterViewReuseIdentifier:@"ShopCartFooterView"];
        [_cartTableView registerClass:[ShopCarHeaderView class] forHeaderFooterViewReuseIdentifier:@"ShopCartHeaderView"];
        _cartTableView.dataSource = self.service;
        _cartTableView.delegate = self.service;
        _cartTableView.backgroundColor = [UIColor colorWithRed:(240)/255.0 green:(240)/255.0 blue:(240)/255.0 alpha:(1)];
        _cartTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 50)];
    }
    return _cartTableView;
}

- (ShopCartBar *)cartBar {
    if (!_cartBar) {
        _cartBar = [[ShopCartBar alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 50, [[UIScreen mainScreen] bounds].size.width, 50)];
        _cartBar.isNormalState = YES;
    }
    return _cartBar;
}

#pragma mark -method
- (void)getNewData {
    /**
     *获取数据
     */
    [self.viewModel getData];
    [self.cartTableView reloadData];
}

- (void)editClick:(UIBarButtonItem *)item {
    _isEdit = !_isEdit;
    NSString *itemTitle = _isEdit == YES ? @"完成":@"编辑";
    _editItem.title = itemTitle;
    self.cartBar.isNormalState = !_isEdit;
}

- (void)makeNewData:(UIBarButtonItem *)item {
    [self getNewData];
}


@end
