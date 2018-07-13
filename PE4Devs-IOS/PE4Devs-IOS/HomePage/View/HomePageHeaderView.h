//
//  HomePageHeaderView.h
//  PE4Devs-IOS
//
//  Created by oraclechain on 2018/6/29.
//  Copyright © 2018 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomePageHeaderViewDelegate<NSObject>
- (void)setWalletInfoBtnDidClick;
- (void)importAccountBtnDidClick;
- (void)confirmBtnDidClick;
@end


@interface HomePageHeaderView : UIView
@property(nonatomic, weak) id<HomePageHeaderViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *setPasswordBtn;
@property (weak, nonatomic) IBOutlet UITextField *urlTF;

@end
