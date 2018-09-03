//
//  Abi_json_to_bin_Result.h
//  pocketEOS
//
//  Created by oraclechain on 2018/8/13.
//  Copyright © 2018 oraclechain. All rights reserved.
//


#import "Abi_json_to_bin.h"

@interface Abi_json_to_bin_Result : NSObject
@property(nonatomic , strong) NSNumber *code;
@property(nonatomic , copy) NSString *message;
@property(nonatomic , strong) Abi_json_to_bin *data;
@end
