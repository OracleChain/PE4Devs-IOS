//
//  CreateWalletViewController.m
//  PE4Devs-IOS
//
//  Created by oraclechain on 2018/6/29.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "CreateWalletViewController.h"
#import "CreateWalletHeaderView.h"
#import "NSString+MD5.h"

@interface CreateWalletViewController ()<CreateWalletHeaderViewDelegate>
@property(nonatomic , strong) CreateWalletHeaderView *headerView;
@end

@implementation CreateWalletViewController

- (CreateWalletHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"CreateWalletHeaderView" owner:nil options:nil] firstObject];
        _headerView.delegate = self;
        _headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 380);
    }
    return _headerView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"WALLET INFO";
    [self.view addSubview:self.headerView];
    self.view.backgroundColor = [UIColor whiteColor];
}

//CreateWalletHeaderViewDelegate
- (void)confirmPasswordBtnDidClick{
    if (IsStrEmpty(self.headerView.walletNameTF.text) || IsStrEmpty(self.headerView.phoneNumberTF.text) || IsStrEmpty(self.headerView.passwordTF.text)) {
        [TOASTVIEW showWithText:@"INPUT BOX CAN'T BE NIL!"];
    }else{
        [[NSUserDefaults standardUserDefaults] setValue:self.headerView.passwordTF.text forKey: Current_wallet_password];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        // create wallet 
        NSString *savePassword = [WalletUtil generate_wallet_shapwd_withPassword:self.headerView.passwordTF.text];
        Wallet *model = [[Wallet alloc] init];
        model.wallet_name = self.headerView.walletNameTF.text;
        model.wallet_shapwd = savePassword;
        model.wallet_uid = [self.headerView.phoneNumberTF.text MD5Hash];
        model.wallet_phone = self.headerView.phoneNumberTF.text;
        model.wallet_avatar = @"https://pocketeos.oss-cn-beijing.aliyuncs.com/person_default_img.png";
        [[NSUserDefaults standardUserDefaults] setObject: model.wallet_uid  forKey:Current_wallet_uid];
        [[NSUserDefaults standardUserDefaults] synchronize];
        model.account_info_table_name = [NSString stringWithFormat:@"%@_%@", ACCOUNTS_TABLE,CURRENT_WALLET_UID];
        [[WalletTableManager walletTable] addRecord: model];
        
        [TOASTVIEW showWithText:@"WALLET INFO SET SUCCESS!"];
       
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
