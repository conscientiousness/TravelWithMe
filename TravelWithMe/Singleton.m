//
//  Singleton.m
//  TravelWithMe
//
//  Created by Jesselin on 2015/9/3.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import "Singleton.h"

@implementation Singleton
+(instancetype)sharedInstance
{
    static dispatch_once_t token;
    static Singleton * object = nil;
    dispatch_once(&token, ^{
        object = [[self alloc] init];
    });
    return object;
}
@end
