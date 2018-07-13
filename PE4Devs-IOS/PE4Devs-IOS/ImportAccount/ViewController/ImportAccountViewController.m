//
//  ImportAccountViewController.m
//  pal
//
//  Created by oraclechain on 2018/6/29.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "ImportAccountViewController.h"
#import "ImportAccountHeaderView.h"
#import "AccountInfo.h"
#import "GetAccountRequest.h"
#import "GetAccountResult.h"
#import "GetAccount.h"
#import "Permission.h"
#import "EOS_Key_Encode.h"

@interface ImportAccountViewController ()<ImportAccountHeaderViewDelegate, LoginPasswordViewDelegate>
@property(nonatomic , strong) ImportAccountHeaderView *headerView;
@property(nonatomic, strong) LoginPasswordView *loginPasswordView;
@property(nonatomic, strong) GetAccountRequest *getAccountRequest;
@end

@implementation ImportAccountViewController

{   // 从网络获取的公钥
    NSString *active_public_key_from_network;
    NSString *owner_public_key_from_network;
    // 在本地根据私钥算出的公钥
    NSString *active_public_key_from_local;
    NSString *owner_public_key_from_local;
    BOOL private_owner_Key_is_validate;
    BOOL private_active_Key_is_validate;
}

- (ImportAccountHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"ImportAccountHeaderView" owner:nil options:nil] firstObject];
        _headerView.delegate = self;
        _headerView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 560);
    }
    return _headerView;
}

- (LoginPasswordView *)loginPasswordView{
    if (!_loginPasswordView) {
        _loginPasswordView = [[[NSBundle mainBundle] loadNibNamed:@"LoginPasswordView" owner:nil options:nil] firstObject];
        _loginPasswordView.frame = self.view.bounds;
        _loginPasswordView.delegate = self;
    }
    return _loginPasswordView;
}

-(GetAccountRequest *)getAccountRequest{
    if (!_getAccountRequest) {
        _getAccountRequest = [[GetAccountRequest alloc] init];
    }
    return _getAccountRequest;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.headerView];
    self.view.backgroundColor = [UIColor whiteColor];
}

//ImportAccountHeaderViewDelegate
- (void)importBtnDidClick:(UIButton *)sender{
    if (IsStrEmpty(self.headerView.accountNameTF.text)  || IsStrEmpty(self.headerView.private_ownerKey_TF.text) || IsStrEmpty(self.headerView.private_activeKey_tf.text)) {
        [TOASTVIEW showWithText:NSLocalizedString(@"输入框不能为空!", nil)];
        return;
    }else{
        [self.view addSubview:self.loginPasswordView];
    }
}

// LoginPasswordViewDelegate
-(void)cancleBtnDidClick:(UIButton *)sender{
    [self removeLoginPasswordView];
}

-(void)confirmBtnDidClick:(UIButton *)sender{
    // 验证密码输入是否正确
    Wallet *current_wallet = CURRENT_WALLET;
    if (![WalletUtil validateWalletPasswordWithSha256:current_wallet.wallet_shapwd password:self.loginPasswordView.inputPasswordTF.text]) {
        [TOASTVIEW showWithText:NSLocalizedString(@"密码输入错误!", nil)];
        return;
    }
    [SVProgressHUD show];
    
    // 检查本地是否有对应的账号
    AccountInfo *accountInfo = [[AccountsTableManager accountTable] selectAccountTableWithAccountName:self.headerView.accountNameTF.text];
    if (accountInfo) {
        [TOASTVIEW showWithText:NSLocalizedString(@"本地钱包已存在该账号!", nil)];
        [self removeLoginPasswordView];
        return;
    }
    // 验证 account_name. owner_private_key , active_private_key 是否匹配
    [self validateInputFormat];
}




// 检查输入的格式
- (void)validateInputFormat{
    // 验证账号名私钥格式是否正确
    if (![RegularExpression validateEosAccountName:self.headerView.accountNameTF.text]) {
        [TOASTVIEW showWithText:NSLocalizedString(@"12位字符，只能由小写字母a~z和数字1~5组成。", nil)];
        [self removeLoginPasswordView];
        return;
    }
    private_owner_Key_is_validate = [EOS_Key_Encode validateWif:self.headerView.private_ownerKey_TF.text];
    private_active_Key_is_validate = [EOS_Key_Encode validateWif:self.headerView.private_activeKey_tf.text];
    
    if ((private_owner_Key_is_validate == YES) && (private_active_Key_is_validate == YES)) {
        [self createPublicKeys];
    }else{
        [TOASTVIEW showWithText:NSLocalizedString(@"私钥格式有误!", nil)];
        [self removeLoginPasswordView];
        return ;
    }
}


- (void)createPublicKeys{
    // 将用户导入的私钥生成公钥
    
    active_public_key_from_local = [EOS_Key_Encode eos_publicKey_with_wif:self.headerView.private_activeKey_tf.text];
    owner_public_key_from_local = [EOS_Key_Encode eos_publicKey_with_wif:self.headerView.private_ownerKey_TF.text];
    // 请求该账号的公钥
    WS(weakSelf);
    self.getAccountRequest.name = VALIDATE_STRING(self.headerView.accountNameTF.text) ;
    [self.getAccountRequest postDataSuccess:^(id DAO, id data) {
        GetAccountResult *result = [GetAccountResult mj_objectWithKeyValues:data];
        if (![result.code isEqualToNumber:@0]) {
            [TOASTVIEW showWithText: result.message];
        }else{
            GetAccount *model = [GetAccount mj_objectWithKeyValues:result.data];
            
            for (Permission *permission in model.permissions) {
                if ([permission.perm_name isEqualToString:@"active"]) {
                    active_public_key_from_network = permission.required_auth_key;
                }else if ([permission.perm_name isEqualToString:@"owner"]){
                    owner_public_key_from_network = permission.required_auth_key;
                }
            }
            if ([active_public_key_from_network isEqualToString: active_public_key_from_local] && [owner_public_key_from_network isEqualToString:owner_public_key_from_local]) {
                // 本地公钥和网络公钥匹配, 允许进行导入本地操作
                AccountInfo *accountInfo = [[AccountInfo alloc] init];
                accountInfo.account_name = weakSelf.headerView.accountNameTF.text;
                accountInfo.account_owner_public_key = owner_public_key_from_local;
                accountInfo.account_active_public_key = active_public_key_from_local;
                accountInfo.account_owner_private_key = [AESCrypt encrypt:weakSelf.headerView.private_ownerKey_TF.text password:weakSelf.loginPasswordView.inputPasswordTF.text];
                accountInfo.account_active_private_key = [AESCrypt encrypt:weakSelf.headerView.private_activeKey_tf.text password:weakSelf.loginPasswordView.inputPasswordTF.text];
                accountInfo.is_privacy_policy = @"0";
                NSArray *accountArray = [[AccountsTableManager accountTable ] selectAccountTable];
                if (accountArray.count > 0) {
                    accountInfo.is_main_account = @"0";
                }else{
                    accountInfo.is_main_account = @"1";
                }
                
                [[AccountsTableManager accountTable] addRecord:accountInfo];
                [TOASTVIEW showWithText:NSLocalizedString(@"导入账号成功!", nil)];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                [TOASTVIEW showWithText:NSLocalizedString(@"导入的私钥不匹配!", nil)];
            }
        }
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)removeLoginPasswordView{
    if (self.loginPasswordView) {
        [self.loginPasswordView removeFromSuperview];
        self.loginPasswordView = nil;
    }
}

@end
