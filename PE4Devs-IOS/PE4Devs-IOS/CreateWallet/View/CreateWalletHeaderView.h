//
//  CreateWalletHeaderView.h
//  PE4Devs-IOS
//
//  Created by oraclechain on 2018/6/29.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CreateWalletHeaderViewDelegate<NSObject>
- (void)confirmPasswordBtnDidClick;
@end

@interface CreateWalletHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTF;
@property (weak, nonatomic) IBOutlet UITextField *walletNameTF;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property(nonatomic, weak) id<CreateWalletHeaderViewDelegate> delegate;


@end
