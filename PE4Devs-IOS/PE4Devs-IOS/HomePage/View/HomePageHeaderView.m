//
//  HomePageHeaderView.m
//  PE4Devs-IOS
//
//  Created by oraclechain on 2018/6/29.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import "HomePageHeaderView.h"

@interface HomePageHeaderView()

@end


@implementation HomePageHeaderView
- (IBAction)setWalletInfoBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(setWalletInfoBtnDidClick)]) {
        [self.delegate setWalletInfoBtnDidClick];
    }
}

- (IBAction)importAccountBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(importAccountBtnDidClick)]) {
        [self.delegate importAccountBtnDidClick];
    }
}

- (IBAction)confirmBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(confirmBtnDidClick)]) {
        [self.delegate confirmBtnDidClick];
    }
}

@end
