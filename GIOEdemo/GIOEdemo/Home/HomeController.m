//
//  HomeController.m
//  GIOdemo
//
//  Created by GrowingIO on 2019/1/4.
//  Copyright © 2019年 GIO. All rights reserved.
//

#import "HomeController.h"
#import "HomeCell.h"
#import "GoodsDetailController.h"
#import "SearchViewController.h"
#import "OrderController.h"
#import "Growing.h"
#import "GoodsModel.h"
#import "MainViewController.h"
#import "GrowingTouchCoreKit/GrowingTouchBannerView.h"

static NSString* bannerKey = @"9ad8cc83668bb9f0";

@interface HomeController () <GrowingTouchBannerViewDelegate>

@property(nonatomic , strong)  UIScrollView *backScrollView ;
@property(nonatomic , strong)  UIView *upView ;
@property(nonatomic , strong)  UIView *backSeckillingView ;
@property(nonatomic , strong)  UIView *recommendView ;
@property(nonatomic , strong)  UIView *bestSaleView ;
@property(nonatomic , strong)  NSMutableArray *allDataArray ;
@property(nonatomic , strong)  GrowingTouchBannerView *bannerViews ;
@property(nonatomic , strong)  UIImage *placeholderImage ;
@property (nonatomic, strong) UIImageView *errorPlaceholder;

@end

@implementation HomeController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"主页";
    self.backScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.backScrollView.backgroundColor = [UIColor whiteColor];
    self.backScrollView.contentSize = CGSizeMake(0, self.view.bounds.size.height + 300) ;
    [self.view addSubview:self.backScrollView];
    [self makeHomeData];
    [self makeBanner];
    [self makeUpview];
    [self makeSeckillingView];
    [self makeRecommendView];
    
    
    [Growing setVisitor:@{@"name":@"dddk"}];
    [Growing setPeopleVariable:@{@"age":@"dddk"}];
}

//打点开始
-(void)homePageGoodsImp:(NSMutableDictionary *)dict{
    [Growing track:@"homePageGoodsImp" withVariable:dict];
}
-(void)homePageGoodsClick:(NSDictionary *)dict{
    NSMutableDictionary *mutDict = dict.mutableCopy;
    [mutDict removeObjectForKey:@"price_var"];
    [Growing track:@"homePageGoodsClick" withVariable:mutDict];
}
//打点结束

-(void)makeBanner {
    UIView *searchBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(40, 0,220, 20)];
    [btn setTitle:@"GIO 马克杯" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0,0,0,120)];
    
    UIImageView *imaview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    imaview.image = [UIImage imageNamed:@"搜索"];
    [searchBar addSubview:imaview];
    [searchBar addSubview:btn];
    self.navigationItem.titleView = searchBar ;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchBarTapAction:)];
    [searchBar addGestureRecognizer:tap];
    
    //触达banner
    UIImage* placeholderImage = [UIImage imageNamed:@"suggest1"];
    self.bannerViews = [GrowingTouchBannerView bannerKey:bannerKey
                                             bannerFrame:CGRectMake(0, 0, self.view.bounds.size.width ,220)
                                        placeholderImage:placeholderImage];
    self.bannerViews.bannerViewErrorImage = placeholderImage;
        //  设置图片
//    self.bannerViews.currentPageIndicatorImage = [UIImage imageNamed:@"page_select"];
//    self.bannerViews.pageIndicatorImage = [UIImage imageNamed:@"page_unselect"];
    //    self.bannerView.pageIndicatorSize = CGSizeMake(6,6);
    //    self.bannerView.currentPageIndicatorSize = CGSizeMake(16,16);
    //    self.bannerView.currentPageIndicatorTintColor = [UIColor redColor];
    //    self.bannerView.pageIndicatorTintColor = [UIColor yellowColor];
    [self.bannerViews loadBannerWithDelegate:self];
    [self.backScrollView addSubview:self.bannerViews];
}

-(void)searchBarTapAction:(UIGestureRecognizer *)tap {
    SearchViewController *VC = [[SearchViewController alloc] init];
    VC.hidesBottomBarWhenPushed = YES ;
    [self.navigationController pushViewController:VC  animated:NO];
}

-(void)makeUpview{
    self.upView =[[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.bannerViews.frame) + 40 , self.view.bounds.size.width - 40, 120)];
    for (int i = 0; i < 4; i ++) {
        HomeCell *cell = [[HomeCell alloc] initWithFrame:CGRectMake(i *  (self.view.bounds.size.width - 40)/4.0 ,0, (self.view.bounds.size.width - 40)/4.0 , 120)];
        cell.width = 40 ;
        cell.height = 40 ;
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i+1]] ;
        cell.titleLabel.textAlignment = NSTextAlignmentCenter ;
        
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapAction:)];
        [cell addGestureRecognizer:tapGesturRecognizer];
        
        switch (i) {
            case 0:
            {
                cell.titleLabel.text  = @"增长分类" ;
                tapGesturRecognizer.view.tag = i ;
            }
                break;
            case 1:
            {
                cell.titleLabel.text  = @"精品推荐" ;
                tapGesturRecognizer.view.tag = i ;
            }
                break;
            case 2:
            {
                cell.titleLabel.text  = @"增长" ;
                tapGesturRecognizer.view.tag = i ;
            }
                break;
            case 3:
            {
                cell.titleLabel.text  = @"查看增长" ;
                tapGesturRecognizer.view.tag = i ;
            }
                break;
            default:
                break;
        }
        
        
        UIView *divideView = [[UIView alloc] initWithFrame:CGRectMake(-20, self.upView.frame.size.height, self.view.frame.size.width, 0.5)];
        divideView.backgroundColor = [UIColor lightGrayColor];
        [self.upView addSubview:divideView];
        [self.upView addSubview:cell];
    }
    [self.backScrollView addSubview:self.upView];
}

-(void)cellTapAction:(UIGestureRecognizer *)tapGesture{
    NSUInteger tag = tapGesture.view.tag;
    switch (tag) {
        case 0:
        {
            self.tabBarController.selectedIndex = 1 ;
        }
            break;
        case 1:
        {
            self.tabBarController.selectedIndex = 1 ;
        }
            break;
        case 2:
        {
            self.tabBarController.selectedIndex = 2 ;
        }
            break;
        case 3:
        {
            OrderController *VC = [[OrderController alloc] init];
            VC.hidesBottomBarWhenPushed = YES ;
            [self.navigationController pushViewController:VC animated:NO];
        }
            break;
        default:
            break;
    }
}

//跳转到详情页
-(void)tapAction:(id)sender
{
    GoodsDetailController *VC = [[GoodsDetailController alloc] init];
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UIView *view = (UIView*) tap.view;
    VC.goodModel = self.allDataArray[view.tag] ;
    VC.hidesBottomBarWhenPushed = YES ;
    [self.navigationController pushViewController:VC animated:YES];
    [self homePageGoodsClick:[VC.goodModel modelTodic]];
}


-(void)makeSeckillingView{
    self.backSeckillingView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.upView.frame) + 10, self.view.bounds.size.width - 40, 220)];
    UILabel *upLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , self.view.bounds.size.width - 40, 30)];
    upLabel.textAlignment = NSTextAlignmentLeft ;
    upLabel.textColor = [UIColor blackColor];
    upLabel.text = @"限时秒杀" ;
    [self.backSeckillingView addSubview:upLabel];
    
    self.backSeckillingView.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i < 3; i ++) {
        HomeCell *cell = [[HomeCell alloc] initWithFrame:CGRectMake(10 * i +  i *  (self.view.bounds.size.width - 40 - 40)/3.0 + 20 ,40, (self.view.bounds.size.width - 40 - 40)/3.0 , 200 - 40 - 20 )];
        cell.width  = cell.bounds.size.width ;
        cell.height = cell.bounds.size.height ;
        cell.tag = i ;
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [cell addGestureRecognizer:tapGesturRecognizer];
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"book%d",i+1]] ;
        cell.titleLabel.textAlignment = NSTextAlignmentCenter ;
        [self.backSeckillingView addSubview:cell];
    }
    [self.backScrollView addSubview:self.backSeckillingView];
}

-(void)makeRecommendView{
    self.recommendView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.backSeckillingView.frame), self.view.bounds.size.width - 40, 200)];
    UILabel *upLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , self.view.bounds.size.width - 40, 30)];
    upLabel.textAlignment = NSTextAlignmentLeft ;
    upLabel.text = @"GIO推荐" ;
    upLabel.textColor = [UIColor darkTextColor];
    [self.recommendView addSubview:upLabel];
    self.recommendView.backgroundColor = [UIColor whiteColor];
    HomeCell *cell = [[HomeCell alloc] initWithFrame:CGRectMake(0,40, (self.view.bounds.size.width - 40) , 200 - 40 - 20 )];
    cell.tag = 4 ;
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [cell addGestureRecognizer:tapGesturRecognizer];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"suggest"]] ;
    cell.width  = cell.bounds.size.width ;
    cell.height = cell.bounds.size.height ;
    [self.recommendView addSubview:cell];
    [self.backScrollView addSubview:self.recommendView];
}

-(void)makeHomeData{
    NSMutableArray *allNameArray = [NSMutableArray arrayWithObjects:@"渠道流量分析",@"产品经理数据分析",@"增长黑客手册",@"GIO马克杯",@"GIO文化衫", nil];
    NSMutableArray *priceArray = [NSMutableArray arrayWithObjects:@"59",@"39",@"36",@"59",@"89", nil];
    self.allDataArray = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < 5 ; i ++ ) {
        GoodsModel *model = [[GoodsModel alloc] init];
        model.productId_var = [NSString stringWithFormat:@"00%d",i+1];
        model.productName_var = allNameArray[i];
        model.price_var = priceArray[i];
        model.floor_var = @"首页" ;
        [self.allDataArray addObject:model];
        [self homePageGoodsImp:[model modelTodic]];
    }
}

#pragma mark GrowingTouchBannerViewDelegate

- (void)growingTouchBannerLoadFailed:(GrowingTouchBannerView *)bannerView error:(NSError *)error {
    if (![bannerView.subviews containsObject:self.errorPlaceholder]) {
        [bannerView addSubview:self.errorPlaceholder];
    }
}

#pragma mark lazy load

- (UIImageView *)errorPlaceholder {
    if (!_errorPlaceholder) {
        _errorPlaceholder = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"suggest1"]];
        _errorPlaceholder.frame = self.bannerViews.bounds;
    }
    return _errorPlaceholder;
}

@end
