//
//  PassValueDelegate.h
//  AfterSchool
//
//  Created by Chenxi Cai on 14-11-20.
//  Copyright (c) 2014年 AfterSchool. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddressDto.h"

@protocol PassValueDelegate <NSObject>

-(void)passValue:(NSString *)value
             tag:(NSString *)tag;

-(void)passAddressDto:(AddressDto *)dto tag:(NSString *)tag;


@end
 