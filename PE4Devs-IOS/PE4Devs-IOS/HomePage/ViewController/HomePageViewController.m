//
//  HomePageViewController.m
//  pal
//
//  Created by oraclechain on 2018/6/29.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "HomePageViewController.h"
#import "CreateWalletViewController.h"
#import "ImportAccountViewController.h"
#import "DappDetailViewController.h"
#import "HomePageHeaderView.h"

@interface HomePageViewController ()<HomePageHeaderViewDelegate>
@property(nonatomic , strong) HomePageHeaderView *headerView;
@end

@implementation HomePageViewController

- (HomePageHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"HomePageHeaderView" owner:nil options:nil] firstObject];
        _headerView.delegate = self;
        _headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 200);
    }
    return _headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"PE4Devs-IOS";
    [self.view addSubview:self.headerView];
}


//HomePageHeaderViewDelegate
-(void)setWalletInfoBtnDidClick{
    Wallet *wallet = CURRENT_WALLET;
    if (IsNilOrNull(wallet)) {
        CreateWalletViewController *vc = [[CreateWalletViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self.headerView.setPasswordBtn setTitle:[NSString stringWithFormat:@"YOUR PASSWORD IS : %@", CURRENT_WALLET_PASSWORD] forState:(UIControlStateNormal)];
        [TOASTVIEW showWithText:@"you had set wallet info already!"];
    }
}

- (void)importAccountBtnDidClick{
    ImportAccountViewController *vc = [[ImportAccountViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)confirmBtnDidClick{
    Wallet *wallet = CURRENT_WALLET;
    if (IsNilOrNull(wallet)) {
        [TOASTVIEW showWithText:@"Set wallet info first!"];
        return;
    }
    NSLog(@"%@", self.headerView.urlTF.text);
    if (![self.headerView.urlTF.text hasPrefix:@"http"] ) {
        [TOASTVIEW showWithText:@"Input the correct dapp address please!"];
        return;
    }

    DappDetailViewController *vc = [[DappDetailViewController alloc] init];
    Application *model = [[Application alloc] init];
    model.url = self.headerView.urlTF.text;
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

@end

