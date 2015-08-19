//
//  UIColors.m
//  TravelWithMe
//
//  Created by Jesselin on 2015/7/9.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import "UIColors.h"


@implementation UIColor (UIColors)

/*
 * 用法:
 * (1)以homeCellbgColor為範例
 * (2)UIColors.h 也要加，你的class才讀得到
 * (2)#import "UIColors.h" 到你的.m檔
 * (3)在你的class內 [UIColor homeCellbgColor] 這樣就可以
 */


//主畫面Cell背景色

+ (UIColor *) homeCellbgColor {
    
    return [UIColor colorWithRed:1.000 green:0.946 blue:0.891 alpha:1.000];
}

//Navigation Bar

+ (UIColor *) navigationBarColor {
    
    return [UIColor colorWithWhite:1.000 alpha:0.040];
}

//Tab Bar
+ (UIColor *) tabBarColor {
    //return [UIColor colorWithRed:0.9266 green:0.6583 blue:0.2071 alpha:1.0];
    return [UIColor colorWithWhite:0.980 alpha:0.100];
}

//大頭照邊框-boy

+ (UIColor *) boyPhotoBorderColor {
    return [UIColor colorWithRed:0.4738 green:0.7704 blue:0.9539 alpha:1.0];
}


//大頭照邊框-girl
+ (UIColor *) girlPhotoBorderColor {
    return [UIColor colorWithRed:0.9632 green:0.7918 blue:0.7941 alpha:1.0];
}

//專屬綠色
+ (UIColor *) customGreenColor {
    return [UIColor colorWithRed:0.082 green:0.647 blue:0.698 alpha:1.000];
}








@end

