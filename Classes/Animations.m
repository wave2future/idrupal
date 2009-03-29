//
//  Animations.m
//  World
//
//  Created by Steve on 20/02/09.
//  Copyright 2009 Eighty Elements. All rights reserved.
//

#import "Animations.h"


@implementation UIView (UIView_Animations)


- (void)startAnimationBlock:(NSTimeInterval)duration {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
}


- (void)stopAnimationBlock {
    [UIView commitAnimations];
}


- (void)fadeIn:(NSTimeInterval)duration {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    
    self.alpha = 1.0;
    
    [UIView commitAnimations];
}


- (void)fadeOut:(NSTimeInterval)duration {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    
    self.alpha = 0.0;
    
    [UIView commitAnimations];    
}


- (void)slideOutToLeft:(NSTimeInterval)duration {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    
    self.frame = CGRectMake(self.frame.size.width * -1, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    
    [UIView commitAnimations];   
}


- (void)slideOutToBottom:(NSTimeInterval)duration {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    
    CGRect bounds = self.window.bounds;
    
    self.frame = CGRectMake(self.frame.origin.x, bounds.size.height + self.frame.size.height, self.frame.size.width, self.frame.size.height);
    
    [UIView commitAnimations];   
}


- (void)slideInFromRight:(NSTimeInterval)duration to:(CGFloat)to {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    
    self.frame = CGRectMake(to, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    
    [UIView commitAnimations];   
}


- (void)slideInFromBottom:(NSTimeInterval)duration to:(CGFloat)to {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    
    self.frame = CGRectMake(self.frame.origin.x, to, self.frame.size.width, self.frame.size.height);
    
    [UIView commitAnimations];   
}


@end
