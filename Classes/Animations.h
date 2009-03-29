//
//  Animations.h
//  World
//
//  Created by Steve on 20/02/09.
//  Copyright 2009 Eighty Elements. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (UIView_Animations)


// Basic animation block to make it easier.
- (void)startAnimationBlock:(NSTimeInterval)duration;
- (void)stopAnimationBlock;


// Basic fading.
- (void)fadeIn:(NSTimeInterval)duration;
- (void)fadeOut:(NSTimeInterval)duration;


// Transition views out of display.
- (void)slideOutToLeft:(NSTimeInterval)duration;
- (void)slideOutToBottom:(NSTimeInterval)duration;


// Transition views into display.
- (void)slideInFromRight:(NSTimeInterval)duration to:(CGFloat)to;
- (void)slideInFromBottom:(NSTimeInterval)duration to:(CGFloat)to;


@end

