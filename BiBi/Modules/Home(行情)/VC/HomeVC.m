//
//  HomeVC.m
//  BiBi
//
//  Created by frechai on 2018/4/3.
//  Copyright © 2018年 frechai. All rights reserved.
//

#import "HomeVC.h"
#import "MenuBtnView.h"
#import "QuotationCell.h"
#import "KLineVC.h"

@interface HomeVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) MenuBtnView *menuView;
@property (nonatomic, strong) NSArray *menuTitles;
@property (nonatomic, strong) UIScrollView *scrollview;

@property (nonatomic, strong) UITableView *MYTable;
@property (nonatomic, strong) UITableView *BTCTable;
@property (nonatomic, strong) UITableView *ETHTable;
@property (nonatomic, strong) UITableView *USDTTable;

@property (nonatomic, assign) CGFloat LineCenterX;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UITableView *currentTableView;
@property (nonatomic, strong) UITableView *preTableView;
@property (nonatomic, strong) NSMutableArray *tableviewArr;
@property (nonatomic, strong) MJRefreshNormalHeader *MJHeader;
@end

@implementation HomeVC

#pragma mark 控件懒加载
-(NSMutableArray *)tableviewArr
{
    if (!_tableviewArr) {
        _tableviewArr = [NSMutableArray new];
    }
    
    return _tableviewArr;
}


- (MenuBtnView *)menuView
{
    if (!_menuView) {
        kWeakSelf(self);
        _menuView  = [[MenuBtnView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50) bgColor:NormalColor selectColor:SelectedColor defaultColor:KWhiteColor titles:self.menuTitles block:^(NSInteger index) {
            weakself.LineCenterX = ScreenWidth/weakself.menuTitles.count*index+ScreenWidth/(weakself.menuTitles.count*2);
            [weakself.scrollview setContentOffset:CGPointMake(ScreenWidth*index, 0) animated:YES];
            
            //当前tableview索引
            [weakself.preTableView.mj_header endRefreshing];
            weakself.currentIndex = index;
            if (weakself.tableviewArr.count) {
                weakself.currentTableView = (UITableView *)weakself.tableviewArr[index];
                [weakself.currentTableView.mj_header beginRefreshing];
                weakself.preTableView = weakself.currentTableView;
            }
        }];
    }
    
    return _menuView;
}

#pragma mark 头部刷新
- (void)headerRereshing
{
    DLog(@"刷新啦...");
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSTimer scheduledTimerWithTimeInterval:0.1 block:^(NSTimer * _Nonnull timer) {
           [self.currentTableView.mj_header endRefreshing];
        } repeats:NO];
    });

}

#pragma mark 刷新下载数据
- (void)loadData
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //UI
    [self setUpUI];
}

- (void)setUpUI
{
    self.isShowLiftBack = NO;
    [self addNavigationItemWithImageNames:@[@"xuanxiang",@"sousuo"] isLeft:NO target:self action:@selector(rightNavItemClick:) tags:@[@"100",@"101"]];
    self.title = @"市场";
    //菜单按钮
    self.menuTitles  = [NSArray arrayWithObjects:@"自选",@"BTC",@"ETH",@"USDT", nil];
    [self.view addSubview:self.menuView];
    //指标
    UIView *targetView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.menuView.frame), CGRectGetMaxY(self.menuView.frame), ScreenWidth, 50)];
    targetView.backgroundColor = [UIColor blackColor];
    NSArray *targets = [NSArray arrayWithObjects:@"商品市场",@"最新价",@"涨跌幅", nil];
    if (targets.count) {
        for (NSInteger i = 0; i < targets.count; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*ScreenWidth/targets.count, 0, ScreenWidth/targets.count, 50)];
            label.text = targets[i];
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:13];
            [targetView addSubview:label];
        }
        
    }
    [self.view addSubview:targetView];
    //scrollview
    self.scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(CGRectGetMinX(targetView.frame), CGRectGetMaxY(targetView.frame), ScreenWidth, ScreenHeight - KTopHeight - 100 - KTabBarHeight)];
    self.scrollview.pagingEnabled = YES;
    self.scrollview.delegate = self;
    self.scrollview.contentSize = CGSizeMake(ScreenWidth *self.menuTitles.count, self.scrollview.frame.size.height-49);
    [self.view addSubview:self.scrollview];
    
    //tableview
    self.MYTable = [self TableViewWithFrame:CGRectMake(0, 0, ScreenWidth, self.scrollview.frame.size.height)];
    self.MYTable.mj_header = [self createRefreshHeader];
    self.currentTableView = self.MYTable;
    [self.MYTable.mj_header beginRefreshing];
    
    self.BTCTable = [self TableViewWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, self.scrollview.frame.size.height)];
    self.BTCTable.mj_header = [self createRefreshHeader];
    
    self.ETHTable = [self TableViewWithFrame:CGRectMake(ScreenWidth*2, 0, ScreenWidth, self.scrollview.frame.size.height)];
    self.ETHTable.mj_header = [self createRefreshHeader];
    
    self.USDTTable = [self TableViewWithFrame:CGRectMake(ScreenWidth*3, 0, ScreenWidth, self.scrollview.frame.size.height)];
    self.USDTTable.mj_header = [self createRefreshHeader];
}

- (MJRefreshNormalHeader *)createRefreshHeader
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    header.automaticallyChangeAlpha = NO;
    header.lastUpdatedTimeLabel.hidden = NO;
    return header;
}

- (UITableView *)TableViewWithFrame:(CGRect)frame
{
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    if (CurrentSystemVersion >= 8.0) {
        if ([tableview respondsToSelector:@selector(setSeparatorInset:)]) {
            // 如果tableView响应了setSeparatorInset: 这个方法,我们就将tableView分割线的内边距设为0.
            [tableview setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([tableview respondsToSelector:@selector(setLayoutMargins:)]) {
            // 如果tableView响应了setLayoutMargins: 这个方法,我们就将tableView分割线的间距距设为0.
            [tableview setLayoutMargins:UIEdgeInsetsZero];
        }
    }else{
       tableview.separatorInset = UIEdgeInsetsZero;
    }
    
    tableview.backgroundColor = NormalColor;
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.scrollview addSubview:tableview];
    [self.tableviewArr addObject:tableview];
    return tableview;
}

#pragma mark 右上功能事件
- (void)rightNavItemClick:(UIButton *)btn
{
    NSInteger btnTag = btn.tag;
    switch (btnTag) {
        case 100:
            NSLog(@"更多选项");
            break;
        case 101:
            NSLog(@"搜索");
            break;
        default:
            break;
    }
    
}

#pragma mark tableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const cellIdentifier = @"quotationCell";
    QuotationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[QuotationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KLineVC *vc = [[KLineVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark ScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.scrollview == scrollView) {
        CGFloat x = scrollView.contentOffset.x;
        NSInteger count = x/ScreenWidth;
        UIButton *selectBtn = [self.menuView viewWithTag:200+count];
        [self.menuView btnTypeClick:selectBtn];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    if (self.scrollview == scrollView) {
//        CGFloat x = scrollView.contentOffset.x;
//        CGFloat ratio = x/ScreenWidth;
//        self.menuView.indicatorView.centerX = ScreenWidth/8 + ScreenWidth/4*ratio;
//    }
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
