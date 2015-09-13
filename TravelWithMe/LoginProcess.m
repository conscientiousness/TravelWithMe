//
//  LoginProcess.m
//  TravelWithMe
//
//  Created by Jesselin on 2015/9/13.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import "LoginProcess.h"

@implementation LoginProcess

- (BOOL)validateEmailLogin {
    
    return YES;
}

- (BOOL)validateEmailRegister {
    
    return YES;
}

- (BOOL)validateEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}

@end
