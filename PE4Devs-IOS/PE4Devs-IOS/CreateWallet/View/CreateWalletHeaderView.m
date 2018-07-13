//
//  CreateWalletHeaderView.m
//  PE4Devs-IOS
//
//  Created by oraclechain on 2018/6/29.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "CreateWalletHeaderView.h"

@implementation CreateWalletHeaderView

- (IBAction)confirmBtnclick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(confirmPasswordBtnDidClick)]) {
        [self.delegate confirmPasswordBtnDidClick];
    }
}


@end
