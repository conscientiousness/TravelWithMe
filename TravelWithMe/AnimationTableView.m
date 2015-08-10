//
//  AnimationTableView.m
//  TravelWithMe
//
//  Created by Hank on 2015/8/8.
//  Copyright (c) 2015年 Jesse. All rights reserved.
//

#import "AnimationTableView.h"


@implementation AnimationTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    id hitView = [super hitTest:point withEvent:event];
    if (point.y<0) {
        return nil;
    }
    return hitView;
}

@end
