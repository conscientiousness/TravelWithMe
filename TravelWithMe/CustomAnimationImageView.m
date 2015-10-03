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
        
        UIImageView *explosion = [[UIImageView alloc] initWithFrame:self.bounds];
        
        NSMutableArray *images = [NSMutableArray new];
        for (int i=0; i<=51; i++) {
            [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"PR_3_%05d.png",i]]];
        }
        
        //Add images which will be used for the animation using an array. Here I have created an array on the fly
        explosion.animationImages =  images;
        
        //Set the duration of the entire animation
        explosion.animationDuration = 1.3;
        
        //Set the repeat count. If you don't set that value, by default will be a loop (infinite)
        //explosion.animationRepeatCount = 1;
        
        //Start the animationrepeatcount
        [explosion startAnimating];
        
        [self addSubview:explosion];
    }
    return self;
}

@end
