//
//  LayoutsViewController.m
//  Cypress
//
//  Created by Steve on 15/01/09.
//  Copyright 2009 Eighty Elements. All rights reserved.
//

#import "LayoutsViewController.h"


@implementation LayoutsViewController


@synthesize lastOrientation;

@synthesize appDelegate;


#pragma mark - Initialization methods

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        self.lastOrientation = [UIApplication sharedApplication].statusBarOrientation;
    }
    
    return self;
}


/**
 *  If a memoryWarning is fired and this view is not being viewed, its content will be removed.
 *  Make sure that we cleared / set everything we create in viewWillAppear as well.
 */
- (void)setView:(UIView *)view {
    [super setView:view];
    
    if (view == nil) {
        self.appDelegate = nil;
    }
}


- (void)viewDidLoad {
    self.appDelegate = (iDrupalAppDelegate *)[[UIApplication sharedApplication] delegate];
}


#pragma mark - Custom Methods

/**
 *  All the changes needed when switching orientations.
 */
- (void)alterOnOrientationChange:(UIInterfaceOrientation)orientation {
    // Handle the differences between our landscape and portrait themes.
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
             
            break;
            
        case UIInterfaceOrientationPortraitUpsideDown:

            break;
            
        case UIInterfaceOrientationLandscapeLeft:

            break;
            
        case UIInterfaceOrientationLandscapeRight:

            break;
    }
}


- (void)willAnimateFirstHalfOfRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateFirstHalfOfRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self alterOnOrientationChange:toInterfaceOrientation];
}


- (void)willAnimateSecondHalfOfRotationFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateSecondHalfOfRotationFromInterfaceOrientation:fromInterfaceOrientation duration:duration];
    
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    self.lastOrientation = fromInterfaceOrientation;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void)viewWillAppear:(BOOL)animated {
    // Make sure to keep the view updated so it can perform the tweaks it needs depending on the orientation.
    if (self.lastOrientation != [UIApplication sharedApplication].statusBarOrientation) {
        self.lastOrientation = [UIApplication sharedApplication].statusBarOrientation;
        [self alterOnOrientationChange:self.lastOrientation];
    }
}


@end

