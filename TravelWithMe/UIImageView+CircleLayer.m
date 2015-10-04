//
//  UIImageView+circleLayer.m
//  TravelWithMe
//
//  Created by Jesselin on 2015/10/4.
//  Copyright © 2015年 Jesse. All rights reserved.
//

#import "UIImageView+CircleLayer.h"

@implementation UIImageView(CircleLayer)

+(UIImageView*)circleImageView:(UIImageView*)imageView borderWidth:(CGFloat)borderWidth borderColor:(UIColor*)borderColor 
{
    imageView.layer.cornerRadius = imageView.frame.size.width / 2;
    imageView.layer.borderWidth = borderWidth;
    imageView.layer.borderColor = borderColor.CGColor;
    imageView.clipsToBounds = YES;

    return imageView;
}

@end
