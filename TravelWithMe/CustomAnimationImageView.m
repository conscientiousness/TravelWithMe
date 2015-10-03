//
//  CustomAnimationImageView.m
//  TravelWithMe
//
//  Created by Jesselin on 2015/10/2.
//  Copyright © 2015年 Jesse. All rights reserved.
//

#import "CustomAnimationImageView.h"


@implementation CustomAnimationImageView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        
        NSMutableArray *images = [NSMutableArray new];
        for (int i=0; i<=51; i++) {
            [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"PR_3_%05d.png",i]]];
        }
        
        //Add images which will be used for the animation using an array. Here I have created an array on the fly
        imageView.animationImages =  images;
        
        //Set the duration of the entire animation
        imageView.animationDuration = 1.3;
        
        //Set the repeat count. If you don't set that value, by default will be a loop (infinite)
        //explosion.animationRepeatCount = 1;
        
        //Start the animationrepeatcount
        [imageView startAnimating];
        
        [self addSubview:imageView];
    }
    return self;
}

@end
