//
//  TransferAbi_json_to_bin_result.h
//  PE4Devs-IOS
//
//  Created by 师巍巍 on 01/07/2018.
//  Copyright © 2018 Oraclechain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransferAbi_json_to_bin_result : NSObject
@property(nonatomic, strong) NSNumber *code;
@property(nonatomic, copy) NSString *message;
@property(nonatomic, strong) NSDictionary *data;

@end
